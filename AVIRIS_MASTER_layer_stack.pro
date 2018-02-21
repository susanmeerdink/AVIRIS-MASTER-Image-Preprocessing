FUNCTION AVIRIS_MASTER_layer_stack, e, a_img, m_img, output
; This code stacks the AVIRIS (224 bands) with MASTER (emissivity and surface temperature band) files.
; It does not use the ENVI layer function because that function projects the new image and rotates it
; Susan Meerdink
; 2/20/2018
; INPUTS:
; 1) e: an object reference to the envi application. 
; 2) a_img: a string containing the path location of the aviris image to be layered
; 3) m_img: a string containing the path location of the master image to be layered
; 4) output: a string designating the output locations of the resized image
; RETURNS:
; 1) saves layered image to designated output location
;--------------------------------------------------------------------------
  
  ; Open an input files 
  raster_a = e.OpenRaster(a_img)
  raster_m = e.OpenRaster(m_img)
  
  ; Get the spatial reference of the master raster
  spatialRef = raster_m.SPATIALREF
  nCols = raster_m.NCOLUMNS
  nRows = raster_m.NROWS
  coordSysString = spatialRef.COORD_SYS_STR
  coordSys = ENVICoordSys(COORD_SYS_STR=coordSysString)
  pixelSize = spatialRef.PIXEL_SIZE
  tiePointMap = spatialRef.TIE_POINT_MAP
  tiePointPixel = spatialRef.TIE_POINT_PIXEL

  ; Create a grid definition
  Grid = ENVIGridDefinition(coordSys, $ ; The ENVICoordSys object that defines the coordinate system used for the grid definition.
    PIXEL_SIZE = pixelSize, $ ; Specify a two-element array with the [x,y] pixel size in the same units as the associated ENVICoordSys object.
    TIE_POINT_MAP = tiePointMap, $ ; Specify a two-element array with the map coordinates of the TIE_POINT_PIXEL location
    TIE_POINT_PIXEL = tiePointPixel, $ ; Specify a two-element array with the pixel coordinates of the tie point
    NCOLUMNS = nCols, $ ; Specify the number of columns in the grid
    NROWS = nRows) ; Specify the number of rows in the grid
  
  ; Create a layer stack: http://www.harrisgeospatial.com/docs/envilayerstackraster.html
  layerStack = ENVILayerStackRaster([raster_a, raster_m], Grid)  
  
  ; Save the result to ENVI raster format
  layerStack.Export, output, 'ENVI'

  RETURN, 'Completed Layering'
END