#/bin/bash

NFS_PATH="/nfs/recordings"
CAMERA_ID=$2
STREAM_URL=$1

year=`date +'%Y'`
month=`date +'%m'`
day=`date +'%d'`
hour=`date +'%H'`
minute=`date +'%M'`

HOUR_PATH=$year/$month/$day/$hour
mkdir -p $NFS_PATH/$HOUR_PATH/$CAMERA_ID
FULL_PATH=${HOUR_PATH}/${CAMERA_ID}/${minute}.mp4

ffmpeg -i $STREAM_URL -t 61 -filter:v fps=fps=8 ${NFS_PATH}/$FULL_PATH

#when min == 00, zip up the previous hour and push to glacier bucket
#sudo aws s3 mv ${NFS_PATH}/$FULL_PATH s3://$S3BUCKET/$FULL_PATH
#NFS isnt needed really as everything is going to S3
