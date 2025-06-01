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