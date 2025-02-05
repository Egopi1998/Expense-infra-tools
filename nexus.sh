#!/bin/bash

# Exit on any error
set -e

# Install required packages
echo "Installing required packages..."
sudo yum install java-17-openjdk -y
echo "Creating Nexus user..."
sudo mkdir /app
echo "Downloading Nexus..."
cd /app
sudo curl -L -o nexus.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz
sudo tar -xvf nexus.tar.gz 
rm -f nexus.tar.gz
sudo mv nexus-3* nexus
if ! id -u nexus >/dev/null 2>&1; then
    sudo useradd -r -m -d /app -s /bin/bash nexus
else
    echo "User nexus already exists."
fi
# Set up Nexus data directory
echo "Configuring Nexus data directory..."
sudo chown -R nexus:nexus /app/nexus
sudo chown -R nexus:nexus /app/sonatype-work
# Update Nexus run configuration
echo "Configuring Nexus to use correct directories..."
sudo sed -i "s|#run_as_user=\"\"|run_as_user=\"nexus\"|g" /app/nexus/bin/nexus.rc

# Create a systemd service file for Nexus
echo "Creating systemd service file..."
cat <<EOF | sudo tee /etc/systemd/system/nexus.service
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/app/nexus/bin/nexus start
ExecStop=/app/nexus/bin/nexus stop
User=nexus
Restart=on-abort
SyslogIdentifier=nexus

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable the Nexus service
echo "Enabling Nexus service..."
sudo systemctl daemon-reload
sudo systemctl enable nexus

# Start the Nexus service
echo "Starting Nexus service..."
sudo systemctl start nexus

# Check service status
echo "Checking Nexus service status..."
sudo systemctl status nexus

echo "Nexus installation completed successfully!"
echo "Access Nexus at: http://<your-server-ip>:8081"