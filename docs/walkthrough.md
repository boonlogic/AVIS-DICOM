[![Boon Logic](../images/BoonLogic.png)](http://docs.boonlogic.com)

# Walkthroughs

[* Check Connection](#example-check-connection)  
[* Quick Start](#example-quick-start)  
[* Complete Guide](#example-complete-guide)  

## Example 1 - Check Connection
Simple curl command to return the current timestamp. Returns the timestamp as a string if server is running (and 200 return code) and fails if server is offline.
```curl
curl -X GET http://10.0.1.41:8080/avis-dicom/v1/status
```

## Example 2 - Quick Start
### Step 1: Connect test bench to server
Example uses identifier "test123"
```curl
curl -X POST http://10.0.1.41:8080/avis-dicom/v1/testBench/test123 \
  -H "x-token: test"
```
### Step 2: Push DICOM image through pipeline
Use any DICOM image or this [example image](../images/BAD_FilterRhAg_SF.DCM)
```curl
curl -X POST http://10.0.1.41:8080/avis-dicom/v1/rawImage/test123?filetype=dcm \
  -H "x-token: test" \
  -H "accept: application/json" \
  -H "Content-Type: multipart/form-data" \
  -F "upfile=path/to/image/BAD_FilterRhAg_SF.DCM"
```
### Step 3: Get results
```curl
curl -X GET http://10.0.1.41:8080/avis-dicom/v1/results/test123 \
  -H "x-token: test"
```
### Step 4: Repeat steps 2 and 3 as much as desired for testing

### Step 5: Disconnect test bench
```curl
curl -X DELETE http://10.0.1.41:8080/avis-dicom/v1/testBench/test123 \
  -H "x-token: test"
```
### All steps
```curl
curl -X POST http://10.0.1.41:8080/avis-dicom/v1/testBench/test123 \
  -H "x-token: test"

curl -X POST http://10.0.1.41:8080/avis-dicom/v1/rawImage/test123?filetype=dcm \
  -H "x-token: test" \
  -H "accept: application/json" \
  -H "Content-Type: multipart/form-data" \
  -F "upfile=path/to/image/BAD_FilterRhAg_SF.DCM"

curl -X GET http://10.0.1.41:8080/avis-dicom/v1/results/test123 \
  -H "x-token: test"

curl -X DELETE http://10.0.1.41:8080/avis-dicom/v1/testBench/test123 \
  -H "x-token: test"
```

## Example 3 - Complete Guide
### Step 1: Check connection
```curl
curl -X GET http://10.0.1.41:8080/avis-dicom/v1/status
```
