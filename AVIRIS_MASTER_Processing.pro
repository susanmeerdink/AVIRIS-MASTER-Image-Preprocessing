PRO AVIRIS_MASTER_Processing
; This code 
; Susan Meerdink
; 2/20/2018
;--------------------------------------------------------------------------
;;; INPUTS ;;;
;

;;; SETTING UP ENVI/IDL ENVIRONMENT ;;;
COMPILE_OPT IDL2
e = ENVI(/HEADLESS)  ; Use the new ENVI/IDL code without GUI

;--------------------------------------------------------------------------
;;; RESAMPLE ;;;
; This section will resample AVIRIS image to 36 meters spatial resoultion to match MASTER spatial resolution



;--------------------------------------------------------------------------
;;; LAYER ;;;
; This section will layer AVIRIS image on top of the MASTER image


;--------------------------------------------------------------------------
;;; MASK ;;;
; This section will mask out the image that does not fall in the AVIRIS flightline footprint