#!/bin/bash

# Check if a backup file is specified
if [ -z "$1" ]; then
    echo "Usage: $0 <backup-file>"
    echo "Example: $0 backups/hotcrp_initial_setup.sql"
    exit 1
fi

# Check if the backup file exists
if [ ! -f "$1" ]; then
    echo "Error: Backup file '$1' not found"
    exit 1
fi

# Restore the database
echo "Restoring database from $1..."
docker compose exec -T db mysql -uroot -proot < "$1"

echo "Database restore completed!" 