#!/bin/bash
#!/bin/bash
dmesg | grep -Fw "removable disk"
echo ""
lsblk -d -e 7 -o NAME,SIZE,MODEL
read
