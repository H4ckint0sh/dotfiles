#!/bin/bash
set -u

LOG_FILE="/var/log/loginwindow_relaunch_lock.log"
exec >>"$LOG_FILE" 2>&1

echo "==== $(date '+%Y-%m-%d %H:%M:%S') start ===="

# Wait (up to 10 minutes) for a real console user
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

chflags nouchg "$plist" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Delete :TALAppsToRelaunchAtLogin" "$plist" 2>/dev/null || true
chflags uchg "$plist"

flags="$(ls -lO "$plist" | awk '{print $5}')"
echo "Final flags: ${flags}"
echo "Done."
echo "==== $(date '+%Y-%m-%d %H:%M:%S') end ===="
