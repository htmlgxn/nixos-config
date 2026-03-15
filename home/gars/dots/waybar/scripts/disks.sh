#!/usr/bin/env bash
# disks.sh — Waybar custom module for free/total per disk
# Uses Pango markup instead of Polybar color tags

PRIMARY="#E3C220"
FOREGROUND="#F6EEC9"
DISABLED="#826F11"

human() {
  numfmt --to=iec --suffix=B --format="%.1f" "$1" | tr '[:upper:]' '[:lower:]'
}

output=""
for disk in $(lsblk -ndo NAME,TYPE | awk '$2=="disk"{print $1}'); do
  size=$(lsblk -bndo SIZE /dev/$disk)
  parts=$(lsblk -lnpo NAME,TYPE /dev/$disk | awk '$2=="part"{print $1}')
  free=0
  total=0
  for p in $parts; do
    mp=$(lsblk -no MOUNTPOINT "$p")
    if [ -n "$mp" ] && mountpoint -q -- "$mp"; then
      read -r avail size <<EOF
$(df -B1 --output=avail,size "$mp" 2>/dev/null | tail -1)
EOF
      free=$((free + avail))
      total=$((total + size))
    fi
  done
  if [ "$total" -gt 0 ]; then
    output+="[<span color='${PRIMARY}'>${disk}</span>]<span color='${FOREGROUND}'>$(human $free)/$(human $total)</span> "
  else
    output+="<span color='${PRIMARY}'>${disk}</span> <span color='${DISABLED}'>--</span>/<span color='${FOREGROUND}'>$(human $size)</span>  "
  fi
done

echo "${output%"${output##*[![:space:]]}"}"
