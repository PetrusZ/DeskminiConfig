#!/bin/sh
# Send email
echo "$SMARTD_MESSAGE" | mail -s "$SMARTD_FAILTYPE" "$SMARTD_ADDRESS"
# Notify user
wall "$SMARTD_MESSAGE"
