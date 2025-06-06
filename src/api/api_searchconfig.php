<?php
// api_searchconfig.php -- HotCRP search configuration API calls
// Copyright (c) 2008-2024 Eddie Kohler; see LICENSE.

class SearchConfig_API {
    static function viewoptions(Contact $user, Qrequest $qreq) {
        $report = $qreq->report ?? "pl";
        if ($report !== "pl" && $report !== "pf") {
            return JsonResult::make_not_found_error("report", "<0>Report not found");
        }
        $search = new PaperSearch($user, "NONE");

        if ($qreq->method() === "POST" && $user->privChair) {
            if (!isset($qreq->display)) {
                return JsonResult::make_missing_error("display");
            }

            $pl = new PaperList($report, $search, ["sort" => true]);
            $pl->parse_view($qreq->display, PaperList::VIEWORIGIN_MAX);
            $parsed_view = $pl->unparse_view(PaperList::VIEWORIGIN_REPORT, true);
            $pl->prepare_table_view();
            if ($pl->message_set()->has_error()) {
                return new JsonResult(["ok" => false, "message_list" => $pl->message_set()->message_list()]);
            }

            $want = join(" ", $parsed_view);
            if ($want !== $pl->unparse_baseline_view()) {
                $user->conf->save_setting("{$report}display_default", 1, $want);
                if (strpos($want, "show:show") !== false) {
                    error_log("saving with show:show: " . json_encode($qreq->debug_json()));
                }
            } else {
                $user->conf->save_setting("{$report}display_default", null);
            }
            $qreq->unset_csession("{$report}display");
            if ($report === "pl") {
                $qreq->unset_csession("uldisplay");
            }
        }

        $pl = new PaperList($report, $search, ["sortable" => true], $qreq);
        $pl->set_report_view_errors(true);
        $pl->apply_view_report_default();
        $vd = $pl->unparse_view(PaperList::VIEWORIGIN_REPORT, true);
        $dml = $pl->prepare_table_view()->message_list();

        $qreq->q = $qreq->q ?? "NONE";
        $search = new PaperSearch($user, $qreq);
        $pl = new PaperList($report, $search, ["sort" => true], $qreq);
        $pl->set_report_view_errors(true);
        $pl->apply_view_report_default();
        $pl->apply_view_session($qreq);
        $vr = $pl->unparse_view(PaperList::VIEWORIGIN_REPORT, true);
        $vrx = $pl->unparse_view(PaperList::VIEWORIGIN_DEFAULT_DISPLAY, true);

        return new JsonResult([
            "ok" => true, "report" => $report,
            "display_current" => join(" ", $vr),
            "display_default" => join(" ", $vd),
            "display_difference" => join(" ", $vrx),
            "display_default_message_list" => $dml,
            "message_list" => $pl->prepare_table_view()->message_list()
        ]);
    }

    static function namedformula(Contact $user, Qrequest $qreq) {
        $fjs = [];
        foreach ($user->conf->viewable_named_formulas($user) as $f) {
            $fj = ["name" => $f->name, "expression" => $f->expression, "id" => $f->formulaId];
            if ($user->can_edit_formula($f)) {
                $fj["editable"] = true;
            }
            if (!$f->check()) {
                $fj["message_list"] = $f->message_list();
            }
            $fjs[] = $fj;
        }
        return new JsonResult(["ok" => true, "formulas" => $fjs]);
    }

    static private function translate_qreq(Qrequest $qreq) { // XXX backward compat
        for ($fidx = 1; isset($qreq["formulaid_{$fidx}"]); ++$fidx) {
            $qreq["formula/{$fidx}/name"] = $qreq["formulaname_{$fidx}"];
            $qreq["formula/{$fidx}/expression"] = $qreq["formulaexpression_{$fidx}"];
            $qreq["formula/{$fidx}/id"] = $qreq["formulaid_{$fidx}"];
            $qreq["formula/{$fidx}/delete"] = $qreq["formuladeleted_{$fidx}"];
        }
    }

