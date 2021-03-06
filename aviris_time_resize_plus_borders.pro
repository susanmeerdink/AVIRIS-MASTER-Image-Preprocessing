FUNCTION aviris_time_resize_plus_borders, base_file, in_File, out_File
  ;Created for images from the HyspIRI campaign (same area flown three times in 2013 and 2014).
  ;Images must have same number of bands and be in zero rotation (aka North to South - NO angle).
  ;This file loops through folders that contain files for a specific flightline from multiple dates.
  ;The goal of this code is to read in a base file that has been cropped to the study area of choice for each flightline folder (FL01, FL02, etc).
  ;The code will crop all other files for that specific flightline to the study area of interested (covered in the base file).
  ;The code will add a 10 sample/line border to all sides the flightline that has a value of zero.
  ;The resulting files will be a BSQ image that has the same number of samples and lines for all files in the flightline folder.
  ;This code outputs images that will be inputs for Alex Koltunov's Image to Image Registration code.
  ; Susan Meerdink
  ; Created 8/17/2018
  ;
  ; --------------------------------------------------------------------------------------------------------------------------
  ;;; SETTING UP ENVI/IDL ENVIRONMENT ;;;
  COMPILE_OPT STRICTARR
  envi, /restore_base_save_files
  ENVI_BATCH_INIT ;Doesn't require having ENVI open - use with stand alone IDL 64 bit
  ;;; DONE SETTING UP ENVI/IDL ENVIRONMENT ;;;

  ;;; ADDITIONAL VARIABLES FOR MEMORY PURPOSES ;;;
  outImage = MAKE_ARRAY([800, 250, 10000], TYPE = 2, VALUE = 0) ;Create empty array that is large for memory allocation purposes
  outImage = 0 ;Set to zero for memory purposes
  ;;; DONE ADDITIONAL VARIABLES FOR MEMORY PURPOSES ;;;

    ;;; FINDING BASE IMAGE ;;;
    envi_open_file, base_file, R_FID = fidBase ;Open the basefile
    envi_file_query, fidBase, $ ;Get information about basefile
      NS = base_samples, $ ;Number of Samples
      NL = base_lines, $ ; Number of Lines
      SNAME = base_file_name ;Short name of base file (no path)
    print, 'Basefile: ' + base_file_name
    map_info_base = envi_get_map_info(FID = fidBase) ;Get basefile's map information
    upperCoordE = map_info_base.mc[2];declaring variable that will hold upper E coordinate
    upperCoordN = map_info_base.mc[3];declaring variable that will hold upper N coordinate
    ;;; DONE FINDING BASE IMAGE ;;;

    ;;; LOOPING THROUH OTHER IMAGES ;;;
      ENVI_open_file, in_File, R_FID = fidRaster ;Open the file
      ENVI_file_query, fidRaster,$ ;Get information about file
        DIMS = raster_dims,$ ;The dimensions of the image
        NB = raster_bands,$ ;Number of bands in image
        BNAMES = raster_band_names,$ ;Band names of image
        NS = raster_samples, $ ;Number of Samples
        NL = raster_lines,$ ;Number of lines
        WL = raster_wl,$ ;WAvelengths of image
        DATA_TYPE = raster_data_type, $ ;File data types
        FNAME = raster_file_name ;contains the full name of the file (including path)
      map_info_raster = envi_get_map_info(FID = fidRaster) ;Get Raster map info
      ;;; DONE BASIC FILE INFO ;;;

      ;;; FINDING RESIZE COORDINATES ;;;
      ;; find coordinates of base image in the raster image - will be used an resizing coordinates
      ENVI_CONVERT_FILE_COORDINATES, $ ;this procedure to convert x,y pixel coordinates to their corresponding map coordinates, and vice-versa
        fidRaster, $ ;File ID
        upperCoordX, $ ;XF is a named variable that contains the returned x file coordinates for the input XMap and YMap arrays
        upperCoordY, $ ;YF is a named variable that contains the returned y file coordinates for the input XMap and YMap arrays
        upperCoordE, $ ;XMap is a variable that contains the x map coordinates to convert
        upperCoordN ;YMap is a variable that contains the y map coordinates to convert
      upperCoordX = round(upperCoordX) ;Round to the nearest whole pixel
      upperCoordY = round(upperCoordY) ;Round to the nearest whole pixel

      ;; Setting the number of samples to pull data out
      startSample = upperCoordX ; Set the sample number to start with
      offsetSampleStart = 0 ;Set the offset to zero
      if startSample LT 0 then begin ;If the coordinate is found off the image (a negative value)
        offsetSampleStart = abs(startSample) ;Set the offset for that difference
        startSample = 0 ;Start at the first sample of the image
      endif
      endSample = (base_samples - 1) + upperCoordX ;Set the sample number to end with
      offsetSampleEnd = 0 ; set the default offset to zero
      if endSample GT (raster_samples - 1) then begin ;If the sample to end with is found off the image
        offsetSampleEnd =  endSample - raster_samples
        endSample = (raster_samples - 1) ; Set the last sample to the image
      endif

      ;; Setting the number of samples to pull data out
      startLine = upperCoordY ;Set the line number to start with
      offsetLineStart = 0 ; Set the default offset to zero
      if startLine LT 0 then begin ;If the coordinate is found off the image (a negative value)
        offsetLineStart = abs(upperCoordY) - 1 ; Set the offset for that difference
        startLine = 0 ;Set the first line to the input image
      endif
      endLine = (base_lines - 1) + upperCoordY ;Set the line number to end with
      if endLine GT (raster_lines -1) then begin ;If this line is found off the image
        endLine = (raster_lines - 1) ;set it to the last sample found in the image
      endif
      ;;; DONE FINDING RESIZE COORDINATES ;;;

      ;;; GET DATA & ASSIGN TO RESIZED IMAGE ;;;
      outImage = 0 ;This is for memory purposes
      outImage = MAKE_ARRAY([(base_samples+20), raster_bands, (base_lines+20)], TYPE = raster_data_type, VALUE = 0) ;Create empty array for output image
      zerosFront = MAKE_ARRAY(10 + offsetSampleStart,raster_bands, VALUE = 0) ;Place holders for beginning of line
      zerosEnd = MAKE_ARRAY(10 + offsetSampleEnd, raster_bands, VALUE = 0) ;Place holders for end of line
      countLine = 9 + offsetLineStart;Counter for array assignment in loop (skips first 10 lines for header)

      FOR i = startLine, endLine DO BEGIN ;Loop through lines of image
        newImageData = ENVI_GET_SLICE(/BIL, FID = fidRaster, LINE = i, POS = INDGEN(raster_bands), XS = startSample, XE = endSample) ;Get Data from new image (returns in BIL format)
        ;              LINE = keyword to specify the line number to extract the slice from. LINE is a zero-based number.
        ;              POS = keyword to specify an array of band positions
        ;              XE = keyword to specify the x ending value. XE is a zero-based number.
        ;              XS = keyword to specify the x starting value. XS is a zero-based number.
        ;              /BIL = keyword that make data returned in BIL format - dimensions of a BIL slice are always [num_samples, num_bands]
        outLine = [zerosFront, newImageData, zerosEnd];Assign Data to new array
        outImage[0,0,countLine] = outLine ;Assign Array
        countLine = countLine + 1 ;Advance counter used in array assignment

      ENDFOR
      ;;; DONE GETTING DATA & ASSIGNING TO RESIZED IMAGE ;;;

      ;;; WRITE DATA TO ENVI FILE ;;;
      fileOutput = out_File ;Set file name for new image
      fileOutputTemp = out_File + 'Temp' ;Set file name for new BSQ image
      ENVI_WRITE_ENVI_FILE, outImage, $ ; Data to write to file
        OUT_NAME = fileOutputTemp, $ ;Output file name
        NB = raster_bands, $; Number of Bands
        NL = base_lines + 20, $ ;Number of lines
        NS = base_samples + 20, $ ;Number of Samples
        INTERLEAVE = 1 , $ ;Set this keyword to one of the following integer values to specify the interleave output: 0: BSQ 1: BIL 2: BIP
        R_FID = fidTemp, $ ;Set keyword for new file's FID
        OFFSET = 0 ; Use this keyword to specify the offset (in bytes) to the start of the data in the file.
      ;;; DONE WRITING DATA TO ENVI FILE ;;;

      ;;; CONVERT TO BSQ ;;;
      ENVI_FILE_QUERY,fidTemp, DIMS = new_dims, NS = new_samples, NL = new_lines, NB = new_bands
      ENVI_DOIT, 'CONVERT_DOIT', $
        DIMS = new_dims, $ ;five-element array of long integers that defines the spatial subset
        FID = fidTemp, $ ;Set for new file's fid
        OUT_NAME = fileOutput, $ ; Set new files output name
        R_FID = fidFinal, $ ;Set BSQ file fid
        O_INTERLEAVE = 0, $ ;keyword that specifies the interleave output: 0: BSQ, 1: BIL, 2: BIP
        POS =  INDGEN(raster_bands) ;specify an array of band positions
      ;;; DONE CONVERTING TO BSQ ;;;

      ;;; CREATING ENVI HEADER FILE ;;;
      map_info_base.mc[0] = 10 ;Update x pixel start
      map_info_base.mc[1] = 10 ;Update y pixel start
      ENVI_SETUP_HEAD, $
        fname = fileOutput + '.hdr', $ ;Header file name
        NS = new_samples,$ ;Number of samples
        NL = new_lines, $ ;Number of lines
        data_type = raster_data_type,$ ; Data type of file
        interleave =  0, $ ;specify the interleave output: 0: BSQ,1: BIL,2: BIP
        NB = new_bands,$ ;Number of Bands
        wl = raster_wl,$ ;Wavelength list
        bbl = raster_bbl, $ ;Bad Band List
        map_info = map_info_base, $ ;Map Info - set to the base image since raster has been resized.
        bnames = raster_band_names, $ ;Bands Names
        /write
      ;;; DONE CREATING ENVI HEADER FILE ;;;

      ;;; CLOSING ;;;
      print, 'Completed Resize Plus Borders Processing ' 
      envi_file_mng, ID = fidRaster, /remove ;Close current Raster image
      envi_file_mng, ID = fidTemp, /remove ;Close current Raster image
      envi_file_mng, ID = fidFinal, /remove ;Close current Raster image
      FILE_DELETE, fileOutputTemp ;Delete the temporary BIL formatted image
      FILE_DELETE, fileOutputTemp + '.hdr' ;Delete the temporary BIL formatted image
      ;;; DONE CLOSING ;;;

END ; End of File