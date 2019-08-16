#!/usr/bin/env bash

# Henry's BackUp Script (HBUS)
# v0.0.1

# pesky config location
if [[ $# -gt 0 ]]; then
    source $1
else
    if [[ -f ~/.config/hbus/hbus.conf ]]; then
        source ~/.config/hbus/hbus.conf
    else
        echo "[ERROR] No configuration!"
        exit 1
    fi
fi

# upload rchive
tar cvfz - $TARGETS | gpg --encrypt --recipient $GPG_DECRYPT --output $OUTFILE

# check if file size is not too big
if [ $(stat --format="%s" $OUTFILE) -gt "$MAX_UPLOAD" ]; then
    echo [ERROR] Backup not uploaded, exceeded max size!
else
    # google cloud
    gsutil cp $OUTFILE gs://$GOOGLE_BUCKET
fi
