![Boon Logic](../images/BoonLogic.png)

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


See the [Server Connections Document](./server_connections.md) for more information.


## REST API

REST interface for accessing the server and its processed results.

<img src="../images/pipeline-API.png" alt="Labview SDK" width="400">
<br/>
<br/>

# **TODO** Fill in details of what everything means

### General
| Status | Version |
| :--- | :--- |
| Timestamp of the call to determine if server is active | Version numbers for all included software |

**Included Software:**
* avis-dicom-api
* avis-dicom-common
* builder
* expert-common
* nano-py-bindings
* nano-secure

### Test Bench
| Attach<br/><span style="font-weight:normal">*(Required)*</span> | Detach | Status |
| :--- | :--- | :--- |
| Assign identifier | Remove identifier from the list of valid test benches | Status in pipeline of individual test bench <br/> **OR** <br/> List of all test benches' statuses in their respective pipelines |

### Parameters
| Define | Returned |
| :--- | :--- |
| Set values and forego autotuning for any set values | Complete list of parameters used in processing of the image (including auto-set values)

##### subcell
###### width (configurable)
###### shift (set)
##### preprocess
###### filter (configurable)
###### parameter (configurable)
##### edge (configurable)
##### thresholds
###### contrast (configurable)
###### variation (set)
###### distance (set)
###### local z value (set)
##### histogram maximum (set)

### Image

### Results

### Summary


See the [API Documentation](./api_docs.md) for more information.