    static function save_namedformula(Contact $user, Qrequest $qreq) {
        // NB permissions handled in loop

        // capture current formula set
        $new_formula_by_id = $formula_by_id = $user->conf->named_formulas();
        $max_id = array_reduce($formula_by_id, function ($max, $f) {
            return max($max, $f->formulaId);
        }, 0);

        if (!isset($qreq["formula/1/id"])) {
            self::translate_qreq($qreq);
        }

        // determine new formula set from request
        $id2idx = [];
        $msgset = new MessageSet;
        for ($fidx = 1; isset($qreq["formula/{$fidx}/id"]); ++$fidx) {
            $name = $qreq["formula/{$fidx}/name"];
            $expr = $qreq["formula/{$fidx}/expression"];
            $id = $qreq["formula/{$fidx}/id"];
            $deleted = $qreq["formula/{$fidx}/delete"];
            if (!isset($name) && !isset($expr) && !isset($deleted)) {
                continue;
            }

            $name = simplify_whitespace($name ?? "");
            $lname = strtolower($name);
            $expr = simplify_whitespace($expr ?? "");
            $pfx = $name === "" ? "" : "{$name}: ";

            if ($id === "new") {
                if (($name === "" && $expr === "") || $deleted) {
                    continue;
                }
                $fdef = null;
                $id = ++$max_id;
            } else {
                $id = (int) $id;
                if (!($fdef = $formula_by_id[$id] ?? null)) {
                    $msgset->error_at("formula/{$fidx}", "<0>{$pfx}This formula has been deleted");
                    continue;
                }
            }
            $id2idx[$id] = $fidx;

            if (!$user->can_edit_formula($fdef)
                && (!$fdef || $name !== $fdef->name || $expr !== $fdef->expression || $deleted)) {
                $msgset->error_at("formula/{$fidx}", $fdef ? "<0>{$pfx}You can’t change this named formula" : "<0>You can’t create named formulas");
                continue;
            }

            if ($deleted) {
                unset($new_formula_by_id[$id]);
                continue;
            } else if ($expr === "") {
                $msgset->error_at("formula/{$fidx}/expression", "<0>{$pfx}Expression required");
                continue;
            }

            if (($error = self::name_error($name, "formula"))) {
                $msgset->error_at("formula/{$fidx}/name", "<0>{$pfx}{$error}");
            }

            $f = new Formula($expr);
            $f->name = $name;
            $f->formulaId = $id;
            $new_formula_by_id[$id] = $f;
        }

        // check name reuse
        $lnames_used = [];
        foreach ($new_formula_by_id as $f) {
            $lname = strtolower($f->name);
            if (isset($lnames_used[$lname]))  {
                $msgset->error_at("formula/" . $id2idx[$f->formulaId] . "/name", "<0>" . ($f->name ? $f->name . ": " : "") . "Formula names must be distinct");
            }
            $lnames_used[$lname] = true;
        }

        // validate formulas using new formula set
        $user->conf->replace_named_formulas($new_formula_by_id);
        foreach ($new_formula_by_id as $f) {
            $fdef = $formula_by_id[$f->formulaId] ?? null;
            $pfx = $f->name ? htmlspecialchars($f->name) . ": " : "";
            if ($f->check($user)) {
                if ((!$fdef || $fdef->expression !== $f->expression)
                    && !$user->can_view_formula($f))  {
                    $msgset->error_at("formula/" . $id2idx[$f->formulaId] . "/expression", "<0>{$pfx}This expression refers to properties you can’t access");
                }
            } else {
                foreach ($f->message_list() as $mi) {
                    $msgset->append_item($mi->with_field("formula/" . $id2idx[$f->formulaId] . "/expression"));
                }
            }
        }

        // save
        if (!$msgset->has_error()) {
            $q = $qv = [];
            foreach ($formula_by_id as $f) {
                if (!isset($new_formula_by_id[$f->formulaId])) {
                    $q[] = "delete from Formula where formulaId=?";
                    $qv[] = $f->formulaId;
                }
            }
            foreach ($new_formula_by_id as $f) {
                $fdef = $formula_by_id[$f->formulaId] ?? null;
                if (!$fdef) {
                    $q[] = "insert into Formula set name=?, expression=?, createdBy=?, timeModified=?";
                    array_push($qv, $f->name, $f->expression, $user->privChair ? -$user->contactId : $user->contactId, Conf::$now);
                } else if ($f->name !== $fdef->name || $f->expression !== $fdef->expression) {
                    $q[] = "update Formula set name=?, expression=?, timeModified=? where formulaId=?";
                    array_push($qv, $f->name, $f->expression, Conf::$now, $f->formulaId);
                }
            }
            if (empty($new_formula_by_id)) {
                $q[] = "delete from Settings where name='formulas'";
            } else {
                $q[] = "insert into Settings set name='formulas', value=1 on duplicate key update value=1";
            }
            $mresult = Dbl::multi_qe_apply($user->conf->dblink, join(";", $q), $qv);
            $mresult->free_all();

            $user->conf->replace_named_formulas(null);
            return self::namedformula($user, $qreq);
        } else {
            return ["ok" => false, "message_list" => $msgset->message_list()];
        }
    }


