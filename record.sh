#/bin/bash

NFS_PATH="/nfs/recordings"
CAMERA_ID=$2
STREAM_URL=$1

year=`date +'%Y'`
month=`date +'%m'`
day=`date +'%d'`
hour=`date +'%H'`
minute=`date +'%M'`

HOUR_PATH=$NFS_PATH/$year/$month/$day/$hour/$CAMERA_ID
mkdir -p $HOUR_PATH
FULL_PATH=${HOUR_PATH}/${CAMERA_ID}_${minute}.mp4

ffmpeg -i $STREAM_URL -t 61 -c copy -bsf:a aac_adtstoasc $FULL_PATH

aws s3 mv $FULL_PATH s3://$S3BUCKET/$FULL_PATH
#NFS isnt needed really as everything is going to S3
