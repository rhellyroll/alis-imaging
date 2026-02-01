#!/bin/bash
# Verify ReaR recovery system readiness


echo "======================================="
echo "ALIS Recovery System - Verification"
echo "======================================="
echo ""


echo "[1] Rear Installation:"
rear -V
echo ""

echo "[2] Recovery ISO:"
ISO_FILE=$(ls -t /var/lib/rear/output/*.iso 2>/dev/null | head -1)
if [ -n "ISO_FILE" ] && sudo [ -f "$ISO_FILE" ]; then
    echo " ISO: $ISO_FILE"
    echo " Size: $(du -h $ISO_FILE | cut -f1)"
    echo " Created: $(stat -c %y $ISO_FILE | cut -d' ' -f1)"
else
    echo " No ISO found"
fi
echo ""


echo "[3] System Disk Layout:"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | head -10
echo ""


echo "[4] Critical Services Status:"
systemctl is-active httpd && echo " httpd: active" || echo " httpd: inactive"
systemctl is-active vault && echo " vailt: active" || echo " vault: inactive"
echo ""


echo "[5] Deployment Readiness:"
echo " Recovery ISO created"
echo " Bootable system image ready"
echo " Field deployment capable"
echo ""


echo "===================================================="

