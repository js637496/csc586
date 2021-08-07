#/bin/bash

NFS_PATH="/nfs/recordings"
CAMERA_ID=$2

year=`date +'%Y'`
month=`date +'%m'`
day=`date +'%d'`
hour=`date +'%H'`
minute=`date +'%M'`

FULL_PATH=$NFS_PATH/$2/$year/$month/$day/$hour

mkdir -p $FULL_PATH

ffmpeg -i $1 -t 60 -c copy -bsf:a aac_adtstoasc $FULL_PATH/$minute.mp4
