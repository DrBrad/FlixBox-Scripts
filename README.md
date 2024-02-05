# FlixBox Scripts
Scripts to help convert videos and subtitles to a valid format for android, web, & chromecast

Reformat
-----
Reformat will format MP4, AVI, & MKV. It will format so that the following is correct:
- FPS - less than or equal to 30 for 1080p and less than or equal to 60 for 720p
- Audio Codec - Must be AAC, LC, Channels 2
- Video Codec - Must Be h264, High, Level 41
> [!CAUTION]
> WThis script does not change or verify bitrate.
```sh
./reformat.sh
```

This will move all of the formatted videos into the converted folder

Expected output
```
The file is valid.
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
