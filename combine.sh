#!/bin/bash

#ffmpeg -i stabilized.mp4 -i output-audio.mp3 -c:v copy -map 0:v:0 -map 1:a:0 new.mp4

if [ ! -d "combine" ]; then
	mkdir "combine"
	echo -e "\033[31mYou didn't have a combine folder, a new one was created. Please place files into folder and name them numerically [A-Z0-9] for order to be correct.\033[0m"
	exit 0
fi

mkdir "combined"

file_list="filelist.txt"

> $file_list

for file in combine/*.mp4*
do
	echo $file
	[ -f "$file" ] || continue
	echo "file '$file'" >> $file_list
done

ffmpeg -f concat -safe 0 -i $file_list -c copy "combined/${1}"

#rm $file_list

notify-send "Video Format" "Video combine complete."
