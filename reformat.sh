#!/bin/bash
verify(){
    local video=$1
    format_info=$(ffprobe -v error -show_entries format=format_name,bit_rate -of default=nw=1:nk=1 "$video")
    video_info=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name,profile,coded_width,coded_height,level,r_frame_rate -of default=nw=1:nk=1 "$video")
    audio_info=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name,profile,channels -of default=nw=1:nk=1 "$video")

    video_codec=$(echo "$video_info" | head -n 1)
    video_profile=$(echo "$video_info" | head -n 2 | tail -n 1)
    video_level=$(echo "$video_info" | head -n 5 | tail -n 1)
    fps=$(echo "$video_info" | head -n 6 | tail -n 1)

    audio_codec=$(echo "$audio_info" | head -n 1)
    audio_profile=$(echo "$audio_info" | head -n 2 | tail -n 1)
    channels=$(echo "$audio_info" | head -n 3 | tail -n 1)

    if [ "$video_codec" != "h264" ]; then
        echo -e "\033[31mVideo Codec is not valid.\033[0m"
        return 2
    fi

    if [ "$video_profile" != "High" ]; then
        echo -e "\033[31mVideo Profile is not valid.\033[0m"
        return 2
    fi

    if [ "$video_level" != "41" ]; then
        echo -e "\033[31mVideo Level is not valid.\033[0m"
        return 2
    fi

    if [ -z "$audio_codec" ]; then
        echo -e "\033[31mAudio Codec is not valid.\033[0m"
        return 2
    fi

    if [ "$audio_codec" != "aac" ]; then
        echo -e "\033[31mAudio Codec is not valid.\033[0m"
        return 2
    fi

    if [ "$audio_profile" != "LC" ]; then
        echo -e "\033[31mAudio Profile is not valid.\033[0m"
        return 2
    fi

    if [ "$channels" -ne 2 ]; then
        echo -e "\033[31mAudio Channel is not valid.\033[0m"
        return 1
    fi

    echo -e "\033[32mThe file is valid.\033[0m"
    return 0;
}

check_fps(){
    local video=$1
    echo ${video}
    format_info=$(ffprobe -v error -show_entries format=format_name,bit_rate -of default=nw=1:nk=1 "$video")
    video_info=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name,profile,coded_width,coded_height,level,r_frame_rate -of default=nw=1:nk=1 "$video")

    width=$(echo "$video_info" | head -n 3 | tail -n 1)
    height=$(echo "$video_info" | head -n 4 | tail -n 1)
    fps=$(echo "$video_info" | head -n 6 | tail -n 1)

    def=( 720 1280 1920 3840 )

    ckey=0

    for key in "${!def[@]}"; do
        if [ -z "$ckey" ] || [ $(("$width" - def[$key])) -gt $((def[$ckey] - "$width")) ]; then
            ckey="$key"
        fi
    done

    fps_numerator=$(echo "$fps" | cut -d '/' -f 1)
    fps_denominator=$(echo "$fps" | cut -d '/' -f 2)
    fps_integer=$((fps_numerator / fps_denominator))
    
    echo "key "$ckey;
    fps=""

    if [ $ckey -gt 0 ]; then
        fps="30";
    
    else
        fps="60";
    fi
    
    echo $fps
    
    if [ "$fps_integer" -gt $fps ]; then
    	return $fps;
    fi
    
    return 0;
}

mkdir "converted"

for file in *.mp4*
do
	if [[ -f ${file} ]]
	then
		verify "$file"
		verify_status=$?
		
		check_fps "$file"
		fps_status=$?

		if [ $verify_status -eq 0 ]; then
			if [ $fps_status -eq 0 ]; then
				mv "$file" "converted/$file"
			else
				ffmpeg -y -i "$file" -r $fps "converted/$file"
			fi
					
		elif [ $verify_status -eq 1 ]; then
			if [ $fps_status -eq 0 ]; then
				ffmpeg -y -i "$file" -c:v copy -c:a aac -ac 2 -ab 256k "converted/$file"
			else
				ffmpeg -y -i "$file" -r $fps -c:a aac -ac 2 -ab 256k "converted/$file"
			fi
	    
		elif [ $verify_status -eq 2 ]; then
			if [ $fps_status -eq 0 ]; then
				ffmpeg -y -i "$file" -vcodec libx264 -profile:v high -level:v 4.1 -pix_fmt yuv420p -c:a aac -ac 2 -ab 256k "converted/$file"
			else
				ffmpeg -y -i "$file" -r $fps -vcodec libx264 -profile:v high -level:v 4.1 -pix_fmt yuv420p -c:a aac -ac 2 -ab 256k "converted/$file"
			fi
		else
			echo -e "\033[32mUnknown type response.\033[0m"
		fi
	fi
done

types=( mkv MKV avi AVI vob VOB )

for type in "${types[@]}"
do
	for file in *."${type}"
	do
		if [[ -f $file ]]; then
    	
			check_fps "$file"
	    		fps_status=$?

			if [ $fps_status -eq 0 ]; then
				ffmpeg -y -i "$file" -vcodec libx264 -profile:v high -level:v 4.1 -pix_fmt yuv420p -c:a aac -ac 2 -ab 256k "converted/${file%.*}.mp4"
			
			else
				ffmpeg -y -i "$file" -r $fps -vcodec libx264 -profile:v high -level:v 4.1 -pix_fmt yuv420p -c:a aac -ac 2 -ab 256k "converted/${file%.*}.mp4"
			fi
		fi
	done
done

echo -en "\007"
sleep 0.3
echo -en "\007"
