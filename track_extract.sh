#!/bin/bash

#ffmpeg -i stabilized.mp4 -i output-audio.mp3 -c:v copy -map 0:v:0 -map 1:a:0 new.mp4

if [ $1 == "-s" ]; then
	mkdir "subs"

	for file in *.mkv*
	do
		echo $file
		ffmpeg -i "${file%.*}.mkv" -map 0:s:${2} "subs/${file%.*}.srt"
	done

elif [ $1 == "-a" ]; then
	mkdir "audio"

	for file in *.mkv*
	do
		echo $file
		ffmpeg -i "${file%.*}.mkv" -map 0:a:${2} "audio/${file%.*}.mp3"
	done

else
	echo "Unknown track type"
fi
