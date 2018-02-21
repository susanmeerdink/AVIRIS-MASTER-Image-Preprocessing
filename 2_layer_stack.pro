FUNCTION layer_stack, a_img, m_img
; This code stacks the AVIRIS (224 bands) with MASTER (emissivity and surface temperature band) files.
; It does not use the ENVI layer function because that function projects the new image and rotates it
; Susan Meerdink
; 2/20/2018
; INPUTS:
; 1) a_img: a string containing the path location of the aviris image to be layered
; 2) m_img: a string containing the path location of the master image to be layered
; RETURNS:
; 1) 
;--------------------------------------------------------------------------

; Open Files  
ENVI_OPEN_FILE, a_img, R_FID = fidA ;Open the aviris file
ENVI_OPEN_FILE, m_img, R_FID = fidM ;Open the master file

; Get info about aviris file
ENVI_FILE_QUERY, fidA, $ 
  NB        = a_bands, $ ; Number of bands
  NS        = a_numSamples, $ ;Number of samples
  NL        = a_numLines, $ ;Number of lines
  DATA_TYPE = a_dt, $ ;Data Type
  WL        = a_WL, $ ;Wavelength values
  SNAME     = a_name_short ;short file name for aviris file

; Get info about master file
ENVI_FILE_QUERY, fidM, $ 
  NB        = m_bands, $ ; Number of bands
  NS        = m_numSamples, $ ;Number of samples
  NL        = m_numLines, $ ;Number of lines
  DATA_TYPE = m_dt, $ ;Data Type
  WL        = m_WL, $ ;Wavelength values
  SNAME     = m_name_short ;short file name for master file

; Set up variables for image creation  
map_info = ENVI_GET_MAP_INFO(FID = fidA)
outImage = MAKE_ARRAY([numSamples, (a_bands + m_bands), numLines], TYPE = 3, VALUE = 0) ;Create empty array for output image with Long integer (32 bits) data type
countLine = 0 ;Counter for array assignment in loop

;;; GET DATA & ASSIGN TO RESIZED IMAGE ;;;
FOR i = 0, (numLines-1) DO BEGIN ;Loop through lines of image
  aData = ENVI_GET_SLICE(/BIL, FID = fidA, LINE = i, POS = INDGEN(a_bands), XS = 0, XE = numSamples-1) ;Get Data from new image (returns in BIL format)
  mData = ENVI_GET_SLICE(/BIL, FID = fidM, LINE = i, POS = INDGEN(m_bands), XS = 0, XE = numSamples-1) ;Get Data from new image (returns in BIL format)
  ;              LINE = keyword to specify the line number to extract the slice from. LINE is a zero-based number.
  ;              POS = keyword to specify an array of band positions
  ;              XE = keyword to specify the x ending value. XE is a zero-based number.
  ;              XS = keyword to specify the x starting value. XS is a zero-based number.
  ;              /BIL = keyword that make data returned in BIL format - dimensions of a BIL slice are always [num_samples, num_bands] 
  if a_dt EQ 4 then begin ;If the data type is float instead of 14
    aData = FIX(aData*1000)       
  endif
  outLine = [[aData],[mData]];Assign Data to new array
  outImage[0,0,countLine] = outLine ;Assign Array
  countLine = countLine + 1 ;Advance counter used in array assignment 
ENDFOR
;;; DONE GETTING DATA & ASSIGNING TO RESIZED IMAGE ;;; 

;;; WRITE DATA TO ENVI FILE ;;;
fileOutput = single_flightline + '\' + STRMID(emis_name_short,0,(STRPOS(emis_name_short,'-')+1)) + 'emissivity&temp' ;Set file name for new image
fileOutputTemp = single_flightline + '\' + STRMID(emis_name_short,0,(STRPOS(emis_name_short,'-')+1)) + 'emissivity&tempBIL' ;Set file name for new BSQ image

ENVI_WRITE_ENVI_FILE, outImage, $ ; Data to write to file
  OUT_NAME = fileOutputTemp, $ ;Output file name
  NB = (emis_bands + temp_bands), $; Number of Bands
  NL = numLines, $ ;Number of lines
  NS = numSamples, $ ;Number of Samples
  INTERLEAVE = 1 , $ ;Set this keyword to one of the following integer values to specify the interleave output: 0: BSQ 1: BIL 2: BIP
  R_FID = fidInter, $ ;Set keyword for new file's FID
  OFFSET = 0 ; Use this keyword to specify the offset (in bytes) to the start of the data in the file.
;;; DONE WRITING DATA TO ENVI FILE ;;;

;;; CONVERT TO BSQ ;;;
ENVI_FILE_QUERY,fidInter, DIMS = new_dims, NS = new_samples, NL = new_lines, NB = new_bands
ENVI_DOIT, 'CONVERT_DOIT', $
  DIMS = new_dims, $ ;five-element array of long integers that defines the spatial subset
  FID = fidInter, $ ;Set for new file's fid
  OUT_NAME = fileOutput, $ ; Set new files output name
  R_FID = fidFinal, $ ;Set BSQ file fid
  O_INTERLEAVE = 0, $ ;keyword that specifies the interleave output: 0: BSQ, 1: BIL, 2: BIP
  POS =  INDGEN(new_bands) ;specify an array of band positions
;;; DONE CONVERTING TO BSQ ;;;

;;; CREATING ENVI HEADER FILE ;;;
raster_wl = [string(emis_WL),'surface_temp']
ENVI_SETUP_HEAD, $
  fname = fileOutput + '.hdr', $ ;Header file name
  NS = new_samples,$ ;Number of samples
  NL = new_lines, $ ;Number of lines
  data_type = 3,$ ; Data type of file
  interleave =  0, $ ;specify the interleave output: 0: BSQ,1: BIL,2: BIP
  NB = new_bands,$ ;Number of Bands
  map_info = map_info, $ ;Map Info - set to the base image since raster has been resized.
  bnames = raster_wl, $ ;Bands Names
  /write
;;; DONE CREATING ENVI HEADER FILE ;;;

;;; CLOSING ;;;
envi_file_mng, ID = fidEmis, /remove ;Close current Raster image
envi_file_mng, ID = fidTemp, /remove ;Close current Raster image
envi_file_mng, ID = fidInter, /remove ;Close current Raster image
envi_file_mng, ID = fidFinal, /remove ;Close current Raster image
FILE_DELETE, fileOutputTemp ;Delete the temporary BIL formatted image
FILE_DELETE, fileOutputTemp + '.hdr' ;Delete the temporary BIL formatted image
;;; DONE CLOSING ;;;

END