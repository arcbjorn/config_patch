#!/bin/bash
# Clean GitHub contribution graph - visual only

USERNAME="arcbjorn"

# Get 2025 contribution data
CONTRIB_DATA=$(curl -s "https://github-contributions-api.jogruber.de/v4/$USERNAME?y=2025" 2>/dev/null)

if [ -z "$CONTRIB_DATA" ]; then
    echo '{"text": "󰊤", "tooltip": "⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜"}'
    exit 0
fi

# Get contributions up to today (exclude future dates with 0)
TODAY=$(date +%Y-%m-%d)
RECENT=$(echo "$CONTRIB_DATA" | jq -r --arg today "$TODAY" '.contributions[] | select(.date <= $today) | .count' | tail -84)

if [ -n "$RECENT" ]; then
    # Create 7 rows (days of week)
    declare -a ROWS
    for i in {0..6}; do
        ROWS[$i]=""
    done
    
    DAY_COUNT=0
    for count in $RECENT; do
        DAY_OF_WEEK=$((DAY_COUNT % 7))
        
        # Simple GitHub style: white and green only
        if [ "$count" -eq 0 ]; then
            SYMBOL="⬜"  # No contributions
        else
            SYMBOL="🟩"  # Any contributions
        fi
        
        ROWS[$DAY_OF_WEEK]="${ROWS[$DAY_OF_WEEK]}${SYMBOL}"
        DAY_COUNT=$((DAY_COUNT + 1))
    done
    
    # Create visual grid - no text, just the graph
    TOOLTIP=""
    for i in {0..6}; do
        TOOLTIP="${TOOLTIP}${ROWS[$i]}"
        if [ $i -lt 6 ]; then
            TOOLTIP="${TOOLTIP}\r"
        fi
    done
else
    TOOLTIP="⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜\r⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜\r⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜\r⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜\r⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜\r⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜\r⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜"
fi

# Output pure visual graph
echo '{"text": "󰊤", "tooltip": "'$TOOLTIP'"}'