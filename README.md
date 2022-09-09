# OPERAnet
This repository implements functions in Python to read data from [OPERAnet, a multimodal activity recognition dataset acquired from radio frequency and vision-based sensors](https://www.nature.com/articles/s41597-022-01573-2).

## Acronyms

- (CSI) WiFi Channel State Information 
- (HAR) Human Activity Recognition 
- (PWR) Passive WiFi Radar 
- (RF)  Radio-Frequency 
- (UWB) Ultra-Wideband 

## Install

### Dataset pre-processing

The original OPERAnet datasets contain MATLAB `String` fields that are not compatible with Scipy. To solve this, make sure you run the `convert_and_save.m` MATLAB script on all directories containing `.mat` files  using the command below. You just have to do this once.

``
matlab -nodisplay -r "data_dir='/full/path/to/mat/files/directory'; convert_and_save(data_dir); exit"
``

### Install dependencies

Dependencies can be found in the `requirements.txt` file. 
``
pip install -r requirements.txt
`` 

## Data Description

### WiFi Channel State Information (CSI) 

 | Field                       | Type           | Example         |
 | --------------------------- | -------------- | --------------- |
 | timestamp                   | `datetime`     | `15:07:30.646`  |
 | activity                    | List[`str`]    | `walk`          |
 | exp_no                      | `str`          | `exp_002`       |
 | person_id                   | `str`          | `One`           |
 | room_no                     | `str`          | `1`             |
 | tx{1..3}rx{1..3}_sub{1..30} | complex number | `11.75 - 1.19j` |


### Passive WiFi Radar (PWR)

 | Field     | Type          | Example        |
 | --------- | ------------- | -------------- |
 | exp_no    | `str`         | `exp_002`      |
 | timestamp | `datetime`    | `15:07:30.646` |
 | activity  | List[`str`]   | `walk`         |
 | person_id | `str`         | `One`          |
 | room_no   | `str`         | `1`            |
 | PWR_ch1   | (N,1) float64 |                |
 | PWR_ch2   | (N,1) float64 |                |
 | PWR_ch3   | (N,1) float64 |                |

### Ultra-Wideband (UWB)

 | Field | Type | 
 TODO

### Kinect

 | Field           | Type          | Example        |
 | --------------- | ------------- | -------------- |
 | exp_no          | `str`         | `exp_002`      |
 | timestamp       | `datetime`    | `15:07:30.646` |
 | activity        | List[`str`]   | `walk`         |
 | person_id       | `str`         | `One`          |
 | room_no         | `str`         | `1`            |
 | Kinect1_Markers | (N,3) float64 |                |
 | Kinect2_Markers | (N,3) float64 |                |

## References 

> Bocus, M.J., Li, W., Vishwakarma, S. et al. OPERAnet, a multimodal activity recognition dataset acquired from radio frequency and vision-based sensors. Sci Data 9, 474 (2022). https://doi.org/10.1038/s41597-022-01573-2

