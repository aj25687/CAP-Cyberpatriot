#!/bin/bash
#Unstable Services Check
echo "=== CyberPatriot Service Checker ==="
echo "Active services:"
systemctl list-units --type=service --state=active | grep ".service" | awk '{print $1}'

echo -e "\nChecking for insecure services (telnet, ftp, rsh):"
for svc in telnet.service vsftpd.service rsh.service tftp.service rsh.service apache2.service vnc4server.service xinetd.service; do
    if systemctl is-active --quiet $svc; then
        echo "WARNING: $svc is running! "
    fi
done

echo "Listening ports:"
ss -tulpn

echo "Check for insecure services (telnet, ftp):"
systemctl status telnet #telnet.service
systemctl status vsftpd #vsftpd.service
systemctl status tftp #tftp.service
systemctl status rsh #rsh.service
systemctl status apache2 #apache2.service
systemctl status vnc4server #vnc4server.service
systemctl status xinetd #xinetd.service

echo -e "\nCheck complete. Disable unnecessary or insecure services."
Linux/Scripts/Templates/audit_services.sh

#SSH Hardening
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw enable

echo "UFW firewall hardened and enabled."

if systemctl is-active --quiet ssh; then
    echo "SSH service is running."
else
    echo "SSH service is not running. Starting SSH service..."
    systemctl start ssh
fi

SSHD_CONFIG="/etc/ssh/sshd_config"
cp "$SSHD_CONFIG" "$SSHD_CONFIG.bak"

sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' "$SSHD_CONFIG"
sed -i 's/^#*X11Forwarding.*/X11Forwarding no/' "$SSHD_CONFIG"
echo "MaxAuthTries 3" >> "$SSHD_CONFIG"

systemctl restart ssh
echo "SSH configuration hardened."

#UFW Firewall Hardening
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw enable

echo "UFW firewall hardened and enabled."