    static function namedsearch(Contact $user, Qrequest $qreq) {
        $fjs = [];
        $ms = new MessageSet;
        foreach ($user->viewable_named_searches(false) as $sj) {
            $q = $sj->q;
            if ($q !== "" && ($sj->t ?? "") !== "" && $sj->t !== "s") {
                $q = "({$sj->q}) in:{$sj->t}";
            }
            $nsj = ["name" => $sj->name, "q" => $q];
            if (isset($sj->display)) {
                $nsj["display"] = $sj->display;
            }
            if (isset($sj->description)) {
                $nsj["description"] = $sj->description;
            }
            if (self::can_edit_search($user, $sj)) {
                $nsj["editable"] = true;
            }
            $fjs[] = $nsj;
            self::append_search_messages($user, $sj->name, $q, count($fjs), $ms);
        }
        $j = ["ok" => true, "searches" => $fjs];
        if ($ms->has_message()) {
            $j["message_list"] = $ms->message_list();
        }
        return new JsonResult($j);
    }

    /** @param Contact $user
     * @param string $name
     * @param string $q
     * @param int $ctr
     * @param MessageSet $ms */
    static function append_search_messages($user, $name, $q, $ctr, $ms) {
        $ps = new PaperSearch($user, $q);
        if (strpos($name, "~") === false && $user->privChair) {
            $ps->main_term()->visit(function (SearchTerm $qe, ...$args) use ($ps) {
                if ($qe instanceof Tag_SearchTerm
                    && ($single_tag = $qe->tsm->single_tag())
                    && $ps->conf->tags()->is_chair($single_tag)) {
                    $ps->lwarning($qe, "<0>Some parts of this PC-visible search only work for chairs");
                }
                return null;
            });
        }
        foreach ($ps->message_list() as $mi) {
            $ms->append_item_at("named_search/{$ctr}/search", $mi);
        }
    }

    /** @param object $v
     * @return bool */
    static function can_edit_search(Contact $user, $v) {
        return $user->privChair
            || !($v->owner ?? false)
            || $v->owner === $user->contactId;
    }

    /** @param string $name
     * @param 'search'|'formula' $type
     * @return ?string */
    static function name_error($name, $type) {
        if ($name === "") {
            return "Name required";
        } else if (preg_match('/\A(?:formula[:\d].*|[fs]:.*|ss:.*|search:.*|[-+]?(?:\d+\.?\d*|\.\d+)(?:e[-+]?\d*)?|none|any|all|unknown|new)\z|[()\[\]\{\}\\\\"\'\#]|\A(?:~.|\d+~|(?=[^~\d])).*~|~\z|\pZ/u', $name)) {
            return "Name reserved";
        } else {
            return null;
        }
    }

    /** @param string $name
     * @param Contact $user
     * @param string $field
     * @param MessageSet $ms
     * @return string */
    static private function _resolve_named_search_name($name, $user, $field, $ms) {
        $twiddle = strpos($name, "~");
        if ($twiddle === false) {
            /* ok */
        } else if ($twiddle === 0 && str_starts_with($name, "~~")) {
            if (!$user->privChair) {
                $ms->error_at($field, "<0>Search reserved for chairs");
            }
        } else if ($twiddle === 0) {
            $name = $user->contactId . $name;
        } else if (str_starts_with($name, $user->contactId . "~")) {
            /* ok */
        } else {
            $ms->error_at($field, "<0>Search name reserved");
        }
        return $name;
    }

