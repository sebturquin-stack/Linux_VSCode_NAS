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
}

write_state() {
    cat > "$STATE_FILE" <<EOF
LAST_ACK_DATE=$LAST_ACK_DATE
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

send_reminder_notification() {
    local due
    due="$(last_due_date)"

    if command -v notify-send >/dev/null 2>&1; then
        notify-send \
            "Rappel MAJ Linux (Mardi/Samedi)" \
            "Cycle en attente depuis ${due}.\nLance la routine MAJ puis acquitte: linux_maj_reminder.sh --ack" \
            --urgency=critical \
            --app-name="MAJ Reminder" \
            --expire-time=0
    fi

    log_line "RAPPEL_EMIS due=$due last_ack=$LAST_ACK_DATE"
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
- Derniere echeance (mardi/samedi): $due
- Rappel en attente: $pending
- Routine conseillee:
  $CHECK_CMD
EOF
}

ack_now() {
    LAST_ACK_DATE="$(iso_today)"
    write_state
    log_line "ACK date=$LAST_ACK_DATE"
    echo "Acquittement enregistre pour $LAST_ACK_DATE"
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
        --help|-h)
            cat <<EOF
Usage:
  linux_maj_reminder.sh --check   # emet un rappel si cycle mardi/samedi non acquitte
  linux_maj_reminder.sh --status  # affiche l'etat du rappel
  linux_maj_reminder.sh --ack     # marque le cycle comme traite

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
