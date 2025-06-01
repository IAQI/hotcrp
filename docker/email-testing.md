# Email Testing Instructions

This guide explains how to test the email functionality in the HotCRP Docker environment.

## Prerequisites
- HotCRP Docker environment running
- MailHog container running and accessible at http://localhost:8025

## Testing Steps

### 1. Create Test Script
Create a file called `test_email.php` in the project root:

```php
<?php
// Test email configuration
$to = "test@example.com";
$subject = "Test email from HotCRP";
$message = "This is a test email sent at " . date('Y-m-d H:i:s');
$headers = "From: local_hotcrp@schaffner.pro\r\n";
$headers .= "Content-Type: text/plain; charset=UTF-8\r\n";

echo "Attempting to send test email...\n";
$result = mail($to, $subject, $message, $headers);

if ($result) {
    echo "Email was sent successfully!\n";
} else {
    echo "Failed to send email.\n";
    echo "Last PHP error: " . error_get_last()['message'] . "\n";
}
```

### 2. Run the Test
Execute the test script using Docker:
```bash
docker compose exec web php /var/www/html/test_email.php
```

### 3. Verify Results
1. Check the terminal output - you should see:
   ```
   Attempting to send test email...
   Email was sent successfully!
   ```

2. Open the MailHog web interface at http://localhost:8025
   - You should see a new email in the list
   - The email should have:
     - Subject: "Test email from HotCRP"
     - From: local_hotcrp@schaffner.pro
     - To: test@example.com

## Troubleshooting

If the test fails, check:
1. MailHog container is running:
   ```bash
   docker compose ps mailhog
   ```

2. SMTP configuration in PHP:
   ```bash
   docker compose exec web cat /etc/ssmtp/ssmtp.conf
   ```
   Should show:
   ```
   mailhub=mailhog:1025
   UseTLS=NO
   FromLineOverride=YES
   ```

3. PHP mail configuration:
   ```bash
   docker compose exec web cat /usr/local/etc/php/conf.d/mail.ini
   ```
   Should show:
   ```
   sendmail_path = /usr/sbin/ssmtp -t
   ```

## Cleanup
After successful testing, you can remove the test file:
```bash
rm test_email.php
``` 