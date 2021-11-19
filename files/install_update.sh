#! /bin/bash

# Script to safely update the Boon Logic AVIS DICOM Server
# Usage:
# ./install_update.sh avis-dicom-server-linux-x86_64-dev-*.tgz

sudo systemctl stop avis-dicom

rm -rf /opt/boonlogic/install_old

mv /opt/boonlogic/install /opt/boonlogic/install_old

mkdir /opt/boonlogic/install

tar -xvf $1 -C /opt/boonlogic/install

sudo systemctl start avis-dicom

sleep 2

if (systemctl is-active --quiet avis-dicom) then
    echo "AVIS DICOM Server Update Complete..."
else
    echo "AVIS DICOM Server Update Failed... Check systemctl status "
    exit 1
fi
