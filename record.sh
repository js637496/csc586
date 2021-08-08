#/bin/bash

NFS_PATH="/nfs/recordings"
CAMERA_ID=$2
STREAM_URL=$1

year=`date +'%Y'`
month=`date +'%m'`
day=`date +'%d'`
hour=`date +'%H'`
minute=`date +'%M'`

#tar ball every hour for every camera (full daily is too large)
FULL_PATH=$NFS_PATH/$year/$month/$day/$hour/$CAMERA_ID

mkdir -p $FULL_PATH

ffmpeg -i $STREAM_URL -t 61 -c copy -bsf:a aac_adtstoasc $FULL_PATH/$minute.mp4

#LATER - if its a new hours (00.mp4) start the tarball process for this camera's pervious hour
#send to bucket.
