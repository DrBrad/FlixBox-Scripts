#!/bin/bash
#################################################################################
# These are inherited from Transmission.                                        #
# Do not declare these. Just use as needed.                                     #
#                                                                               #
# TR_APP_VERSION                                                                #
# TR_TIME_LOCALTIME                                                             #
# TR_TORRENT_DIR                                                                #
# TR_TORRENT_HASH                                                               #
# TR_TORRENT_ID                                                                 #
# TR_TORRENT_NAME                                                               #
#                                                                               #
#################################################################################

#./html/transmission/complete.sh

#TR_TORRENT_DIR=/home/brad/Downloads/torrents
#TR_TORRENT_NAME="movie.mp4"
#TR_TORRENT_ID=10

echo $TR_TORRENT_DIR;
echo $TR_TORRENT_NAME;
echo $TR_TORRENT_ID;

transmission-remote -t $TR_TORRENT_ID --remove

mv "${TR_TORRENT_DIR}/${TR_TORRENT_NAME}" "$(dirname $TR_TORRENT_DIR)/done/${TR_TORRENT_NAME}"
