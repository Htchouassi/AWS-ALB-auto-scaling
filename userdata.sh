#!/bin/bash

# Update and install necessary packages
sudo apt-get update
sudo apt-get install -y apache2

# Start Apache server
sudo systemctl start apache2
sudo systemctl enable apache2

# Fetch the server's IP address using hostname -i
SERVER_IP=$(hostname -i)

# Create an HTML file with the message and server IP address
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Congratulations!</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background: linear-gradient(45deg, #ff6b6b, #f7d794, #48dbfb, #1dd1a1, #5f27cd);
            background-size: 400% 400%;
            animation: gradient 15s ease infinite;
            font-family: Arial, sans-serif;
        }
        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        .message {
            font-size: 2em;
            color: white;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="message">
        <h1>This message is from your webserver: $SERVER_IP</h1>
        <p>Congratulations!! You just built this application using Terraform.</p>
    </div>
</body>
</html>
EOF
