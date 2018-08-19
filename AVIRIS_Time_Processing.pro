PRO AVIRIS_Time_Processing
  ; This code processes UTC time data from AVIRIS image to MASTER spatial resolution and area.
  ; Susan Meerdink
  ; 8/17/2018
  ;--------------------------------------------------------------------------

  ;;; INPUTS ;;;
  aviris_path = 'D:\Imagery\AVIRIS\'
  output_path = 'D:\Imagery\AVIRIS+MASTER\'
  ;fl_list = ['FL02', 'FL03', 'FL04', 'FL05', 'FL06', 'FL07', 'FL08', 'FL09', 'FL10', 'FL11']
  ;date_list = ['130411', '130606', '131125', '140416', '140606', '140829', '150416', '150602', '150824']
  fl_list = ['FL03']
  date_list =  ['130411']

  ;;; SETTING UP ENVI/IDL ENVIRONMENT ;;;
  COMPILE_OPT IDL2
  e = ENVI(/HEADLESS)  ; Use the new ENVI/IDL code without GUI

  ; Loop through flightlines
  foreach fl, fl_list do begin

    ; Loop through dates
    foreach date, date_list do begin
      print, 'Processing ' + fl + ' ' + date

      ; Find Original Image Files, REQUIRES that the default sort is ON - important if ENVI files do not end in .dat and that code doesn't process .hdr files
      aviris_list = file_search(output_path + fl + '\2 - Time Files\*' + date + '*obs*', /WINDOWS_SHORT_NAMES) ;Get list of aviris files for this flightline & date

      ; Only process flightline and date if there is an image for BOTH AVIRIS and MASTER
      if size(aviris_list, /N_ELEMENTS) GT 1 then begin
        ;--------------------------------------------------------------------------
        ;;; RESIZE PLUS BORDERS ;;;
        ; This section will resample AVIRIS Time image to AVIRIS spatial area
        base_file = file_search(aviris_path + fl + '\2 - Resize Plus Border Files\*140416*') ;Get list of aviris files for this flightline & date
        outputResize = output_path + fl + '\2 - Time Files\' + fl + '_' + date + '_UTC_resize'
        PRINT, aviris_time_resize_plus_borders(base_file[0], aviris_list[0], outputResize)
        
        ;--------------------------------------------------------------------------
        ;;; RESAMPLE ;;;
        ; This section will resample AVIRIS image to 36 meters spatial resoultion to match MASTER spatial resolution
        outputResample = output_path + fl + '\2 - Time Files\' + fl + '_' + date + '_UTC_36'
        spatial_dim = 36
        PRINT, AVIRIS_resize(e, outputResize, spatial_dim, outputResample)

        print, 'Completed ' + fl + ' ' + date
      endif

    endforeach

  endforeach

END