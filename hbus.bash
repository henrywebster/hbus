#!/usr/bin/env bash

# Henry's BackUp Script (HBUS)
# v0.0.1

# get configuration file from input
if [[ $# -ne 0 ]]; then
    source $1
else
    echo "[ERROR] No configuration!"
    exit 1
fi

OUTFILE=/tmp/$OUTFILE

function backup_gcloud() {
    gsutil cp $OUTFILE gs://$GOOGLE_BUCKET
}

function backup_local() {
    cp $OUTFILE ~/backup/
}

# package
tar cvfz - $TARGETS | gpg --encrypt --recipient $GPG_DECRYPT --output $OUTFILE

# check if file size is not too big
if [ $(stat --format="%s" $OUTFILE) -gt "$MAX_UPLOAD" ]; then
    echo [ERROR] Backup not uploaded, exceeded max size! 1>&2
else
    # perform each backup step
    for task in ${TASKS[@]}; do
        if $task; then
            printf "%s suceeded\n" $task
        else
            printf "[ERROR] %s task failed\n" $task 1>&2
        fi 
    done
fi

echo "Cleaning up..."
rm $OUTFILE
