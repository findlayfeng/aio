#!/bin/sh

./occ config:app:set richdocuments public_wopi_url --value https://code.localhost:8443
./occ config:app:set richdocuments wopi_allowlist --value 192.254.3.253
./occ config:app:set richdocuments wopi_url --value http://code:9980
./occ app:enable richdocuments
