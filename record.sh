#/bin/bash

NFS_PATH="/nfs/recordings"
CAMERA_ID=$2
STREAM_URL=$1

year=`date +'%Y'`
month=`date +'%m'`
day=`date +'%d'`
hour=`date +'%H'`
minute=`date +'%M'`

FULL_PATH=$NFS_PATH/$year/$month/$day/$hour/$CAMERA_ID
FULL_PATH=${FULL_PATH}_${minute}_.mp4

mkdir -p $FULL_PATH

ffmpeg -i $STREAM_URL -t 61 -c copy -bsf:a aac_adtstoasc $FULL_PATH

aws s3 mv $FULL_PATH s3://$S3BUCKET/$FULL_PATH
#NFS isnt needed really as everything is going to S3
