[![Boon Logic](../images/BoonLogic.png)](http://docs.boonlogic.com)


# Installation/Update Instructions:

1. Download the release tgz file and install_update.sh file onto server
2. Run the following command from the download location to update:
```
./install_update.sh avis-dicom-server-linux-x86_64-rel-<tag>.tgz
```

Notes:  

- Previous installation will be saved in /opt/boonlogic/install_old
- If system is completely offline or the hard drive broke, email Boon Logic Support at:  
```
nano-support@boonlogic.com
```

# Test Server Connection:
```curl
curl -X GET http://ip.address:8080/avis-dicom/v1/version
```

```curl
{
  "release": "",
  "avis-dicom-common": "",
  "avis-dicom-api": "",
  "builder": "",
  "expert-common": "",
  "nano-py-bindings": "",
  "nano-secure"
}
```

