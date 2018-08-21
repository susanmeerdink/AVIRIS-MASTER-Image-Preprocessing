# AVIRIS-MASTER-Image-Preprocessing
This is a project that contains code to layer AVIRIS and MASTER imagery at a 36 m spatial resolution and only retains image areas were they overlap.
Susan Meerdink
Feb 2018

## Requirements:
ENVI 5.4

## Overview of Files:
* AVIRIS_MASTER_Processing.pro: Main IDL file that calls other functions and loops through files for processing
* AVIRIS_MASTER_processing_single.pro: Main IDL file that call other functions and only processes a single file
* AVIRIS_resize.pro: Function that takes an AVIRIS image and resizes the spatial dimensions
* AVIRIS_MASTER_layer_stack.pro: Function that takes an AVIRIS (reized to match spatial dimensions) and MASTER image and layers them
* AVIRIS_MASTER_mask.pro: Function that takes layered image and removes areas where the two areas don't overlap
* AVIRIS_resize.pro: Function that resizes AVIRIS 18 m spatial resolution to 36 m spatial resolution
* AVIRIS_Time_Processing.pro: Main IDL file that calls other functions and loops through time files for processing.
* AVIRIS_time_resize_plus_borders.pro: Function that reads in time image and resizes it to match the same spatial area of a base image.
* Time_resize.pro: Function that resizes AVIRIS Time image 18 m spatial resolution to 36 m spatial resolution

## Steps:
1. Time Processing: 
    * Details: In order to calculate surface temperature - air temperature it was necessary to add the time each pixel was collected. To add this information, the observation file (*obs or *obs_ort) from JPL's AVIRIS processing steps needed to be processed to match AVIRIS+MASTER imagery. This code (AVIRIS_Time_Processing.pro) processes a obs flightline to resize image (aviris_time_resize_plus_borders.pro) and then resample to 36 m spatial resolution (time_resize.pro). 
    * Resize Image: (aviris_time_resize_plus_borders.pro)Created for images from the HyspIRI campaign (same area flown three times in 2013 and 2014). Images must have same number of bands and be in zero rotation (aka North to South - NO angle). This file loops through folders that contain files for a specific flightline from multiple dates. The goal of this code is to read in a base file that has been cropped to the study area of choice for each flightline folder (FL01, FL02, etc).The code will crop all other files for that specific flightline to the study area of interested (covered in the base file). The code will add a 10 sample/line border to all sides the flightline that has a value of zero. The resulting files will be a BSQ image that has the same number of samples and lines for all files in the flightline folder.
    * Resample Image: (time_resize.pro) Resizes image to 36 m spatial resolution and only uses utc time band.

2. AVIRIS + MASTER Processing:
    * Details: this code takes the aviris bands, master bands, and time band and combines them into one image. There are two main IDL codes for this depending on if you want to processes multiple (AVIRIS_MASTER_processing.pro) or a single (AVIRIS_MASTER_processing_single.pro). This code first resamples aviris images to 36 meter spatial resolution, layers aviris+master+time images, and then masks out areas were all three do not cover.
    * Resample: (AVIRIS_resize.pro) Resizes image to 36 m spatial resolution from the original 18 m spatial resolution. 
    * Layer: (AVIRIS_MASTER_layer_stack.pro) This code takes all 224 bands of AVIRIS, 5 bands + Temp of MASTER, and 1 band of UTC time and layers them into one image.
    * Mask: (AVIRIS_MASTER_mask.pro)This code reads in image that has both AVIRIS and MASTER imagery layered and will mask out areas where the MASTER imagery does not overlap with AVIRIS imagery. This code also update the metadata specifically band names, wavelengths, and bbl.
