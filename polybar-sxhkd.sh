#!/usr/bin/env bash
source "$XDG_CONFIG_HOME/polybar/scripts/color.sh"

# ============================================================================
#   Configuration Section
# ============================================================================
declare -r COLOR_FG="%{F$COLOR_GREY_4}"
declare -r COLOR_BG="%{B$COLOR_GREY_1}"
declare -r COLOR_UL="%{u$COLOR_GREEN}"
declare -r COLOR_OL="%{o$COLOR_EMPTY}"

declare -r PIPE="/run/user/$UID/sxhkd.fifo"

declare -r LABEL_PREFIX=" "
declare -r LABEL_SUFFIX=" "

# List of the labels ---------------------------------------------------------
#
#   Key: 'H' + the prefix of hotkey chain to disply including ALL WHITESPACES.
#     all whitespaces are not trimmed, including the last one.
#
#   Value: Label of the hotkey chain to display
#
# ----------------------------------------------------------------------------
declare -r LABEL_TABLE=(
    "Hsuper + r:Resize" # Example for single prefix
)



# ============================================================================
#   Script Section
# ============================================================================

declare -i REGISTER_CHAINMODE=1

remove_label () {
    echo ""
}

display_label () {
    echo "$LABEL_PREFIX$1$LABEL_SUFFIX"
}

# If input is hotkey, find label in the list and display the label
event_hotkey () {
    local -r event="$1"
    local key
    local val

    for elem in "${LABEL_TABLE[@]}"; do
        key="${elem%%:*}"
        val="${elem##*:}"
        [[ $(echo "$event" | grep "$key") ]] && display_label $val
    done
}

# If chain is begin, turn the REGISTER_CHAINMODE on
event_begin () {
    REGISTER_CHAINMODE=0
}

# If chain is aborted, turn the register off and remove the label
event_end () {
    remove_label
    REGISTER_CHAINMODE=1
}

# Check input event
handle_event () {
    local -r event="$1"
    [[ $(echo "$event" | grep "^H") ]] && event_hotkey "$event"
    [[ $(echo "$event" | grep "^BBegin") ]] && event_begin
    [[ $(echo "$event" | grep "^EEnd") ]] && event_end
    [[ $(echo "$event" | grep "^C") ]] && [[ $REGISTER_CHAINMODE -eq 0 ]] && event_end
}

# Waiting input event from pipe
loop () {
    cat $PIPE | \
    while read event; do
        handle_event "$event"
    done
}

loop
