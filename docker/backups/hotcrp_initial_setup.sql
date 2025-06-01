/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.5.29-MariaDB, for debian-linux-gnu (aarch64)
--
-- Host: localhost    Database: hotcrp
-- ------------------------------------------------------
-- Server version	10.5.29-MariaDB-ubu2004

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `hotcrp`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `hotcrp` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci */;

USE `hotcrp`;

--
-- Table structure for table `ActionLog`
--

DROP TABLE IF EXISTS `ActionLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ActionLog` (
  `logId` int(11) NOT NULL AUTO_INCREMENT,
  `contactId` int(11) NOT NULL,
  `destContactId` int(11) DEFAULT NULL,
  `trueContactId` int(11) DEFAULT NULL,
  `paperId` int(11) DEFAULT NULL,
  `timestamp` bigint(11) NOT NULL,
  `ipaddr` varbinary(39) DEFAULT NULL,
  `action` varbinary(4096) NOT NULL,
  `data` varbinary(8192) DEFAULT NULL,
  PRIMARY KEY (`logId`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ActionLog`
--

LOCK TABLES `ActionLog` WRITE;
/*!40000 ALTER TABLE `ActionLog` DISABLE KEYS */;
INSERT INTO `ActionLog` VALUES (1,1,NULL,NULL,NULL,1748772777,'192.168.65.1','Account created',NULL),(2,1,NULL,NULL,NULL,1748772777,'192.168.65.1','Account edited: roles [+sysadmin]',NULL),(3,1,NULL,NULL,NULL,1748772791,'192.168.65.1','Password reset via hcpw0PMLRTuf...',NULL),(4,1,NULL,NULL,NULL,1748772825,'192.168.65.1','Account edited: roles [+pc +chair], name, affiliation, country',NULL),(5,1,NULL,NULL,1,1748772885,'192.168.65.1','Paper started draft: title, abstract, authors, contacts',NULL),(6,1,NULL,NULL,NULL,1748772896,'192.168.65.1','Settings edited: sub_open',NULL),(7,1,NULL,NULL,NULL,1748772903,'192.168.65.1','Settings edited: opt.noPapers',NULL),(8,1,2,NULL,NULL,1748772948,'192.168.65.1','Account created',NULL),(9,1,NULL,NULL,1,1748772948,'192.168.65.1','Paper submitted: contacts, status',NULL),(10,1,3,NULL,NULL,1748772997,'192.168.65.1','Account created',NULL),(11,1,3,NULL,1,1748772997,'192.168.65.1','Review 1 assigned: external',NULL),(12,3,NULL,NULL,NULL,1748773042,'192.168.65.1','Password reset via hcpw0NNzeEcP...',NULL),(13,3,NULL,NULL,NULL,1748773056,'192.168.65.1','Account edited: affiliation, country',NULL),(14,1,NULL,NULL,NULL,1748773216,'192.168.65.1','Settings edited: rev_open',NULL),(15,3,NULL,NULL,1,1748773235,'192.168.65.1','Review 1 edited, submitted: OveMer:2, RevExp:2, PapSum, ComAut, ComPC, 5 words',NULL),(16,1,NULL,NULL,NULL,1748773377,'192.168.65.1','Settings edited: pcrev_editdelegate',NULL),(17,1,4,NULL,NULL,1748773439,'192.168.65.1','Account created',NULL),(18,1,4,NULL,1,1748773439,'192.168.65.1','Review 2 assigned: external',NULL),(19,4,NULL,NULL,NULL,1748773461,'192.168.65.1','Password reset via hcpw0XVBeBHT...',NULL),(20,4,NULL,NULL,NULL,1748773467,'192.168.65.1','Account edited: affiliation',NULL),(21,4,NULL,NULL,1,1748773475,'192.168.65.1','Review 2 edited, delivered: OveMer:1, RevExp:3, PapSum, ComAut, ComPC, 3 words',NULL);
/*!40000 ALTER TABLE `ActionLog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Capability`
--

DROP TABLE IF EXISTS `Capability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Capability` (
  `capabilityType` int(11) NOT NULL,
  `contactId` int(11) NOT NULL,
  `paperId` int(11) NOT NULL,
  `reviewId` int(11) NOT NULL DEFAULT 0,
  `timeCreated` bigint(11) NOT NULL,
  `timeUsed` bigint(11) NOT NULL,
  `timeInvalid` bigint(11) NOT NULL,
  `timeExpires` bigint(11) NOT NULL,
  `salt` varbinary(255) NOT NULL,
  `inputData` varbinary(16384) DEFAULT NULL,
  `data` varbinary(16384) DEFAULT NULL,
  `outputData` longblob DEFAULT NULL,
  `lookupKey` varbinary(255) DEFAULT NULL,
  PRIMARY KEY (`salt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Capability`
--

LOCK TABLES `Capability` WRITE;
/*!40000 ALTER TABLE `Capability` DISABLE KEYS */;
INSERT INTO `Capability` VALUES (4,0,1,0,1748772948,0,0,0,'hcav1JsGTuRYQCBJoLMFmgMnnKaJC',NULL,NULL,NULL,NULL),(1,2,0,0,1748772948,0,0,1749032148,'hcpw0GccVhFgcYrmizHGqXbhUyFuYfbtWKB',NULL,NULL,NULL,NULL),(5,3,1,1,1748772997,0,1752660997,1753956997,'hcra1wQTmGYnASLMdFfDhrdDUCazA',NULL,NULL,NULL,NULL),(5,4,1,2,1748773439,0,1752661439,1753957439,'hcra2YkBooXHHEfCSADRkPtUdYXDC',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `Capability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ContactCounter`
--

DROP TABLE IF EXISTS `ContactCounter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ContactCounter` (
  `contactId` int(11) NOT NULL,
  `apiCount` bigint(11) NOT NULL DEFAULT 0,
  `apiLimit` bigint(11) NOT NULL DEFAULT 0,
  `apiRefreshMtime` bigint(11) NOT NULL DEFAULT 0,
  `apiRefreshWindow` int(11) NOT NULL DEFAULT 0,
  `apiRefreshAmount` int(11) NOT NULL DEFAULT 0,
  `apiLimit2` bigint(11) NOT NULL DEFAULT 0,
  `apiRefreshMtime2` bigint(11) NOT NULL DEFAULT 0,
  `apiRefreshWindow2` int(11) NOT NULL DEFAULT 0,
  `apiRefreshAmount2` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`contactId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ContactCounter`
--

LOCK TABLES `ContactCounter` WRITE;
/*!40000 ALTER TABLE `ContactCounter` DISABLE KEYS */;
/*!40000 ALTER TABLE `ContactCounter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ContactInfo`
--

DROP TABLE IF EXISTS `ContactInfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ContactInfo` (
  `contactId` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(120) NOT NULL,
  `firstName` varbinary(120) NOT NULL DEFAULT '',
  `lastName` varbinary(120) NOT NULL DEFAULT '',
  `unaccentedName` varbinary(2048) NOT NULL DEFAULT '',
  `affiliation` varbinary(2048) NOT NULL DEFAULT '',
  `roles` tinyint(1) NOT NULL DEFAULT 0,
  `disabled` tinyint(1) NOT NULL DEFAULT 0,
  `primaryContactId` int(11) NOT NULL DEFAULT 0,
  `contactTags` varbinary(4096) DEFAULT NULL,
  `cflags` int(11) NOT NULL DEFAULT 0,
  `orcid` varbinary(64) DEFAULT NULL,
  `phone` varbinary(64) DEFAULT NULL,
  `country` varbinary(256) DEFAULT NULL,
  `password` varbinary(2048) NOT NULL,
  `passwordTime` bigint(11) NOT NULL DEFAULT 0,
  `passwordUseTime` bigint(11) NOT NULL DEFAULT 0,
  `collaborators` varbinary(8192) DEFAULT NULL,
  `preferredEmail` varchar(120) DEFAULT NULL,
  `updateTime` bigint(11) NOT NULL DEFAULT 0,
  `lastLogin` bigint(11) NOT NULL DEFAULT 0,
  `defaultWatch` int(11) NOT NULL DEFAULT 2,
  `cdbRoles` tinyint(1) NOT NULL DEFAULT 0,
  `data` varbinary(32767) DEFAULT NULL,
  PRIMARY KEY (`contactId`),
  UNIQUE KEY `email` (`email`),
  KEY `roles` (`roles`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ContactInfo`
--

LOCK TABLES `ContactInfo` WRITE;
/*!40000 ALTER TABLE `ContactInfo` DISABLE KEYS */;
INSERT INTO `ContactInfo` VALUES (1,'local_chair@schaffner.pro','First','PCChair','first pcchair (master university)','Master University',7,0,0,NULL,0,NULL,NULL,'NL',' $$2y$10$N4XllbR1nWc54WJhCZVZTueCFDUZ3iGgRVsyOQFBDBmvXfP1eItvy',1748772791,1748772794,NULL,NULL,1748772825,1748773377,2,0,NULL),(2,'author1@schaffner.pro','','First','first (author)','Author',0,0,0,NULL,32,NULL,NULL,NULL,' unset',1748772885,0,NULL,NULL,0,0,2,0,NULL),(3,'external_reviewer@schaffner.pro','External','Reviewer','external reviewer (external university)','External University',0,0,0,NULL,0,NULL,NULL,'NL',' $$2y$10$ViDGYZectjmU6rVx3JpJ1OTq6j1DSS2euk6Rz9Dp/DiYk2OWwCVzi',1748773042,1748773045,NULL,NULL,1748773056,1748773235,2,0,NULL),(4,'another_external@schaffner.pro','Another','External','another external (asdfasdf)','asdfasdf',0,0,0,NULL,0,NULL,NULL,NULL,' $$2y$10$mAzyzP1pT4nnKNS1JQeT0eZbTxUx9PDQzpQgz9EyoIr4CZbG2obbe',1748773461,1748773463,NULL,NULL,1748773467,1748773475,2,0,NULL);
/*!40000 ALTER TABLE `ContactInfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ContactPrimary`
--

DROP TABLE IF EXISTS `ContactPrimary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ContactPrimary` (
  `contactId` int(11) NOT NULL,
  `primaryContactId` int(11) NOT NULL,
  PRIMARY KEY (`contactId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ContactPrimary`
--

LOCK TABLES `ContactPrimary` WRITE;
/*!40000 ALTER TABLE `ContactPrimary` DISABLE KEYS */;
/*!40000 ALTER TABLE `ContactPrimary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DeletedContactInfo`
--

DROP TABLE IF EXISTS `DeletedContactInfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DeletedContactInfo` (
  `contactId` int(11) NOT NULL,
  `firstName` varbinary(120) NOT NULL,
  `lastName` varbinary(120) NOT NULL,
  `unaccentedName` varbinary(2048) NOT NULL,
  `email` varchar(120) NOT NULL,
  `affiliation` varbinary(2048) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DeletedContactInfo`
--

LOCK TABLES `DeletedContactInfo` WRITE;
/*!40000 ALTER TABLE `DeletedContactInfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `DeletedContactInfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DocumentLink`
--

DROP TABLE IF EXISTS `DocumentLink`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `DocumentLink` (
  `paperId` int(11) NOT NULL,
  `linkId` int(11) NOT NULL,
  `linkType` int(11) NOT NULL,
  `documentId` int(11) NOT NULL,
  PRIMARY KEY (`paperId`,`linkId`,`linkType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DocumentLink`
--

LOCK TABLES `DocumentLink` WRITE;
/*!40000 ALTER TABLE `DocumentLink` DISABLE KEYS */;
/*!40000 ALTER TABLE `DocumentLink` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FilteredDocument`
--

DROP TABLE IF EXISTS `FilteredDocument`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `FilteredDocument` (
  `inDocId` int(11) NOT NULL,
  `filterType` int(11) NOT NULL,
  `outDocId` int(11) NOT NULL,
  `createdAt` bigint(11) NOT NULL,
  PRIMARY KEY (`inDocId`,`filterType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FilteredDocument`
--

LOCK TABLES `FilteredDocument` WRITE;
/*!40000 ALTER TABLE `FilteredDocument` DISABLE KEYS */;
/*!40000 ALTER TABLE `FilteredDocument` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Formula`
--

DROP TABLE IF EXISTS `Formula`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Formula` (
  `formulaId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `expression` varbinary(4096) NOT NULL,
  `createdBy` int(11) NOT NULL DEFAULT 0,
  `timeModified` bigint(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`formulaId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Formula`
--

LOCK TABLES `Formula` WRITE;
/*!40000 ALTER TABLE `Formula` DISABLE KEYS */;
/*!40000 ALTER TABLE `Formula` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IDReservation`
--

DROP TABLE IF EXISTS `IDReservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `IDReservation` (
  `type` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `timestamp` bigint(11) NOT NULL,
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`type`,`id`),
  UNIQUE KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IDReservation`
--

LOCK TABLES `IDReservation` WRITE;
/*!40000 ALTER TABLE `IDReservation` DISABLE KEYS */;
/*!40000 ALTER TABLE `IDReservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Invitation`
--

DROP TABLE IF EXISTS `Invitation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Invitation` (
  `invitationId` int(11) NOT NULL AUTO_INCREMENT,
  `invitationType` int(11) NOT NULL,
  `email` varchar(120) NOT NULL,
  `firstName` varbinary(120) DEFAULT NULL,
  `lastName` varbinary(120) DEFAULT NULL,
  `affiliation` varbinary(2048) DEFAULT NULL,
  `requestedBy` int(11) NOT NULL,
  `timeRequested` bigint(11) NOT NULL DEFAULT 0,
  `timeRequestNotified` bigint(11) NOT NULL DEFAULT 0,
  `salt` varbinary(255) NOT NULL,
  `data` varbinary(4096) DEFAULT NULL,
  PRIMARY KEY (`invitationId`),
  UNIQUE KEY `salt` (`salt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Invitation`
--

LOCK TABLES `Invitation` WRITE;
/*!40000 ALTER TABLE `Invitation` DISABLE KEYS */;
/*!40000 ALTER TABLE `Invitation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `InvitationLog`
--

DROP TABLE IF EXISTS `InvitationLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `InvitationLog` (
  `logId` int(11) NOT NULL AUTO_INCREMENT,
  `invitationId` int(11) NOT NULL,
  `mailId` int(11) DEFAULT NULL,
  `contactId` int(11) NOT NULL,
  `action` int(11) NOT NULL,
  `timestamp` bigint(11) NOT NULL,
  PRIMARY KEY (`logId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `InvitationLog`
--

LOCK TABLES `InvitationLog` WRITE;
/*!40000 ALTER TABLE `InvitationLog` DISABLE KEYS */;
/*!40000 ALTER TABLE `InvitationLog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MailLog`
--

DROP TABLE IF EXISTS `MailLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `MailLog` (
  `mailId` int(11) NOT NULL AUTO_INCREMENT,
  `contactId` int(11) NOT NULL DEFAULT 0,
  `recipients` varbinary(200) NOT NULL,
  `q` varbinary(4096) DEFAULT NULL,
  `t` varbinary(200) DEFAULT NULL,
  `paperIds` blob DEFAULT NULL,
  `cc` blob DEFAULT NULL,
  `replyto` blob DEFAULT NULL,
  `subject` blob DEFAULT NULL,
  `emailBody` blob DEFAULT NULL,
  `fromNonChair` tinyint(1) NOT NULL DEFAULT 0,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`mailId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MailLog`
--

LOCK TABLES `MailLog` WRITE;
/*!40000 ALTER TABLE `MailLog` DISABLE KEYS */;
/*!40000 ALTER TABLE `MailLog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Paper`
--

DROP TABLE IF EXISTS `Paper`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Paper` (
  `paperId` int(11) NOT NULL AUTO_INCREMENT,
  `title` varbinary(512) DEFAULT NULL,
  `authorInformation` varbinary(8192) DEFAULT NULL,
  `abstract` varbinary(16384) DEFAULT NULL,
  `collaborators` varbinary(8192) DEFAULT NULL,
  `timeSubmitted` bigint(11) NOT NULL DEFAULT 0,
  `timeWithdrawn` bigint(11) NOT NULL DEFAULT 0,
  `timeModified` bigint(11) NOT NULL DEFAULT 0,
  `timeFinalSubmitted` bigint(11) NOT NULL DEFAULT 0,
  `paperStorageId` int(11) NOT NULL DEFAULT 0,
  `sha1` varbinary(64) NOT NULL DEFAULT '',
  `finalPaperStorageId` int(11) NOT NULL DEFAULT 0,
  `blind` tinyint(1) NOT NULL DEFAULT 1,
  `outcome` tinyint(1) NOT NULL DEFAULT 0,
  `leadContactId` int(11) NOT NULL DEFAULT 0,
  `shepherdContactId` int(11) NOT NULL DEFAULT 0,
  `managerContactId` int(11) NOT NULL DEFAULT 0,
  `capVersion` int(1) NOT NULL DEFAULT 0,
  `size` bigint(11) NOT NULL DEFAULT -1,
  `mimetype` varbinary(80) NOT NULL DEFAULT '',
  `timestamp` bigint(11) NOT NULL DEFAULT 0,
  `pdfFormatStatus` bigint(11) NOT NULL DEFAULT 0,
  `withdrawReason` blob DEFAULT NULL,
  `paperFormat` tinyint(1) DEFAULT NULL,
  `dataOverflow` longblob DEFAULT NULL,
  PRIMARY KEY (`paperId`),
  KEY `timeSubmitted` (`timeSubmitted`),
  KEY `leadContactId` (`leadContactId`),
  KEY `shepherdContactId` (`shepherdContactId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Paper`
--

LOCK TABLES `Paper` WRITE;
/*!40000 ALTER TABLE `Paper` DISABLE KEYS */;
INSERT INTO `Paper` VALUES (1,'tests','	First	author1@schaffner.pro	Author','test',NULL,1748772948,0,1748772948,0,0,'',0,1,0,0,0,0,0,-1,'',0,0,NULL,NULL,NULL);
/*!40000 ALTER TABLE `Paper` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PaperComment`
--

DROP TABLE IF EXISTS `PaperComment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PaperComment` (
  `paperId` int(11) NOT NULL,
  `commentId` int(11) NOT NULL AUTO_INCREMENT,
  `contactId` int(11) NOT NULL,
  `timeModified` bigint(11) NOT NULL,
  `timeNotified` bigint(11) NOT NULL DEFAULT 0,
  `timeDisplayed` bigint(11) NOT NULL DEFAULT 0,
  `comment` varbinary(32767) DEFAULT NULL,
  `commentType` int(11) NOT NULL DEFAULT 0,
  `replyTo` int(11) NOT NULL,
  `ordinal` int(11) NOT NULL DEFAULT 0,
  `authorOrdinal` int(11) NOT NULL DEFAULT 0,
  `commentTags` varbinary(1024) DEFAULT NULL,
  `commentRound` int(11) NOT NULL DEFAULT 0,
  `commentFormat` tinyint(1) DEFAULT NULL,
  `commentOverflow` longblob DEFAULT NULL,
  `commentData` varbinary(4096) DEFAULT NULL,
  PRIMARY KEY (`paperId`,`commentId`),
  UNIQUE KEY `commentId` (`commentId`),
  KEY `contactId` (`contactId`),
  KEY `timeModifiedContact` (`timeModified`,`contactId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PaperComment`
--

LOCK TABLES `PaperComment` WRITE;
/*!40000 ALTER TABLE `PaperComment` DISABLE KEYS */;
/*!40000 ALTER TABLE `PaperComment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PaperConflict`
--

DROP TABLE IF EXISTS `PaperConflict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PaperConflict` (
  `paperId` int(11) NOT NULL,
  `contactId` int(11) NOT NULL,
  `conflictType` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`contactId`,`paperId`),
  KEY `paperId` (`paperId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PaperConflict`
--

LOCK TABLES `PaperConflict` WRITE;
/*!40000 ALTER TABLE `PaperConflict` DISABLE KEYS */;
INSERT INTO `PaperConflict` VALUES (1,2,96);
/*!40000 ALTER TABLE `PaperConflict` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PaperOption`
--

DROP TABLE IF EXISTS `PaperOption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PaperOption` (
  `paperId` int(11) NOT NULL,
  `optionId` int(11) NOT NULL,
  `value` bigint(11) NOT NULL DEFAULT 0,
  `data` varbinary(32767) DEFAULT NULL,
  `dataOverflow` longblob DEFAULT NULL,
  PRIMARY KEY (`paperId`,`optionId`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PaperOption`
--

LOCK TABLES `PaperOption` WRITE;
/*!40000 ALTER TABLE `PaperOption` DISABLE KEYS */;
/*!40000 ALTER TABLE `PaperOption` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PaperReview`
--

DROP TABLE IF EXISTS `PaperReview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PaperReview` (
  `paperId` int(11) NOT NULL,
  `reviewId` int(11) NOT NULL AUTO_INCREMENT,
  `contactId` int(11) NOT NULL,
  `reviewType` tinyint(1) NOT NULL,
  `requestedBy` int(11) NOT NULL DEFAULT 0,
  `reviewToken` int(11) NOT NULL DEFAULT 0,
  `reviewRound` int(1) NOT NULL DEFAULT 0,
  `reviewOrdinal` int(1) NOT NULL DEFAULT 0,
  `reviewBlind` tinyint(1) NOT NULL,
  `reviewTime` bigint(11) NOT NULL DEFAULT 0,
  `reviewModified` bigint(1) NOT NULL DEFAULT 0,
  `reviewSubmitted` bigint(1) DEFAULT NULL,
  `reviewAuthorSeen` bigint(1) NOT NULL DEFAULT 0,
  `timeDisplayed` bigint(11) NOT NULL DEFAULT 0,
  `timeApprovalRequested` bigint(11) NOT NULL DEFAULT 0,
  `reviewNeedsSubmit` tinyint(1) NOT NULL DEFAULT 1,
  `reviewViewScore` tinyint(2) NOT NULL DEFAULT -3,
  `rflags` int(11) NOT NULL,
  `timeRequested` bigint(11) NOT NULL DEFAULT 0,
  `timeRequestNotified` bigint(11) NOT NULL DEFAULT 0,
  `reviewAuthorModified` bigint(1) DEFAULT NULL,
  `reviewNotified` bigint(1) DEFAULT NULL,
  `reviewAuthorNotified` bigint(11) NOT NULL DEFAULT 0,
  `reviewEditVersion` int(1) NOT NULL DEFAULT 0,
  `reviewWordCount` int(11) DEFAULT NULL,
  `s01` smallint(1) NOT NULL DEFAULT 0,
  `s02` smallint(1) NOT NULL DEFAULT 0,
  `s03` smallint(1) NOT NULL DEFAULT 0,
  `s04` smallint(1) NOT NULL DEFAULT 0,
  `s05` smallint(1) NOT NULL DEFAULT 0,
  `s06` smallint(1) NOT NULL DEFAULT 0,
  `s07` smallint(1) NOT NULL DEFAULT 0,
  `s08` smallint(1) NOT NULL DEFAULT 0,
  `s09` smallint(1) NOT NULL DEFAULT 0,
  `s10` smallint(4) NOT NULL DEFAULT 0,
  `s11` smallint(4) NOT NULL DEFAULT 0,
  `tfields` longblob DEFAULT NULL,
  `sfields` varbinary(2048) DEFAULT NULL,
  PRIMARY KEY (`paperId`,`reviewId`),
  UNIQUE KEY `reviewId` (`reviewId`),
  KEY `contactIdReviewType` (`contactId`,`reviewType`),
  KEY `reviewType` (`reviewType`),
  KEY `reviewRound` (`reviewRound`),
  KEY `requestedBy` (`requestedBy`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PaperReview`
--

LOCK TABLES `PaperReview` WRITE;
/*!40000 ALTER TABLE `PaperReview` DISABLE KEYS */;
INSERT INTO `PaperReview` VALUES (1,1,3,1,1,0,0,1,1,5343,1748773235,1748773235,0,1748773235,0,0,3,70403,1748772997,1748772997,1748773235,1748773235,0,1,3,2,2,0,0,0,0,0,0,0,0,0,'{\"t01\":\"summary\\n\",\"t02\":\"for authors\\n\",\"t03\":\"for pc\\n\"}',NULL),(1,2,4,1,1,0,0,0,1,2401,1748773475,NULL,0,0,1748773475,1,3,67331,1748773439,1748773439,1748773475,NULL,0,1,2,1,3,0,0,0,0,0,0,0,0,0,'{\"t01\":\"sadfasdf\\n\",\"t02\":\"asdfasdf\\n\",\"t03\":\"asdfasd\\n\"}',NULL);
/*!40000 ALTER TABLE `PaperReview` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PaperReviewHistory`
--

DROP TABLE IF EXISTS `PaperReviewHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PaperReviewHistory` (
  `paperId` int(11) NOT NULL,
  `reviewId` int(11) NOT NULL,
  `reviewTime` bigint(11) NOT NULL,
  `reviewNextTime` bigint(11) NOT NULL,
  `contactId` int(11) NOT NULL,
  `reviewRound` int(1) NOT NULL,
  `reviewOrdinal` int(1) NOT NULL,
  `reviewType` tinyint(1) NOT NULL,
  `reviewBlind` tinyint(1) NOT NULL,
  `reviewModified` bigint(11) NOT NULL,
  `reviewSubmitted` bigint(1) NOT NULL,
  `timeDisplayed` bigint(11) NOT NULL,
  `timeApprovalRequested` bigint(11) NOT NULL,
  `reviewAuthorSeen` bigint(1) NOT NULL,
  `reviewAuthorModified` bigint(1) DEFAULT NULL,
  `reviewNotified` bigint(1) DEFAULT NULL,
  `reviewAuthorNotified` bigint(11) NOT NULL,
  `reviewEditVersion` int(1) NOT NULL,
  `rflags` int(11) NOT NULL,
  `revdelta` longblob DEFAULT NULL,
  PRIMARY KEY (`paperId`,`reviewId`,`reviewTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PaperReviewHistory`
--

LOCK TABLES `PaperReviewHistory` WRITE;
/*!40000 ALTER TABLE `PaperReviewHistory` DISABLE KEYS */;
INSERT INTO `PaperReviewHistory` VALUES (1,1,0,5343,3,0,0,1,1,0,0,0,0,0,0,0,0,0,65539,'{\"s01\":null,\"s02\":null,\"t01\":null,\"t02\":null,\"t03\":null}'),(1,2,0,2401,4,0,0,1,1,0,0,0,0,0,0,0,0,0,65539,'{\"s01\":null,\"s02\":null,\"t01\":null,\"t02\":null,\"t03\":null}');
/*!40000 ALTER TABLE `PaperReviewHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PaperReviewPreference`
--

DROP TABLE IF EXISTS `PaperReviewPreference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PaperReviewPreference` (
  `paperId` int(11) NOT NULL,
  `contactId` int(11) NOT NULL,
  `preference` int(4) NOT NULL DEFAULT 0,
  `expertise` int(4) DEFAULT NULL,
  PRIMARY KEY (`paperId`,`contactId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PaperReviewPreference`
--

LOCK TABLES `PaperReviewPreference` WRITE;
/*!40000 ALTER TABLE `PaperReviewPreference` DISABLE KEYS */;
/*!40000 ALTER TABLE `PaperReviewPreference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PaperReviewRefused`
--

DROP TABLE IF EXISTS `PaperReviewRefused`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PaperReviewRefused` (
  `paperId` int(11) NOT NULL,
  `email` varchar(120) NOT NULL,
  `firstName` varbinary(120) DEFAULT NULL,
  `lastName` varbinary(120) DEFAULT NULL,
  `affiliation` varbinary(2048) DEFAULT NULL,
  `contactId` int(11) NOT NULL,
  `refusedReviewId` int(11) DEFAULT NULL,
  `refusedReviewType` tinyint(1) NOT NULL DEFAULT 0,
  `reviewRound` int(1) DEFAULT NULL,
  `requestedBy` int(11) NOT NULL,
  `timeRequested` bigint(11) DEFAULT NULL,
  `refusedBy` int(11) DEFAULT NULL,
  `timeRefused` bigint(11) DEFAULT NULL,
  `reason` varbinary(32767) DEFAULT NULL,
  PRIMARY KEY (`paperId`,`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PaperReviewRefused`
--

LOCK TABLES `PaperReviewRefused` WRITE;
/*!40000 ALTER TABLE `PaperReviewRefused` DISABLE KEYS */;
/*!40000 ALTER TABLE `PaperReviewRefused` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PaperStorage`
--

DROP TABLE IF EXISTS `PaperStorage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PaperStorage` (
  `paperId` int(11) NOT NULL,
  `paperStorageId` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` bigint(11) NOT NULL,
  `mimetype` varbinary(80) NOT NULL DEFAULT '',
  `paper` longblob DEFAULT NULL,
  `compression` tinyint(1) NOT NULL DEFAULT 0,
  `sha1` varbinary(64) NOT NULL DEFAULT '',
  `crc32` binary(4) DEFAULT NULL,
  `documentType` int(3) NOT NULL DEFAULT 0,
  `filename` varbinary(255) DEFAULT NULL,
  `infoJson` varbinary(32768) DEFAULT NULL,
  `size` bigint(11) NOT NULL DEFAULT -1,
  `filterType` int(3) DEFAULT NULL,
  `originalStorageId` int(11) DEFAULT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT 0,
  `npages` int(3) NOT NULL DEFAULT -1,
  `width` int(8) NOT NULL DEFAULT -1,
  `height` int(8) NOT NULL DEFAULT -1,
  PRIMARY KEY (`paperId`,`paperStorageId`),
  UNIQUE KEY `paperStorageId` (`paperStorageId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PaperStorage`
--

LOCK TABLES `PaperStorage` WRITE;
/*!40000 ALTER TABLE `PaperStorage` DISABLE KEYS */;
INSERT INTO `PaperStorage` VALUES (0,1,0,'text/plain','',0,'\⁄9£\Ó^kK\r2Uø\Ôï`êØ\ÿ	',NULL,0,NULL,NULL,0,NULL,NULL,0,-1,-1,-1);
/*!40000 ALTER TABLE `PaperStorage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PaperTag`
--

DROP TABLE IF EXISTS `PaperTag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PaperTag` (
  `paperId` int(11) NOT NULL,
  `tag` varchar(80) NOT NULL,
  `tagIndex` float NOT NULL DEFAULT 0,
  PRIMARY KEY (`paperId`,`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PaperTag`
--

LOCK TABLES `PaperTag` WRITE;
/*!40000 ALTER TABLE `PaperTag` DISABLE KEYS */;
/*!40000 ALTER TABLE `PaperTag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PaperTagAnno`
--

DROP TABLE IF EXISTS `PaperTagAnno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PaperTagAnno` (
  `tag` varchar(80) NOT NULL,
  `annoId` int(11) NOT NULL,
  `tagIndex` float NOT NULL DEFAULT 0,
  `heading` varbinary(8192) DEFAULT NULL,
  `annoFormat` tinyint(1) DEFAULT NULL,
  `infoJson` varbinary(32768) DEFAULT NULL,
  PRIMARY KEY (`tag`,`annoId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PaperTagAnno`
--

LOCK TABLES `PaperTagAnno` WRITE;
/*!40000 ALTER TABLE `PaperTagAnno` DISABLE KEYS */;
/*!40000 ALTER TABLE `PaperTagAnno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PaperTopic`
--

DROP TABLE IF EXISTS `PaperTopic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PaperTopic` (
  `paperId` int(11) NOT NULL,
  `topicId` int(11) NOT NULL,
  PRIMARY KEY (`paperId`,`topicId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PaperTopic`
--

LOCK TABLES `PaperTopic` WRITE;
/*!40000 ALTER TABLE `PaperTopic` DISABLE KEYS */;
/*!40000 ALTER TABLE `PaperTopic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PaperWatch`
--

DROP TABLE IF EXISTS `PaperWatch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `PaperWatch` (
  `paperId` int(11) NOT NULL,
  `contactId` int(11) NOT NULL,
  `watch` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`paperId`,`contactId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PaperWatch`
--

LOCK TABLES `PaperWatch` WRITE;
/*!40000 ALTER TABLE `PaperWatch` DISABLE KEYS */;
/*!40000 ALTER TABLE `PaperWatch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ReviewRating`
--

DROP TABLE IF EXISTS `ReviewRating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ReviewRating` (
  `paperId` int(11) NOT NULL,
  `reviewId` int(11) NOT NULL,
  `contactId` int(11) NOT NULL,
  `rating` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`paperId`,`reviewId`,`contactId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReviewRating`
--

LOCK TABLES `ReviewRating` WRITE;
/*!40000 ALTER TABLE `ReviewRating` DISABLE KEYS */;
/*!40000 ALTER TABLE `ReviewRating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ReviewRequest`
--

DROP TABLE IF EXISTS `ReviewRequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ReviewRequest` (
  `paperId` int(11) NOT NULL,
  `email` varchar(120) NOT NULL,
  `firstName` varbinary(120) DEFAULT NULL,
  `lastName` varbinary(120) DEFAULT NULL,
  `affiliation` varbinary(2048) DEFAULT NULL,
  `reason` varbinary(32767) DEFAULT NULL,
  `requestedBy` int(11) NOT NULL,
  `timeRequested` bigint(11) NOT NULL,
  `reviewRound` int(1) DEFAULT NULL,
  PRIMARY KEY (`paperId`,`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReviewRequest`
--

LOCK TABLES `ReviewRequest` WRITE;
/*!40000 ALTER TABLE `ReviewRequest` DISABLE KEYS */;
/*!40000 ALTER TABLE `ReviewRequest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Settings`
--

DROP TABLE IF EXISTS `Settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Settings` (
  `name` varbinary(256) NOT NULL,
  `value` bigint(11) NOT NULL,
  `data` varbinary(32767) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Settings`
--

LOCK TABLES `Settings` WRITE;
/*!40000 ALTER TABLE `Settings` DISABLE KEYS */;
INSERT INTO `Settings` VALUES ('__capability_gc',1748772717,NULL),('allowPaperOption',310,NULL),('extrev_chairreq',2,NULL),('opt.noPapers',2,NULL),('pcrev_any',1,NULL),('pcrev_editdelegate',3,NULL),('pcrev_soft',0,NULL),('rev_open',1748773216,NULL),('sub_open',1748772896,NULL),('sub_pcconf',1,NULL),('tag_chair',1,'accept pcpaper reject'),('viewrevid',1,NULL);
/*!40000 ALTER TABLE `Settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TopicArea`
--

DROP TABLE IF EXISTS `TopicArea`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `TopicArea` (
  `topicId` int(11) NOT NULL AUTO_INCREMENT,
  `topicName` varbinary(1024) DEFAULT NULL,
  PRIMARY KEY (`topicId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TopicArea`
--

LOCK TABLES `TopicArea` WRITE;
/*!40000 ALTER TABLE `TopicArea` DISABLE KEYS */;
/*!40000 ALTER TABLE `TopicArea` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TopicInterest`
--

DROP TABLE IF EXISTS `TopicInterest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `TopicInterest` (
  `contactId` int(11) NOT NULL,
  `topicId` int(11) NOT NULL,
  `interest` int(1) NOT NULL,
  PRIMARY KEY (`contactId`,`topicId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TopicInterest`
--

LOCK TABLES `TopicInterest` WRITE;
/*!40000 ALTER TABLE `TopicInterest` DISABLE KEYS */;
/*!40000 ALTER TABLE `TopicInterest` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-01 10:26:01