    static function save_namedsearch(Contact $user, Qrequest $qreq) {
        // NB permissions handled in loop

        // capture current named searches set
        $ssjs = $user->conf->named_searches();
        foreach ($ssjs as $sj) {
            $sj->id = $sj->name;
            $sj->ctr = null;
        }
        $tagger = new Tagger($user);

        // determine new formula set from request
        $ms = new MessageSet;
        $ctr = max(stoi($qreq["named_search/first_index"]) ?? 1, 1);
        for (; isset($qreq["named_search/{$ctr}/id"]); ++$ctr) {
            $kpfx = "named_search/{$ctr}";
            $id = $qreq["{$kpfx}/id"];
            $name = $qreq["{$kpfx}/name"];
            $q = $qreq["{$kpfx}/search"];
            $deleted = $qreq["{$kpfx}/delete"];
            if ($id === "" || (!isset($name) && !isset($q) && !isset($deleted))) {
                continue;
            }

            $name = simplify_whitespace($name ?? "");
            $q = simplify_whitespace($q ?? "");
            $pfx = $name === "" ? "" : "{$name}: ";

            // fix name and id
            $id = self::_resolve_named_search_name($id, $user, "{$kpfx}/name", $ms);
            $name = self::_resolve_named_search_name($name, $user, "{$kpfx}/name", $ms);

            // find matching search
            if ($id === "new") {
                $sidx = count($ssjs);
            } else {
                $sidx = 0;
                while ($sidx !== count($ssjs)
                       && strcasecmp($id, $ssjs[$sidx]->id) !== 0) {
                    ++$sidx;
                }
            }
            if ($sidx === count($ssjs)) {
                if ($deleted || ($name === "" && $q === "")) {
                    continue;
                } else if ($id !== "new") {
                    $ms->error_at("{$kpfx}/name", "<0>{$pfx}This search has been deleted");
                    continue;
                }
            }

            // check if search is editable
            $fdef = $ssjs[$sidx] ?? null;
            $editable = !$fdef || self::can_edit_search($user, $fdef);
            if (!$editable
                && !$ms->has_error_at("{$kpfx}/name")
                && (strcasecmp($name, $fdef->name) !== 0
                    || $q !== $fdef->q
                    || $deleted)) {
                $ms->error_at("{$kpfx}/name", "<0>{$pfx}You can’t change this named search");
            }

            // maybe delete search
            if ($deleted) {
                array_splice($ssjs, $sidx, 1);
                continue;
            }

            // check name
            if (!$ms->has_error_at("{$kpfx}/name")
                && ($error = self::name_error($name, "search"))) {
                $ms->error_at("{$kpfx}/name", "<0>{$pfx}{$error}");
            }

            // check search
            if ($q === "") {
                $ms->error_at("{$kpfx}/search", "<0>{$pfx}Search required");
            } else {
                self::append_search_messages($user, $name, $q, $ctr, $ms);
            }

            if (!$fdef) {
                $ssjs[] = $fdef = (object) ["id" => ""];
            }
            $fdef->name = $name;
            $fdef->q = $q;
            $fdef->owner = $user->privChair ? "chair" : $user->contactId;
            $fdef->ctr = $ctr;
            if ($qreq["{$kpfx}/highlight"]) {
                $fdef->display = "highlight";
            } else if ($qreq["has-{$kpfx}/highlight"]) {
                unset($fdef->display);
            }
            if (($description = $qreq["{$kpfx}/description"]) !== null) {
                $description = cleannl($description);
                if ($description !== "") {
                    $fdef->description = $description;
                } else {
                    unset($fdef->description);
                }
            }
        }

        // exit on errors
        if ($ms->has_error()) {
            return ["ok" => false, "message_list" => $ms->message_list()];
        }

        // no other errors: check for duplicate names
        $ctr_by_name = [];
        foreach ($ssjs as $sj) {
            $name = strtolower($sj->name);
            if (array_key_exists($name, $ctr_by_name)) {
                if (isset($sj->ctr)) {
                    $ms->error_at("named_search/{$sj->ctr}/name", "<0>Search name ‘{$sj->name}’ is not unique");
                }
                if (isset($ctr_by_name[$name])) {
                    $ms->error_at("named_search/{$ctr_by_name[$name]}/name", "<0>Search name ‘{$sj->name}’ is not unique");
                }
            } else {
                $ctr_by_name[$name] = $sj->ctr;
            }
        }

        // XXX should validate saved searches using new search set

        if ($ms->has_error()) {
            return ["ok" => false, "message_list" => $ms->message_list()];
        }

        // save result
        foreach ($ssjs as $sj) {
            unset($sj->id, $sj->ctr);
        }
        usort($ssjs, [$user->conf, "named_search_compare"]);
        if (!empty($ssjs)) {
            $user->conf->save_setting("named_searches", 1, json_encode_db($ssjs));
        } else {
            $user->conf->save_setting("named_searches", null);
        }
        return self::namedsearch($user, $qreq);
    }
}
