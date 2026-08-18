#!/bin/bash
set -euo pipefail

LABEL="com.h4ckint0sh.loginwindow-relaunch-lock"
SCRIPT_DST="/usr/local/bin/loginwindow_relaunch_lock.sh"
PLIST_DST="/Library/LaunchDaemons/${LABEL}.plist"

echo "[1/6] Writing payload script to ${SCRIPT_DST}"
sudo mkdir -p /usr/local/bin

sudo tee "${SCRIPT_DST}" >/dev/null <<'EOF'
#!/bin/bash
set -u

LOG_FILE="/var/log/loginwindow_relaunch_lock.log"
exec >>"$LOG_FILE" 2>&1

echo "==== $(date '+%Y-%m-%d %H:%M:%S') start ===="

# Wait up to 10 minutes for a real console user
console_user=""
for i in {1..300}; do
  console_user="$(stat -f%Su /dev/console 2>/dev/null || true)"
  if [[ -n "$console_user" && "$console_user" != "root" ]]; then
    break
  fi
  sleep 2
done

if [[ -z "$console_user" || "$console_user" == "root" ]]; then
  echo "No GUI user detected after timeout; exiting."
  exit 0
fi

echo "Console user: $console_user"

home_dir="$(dscacheutil -q user -a name "$console_user" | awk '/dir:/{print $2}')"
if [[ -z "${home_dir:-}" || ! -d "$home_dir" ]]; then
  echo "Home directory not found for $console_user; exiting."
  exit 1
fi
echo "Home dir: $home_dir"

machine_uuid="$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformUUID/{print $4}')"
if [[ -z "${machine_uuid:-}" ]]; then
  echo "Failed to determine machine UUID; exiting."
  exit 1
fi
echo "Machine UUID: $machine_uuid"

plist="${home_dir}/Library/Preferences/ByHost/com.apple.loginwindow.${machine_uuid}.plist"
echo "Target plist: $plist"

mkdir -p "${home_dir}/Library/Preferences/ByHost"
chown "$console_user":staff "${home_dir}/Library/Preferences/ByHost"

if [[ ! -f "$plist" ]]; then
  echo "Plist missing; creating."
  /usr/bin/touch "$plist"
  chown "$console_user":staff "$plist"
  chmod 600 "$plist"
fi

# unlock, delete key, lock again
chflags nouchg "$plist" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Delete :TALAppsToRelaunchAtLogin" "$plist" 2>/dev/null || true
chflags uchg "$plist"

flags="$(ls -lO "$plist" | awk '{print $5}')"
echo "Final flags: ${flags}"
echo "Done."
echo "==== $(date '+%Y-%m-%d %H:%M:%S') end ===="
EOF

echo "[2/6] Setting script ownership/permissions"
sudo chown root:wheel "${SCRIPT_DST}"
sudo chmod 755 "${SCRIPT_DST}"

echo "[3/6] Writing LaunchDaemon plist to ${PLIST_DST}"
sudo tee "${PLIST_DST}" >/dev/null <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>${LABEL}</string>

    <key>ProgramArguments</key>
    <array>
      <string>/bin/bash</string>
      <string>${SCRIPT_DST}</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>AbandonProcessGroup</key>
    <true/>

    <key>StandardOutPath</key>
    <string>/var/log/loginwindow_relaunch_lock.stdout.log</string>
    <key>StandardErrorPath</key>
    <string>/var/log/loginwindow_relaunch_lock.stderr.log</string>
  </dict>
</plist>
EOF

echo "[4/6] Setting plist ownership/permissions"
sudo chown root:wheel "${PLIST_DST}"
sudo chmod 644 "${PLIST_DST}"

echo "[5/6] Reloading LaunchDaemon"
sudo launchctl bootout system "${PLIST_DST}" 2>/dev/null || true
sudo launchctl bootstrap system "${PLIST_DST}"
sudo launchctl enable "system/${LABEL}"
sudo launchctl kickstart -k "system/${LABEL}"

echo "[6/6] Verifying"
sudo launchctl print "system/${LABEL}" | sed -n '1,80p' || true

echo
echo "Installed successfully."
echo "Logs:"
echo "  /var/log/loginwindow_relaunch_lock.log"
echo "  /var/log/loginwindow_relaunch_lock.stdout.log"
echo "  /var/log/loginwindow_relaunch_lock.stderr.log"
