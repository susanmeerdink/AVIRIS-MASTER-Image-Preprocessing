# AVIRIS-MASTER-Image-Preprocessing
This is a project that contains code to layer AVIRIS and MASTER imagery at a 36 m spatial resolution and only retains image areas were they overlap.
Susan Meerdink
Feb 2018

## Requirements:
ENVI 5.4

## Files:
* AVIRIS_MASTER_Processing.pro: Main IDL file that calls other functions and loops through files for processing
* AVIRIS_resize.pro: Function that takes an AVIRIS image and resizes the spatial dimensions
* AVIRIS_MASTER_layer_stack.pro: Function that takes an AVIRIS (reized to match spatial dimensions) and MASTER image and layers them
* AVIRIS_MASTER_mask.pro: Function that takes layered image and removes areas where the two areas don't overlap
