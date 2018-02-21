FUNCTION AVIRIS_MASTER_mask, e, input, outputMask, outputImage
; This code reads in image that has both AVIRIS and MASTER imagery layered and will mask out areas
; where the MASTER imagery does not overlap with AVIRIS imagery.
; Susan Meerdink
; 2/21/2018
; INPUTS:
; 1) e: an object reference to the envi application. 
; 2) input: a string designating the location of the file to be masked
; 3) outputMask: a string designating the output locations of the mask file
; 4) outputImage: a string designating the output locations of the masked final image
; OUTPUTS:
; 1) Saves a masked image to the specified output location
;-------------------------------------------------------------------------------------
 
  ; Open image                
  rasterIn = e.OpenRaster(input); Open an input file
  
  ; Generate a mask, Get all locations where Bands 1-224 are equal 0
  sum = TOTAL(rasterIn.GetData(BANDS=[0:25]), 3) 
  mask = sum GT 0      
  
  ; Save the mask to a file
  maskRaster = ENVIRaster(mask) ; , URI=outputMask
  maskRaster.Save
        
  ; Create a masked raster: https://www.harrisgeospatial.com/docs/envimaskraster.html
  rasterOut = ENVIMaskRaster(rasterIn, maskRaster)
      
  ; Save the result to ENVI raster format
  rasterOut.Export, outputImage, 'ENVI'
  
  RETURN, 'Completed Masking'

END ; End of File