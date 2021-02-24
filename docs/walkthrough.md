[![Boon Logic](../images/BoonLogic.png)](http://docs.boonlogic.com)

# Walkthroughs

[* Check Connection](#example-1-check-connection)  
[* Quick Start](#example-2-quick-start)  
[* Complete Guide](#example-3-complete-guide)  

## Example 1 - Check Connection
Simple curl command to return the current timestamp. Returns the timestamp as a string if server is running (and 200 return code) and fails if server is offline.
```curl
curl -X GET http://10.0.1.41:8080/avis-dicom/v1/status
```
Returns:
```json
"24/02/2021 18:58:44"
```


## Example 2 - Quick Start
### Step 1: Connect test bench to server
Example uses identifier "test123"
```curl
curl -X POST http://10.0.1.41:8080/avis-dicom/v1/testBench/test123 \
  -H "x-token: test"
```
Returns:
```json
{
  "identifier": "test123",
  "status": "Done: waiting for image"
}
```

### Step 2: Push DICOM image through pipeline
Use any DICOM image or this [example image](../images/BAD_FilterRhAg_SF.DCM)
```curl
curl -X POST http://10.0.1.41:8080/avis-dicom/v1/rawImage/test123?filetype=dcm \
  -H "x-token: test" \
  -H "accept: application/json" \
  -H "Content-Type: multipart/form-data" \
  -F "upfile=@/path/to/image/BAD_FilterRhAg_SF.DCM"
```

Returns:
```json
{
  "code": 200,
  "message": "request successful"
}
```

### Step 3: Get results
```curl
curl -X GET http://10.0.1.41:8080/avis-dicom/v1/results/test123 \
  -H "x-token: test"
```
Returns:
```json
{
  "coordinates": {
    "major": [
      [
        704,
        150
      ]
    ]
  },
  "image": "BAD_FilterRhAg_SF",
  "major": 1,
  "minor": 0
}
```

### Step 4: Repeat steps 2 and 3 as much as desired for testing

### Step 5: Disconnect test bench
```curl
curl -X DELETE http://10.0.1.41:8080/avis-dicom/v1/testBench/test123 \
  -H "x-token: test"
```
Returns:
```json
{
  "code": 200,
  "message": "test bench was successfully disconnected"
}
```
### All steps
```curl
curl -X POST http://10.0.1.41:8080/avis-dicom/v1/testBench/test123 \
  -H "x-token: test"

curl -X POST http://10.0.1.41:8080/avis-dicom/v1/rawImage/test123?filetype=dcm \
  -H "x-token: test" \
  -H "accept: application/json" \
  -H "Content-Type: multipart/form-data" \
  -F "upfile=@/path/to/image/BAD_FilterRhAg_SF.DCM"

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
Returns:
```json
```
### Step 2: Get Versioning
```curl
curl -X GET http://10.0.1.41:8080/avis-dicom/v1/version
```
Returns:
```json
```
### Step 3: Connect Test Bench
Example uses identifier "test123"
```curl
curl -X POST http://10.0.1.41:8080/avis-dicom/v1/testBench/test123 \
  -H "x-token: test"
```
Returns:
```json
```
Duplicate test bench identifiers are not allowed

### Step 4: Get Pipeline Status
```curl
curl -X GET http://10.0.1.41:8080/avis-dicom/v1/testBench/test123 \
  -H "x-token: test"
```
Returns:
```json
```

### Step 5: List Test Benches and Their Statuses
```curl
curl -X GET http://10.0.1.41:8080/avis-dicom/v1/testBenches \
  -H "x-token: test"
```
Returns:
```json
```

### Step 6: Configure Parameters
See the [parameters explanation section](./system_architecture.md#parameters) for more information
```curl
curl -X POST http://10.0.1.41:8080/avis-dicom/v1/testBench/test123 \
  -H "x-token: test"
```
Returns:
```json
```
