#!/bin/bash
set -euo pipefail

LABEL="com.h4ckint0sh.loginwindow-relaunch-lock"

echo "=== launchd status ==="
sudo launchctl print "system/${LABEL}" | sed -n '1,120p' || true

echo
echo "=== main log ==="
sudo tail -n 120 /var/log/loginwindow_relaunch_lock.log || true

echo
echo "=== stdout log ==="
sudo tail -n 120 /var/log/loginwindow_relaunch_lock.stdout.log || true

echo
echo "=== stderr log ==="
sudo tail -n 120 /var/log/loginwindow_relaunch_lock.stderr.log || true
