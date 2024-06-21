[![Boon Logic](../images/BoonLogic.png)](http://docs.boonlogic.com)

# API Documentation

This REST API serves as an interface into the BoonLogic AVIS-DICOM server for processing test mammography images.

## GET /status
Is a generic API call to serve as a basic test to determine if the server is on and connected in a functioning way.

>**Request** <br>
None


>**Response** <br>
String timestamp of the execution

>**Example** <br>
```curl
curl -X GET http://localhost:8080/avis-dicom/v1/status
```


## GET /version
A status call to get the unique version numbers of the individual software components running on the backend.

>**Request** <br>
None


>**Response** <br>
>JSON block of the software components and their corresponding version numbers
```json
{
  "avis-dicom-api": "859e9c0e",
  "avis-dicom-common": "2c55061c",
  "builder": "16fa3cdd",
  "expert-common": "da93f9de",
  "nano-py-bindings": "f152a53c",
  "nano-secure": "b9e862ca",
  "release": "prod"
}
```

>**Example** <br>
```curl
curl -X GET http://localhost:8080/avis-dicom/v1/version
```

## POST /testBench
Connects an identifier for a given test bench to the server. For future calls, this identifier servers as a simple authorization for future calls to that test bench

>**HTTP headers** <br>
--x-token=${idToken}


>**Request** <br>
identifier: (string) label for the test bench
```json
{
  "serial": "serial",
  "status": "status"
}
```


>**Response** <br>
JSON block containing the identifier and the pipeline status for that test bench


>**Example** <br>
```curl
curl -X POST \
    --url http://localhost:8080/avis-dicom/v1/testBench/{identifier} \
    --Header "x-token: test"
```

>**Error conditions** <br>
400 - duplicate test bench identifiers


## GET /testBench
Gets the status information associated with the given test bench identifier.

>**HTTP headers** <br>
--x-token=${idToken}


>**Request** <br>
identifier: (string) label for the test bench


>**Response** <br>
JSON block containing the identifier and the pipeline status for that test bench
```json
{
  "serial": "serial",
  "status": "Done: waiting for image"
}
```

>**Example** <br>
```curl
curl -X GET \
    --url http://localhost:8080/avis-dicom/v1/testBench/{identifier} \
    --Header "x-token: test"
```

>**Error conditions** <br>
400 - given identifier is not a connected test bench

## DELETE /testBench
Removes the test bench identifier from the list of valid test benches to communicate with the server.

>**HTTP headers** <br>
--x-token=${idToken}


>**Request** <br>
identifier: (string) label for the test bench


>**Response** <br>
JSON block containing the return code and a brief message about the success of the call
```json
{
  "code": 200,
  "message": "test bench was successfully disconnected"
}
```

>**Example** <br>
```curl
curl -X DELETE \
    --url http://localhost:8080/avis-dicom/v1/testBench/{identifier} \
    --Header "x-token: test"
```

>**Error conditions** <br>
400 - given identifier is not a connected test bench


## GET /testBenches
Gets the list of connected test bench identifiers and each one's status information.

>**HTTP headers** <br>
--x-token=${idToken}


>**Request** <br>
None


>**Response** <br>
JSON block containing a list of identifiers and the pipeline status for each test bench
```json
[
  {
    "serial": "serial-1",
    "status": "Done: waiting for image"
  },
  {
    "serial": "serial-2",
    "status": "Done: results available for image FilterMoMo_LF_1292019_121230_PM"
  }
]
```

>**Example** <br>
```curl
curl -X GET \
    --url http://localhost:8080/avis-dicom/v1/testBenches \
    --Header "x-token: test"
```

## POST /configuration
Sets various parameters for processing the images.

>**HTTP headers** <br>
--x-token=${idToken}


>**Request** <br>
kernelSize: (integer) number of pixels wide for each sub-image processed (default: 75) <br>
<br>
filterType: (string) filter for overall image: gaussian, median, none (default: none) <br>
<br>
filterParam: (decimal) sigma or radius value corresponding with the filter (default: 1) <br>
<br>
candidateSize: (integer) number of pixels wide to display for each sub-image processed (default: kernelSize) <br>
<br>
major: (decimal) Rose model threshold for major candidates (default: 0.9) <br>
<br>
minor: (decimal) Rose model threshold for minor candidates (default: 0.5) <br>
<br>
edgeCrop: (integer) number of pixels to trim along the edge (default: 3) <br>
<br>
sfEdge: (integer) pixel width to trim for SF images (trims off right side of image) (default: 1290) <br>
<br>
a0SF: (decimal) candidate area minimum asymptote for SF images (default: 11) <br>
<br>
a0LF: (decimal) candidate area minimum asymptote for LF images (default: 9) <br>
<br>
c0: (decimal) candidate contrast minimum asymptote (default: 0.015) <br>
<br>
w: (decimal) determines steepness of Rose model contours with higher values being more gradual slope (default: 2.1) <br>
<br>
k0: (decimal) determines steepness of Rose model curve with higher values being more gradual slope (default: 2) <br>
<br>
areaMax: (integer) candidate area maximum to use Rose model. Areas above are automatically major (default: none) <br>
<br>
contrastMax: (float) candidate contrast maximum to use Rose model. Contrasts above are automatically major (default: none) <br>
<br>

>**Response** <br>
JSON block containing a complete list of the parameters including both the set values and the ones autotuned in the pipeline.
```json
{
  "image": "FilterRhAg_SF_TestFilters_1909863.DPm_9172019_54221_PM.MGDC",
  "subcell": {
    "width": 101,
    "shift": 33
  },
  "max": 159,
  "preprocess": {
    "filter": "gaussian",
    "parameter": 1,
    "edge": 3,
    "SFedge": 1290
  },
  "thresholds": {
    "variation": 0.07,
    "major": 0.95,
    "minor": 0.5,
    "anomaly": 254,
    "distance": 256,
    "areaMax": 60,
    "contrastMax": 0.3
  },
  "roseConstants": {
    "a0SF": 11,
    "a0LF": 9,
    "c0": 0.015,
    "w": 2.1,
    "k0": 2
  }
}
```

>**Example** <br>
```curl
curl -X POST \
     --url http://localhost:8080/avis-dicom/v1/configuration/{identifier} \
           ?kernelSize=101 \
           &edgeCrop=10 \
           &c0=0.02 \
           &filterType=gaussian \
           &filterParam=1 \
     --Header "x-token: test"
```

>**Error conditions** <br>
400 - given identifier is not a connected test bench <br>
&emsp;&emsp;- invalid parameter name specified <br>
&emsp;&emsp;- filter is not one of: "gaussian", "median", or "none"



## GET /configuration
Sets various parameters for processing the images.

>**HTTP headers** <br>
--x-token=${idToken}


>**Request** <br>
identifier: (string) label for the test bench


>**Response** <br>
JSON block containing a complete list of the parameters including both the set values and the ones autotuned in the pipeline.
```json
{
  "image": "FilterRhAg_SF_TestFilters_1909863.DPm_9172019_54221_PM.MGDC",
  "subcell": {
    "width": 101,
    "shift": 33
  },
  "max": 159,
  "preprocess": {
    "filter": "gaussian",
    "parameter": 1,
    "edge": 3,
    "SFedge": 1290
  },
  "thresholds": {
    "variation": 0.07,
    "major": 0.95,
    "minor": 0.5,
    "anomaly": 254,
    "distance": 256,
    "areaMax": 60,
    "contrastMax": 0.3
  },
  "roseConstants": {
    "a0SF": 11,
    "a0LF": 9,
    "c0": 0.015,
    "w": 2.1,
    "k0": 2
  }
}
```

>**Example** <br>
```curl
curl -X GET \
     --url http://localhost:8080/avis-dicom/v1/configuration/{identifier}
     --Header "x-token: test"
```

>**Error conditions** <br>
400 - given identifier is not a connected test bench <br>

## POST /rawImage
Loads an image and runs the AVIS-DICOM pipeline on the given image.

>**HTTP headers** <br>
--x-token=${idToken}


>**Request** <br>
identifier: (string) label for the test bench
filetype: (string) file type being uploaded. Can be either dcm or png
upfile: (data) image to process


>**Response** <br>
JSON block containing the return code and a brief message about the success of the call
```json
{
  "code": 200,
  "message": "test bench was successfully disconnected"
}
```

>**Example** <br>
```curl
curl -X POST \
     --url http://localhost:8080/avis-dicom/v1/rawImage/{identifier} \
           ?filetype=dcm \
     --Header "x-token: test" \
     --Header  "accept: application/json" \
     --Header  "Content-Type: multipart/form-data" \
     -F "upfile=@/path/to/file.DICOM"
```

>**Error conditions** <br>
400 - given identifier is not a connected test bench <br>
&emsp;&emsp;- subcell parameter is too big for image <br>
&emsp;&emsp;- edge parameter is too big for image <br>


## GET /results
Prints out the latest image results including the number of major and minor defects and the coordinates for the major defects

>**HTTP headers** <br>
--x-token=${idToken}


>**Request** <br>
identifier: (string) label for the test bench


>**Response** <br>
JSON block containing the list of coordinates for the major defects as well as the number of minor and major defects found
```json
{
  "image": "FilterRhAg_SF_TestFilters_1909863.DPm_9172019_54221_PM.MGDC",
  "major": 1,
  "minor": 3,
  "coordinates": {
    "major": [
      [
        0,
        0
      ]
    ],
    "minor": [
      [
        10,
        10
      ],
      [
        200,
        1
      ],
      [
        3,
        725
      ]
    ]
  },
  "contrasts": {
    "major": [
      0.025
    ],
    "minor": [
      0.019,
      0.013,
      0.01
    ]
  },
  "areas": {
    "major": [
      45
    ],
    "minor": [
      3,
      2,
      7
    ]
  }
}
```

>**Example** <br>
```curl
curl -X GET \
     --url http://localhost:8080/avis-dicom/v1/results/{identifier} \
     --Header "x-token: test"
```

>**Error conditions** <br>
400 - given identifier is not a connected test bench <br>
&emsp;&emsp;- no image processed

## GET /summary
Returns a summary pdf that displays the original image with highlighted areas where the minor and major defects were found. In addition, there is a column of zoomed in defect sub-images with each ones coordinates and calculated contrast value associated with it. All candidates are contrast stretched the same and the window width and window level used is listed above the defect sub-images.

>**HTTP headers** <br>
--x-token=${idToken}


>**Request** <br>
identifier: (string) label for the test bench


>**Response** <br>
file: named after the original image with a "-summary" appended


>**Example** <br>
```curl
curl -X GET \
     --url http://localhost:8080/avis-dicom/v1/summary/{identifier} \
     --Header "x-token: test"
```

>**Error conditions** <br>
400 - given identifier is not a connected test bench <br>
&emsp;&emsp;- no image processed
