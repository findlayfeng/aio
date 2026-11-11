#!/bin/sh

./occ app:enable richdocuments
./occ config:app:set richdocuments wopi_allowlist --value 169.254.3.129
./occ richdocuments:activate-config -w http://code:9980
