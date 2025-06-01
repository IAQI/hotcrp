# Plan for Modifying HotCRP Subreview Adoption Options

## System Setup Instructions

### 1. Create Docker Configuration
1. Create `docker-compose.yml` in the project root:
```yaml
version: '3.8'
services:
  db:
    image: mariadb:10.5
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: hotcrp
      MYSQL_USER: hotcrp
      MYSQL_PASSWORD: hotcrp
    volumes:
      - db_data:/var/lib/mysql
    ports:
      - "3306:3306"
    command: --max-allowed-packet=32M

  web:
    image: php:8.2-apache
    depends_on:
      - db
    volumes:
      - .:/var/www/html
      - ./docker/php.ini:/usr/local/etc/php/php.ini
    ports:
      - "8080:80"
    environment:
      - APACHE_DOCUMENT_ROOT=/var/www/html

  mailhog:
    image: mailhog/mailhog
    ports:
      - "8025:8025"
      - "1025:1025"

volumes:
  db_data:
```

2. Create `docker/php.ini` for PHP configuration:
```ini
upload_max_filesize = 15M
post_max_size = 20M
max_input_vars = 4096
session.gc_maxlifetime = 86400
```

3. Create `Dockerfile` for web service:
```dockerfile
FROM php:8.2-apache

# Install dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    poppler-utils \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# Enable Apache modules
RUN a2enmod rewrite

# Configure Apache
ENV APACHE_DOCUMENT_ROOT /var/www/html
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
```

### 2. Setup and Run
1. Build and start containers:
```bash
# First time setup
docker compose build
docker compose up -d

# Wait for database to be ready
sleep 10

# Create database schema (from host machine)
docker compose exec web /var/www/html/lib/createdb.sh --host=db --user=root --password=root hotcrp
```

2. Configure application:
```bash
# Create config directory and copy default options
mkdir -p conf
cp etc/distoptions.php conf/options.php

# Update database configuration in conf/options.php
cat << EOF >> conf/options.php
\$Opt["dbName"] = "hotcrp";
\$Opt["dbUser"] = "hotcrp";
\$Opt["dbPassword"] = "hotcrp";
\$Opt["dbHost"] = "db";
EOF

# Set proper permissions
docker compose exec web chown -R www-data:www-data /var/www/html/conf
docker compose exec web chmod 600 /var/www/html/conf/options.php
```

### 3. Testing Environment Setup
1. Access the application:
   - Web interface: http://localhost:8080
   - MailHog (for email testing): http://localhost:8025

2. Create test accounts through the web interface:
   - Create admin account by visiting http://localhost:8080
   - The first account created becomes the administrator

3. Test data setup:
   - Log in as admin
   - Create a test conference
   - Create some test papers
   - Set up PC members and external reviewers

4. Verify system:
   - Check database connection
   - Verify email sending (through MailHog)
   - Test file uploads
   - Check review functionality

### 4. Development Workflow
1. Make changes to files locally - they are mounted into the container
2. Changes take effect immediately (no rebuild needed)
3. Logs can be viewed with:
```bash
docker compose logs -f web
```

4. Database can be accessed with:
```bash
docker compose exec db mariadb -uhotcrp -photcrp hotcrp
```

5. To rebuild containers after dependency changes:
```bash
docker compose down
docker compose build
docker compose up -d
```

## Current System Understanding
The review adoption options are controlled in the UI through:

1. `src/reviewform.php` - Controls the UI buttons and their functionality:
   - Multiple buttons are generated based on different conditions:
     - "Adopt as draft" (via `can-adopt` and `can-adopt-replace` classes)
     - "Approve subreview" (base button)
     - "Adopt and submit" (via `can-approve-submit` class)
   - Button state (enabled/disabled) is controlled through the `disabled` attribute
   - Button visibility and behavior is managed through CSS classes

## Required Changes

### Primary File to Modify
- `src/reviewform.php`
- Specifically the button generation code around line 467

### Specific Changes Needed
1. Keep all existing buttons but modify their enabled state:
   ```php
   // Example structure:
   $buttons[] = Ht::submit("action", "Button Text", [
     "class" => "original-classes",
     "disabled" => $this->shouldBeDisabled()  // New logic here
   ]);
   ```

2. Add disabled attribute to:
   - "Adopt as draft" buttons (both variants)
   - "Approve subreview" basic option
   - Any "Submit as full review" options

3. Leave enabled:
   - "Adopt and submit" option with `can-approve-submit` class

4. Add visual indication that buttons are permanently disabled:
   - Keep existing styling
   - Add tooltip or helper text explaining why options are disabled
   - Maintain consistent UI appearance

5. Maintain existing permission checks and conditions:
   - Keep admin permission verification
   - Preserve review status checks
   - Keep all existing conditional logic

### Testing Steps
1. Using the setup above:
   - Test with admin account (all permissions)
   - Test with PC member account (limited permissions)
   - Test with external reviewer account (restricted permissions)
2. Test review scenarios:
   - Submit external review
   - Verify button states for each role
   - Attempt to use disabled functionality
3. Verify only "Adopt and submit" works

### Verification Plan
1. UI Verification:
   - All buttons visible but inactive except "Adopt and submit"
   - Proper disabled state styling
   - Clear user feedback on disabled options

2. Functional Testing:
   - Only "Adopt and submit" clickable
   - Other actions blocked
   - Review status updates correctly

3. Security Testing:
   - Direct POST requests blocked for disabled actions
   - URL parameter manipulation prevented
   - Role-based access maintained

### Rollback Plan
1. Keep backup of original `reviewform.php`
2. Document current button generation code
3. Create revert commit
4. Test rollback process

## Success Criteria
1. Review adoption options visible but disabled except "Adopt and submit"
2. Clean user experience with clear feedback
3. No security gaps
4. Existing functionality preserved for enabled option
