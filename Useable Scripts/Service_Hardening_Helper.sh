echo "=== Service Hardening Helper ==="

# List all running services
systemctl list-units --type=service --state=active

# List enabled services at boot
systemctl list-unit-files --type=service | grep enabled

echo "Please delete any unwanted or unstable services from the system. Once you have done that, please press enter to continue."
