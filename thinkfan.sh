#!/usr/bin/env bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

echo "Checking if this is a ThinkPad..."
if ! sudo dmidecode -s system-product-name | grep -qi "thinkpad"; then
    echo "ERROR: This script is only for Lenovo ThinkPad laptops!"
    echo "Your system: $(sudo dmidecode -s system-product-name)"
    exit 1
fi
echo "ThinkPad detected: $(sudo dmidecode -s system-product-name)"

echo "Configuring thinkpad_acpi module for fan control..."
echo "options thinkpad_acpi fan_control=1" | sudo tee /etc/modprobe.d/thinkpad_acpi.conf > /dev/null

echo "Reloading thinkpad_acpi module..."
sudo modprobe -r thinkpad_acpi && sudo modprobe thinkpad_acpi

echo "Installing required packages..."
sudo apt-get install -y sysfsutils thinkfan lm-sensors

echo "Checking fan_control status..."
FAN_CONTROL_STATUS=$(systool -v -m thinkpad_acpi | awk '/fan_control/ {print $3}' | tr -d '"')
echo "Fan control enabled: $FAN_CONTROL_STATUS"

if [ "$FAN_CONTROL_STATUS" != "Y" ]; then
    echo "ERROR: Fan control is not enabled. Please reboot and run this script again."
    exit 1
fi

echo "Auto-detecting hwmon temperature sensors..."
TEMP_SENSORS=$(find /sys/devices/platform/coretemp.* -name "temp*_input" 2>/dev/null | sort)

if [ -z "$TEMP_SENSORS" ]; then
    echo "ERROR: No temperature sensors found!"
    exit 1
fi

echo "Creating thinkfan configuration..."
sudo tee /etc/thinkfan.conf > /dev/null <<'EOF'
# ThinkPad fan control configuration
tp_fan /proc/acpi/ibm/fan

EOF

# Add detected temperature sensors
echo "$TEMP_SENSORS" | while read sensor; do
    echo "hwmon $sensor" | sudo tee -a /etc/thinkfan.conf > /dev/null
done

# Add fan speed levels
# Format: (LEVEL, LOW_TEMP, HIGH_TEMP)
# Level 0 = fan off, Level 7 = full speed
sudo tee -a /etc/thinkfan.conf > /dev/null <<'EOF'

# Fan speed levels based on temperature (Celsius)
# Level 0: Fan off (0-50°C)
# Level 1: Low speed (48-60°C)
# Level 2: Medium-low (58-65°C)
# Level 3: Medium (63-70°C)
# Level 4: Medium-high (68-75°C)
# Level 5: High (73-80°C)
# Level 7: Maximum (78°C+)
(0,  0, 50)
(1, 48, 60)
(2, 58, 65)
(3, 63, 70)
(4, 68, 75)
(5, 73, 80)
(7, 78, 32767)
EOF

echo "Validating thinkfan configuration..."
if sudo thinkfan -n -c /etc/thinkfan.conf; then
    echo "Configuration is valid!"
else
    echo "ERROR: Configuration validation failed!"
    exit 1
fi

echo "Enabling and starting thinkfan service..."
sudo systemctl enable thinkfan
sudo systemctl restart thinkfan

echo "Checking thinkfan status..."
sudo systemctl status thinkfan --no-pager

echo ""
echo "Thinkfan setup complete!"
echo "Monitor fan status with: cat /proc/acpi/ibm/fan"
echo "Monitor temperature with: sensors"
