# FlixBox Scripts
Scripts to help convert videos and subtitles to a valid format for android, web, & chromecast

Reformat
-----
Reformat will format MP4, AVI, & MKV. It will format so that the following is correct:
- FPS - less than or equal to 30 for 1080p and less than or equal to 60 for 720p
- Audio Codec - Must be AAC, LC, Channels 2
- Video Codec - Must Be h264, High, Level 41
> [!CAUTION]
> This script does not change or verify bitrate.
```sh
./reformat.sh
```

This will make all of the formatted videos into the converted folder

Track Extract
-----
Track Extract will extract audio and subtitle tracks from MKV files so that you can then modify the tracks for converted MP4s.
Use case may be that you have a movie that has the first audio track as Japanese, and you want it to be an English MP4.
The way you would go about this is by running reformat, then using track extract, then using refactor tracks.
> [!NOTE]
> You can only do 1 track at a time
> The number after -a or -s indicated the track number starting from 0

Audio Extraction
```sh
./track_extract.sh -a 0
```

This will make all audio as a .mp3 in the audio folder

Subtitle Extraction
```sh
./track_extract.sh -s 0
```

This will make all subtitles as a .srt in the sub folder

Refactor Tracks
-----
This will take all converted videos that have a correlating audio track and make them 1 file.
Use case would be an English audio track combined with a Japanese video.
```sh
./refactor_tracks.sh
```

Verify
-----
Verify will verify that the videos have the correct audio and video codecs to let you know if you have to reformat them, this script is not necassary as reformat already checks this.
```sh
./verify.sh
```

Expected output
```
The file is valid.
```
