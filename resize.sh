#!/bin/bash
mkdir "resized"

for file in converted/*.mp4*
do
	echo $file
	file=$(basename "${file%.*}")
	ffmpeg -i "converted/$file.mp4" -vf "scale=256:144" -c:a copy -b:a 64k "resized/${file}_144.mp4"
	ffmpeg -i "converted/$file.mp4" -vf "scale=426:240" -c:a copy -b:a 64k "resized/${file}_240.mp4"
	ffmpeg -i "converted/$file.mp4" -vf "scale=640:360" -c:a copy -b:a 64k "resized/${file}_360.mp4"
	ffmpeg -i "converted/$file.mp4" -vf "scale=854:480" -c:a copy -b:a 64k "resized/${file}_480.mp4"
	ffmpeg -i "converted/$file.mp4" -vf "scale=1280:720" -c:a copy -b:a 128k "resized/${file}_720.mp4"
done
