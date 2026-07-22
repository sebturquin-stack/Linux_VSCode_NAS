#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/linux-maj-reminder"
STATE_FILE="$STATE_DIR/state.env"
LOG_FILE="$STATE_DIR/reminder.log"
CHECK_CMD="sudo apt-get update && sudo apt-get -y dist-upgrade && sudo apt-get -y autoremove --purge && apt list --upgradable"

mkdir -p "$STATE_DIR"

read_state() {
    if [[ -f "$STATE_FILE" ]]; then
        # shellcheck disable=SC1090
        source "$STATE_FILE"
    fi
    LAST_ACK_DATE="${LAST_ACK_DATE:-1970-01-01}"
    LAST_NOTIFICATION_ID="${LAST_NOTIFICATION_ID:-0}"
}

write_state() {
    cat > "$STATE_FILE" <<EOF
LAST_ACK_DATE=$LAST_ACK_DATE
LAST_NOTIFICATION_ID=$LAST_NOTIFICATION_ID
EOF
}

iso_today() {
    date +%F
}

weekday_num() {
    date +%u
}

last_due_date() {
    local dow
    dow="$(weekday_num)"

    case "$dow" in
        1) date -d 'last saturday' +%F ;;
        2) date +%F ;;
        3|4|5) date -d 'last tuesday' +%F ;;
        6) date +%F ;;
        7) date -d 'last saturday' +%F ;;
        *) date +%F ;;
    esac
}

is_due_pending() {
    local due
    due="$(last_due_date)"

    if [[ "$LAST_ACK_DATE" < "$due" ]]; then
        return 0
    fi

    return 1
}

log_line() {
    printf '[%s] %s\n' "$(date '+%F %T')" "$1" >> "$LOG_FILE"
}

extract_notification_id() {
    local raw="$1"
    local id=""
    id="$(printf '%s' "$raw" | sed -nE 's/.*([0-9]+).*/\1/p' | head -n1)"
    if [[ -n "$id" ]] && [[ "$id" =~ ^[0-9]+$ ]]; then
        printf '%s\n' "$id"
    else
        printf '0\n'
    fi
}

close_tracked_notification() {
    if [[ "$LAST_NOTIFICATION_ID" -gt 0 ]] && command -v gdbus >/dev/null 2>&1; then
        if gdbus call --session \
            --dest org.freedesktop.Notifications \
            --object-path /org/freedesktop/Notifications \
            --method org.freedesktop.Notifications.CloseNotification \
            "$LAST_NOTIFICATION_ID" >/dev/null 2>&1; then
            log_line "RAPPEL_FERME id=$LAST_NOTIFICATION_ID"
        else
            log_line "RAPPEL_FERME_WARN id=$LAST_NOTIFICATION_ID close_failed"
        fi
    fi
    LAST_NOTIFICATION_ID=0
    write_state
}

send_reminder_notification() {
    local due
    due="$(last_due_date)"
    local notified="NON"
    local notif_id_output=""
    local notif_id="0"

    if command -v notify-send >/dev/null 2>&1; then
        notif_id_output="$(notify-send \
            "Rappel MAJ Linux (Mardi/Samedi)" \
            "Cycle en attente depuis ${due}.\nLance la routine MAJ puis acquitte: linux_maj_reminder.sh --ack" \
            --urgency=critical \
            --app-name="MAJ Reminder" \
            --expire-time=15000 \
            --replace-id="$LAST_NOTIFICATION_ID" \
            --print-id 2>/dev/null || true)"
        notif_id="$(extract_notification_id "$notif_id_output")"
        if [[ "$notif_id" -gt 0 ]]; then
            LAST_NOTIFICATION_ID="$notif_id"
            write_state
            notified="OUI"
        fi
    fi

    if [[ "$notified" != "OUI" ]] && command -v gdbus >/dev/null 2>&1; then
        notif_id_output="$(gdbus call --session \
            --dest org.freedesktop.Notifications \
            --object-path /org/freedesktop/Notifications \
            --method org.freedesktop.Notifications.Notify \
            "MAJ Reminder" "$LAST_NOTIFICATION_ID" "dialog-warning" \
            "Rappel MAJ Linux (Mardi/Samedi)" \
            "Cycle en attente depuis ${due}.\nLance la routine MAJ puis acquitte: linux_maj_reminder.sh --ack" \
            [] '{"urgency": <byte 2>}' 15000 2>/dev/null || true)"
        notif_id="$(extract_notification_id "$notif_id_output")"
        if [[ "$notif_id" -gt 0 ]]; then
            LAST_NOTIFICATION_ID="$notif_id"
            write_state
            notified="OUI"
        fi
    fi

    log_line "RAPPEL_EMIS due=$due last_ack=$LAST_ACK_DATE notified=$notified notif_id=$LAST_NOTIFICATION_ID"
}

show_status() {
    local due pending
    due="$(last_due_date)"
    pending="NON"

    if is_due_pending; then
        pending="OUI"
    fi

    cat <<EOF
Etat rappel MAJ
- Date du jour: $(iso_today)
- Dernier acquittement: $LAST_ACK_DATE
- Derniere notification id: $LAST_NOTIFICATION_ID
- Derniere echeance (mardi/samedi): $due
- Rappel en attente: $pending
- Routine conseillee:
  $CHECK_CMD
EOF
}

ack_now() {
    LAST_ACK_DATE="$(iso_today)"
    write_state
    close_tracked_notification
    log_line "ACK date=$LAST_ACK_DATE"
    echo "Acquittement enregistre pour $LAST_ACK_DATE"
}

clear_now() {
    close_tracked_notification
    log_line "CLEAR notif_id_reset=1"
    echo "Notification suivie fermee (si presente) et id reinitialise."
}

main() {
    read_state

    case "${1:-}" in
        --check|"")
            if is_due_pending; then
                send_reminder_notification
                echo "Rappel emis (cycle en attente)."
            else
                echo "Aucun rappel necessaire."
            fi
            ;;
        --status)
            show_status
            ;;
        --ack)
            ack_now
            ;;
        --clear)
            clear_now
            ;;
        --help|-h)
            cat <<EOF
Usage:
  linux_maj_reminder.sh --check   # emet un rappel si cycle mardi/samedi non acquitte
  linux_maj_reminder.sh --status  # affiche l'etat du rappel
  linux_maj_reminder.sh --ack     # marque le cycle comme traite
  linux_maj_reminder.sh --clear   # ferme la notification suivie et reinitialise son id

Routine MAJ manuelle conseillee:
  $CHECK_CMD
EOF
            ;;
        *)
            echo "Option inconnue: $1" >&2
            exit 1
            ;;
    esac
}

main "$@"
