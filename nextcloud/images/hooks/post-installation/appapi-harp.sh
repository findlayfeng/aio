#!/bin/sh

./occ security:certificates:import /usr/local/share/ca-certificates/caddy_root.crt
./occ app_api:daemon:register \
    harp_proxy_docker \
    "Harp Proxy (Docker)" \
    "docker-install" \
    "http" "appapi-harp:8780" "http://${COMPOSE_PROJECT_NAME}.${AIO_DOMAIN}:${HTTP_INGRES_PORT}" \
    --net nextcloud_app \
    --harp \
    --harp_frp_address "appapi-harp:8782" \
    --harp_shared_key "${HP_SHARED_KEY}" \
    --compute_device cpu \
    --harp_exapp_direct \
    --set-default
