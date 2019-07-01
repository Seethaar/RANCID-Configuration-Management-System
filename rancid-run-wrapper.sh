#!/bin/bash

/usr/libexec/rancid/rancid-run
echo -e "If any invalid SSH key entries have been found, you may need to delete them from '/usr/local/rancid/.ssh/known_hosts':\n"
/bin/grep -h 'Update the SSH known_hosts file accordingly' /var/log/rancid/*`/bin/date '+%Y%m%d'`*
