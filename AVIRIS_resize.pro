FUNCTION AVIRIS_resize, e, img, spatial_dim, output
; This function takes in an image and resize it to the spatial dimensions specified.
; Susan Meerdink
; 2/21/2018
; INPUTS:
; 1) e: an object reference to the envi application. 
; 2) img: a string designating the location of the file to be resized
; 3) spatial_dim: an integer specifying the spatial resolution of output image
; 4) output: a string designating the output locations of the resized image
; OUTPUTS:
; 1) Saves a resampled image to the specified output location
; ------------------------------------------------------------------------------------------

  ; Open an input file & get pixel information
  Raster = e.OpenRaster(img)
  spatial = Raster.SPATIALREF
  pixel_size = spatial.PIXEL_SIZE
  pixel_scale = spatial_dim/pixel_size[0]
  
  ; Get the task from the catalog of ENVITasks
  Task = ENVITask('PixelScaleResampleRaster')  ; http://www.harrisgeospatial.com/docs/envipixelscaleresamplerastertask.html
  
  ; Define inputs
  Task.INPUT_RASTER = Raster
  Task.PIXEL_SCALE = [pixel_scale, pixel_scale]
  
  ; Define outputs
  Task.OUTPUT_RASTER_URI = output
  
  ; Run the task
  Task.Execute
  
  ; Close Files
  Raster.Close
  
  RETURN, 'Completed Resizing'

END