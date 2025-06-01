# HotCRP Docker Setup Instructions

These instructions document the steps needed to successfully set up HotCRP in a Docker environment.

## Prerequisites
- Docker and Docker Compose installed
- HotCRP repository cloned
- At least 2GB of available memory for Docker
- Git installed

## Environment Setup

Before starting the containers, ensure your Docker environment has sufficient resources:
- Memory: At least 2GB for MariaDB and PHP processes
- CPU: At least 2 cores recommended
- Storage: At least 1GB free space

## Complete Setup Steps

1. Clean up any existing containers (if needed):
```bash
cd /Users/chris/Github/hotcrp/docker && docker compose down -v
```

2. Start fresh Docker containers:
```bash
cd /Users/chris/Github/hotcrp/docker && docker compose up -d
```

3. Initialize the database with proper permissions:
```bash
# Create database and grant permissions for remote access
docker compose exec db mysql -uroot -proot -e "DROP DATABASE IF EXISTS hotcrp; CREATE DATABASE hotcrp CHARACTER SET utf8; GRANT ALL ON hotcrp.* TO 'hotcrp'@'%' IDENTIFIED BY 'hotcrp'; FLUSH PRIVILEGES;"
```

4. Load the database schema:
```bash
# Load the schema into the database
docker compose exec web bash -c "cat /var/www/html/src/schema.sql | mysql -h db -u hotcrp -photcrp hotcrp"
```

5. Create the configuration file:
```bash
# Create options.php with proper database and mail settings
cat > /Users/chris/Github/hotcrp/conf/options.php << 'EOL'
<?php
// Database configuration
$Opt["dbName"] = "hotcrp";
$Opt["dbUser"] = "hotcrp";
$Opt["dbPassword"] = "hotcrp";
$Opt["dbHost"] = "db";

// Email configuration
$Opt["contactName"] = "HotCRP Chair";
$Opt["contactEmail"] = "chair@example.com";
$Opt["sendEmail"] = true;
$Opt["emailFrom"] = "hotcrp@example.com";

// Time zone setting
$Opt["timezone"] = "America/New_York";

// Other settings
$Opt["sessionLifetime"] = 86400; // 24 hours
$Opt["redirectToHttps"] = false;  // Set to true if using HTTPS
EOL
```

6. Set proper permissions on the configuration file:
```bash
# Make sure web server can read options.php
docker compose exec web chown www-data:www-data /var/www/html/conf/options.php
docker compose exec web chmod 640 /var/www/html/conf/options.php
```

## PHP Configuration

The Docker environment comes with recommended PHP settings, but you can adjust them if needed:

- `upload_max_filesize`: 20M
- `post_max_size`: 20M
- `memory_limit`: 128M
- `max_input_vars`: 4096
- `session.gc_maxlifetime`: 86400

These can be modified in `docker/php.ini`.

## Mail Configuration

The default setup includes a MailHog container for testing email functionality. Emails sent by HotCRP will be captured and viewable at http://localhost:8025.

For detailed instructions on testing the email functionality, see [Email Testing Instructions](email-testing.md).

For production use, you should configure a proper SMTP server by updating the email settings in `options.php`:

## Database Backup and Restore

The system includes tools for backing up and restoring the database state. This is useful for:
- Creating snapshots of a working system
- Rolling back to a known good state
- Transferring data between environments

### Creating a Backup
To create a database backup:
```bash
cd docker
mkdir -p backups
docker compose exec db mysqldump -uroot -proot --databases hotcrp > backups/hotcrp_backup.sql
```

### Restoring from Backup
A restore script is provided to easily restore the database from a backup file:
```bash
cd docker
./restore-db.sh backups/hotcrp_backup.sql
```

The initial system setup backup is stored at `docker/backups/hotcrp_initial_setup.sql`. You can use this to reset the system to its initial working state:
```bash
cd docker
./restore-db.sh backups/hotcrp_initial_setup.sql
```

Note: The restore process will overwrite the current database state. Make sure to backup any important data before performing a restore.