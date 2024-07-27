#!/bin/bash

#ffmpeg -i stabilized.mp4 -i output-audio.mp3 -c:v copy -map 0:v:0 -map 1:a:0 new.mp4
mkdir "thumbnails"

for file in converted/*.mp4*
do
	echo $file
	file=$(basename "${file%.*}")
	ffmpeg -i "converted/$file.mp4" -ss 00:05:00.000 -vframes 1 "thumbnails/$file.png"
done
