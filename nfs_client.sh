#/bin/bash
sudo apt update
sudo apt -y install nfs-common
sudo apt -y install ffmpeg
sudo apt -y install jq
sleep 10m

sudo mount 192.168.1.1:/nfs  /nfs

#figure out what portion of json file this node will deal with
start=$1
findstart=0
count=0

#for testing, only allow 20
stopval=20
stopcount=0

data=`cat ny.json`
dataLength=`jq length ny.json`
for row in $(echo "${data}" | jq -r '.[] | @base64'); do
    if [ $start -eq $findstart ]
    then
        modVal=$(($count%$2))
        count=$(($count+1))
        _jq() {
            echo ${row} | base64 --decode | jq -r ${1}
        }
        if [ $modVal -eq 0 ]
        then
            streamSource=$(_jq '.streamSource')
            cameraID=$(_jq '.cameraID')
            echo $cameraID
            crontab -l | { cat; echo "* * * * * sudo bash /local/repository/record.sh ${streamSource} ${cameraID}" ; } | crontab
            stopcount=$(($stopcount+1))
            if [ $stopcount -eq $stopval ]
            then
                break
            fi
        fi
    else
        findstart=$(($findstart+1))
    fi
done
