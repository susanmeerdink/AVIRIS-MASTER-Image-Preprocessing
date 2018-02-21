PRO 0_AVIRIS_MASTER_Processing
; This code stacks the AVIRIS (224 bands) with MASTER (emissivity and surface temperature band) files.
; It does not use the ENVI layer function because that function projects the new image and rotates it
; Susan Meerdink
; 2/20/2018
;--------------------------------------------------------------------------
;;; INPUTS ;;;
;

;;; SETTING UP ENVI/IDL ENVIRONMENT ;;;
COMPILE_OPT STRICTARR
envi, /restore_base_save_files
ENVI_BATCH_INIT ;Doesn't require having ENVI open - use with stand alone IDL 64 bit

;--------------------------------------------------------------------------
;;; RESAMPLE ;;;
; This section will resample AVIRIS image to 36 meters spatial resoultion to match MASTER spatial resolution



;--------------------------------------------------------------------------
;;; LAYER ;;;
; This section will layer AVIRIS image on top of the MASTER image


;--------------------------------------------------------------------------
;;; MASK ;;;
; This section will mask out the image that does not fall in the AVIRIS flightline footprint