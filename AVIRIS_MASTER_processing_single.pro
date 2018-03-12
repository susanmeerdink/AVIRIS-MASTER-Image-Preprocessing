PRO AVIRIS_MASTER_processing_single
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
  aviris_img = 'R:\AVIRIS_Imagery\Santa_Barbara\Santa Barbara 20150416\6 - Spectral Correction Files\FL02_f150416t01p00r08_corr_018m_nnvf_v1d_mask_ResizePlusBorder_fr_2_REGlinear_Regis_Cor'
  master_img = 'R:\MASTER_Imagery\Santa Barbara\FL02\5 - Registered Files\FL02_MASTERL2_1593200_06_20150416_1855_1914_V01-emissivity&temp_ResizePlusBorder_Reg'
  output_img = 'R:\AVIRIS+MASTER_Imagery\FL02\FL02_150416_AVIRIS_MASTER'

  ;;; SETTING UP ENVI/IDL ENVIRONMENT ;;;
  COMPILE_OPT IDL2
  e = ENVI(/HEADLESS)  ; Use the new ENVI/IDL code without GUI

  ;--------------------------------------------------------------------------
  ;;; RESAMPLE ;;;
  ; This section will resample AVIRIS image to 36 meters spatial resoultion to match MASTER spatial resolution
  outputResample = aviris_img + '_36'
  spatial_dim = 36
  if file_test(outputResample) EQ 0 then begin
    PRINT, AVIRIS_resize(e, aviris_img, spatial_dim, outputResample)
  endif

  ;--------------------------------------------------------------------------
  ;;; LAYER ;;;
  ; This section will layer AVIRIS image on top of the MASTER image
  outputLayer = output_img + '_layer'
  if file_test(outputLayer) EQ 0 then begin
    PRINT, AVIRIS_MASTER_layer_stack(e, outputResample, master_img, outputLayer)
  endif

  ;--------------------------------------------------------------------------
  ;;; MASK ;;;
  ; This section will mask out the image that does not fall in the AVIRIS flightline footprint
  outputMask = output_img + '_mask'
  outputImg = output_img + '_cor'
  if file_test(outputImg) EQ 0 then begin
    PRINT, AVIRIS_MASTER_mask(e, outputLayer, outputMask, outputImg)
  endif
  
END