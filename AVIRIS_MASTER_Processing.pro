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
;input = 'D:\Imagery\AVIRIS\FL11\6 - Spectral Correction Files\FL011_f140416t01p00r15_refl_hpc18_v1_ResizePlusBorder_Regis_Cor'
;output = 'D:\Imagery\AVIRIS+MASTER\FL11\1 - Resized Imagery\FL011_f140416t01p00r15_refl_hpc18_v1_ResizePlusBorder_Regis_Cor_36'
;spatial_dim = 36
;PRINT, AVIRIS_resize(e, input, spatial_dim, output)

;--------------------------------------------------------------------------
;;; LAYER ;;;
; This section will layer AVIRIS image on top of the MASTER image
inputA = 'D:\Imagery\AVIRIS+MASTER\FL11\1 - Resized Imagery\FL011_f140416t01p00r15_refl_hpc18_v1_ResizePlusBorder_Regis_Cor_36'
inputM = 'D:\Imagery\MASTER\FL11\5 - Registered Files\FL011_MASTERL2_1463300_11_20140416_2130_2146_V02-emissivity&temp_cropped_ResizePlusBorder_Reg'
output = 'D:\Imagery\AVIRIS+MASTER\FL11\2 - Layered Imagery\FL011_f140416_AVIRIS_MASTER'
PRINT, AVIRIS_MASTER_layer_stack(e, inputA, inputM, output)


;--------------------------------------------------------------------------
;;; MASK ;;;
; This section will mask out the image that does not fall in the AVIRIS flightline footprint
; 

END