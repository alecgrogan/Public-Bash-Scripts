#!/bin/bash

# System Security Audit Script

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Function to check for security issues
check_security() {
    echo "----------------------------"
    echo "Security Check: $1"
    echo "----------------------------"
    $2
    echo
}

# Check 1: Update System
check_security "Update System" "apt update && apt upgrade"

# Check 2: Firewall Status
check_security "Firewall Status" "ufw status"

# Check 3: List Listening Ports
check_security "Listening Ports" "netstat -tuln"

# Check 4: Check for Uncommon Users
check_security "Uncommon Users" "awk -F: '\$3 < 1000 {print \$1}' /etc/passwd"

# Check 5: Sudo Access
check_security "Sudo Access" "getent group sudo"

# Check 6: Root SSH Access
check_security "Root SSH Access" "grep -i 'PermitRootLogin' /etc/ssh/sshd_config"

# Check 7: Password Policy
check_security "Password Policy" "grep -E '^PASS_MAX_DAYS|^PASS_MIN_DAYS|^PASS_WARN_AGE' /etc/login.defs"

# Check 8: Check for World-Writable Files
check_security "World-Writable Files" "find / -xdev -type f -perm -o+w"

# Check 9: Check for World-Writable Directories
check_security "World-Writable Directories" "find / -xdev -type d -perm -o+w"

# Check 10: Check for SUID/SGID Files
check_security "SUID/SGID Files" "find / -xdev \( -perm -4000 -o -perm -2000 \) -type f 2>/dev/null"

# Check 11: Check for Noowner Files
check_security "Noowner Files" "find / -xdev -nouser -o -nogroup"

echo "Security audit completed."
