#!/bin/bash

#ffmpeg -i stabilized.mp4 -i output-audio.mp3 -c:v copy -map 0:v:0 -map 1:a:0 new.mp4
mkdir "refactored"

for file in converted/*.mp4*
do
	echo $file
	file=$(basename "${file%.*}")
	ffmpeg -i "converted/$file.mp4" -i "audio/$file.mp3" -c:v copy -map 0:v:0 -map 1:a:0 "refactored/$file.mp4"
done
