[![Boon Logic](../images/BoonLogic.png)](http://docs.boonlogic.com)

# System Architecture

This server is made to process DICOM test images and return major and minor defect information to the user.

![Whole Pipeline](../images/pipeline-overview.png)

## Labview SDK

Located on the test bench controller, this interfaces with the AVIS server over the internal network.  

<img src="../images/pipeline-labview.png" alt="Labview SDK" width="400">  

<br/>
<br/>

**Example image**

![All Options Labview](../images/complete-labview.png)

## AVIS AI Server

On-prem 1U mountable rack to be delivered on site.

<img src="../images/pipeline-hardware.png" alt="Labview SDK" width="400">
<br/>
<br/>

**Specifications:**   
* Manufacturer&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Dell
* Device&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;R240
* CPU&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Intel Xeon E-2288G (16 Threads)
* Memory&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; 16 GB
* Connectivity &emsp;&emsp;&emsp;&emsp;&emsp;&emsp; Dual 1-Gb Ethernet Link
* Test Benches Supported&emsp;10

**Features:**  
* On-Premise AI Inference and Training
* Up to 10 simultaneous Image Analysis Pipelines
* Boon Logic API Server
* Token Authentication
* RSA Authentication for SSH Access
* iDRAC Server Monitoring
* Boon OTA Software Update
* Simple Disaster Recovery


### See the [Server Connections Document](./server_connections.md) for more information.


## REST API

REST interface for accessing the server and its processed results.

<img src="../images/pipeline-API.png" alt="Labview SDK" width="400">
<br/>
<br/>

| General |  |
| :--- | :--- |
| **Status** | Timestamp of the call to determine if server is active  |
| **Version** | Version numbers for all included software |

**Included Software:**
* avis-dicom-api
* avis-dicom-common
* builder
* expert-common
* nano-py-bindings
* nano-secure
* nano-sgx

| Test Bench | |
| :--- | :--- |
| **Attach**<br/>*(Required)* | Assign identifier |
| **Detach** | Remove identifier from the list of valid test benches |
| **Status** | Status in pipeline of individual test bench <br/> **OR** <br/> List of all test benches' statuses in their respective pipelines |


| Configuration |  |
| :--- | :--- |
| **Define** | Set values and forego autotuning for any set values |
| **Returned** | Complete list of parameters used in processing of the image (including auto-set values)

##### subcell
###### width (configurable) - number of pixels across for the subimage
###### shift (set) - number of pixels to shift over between each subimage
##### preprocess
###### filter (configurable) - filter to preprocess the whole image. Options are median, gaussian, or none
###### parameter (configurable) - parameter associated with the filter. If the filter is median, this value corresponds to the window width, if the filter is gaussian, then this corresponds to the sigma value
##### edge (configurable) - number of pixels to trim around the edge of the image
##### SFEdge (configurable) - number of pixels wide to trim the SF images
##### thresholds
###### contrastMax (configurable) - maximum contrast to apply Rose Model before automatically labelling candidate as major
###### areaMax (configurable) - maximum area to apply Rose Model before automatically labelling candidate as major
###### major (configurable) - Rose model threshold for major candidates
###### minor (configurable) - Rose model threshold for minor candidates
###### variation (set) - the distance measurement to distinguish variation between subimages (Boon value)
###### distance (set) - distance index between subimages' clusters (Boon value)
###### anomaly (set) - frequency index for subimages' clusters (Boon value)
##### max (set) - value for cropping histogram of magnitude values for each subimage
##### roseConstants
###### a0SF (configurable) - minimum area asymptote for Rose Model curve for SF images
###### a0LF (configurable) - minimum area asymptote for Rose Model curve for LF images
###### c0 (configurable) - minimum contrast asymptote for Rose Model curve
###### w (configurable) - scalar for Rose model curve to adjust contour spacing (high values spread out contours)
###### k0 (configurable) - scalar for Rose Model curve to adjust contour edge slope (high values make the curve more gradual)

| Image |  |
| :--- | :--- |
| **Send**<br/>*(Required)* | Send DICOM image to AVIS server to be processed |


| Results |  |
| :--- | :--- |
| **Returned**<br/>*(Required)* | Summary of defect values resulting from the last image processed |

##### image - identifier associated with the last image processed
##### major - number of major candidates found
##### minor - number of minor candidates found
##### coordinates
###### major - list of coordinates where each major defect candidate was located on the original image
###### minor - list of coordinates where each minor defect candidate was located on the original image
##### contrasts
###### major - list of contrast values for each major defect candidate
###### minor - list of contrast values for each minor defect candidate
##### areas
###### major - list of defect areas for each major defect candidate
###### minor - list of defect areas for each minor defect candidate

| Summary |  |
| :--- | :--- |
| **Returned**<br/>*(Required)* | Send DICOM image to AVIS server to be processed |

**Example summary file**  
<br>
<img src="../images/summary.png" alt="Labview SDK" width="400">

### See the [API Documentation](./api_docs.md) for more information.


## Image Process

General pipeline happening on the backend when each DICOM image is pushed to the AVIS server.

<img src="../images/pipeline-process.png" alt="Labview SDK" width="400">
<br/>
<br/>

#### Step 1: Crop SF images
Using the image name identifier, the right edge is clipped if the DICOM image name contains the filter identifier "SF". If the filter is LF, this step is skipped.
#### Step 2: Filter image
Using the specified filter type in the configuration (gaussian, median, or none), the image is passed through the filter. The filtered image is now the image used in the rest of the processing pipeline.
#### Step 3: Subdivide image
Using the subcell width from the configuration (in number of pixels), the DICOM image is subdivided into smaller images. The number of pixels between each subimage is the subcell shift value in the configuration.<br>
<img src="../images/subimage.png" alt="Labview SDK" width="200">  
Subimages are shown in yellow. This simplified example is for a width of 3 and a shift of 2.
#### Step 4: Convert subimages to histograms of magnitudes
Each subimage is converted to a histogram of magnitudes using the raw pixel values. Pixel values are binned so that the histogram is has 64 bins of pixels. These histograms are what are used to create the model for each image and find any defects.

## Clustering Process

Boon Logic clustering process of the DICOM image.

<img src="../images/pipeline-clustering.png" alt="Labview SDK" width="400">
<br/>
<br/>

The histograms for the image are clustered using Boon Logic's nano clustering technique. From the raw image, shown on the right, the resulting clusters are assigned frequency values where high values are associated with areas of the image that are different from the rest of the image regions. The image shown on the right is a contour plot of an example DICOM image's results with areas in white depicting parts of the image that are potential defects.  
<img src="../images/raw-image.png" alt="Labview SDK" width="200">
<img src="../images/RI-contours.png" alt="Labview SDK" width="250">  

Note that areas along the edge of the image are white where the original image has a natural gradient. This will be taken into account and ignored in the classification step if those areas are indeed just gradients.

## Classification Process

Process for classifying the candidates as major or minor defects.

<img src="../images/pipeline-classification.png" alt="Labview SDK" width="400">
<br/>
<br/>

### Major candidates - above Rose model major threshold
### Minor candidates - above Rose model minor threshold

### Factors
#### Distance
1. Cluster distance from other clusters created throughout the image
2. 95th percentile of all distance indexes within the image is the threshold
3. Candidates above the threshold are selected

#### Frequency
1. Cluster frequency compared to other clusters created throughout the image
2. 95th percentile of all frequency indexes within the image is the threshold
3. Candidates above the threshold are selected

#### Contrast
1. Select candidate subimage pixel values between the 10th and 90th percentile for the subimage
1. Fits each candidate subimage to a plane using the selected pixels from previous step  
2. Find the difference between the min pixel value and the expected plane value (as well as the difference between the max and the plane)
3. Difference value divided by the expected plane value gives the contrast measurement
4. Contrast value is compared to the threshold value

#### Area
1. Select candidate subimage pixel values between the 10th and 90th percentile for the subimage
1. Finds the mean and standard deviation for the pixels selected in previous step
2. Threshold is four times the standard deviation added to the mean
2. Count pixels in subimage that are above the threshold or below the negative threshold

#### Rose Model
1. Using a Rose Model inspired function, calculate Rose Model value for comparison against the major and minor thresholds [(see reference)](#../files/Rose_model-burgess_josaa_1999.pdf)

# Deliverables

### * 1U rack-mountable server (see [AVIS DICOM Server](#avis-ai-server) section)
### * Results values
- Major candidate count
- Minor candidate count
- Coordinates of major candidates
- Summary image of the locations of the candidates and the window level/window width used for displaying the image

# AVIS Enabled Process
<img src="../images/avis-enabled-process.png" alt="Labview SDK" width="900">
<br/>
<br/>
