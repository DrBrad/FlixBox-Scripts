#!/bin/bash
verify(){
    local video=$1
    format_info=$(ffprobe -v error -show_entries format=format_name,bit_rate -of default=nw=1:nk=1 "$video")
    video_info=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name,profile,coded_width,coded_height,level,r_frame_rate -of default=nw=1:nk=1 "$video")
    audio_info=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name,profile,channels -of default=nw=1:nk=1 "$video")

    video_codec=$(echo "$video_info" | head -n 1)
    video_profile=$(echo "$video_info" | head -n 2 | tail -n 1)
    width=$(echo "$video_info" | head -n 3 | tail -n 1)
    height=$(echo "$video_info" | head -n 4 | tail -n 1)
    video_level=$(echo "$video_info" | head -n 5 | tail -n 1)
    fps=$(echo "$video_info" | head -n 6 | tail -n 1)

    audio_codec=$(echo "$audio_info" | head -n 1)
    audio_profile=$(echo "$audio_info" | head -n 2 | tail -n 1)
    channels=$(echo "$audio_info" | head -n 3 | tail -n 1)

    def=( 720 1280 1920 3840 )

    ckey=""

    for key in "${!def[@]}"; do
        if [ -z "$ckey" ] || [ $((def[$ckey] - "$width")) -gt $(("$width" - def[$key])) ]; then
            ckey="$key"
        fi
    done

    fps_numerator=$(echo "$fps" | cut -d '/' -f 1)
    fps_denominator=$(echo "$fps" | cut -d '/' -f 2)
    fps_integer=$((fps_numerator / fps_denominator))

    if [ $ckey -gt 0 ]; then
        ckey="30";
    
    else
        ckey="60";
    fi

    if [ "$fps_integer" -gt $ckey ]; then
        echo -e "\033[31mVideo FPS is greater than 30.\033[0m"
        return 2
    fi


    if [ "$video_codec" != "h264" ]; then
        echo -e "\033[31mVideo Codec is not valid.\033[0m"
        exit 2
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

for file in *.mp4*
do
    verify "$file"
done

