#!/bin/bash

uploadToGCP(){
  localDir=$1;
  bucket=$2;
  destDir=$3;

  zdate=`date "+%F"`
  #cd $srcDir
  pwd
  pid=$BASHPID;
  du -a "$localDir">/tmp/localDirfileList.txt
  while read line; do
    #filesize=echo $line|awk '{print $1}';
#    filename=echo $line|awk '{print $2 $3 $4 $5 $6 $7 $8 $9}';
    filename=`echo $line|awk '{$1=""; print $0}'`
 #   echo $line;
#    filename=echo $line;

#if [[ -f "$filename" ]]
#then
#	echo "$filename present"
#else
#	echo " $filename not present"
#	exit 2
#fi

    echo "text:${filename}"
    localCheckSum=`md5sum "${filename}"|awk '{print $1}'`
    copyfilename=`echo $filename|awk -F'/' '{$1=""; $2=""; print $0}'`

    gcpCheckSum=`gsutil hash -h -m "gs://${bucket}/${destDir}/$filename"|grep md5|tr -s " "|awk '{print $3}'`
    echo "Compare Checksum $localCheckSum $gcpCheckSum";
    if [ "$localCheckSum" !=  "$gcpCheckSum" ] 
    then
      echo "$localDir:$bucket:$destDir:$filename">>/tmp/uploadlist.${zdate}.log;
      echo "$filename not present"
      echo "gs://${bucket}/${destDir}/$copyfilename"
      #gsutil -o GSUtil:parallel_composite_upload_threshold=150M cp "$filename" "gs://${bucket}/${destDir}/$copyfilename"
      gcpCheckSum=`gsutil hash -h -m "gs://${bucket}/${destDir}/$filename"|grep md5|awk '{print $3}'`
    fi
    if [ "$localCheckSum" ==  "$gcpCheckSum" ] 
    then
      echo "\"Succeed\",\"${filename}\",\"${bucket}/${destDir}/${filename}\"">>/tmp/uploadlist.${zdate}.csv;
    else
      echo "\"Failed\",\"${filename}\",\"${bucket}/${destDir}/${filename}\"">>/tmp/uploadlist.${zdate}.csv;
    fi
      
  done < "/tmp/localDirfileList.txt"
}


#sdate=date +%F --date="0 days ago";
#echo "checksum: $sdate";
#srcDir="/Volumes/Viuclip_0/TheBridge_04";
#bucket="vuclip-originals-malaysia";
#destDir="TheBridge/TheBridge_04"
#echo uploadToGCP $srcDir $bucket $destDir
#uploadToGCP "$srcDir" "$bucket" "$destDir"


srcDir="/home/arun/Downloads/test123"

bucket="testchecksum"
destDir="test1"
uploadToGCP "$srcDir" "$bucket" "$destDir"


#      localDir="${array[0]}"
#      bucket="${array[1]}"
#      destDir="${array[2]}"
#      file="${array[3]}"