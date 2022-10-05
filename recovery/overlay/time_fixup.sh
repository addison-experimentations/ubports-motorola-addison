#!/sbin/sh

PROG=$(basename $0)

# If not run interactively, send all output to dmesg
if ! test -t 0; then
    exec >> /dev/kmsg
    exec 2>&1
fi

echo "$PROG: Adjusting time"

TIMEKEEP_FILE="/data/android-data/time/timekeep"

if test -f "$TIMEKEEP_FILE"; then
    echo "$PROG: timekeep file found"
else
    echo "$PROG: timekeep file not found, nothing to do"
    exit 0
fi

ADJUSTMENT=$(cat "$TIMEKEEP_FILE")
HWDATE=$(date '+%s')

ADJUSTED_DATE=$(($HWDATE + $ADJUSTMENT))

date "@${ADJUSTED_DATE}" SET

echo "$PROG: Adjusted time: $(date)"
