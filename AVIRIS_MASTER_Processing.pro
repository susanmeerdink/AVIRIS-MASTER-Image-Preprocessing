PRO AVIRIS_MASTER_Processing
; This code reads in AVIRIS and MASTER imagery to create a layered product.
; REQUIRES ENVI 5.3 with Service Pack 2 and higher!
; Imagery goes through three steps:
; 1) Resizes aviris imagery to 36 meter spatial resolution to match master imagery
; 2) Layers the aviris and master imagery on top of each other
; 3) Masks the master imagery so only imagery that falls on top of AVIRIS imagery is included.
; Susan Meerdink
; 2/20/2018
;--------------------------------------------------------------------------

;;; INPUTS ;;;
aviris_path = 'I:\AVIRIS\'
aviris_folder = '\6 - Spectral Correction Files\'
master_path = 'I:\MASTER\'
master_folder = '\5 - Registered Files\'
output_path = 'I:\AVIRIS+MASTER\'
;fl_list = ['FL02', 'FL03', 'FL04', 'FL05', 'FL06', 'FL07', 'FL08', 'FL09', 'FL10', 'FL11']
;date_list = ['130411', '130606', '131125', '140416', '140606', '140829', '150416', '150602', '150824']
fl_list = ['FL02', 'FL05', 'FL09']
date_list =  ['150416']

;;; SETTING UP ENVI/IDL ENVIRONMENT ;;;
COMPILE_OPT IDL2
e = ENVI(/HEADLESS)  ; Use the new ENVI/IDL code without GUI

; Loop through flightlines
foreach fl, fl_list do begin
  
  ; Loop through dates
  foreach date, date_list do begin
    print, 'Processing ' + fl + ' ' + date
    
    ; Find Original Image Files, REQUIRES that the default sort is ON - important if ENVI files do not end in .dat and that code doesn't process .hdr files
    aviris_list = file_search(aviris_path + fl + aviris_folder + '*' + date + '*', /WINDOWS_SHORT_NAMES) ;Get list of aviris files for this flightline & date
    master_list = file_search(master_path + fl + master_folder + '*' + date + '*', /WINDOWS_SHORT_NAMES) ;Get list of master files for this flightline & date
    
    ; Only process flightline and date if there is an image for BOTH AVIRIS and MASTER
    if size(aviris_list, /N_ELEMENTS) GT 1 AND size(master_list, /N_ELEMENTS) GT 1 then begin
      
      ;--------------------------------------------------------------------------
      ;;; RESAMPLE ;;;
      ; This section will resample AVIRIS image to 36 meters spatial resoultion to match MASTER spatial resolution
      input = aviris_list[0]
      outputResample = output_path + fl + '\1 - Resized Imagery\' + file_basename(aviris_list[0]) + '_36'
      spatial_dim = 36
      if file_test(outputResample) EQ 0 then begin
        PRINT, AVIRIS_resize(e, input, spatial_dim, outputResample)
      endif
  
      ;--------------------------------------------------------------------------
      ;;; LAYER ;;;
      ; This section will layer AVIRIS image on top of the MASTER image
      inputM = master_list[0]
      outputLayer = output_path + fl + '\2 - Layered Imagery\' + fl + '_' + date + '_AVIRIS_MASTER'
      if file_test(outputLayer) EQ 0 then begin
        PRINT, AVIRIS_MASTER_layer_stack(e, outputResample, inputM, outputLayer)
      endif
  
      ;--------------------------------------------------------------------------
      ;;; MASK ;;;
      ; This section will mask out the image that does not fall in the AVIRIS flightline footprint
      outputMask = output_path + fl + '\3 - Mask File\' + file_basename(outputLayer) + '_mask'
      outputImg = output_path + fl + '\4 - Corrected Imagery\' + file_basename(outputLayer) + '_Cor'
      if file_test(outputImg) EQ 0 then begin
        PRINT, AVIRIS_MASTER_mask(e, outputLayer, outputMask, outputImg)
      endif      
      
      print, 'Completed ' + fl + ' ' + date
    endif
    
  endforeach
  
endforeach


END