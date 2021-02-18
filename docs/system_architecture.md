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
