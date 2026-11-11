#!/bin/sh

./occ app:enable memories
./occ app:enable previewgenerator
./occ config:system:set memories.vod.disable --value false --type boolean
./occ config:system:set memories.vod.ffmpeg --value /usr/local/bin/ffmpeg
./occ config:system:set memories.vod.ffprobe --value /usr/local/bin/ffprobe
./occ config:system:set memories.vod.external --value true --type boolean
./occ config:system:set memories.vod.connect --value go-vod:47788
./occ config:system:set memories.vod.nc_url --value http://${COMPOSE_PROJECT_NAME}.${AIO_DOMAIN}:${HTTP_INGRES_PORT}
