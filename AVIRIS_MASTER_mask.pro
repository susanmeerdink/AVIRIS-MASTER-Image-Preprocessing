FUNCTION AVIRIS_MASTER_mask, e, input, outputMask, outputImage
; This code reads in image that has both AVIRIS and MASTER imagery layered and will mask out areas
; where the MASTER imagery does not overlap with AVIRIS imagery.
; This code also update the metadata specifically band names, wavelengths, and bbl.
; Based on 224 bands of AVIRIS, 5 MASTER Emissivity Bands, 1 Temperature Band, and 1 UTC Bands
; Susan Meerdink
; 2/21/2018
; INPUTS:
; 1) e: an object reference to the envi application. 
; 2) input: a string designating the location of the file to be masked
; 3) outputMask: a string designating the output locations of the mask file
; 4) outputImage: a string designating the output locations of the masked final image
; OUTPUTS:
; 1) Saves a masked image to the specified output location
;-------------------------------------------------------------------------------------
 
  ; Open image                
  rasterIn = e.OpenRaster(input); Open an input file
  
  ; Generate a mask, Get all locations where Bands 1-224 are equal 0
  sum = TOTAL(rasterIn.GetData(BANDS=[0:25]), 3) 
  mask = sum GT 0      
  
  ; Save the mask to a file
  ; this section is having compiling issues IF you don't compile and run AVIRIS_MASTER_Processing first
  maskRaster = ENVIRaster(mask, URI=outputMask) ; 
  maskRaster.Save
        
  ; Create a masked raster: https://www.harrisgeospatial.com/docs/envimaskraster.html
  rasterOut = ENVIMaskRaster(rasterIn, maskRaster)
  
  ; Update Metadata
  metadata = rasterOut.METADATA
  metadata.UpdateItem, 'band names', $
    ['Band 1 (365.91 nm)', 'Band 2 (375.58 nm)',  'Band 3 (385.25 nm)',  'Band 4 (394.92 nm)',  'Band 5 (404.6 nm)', $
    'Band 6 (414.28 nm)',  'Band 7 (423.96 nm)',  'Band 8 (433.65 nm)',  'Band 9 (443.35 nm)',  'Band 10 (453.05 nm)', $
    'Band 11 (462.75 nm)',  'Band 12 (472.46 nm)',  'Band 13 (482.17 nm)',  'Band 14 (491.89 nm)',  'Band 15 (501.61 nm)', $
    'Band 16 (511.34 nm)',  'Band 17 (521.07 nm)',  'Band 18 (530.8 nm)',  'Band 19 (540.54 nm)',  'Band 20 (550.28 nm)', $
    'Band 21 (560.03 nm)',  'Band 22 (569.78 nm)',  'Band 23 (579.54 nm)',  'Band 24 (589.3 nm)',  'Band 25 (599.07 nm)', $
    'Band 26 (608.84 nm)',  'Band 27 (618.61 nm)',  'Band 28 (628.39 nm)',  'Band 29 (638.17 nm)',  'Band 30 (647.96 nm)', $
    'Band 31 (655.48 nm)',  'Band 32 (657.75 nm)',  'Band 33 (665.28 nm)',  'Band 34 (667.54 nm)',  'Band 35 (675.08 nm)', $
    'Band 36 (684.88 nm)',  'Band 37 (694.67 nm)',  'Band 38 (704.46 nm)',  'Band 39 (714.24 nm)',  'Band 40 (724.02 nm)', $
    'Band 41 (733.79 nm)',  'Band 42 (743.55 nm)',  'Band 43 (753.31 nm)',  'Band 44 (763.07 nm)',  'Band 45 (772.82 nm)', $
    'Band 46 (782.56 nm)',  'Band 47 (792.3 nm)',  'Band 48 (802.04 nm)',  'Band 49 (811.76 nm)',  'Band 50 (821.49 nm)', $
    'Band 51 (831.21 nm)',  'Band 52 (840.92 nm)',  'Band 53 (850.63 nm)',  'Band 54 (860.33 nm)',  'Band 55 (870.03 nm)', $
    'Band 56 (879.72 nm)',  'Band 57 (889.41 nm)',  'Band 58 (899.09 nm)',  'Band 59 (908.77 nm)',  'Band 60 (918.44 nm)', $
    'Band 61 (928.1 nm)',  'Band 62 (937.77 nm)',  'Band 63 (947.42 nm)',  'Band 64 (957.07 nm)',  'Band 65 (966.72 nm)', $
    'Band 66 (976.36 nm)',  'Band 67 (985.99 nm)',  'Band 68 (995.62 nm)',  'Band 69 (1005.25 nm)',  'Band 70 (1014.86 nm)', $
    'Band 71 (1024.48 nm)',  'Band 72 (1034.09 nm)',  'Band 73 (1043.69 nm)',  'Band 74 (1053.29 nm)',  'Band 75 (1062.88 nm)', $
    'Band 76 (1072.47 nm)',  'Band 77 (1082.06 nm)',  'Band 78 (1091.63 nm)',  'Band 79 (1101.21 nm)',  'Band 80 (1110.77 nm)', $
    'Band 81 (1120.34 nm)',  'Band 82 (1129.89 nm)',  'Band 83 (1139.44 nm)',  'Band 84 (1148.99 nm)',  'Band 85 (1158.53 nm)', $
    'Band 86 (1168.07 nm)',  'Band 87 (1177.6 nm)',  'Band 88 (1187.13 nm)',  'Band 89 (1196.65 nm)',  'Band 90 (1206.16 nm)', $
    'Band 91 (1215.67 nm)',  'Band 92 (1225.18 nm)',  'Band 93 (1234.68 nm)',  'Band 94 (1244.17 nm)',  'Band 95 (1253.35 nm)', $
    'Band 96 (1253.66 nm)',  'Band 97 (1263.14 nm)',  'Band 98 (1263.33 nm)',  'Band 99 (1273.3 nm)',  'Band 100 (1283.27 nm)', $
    'Band 101 (1293.24 nm)',  'Band 102 (1303.21 nm)',  'Band 103 (1313.19 nm)',  'Band 104 (1323.16 nm)',  'Band 105 (1333.13 nm)', $
    'Band 106 (1343.1 nm)',  'Band 107 (1353.07 nm)',  'Band 108 (1363.04 nm)',  'Band 109 (1373.01 nm)',  'Band 110 (1382.98 nm)', $
    'Band 111 (1392.95 nm)',  'Band 112 (1402.92 nm)',  'Band 113 (1412.89 nm)',  'Band 114 (1422.86 nm)',  'Band 115 (1432.83 nm)', $
    'Band 116 (1442.79 nm)',  'Band 117 (1452.76 nm)',  'Band 118 (1462.73 nm)',  'Band 119 (1472.7 nm)',  'Band 120 (1482.66 nm)', $
    'Band 121 (1492.63 nm)',  'Band 122 (1502.6 nm)',  'Band 123 (1512.57 nm)',  'Band 124 (1522.53 nm)',  'Band 125 (1532.5 nm)', $
    'Band 126 (1542.46 nm)',  'Band 127 (1552.43 nm)',  'Band 128 (1562.4 nm)',  'Band 129 (1572.36 nm)',  'Band 130 (1582.33 nm)', $
    'Band 131 (1592.29 nm)',  'Band 132 (1602.26 nm)',  'Band 133 (1612.22 nm)',  'Band 134 (1622.18 nm)',  'Band 135 (1632.15 nm)', $
    'Band 136 (1642.11 nm)',  'Band 137 (1652.07 nm)',  'Band 138 (1662.04 nm)',  'Band 139 (1672 nm)',  'Band 140 (1681.96 nm)', $
    'Band 141 (1691.93 nm)',  'Band 142 (1701.89 nm)',  'Band 143 (1711.85 nm)',  'Band 144 (1721.81 nm)',  'Band 145 (1731.77 nm)' , $
    'Band 146 (1741.73 nm)',  'Band 147 (1751.69 nm)',  'Band 148 (1761.66 nm)',  'Band 149 (1771.62 nm)',  'Band 150 (1781.58 nm)', $
    'Band 151 (1791.54 nm)',  'Band 152 (1801.5 nm)',  'Band 153 (1811.45 nm)',  'Band 154 (1821.41 nm)',  'Band 155 (1831.37 nm)', $
    'Band 156 (1841.33 nm)',  'Band 157 (1851.29 nm)',  'Band 158 (1861.25 nm)',  'Band 159 (1866.84 nm)',  'Band 160 (1871.21 nm)', $
    'Band 161 (1872.36 nm)',  'Band 162 (1876.91 nm)',  'Band 163 (1886.96 nm)',  'Band 164 (1897.02 nm)',  'Band 165 (1907.08 nm)', $
    'Band 166 (1917.13 nm)',  'Band 167 (1927.18 nm)',  'Band 168 (1937.23 nm)',  'Band 169 (1947.27 nm)',  'Band 170 (1957.31 nm)', $
    'Band 171 (1967.36 nm)',  'Band 172 (1977.39 nm)',  'Band 173 (1987.43 nm)',  'Band 174 (1997.46 nm)',  'Band 175 (2007.5 nm)', $
    'Band 176 (2017.52 nm)',  'Band 177 (2027.55 nm)',  'Band 178 (2037.58 nm)',  'Band 179 (2047.6 nm)',  'Band 180 (2057.62 nm)', $
    'Band 181 (2067.64 nm)',  'Band 182 (2077.65 nm)',  'Band 183 (2087.66 nm)',  'Band 184 (2097.68 nm)',  'Band 185 (2107.68 nm)', $
    'Band 186 (2117.69 nm)',  'Band 187 (2127.69 nm)',  'Band 188 (2137.7 nm)',  'Band 189 (2147.69 nm)',  'Band 190 (2157.69 nm)', $
    'Band 191 (2167.69 nm)',  'Band 192 (2177.68 nm)',  'Band 193 (2187.67 nm)',  'Band 194 (2197.66 nm)',  'Band 195 (2207.64 nm)',  'Band 196 (2217.63 nm)', $
    'Band 197 (2227.61 nm)',  'Band 198 (2237.58 nm)',  'Band 199 (2247.56 nm)',  'Band 200 (2257.53 nm)',  'Band 201 (2267.51 nm)', $
    'Band 202 (2277.48 nm)',  'Band 203 (2287.44 nm)',  'Band 204 (2297.41 nm)',  'Band 205 (2307.37 nm)',  'Band 206 (2317.33 nm)', $
    'Band 207 (2327.29 nm)',  'Band 208 (2337.24 nm)',  'Band 209 (2347.2 nm)',  'Band 210 (2357.15 nm)',  'Band 211 (2367.09 nm)', $
    'Band 212 (2377.04 nm)',  'Band 213 (2386.99 nm)',  'Band 214 (2396.93 nm)',  'Band 215 (2406.87 nm)',  'Band 216 (2416.8 nm)', $
    'Band 217 (2426.74 nm)',  'Band 218 (2436.67 nm)',  'Band 219 (2446.6 nm)',  'Band 220 (2456.53 nm)',  'Band 221 (2466.45 nm)', $
    'Band 222 (2476.38 nm)',  'Band 223 (2486.3 nm)',  'Band 224 (2496.22 nm)',  'Band 1 (8.6 um)',  'Band 2 (9.03 um)',  'Band 3 (10 .63 um)', $
    'Band 4 (11.32 um)',  'Band 5 (12.14 um)',  'Temp (K)', 'Time (UTC)']
  metadata.AddItem, 'bbl', $
    [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, $
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, $
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, $
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, $
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, $
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, $
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, $
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, $
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0]
  metadata.AddItem, 'wavelength', $
    [365.910004,  375.579987,  385.250000,  394.920013,  404.600006,  414.279999, $
    423.959991,  433.649994,  443.350006,  453.049988,  462.750000,  472.459991, $
    482.170013,  491.890015,  501.609985,  511.339996,  521.070007,  530.799988, $
    540.539978,  550.280029,  560.030029,  569.780029,  579.539978,  589.299988, $
    599.070007,  608.840027,  618.609985,  628.390015,  638.169983,  647.960022, $
    657.750000,  667.539978,  655.479980,  665.280029,  675.080017,  684.880005, $
    694.669983,  704.460022,  714.239990,  724.020020,  733.789978,  743.549988, $
    753.309998,  763.070007,  772.820007,  782.559998,  792.299988,  802.039978, $
    811.760010,  821.489990,  831.210022,  840.919983,  850.630005,  860.330017, $
    870.030029,  879.719971,  889.409973,  899.090027,  908.770020,  918.440002, $
    928.099976,  937.770020,  947.419983,  957.070007,  966.719971,  976.359985, $
    985.989990,  995.619995, 1005.250000, 1014.859985, 1024.479980, 1034.089966, $
    1043.689941, 1053.290039, 1062.880005, 1072.469971, 1082.060059, 1091.630005, $
    1101.209961, 1110.770020, 1120.339966, 1129.890015, 1139.439941, 1148.989990, $
    1158.530029, 1168.069946, 1177.599976, 1187.130005, 1196.650024, 1206.160034, $
    1215.670044, 1225.180054, 1234.680054, 1244.170044, 1253.660034, 1263.140015, $
    1253.349976, 1263.329956, 1273.300049, 1283.270020, 1293.239990, 1303.209961, $
    1313.189941, 1323.160034, 1333.130005, 1343.099976, 1353.069946, 1363.040039, $
    1373.010010, 1382.979980, 1392.949951, 1402.920044, 1412.890015, 1422.859985, $
    1432.829956, 1442.790039, 1452.760010, 1462.729980, 1472.699951, 1482.660034, $
    1492.630005, 1502.599976, 1512.569946, 1522.530029, 1532.500000, 1542.459961, $
    1552.430054, 1562.400024, 1572.359985, 1582.329956, 1592.290039, 1602.260010, $
    1612.219971, 1622.180054, 1632.150024, 1642.109985, 1652.069946, 1662.040039, $
    1672.000000, 1681.959961, 1691.930054, 1701.890015, 1711.849976, 1721.810059, $
    1731.770020, 1741.729980, 1751.689941, 1761.660034, 1771.619995, 1781.579956, $
    1791.540039, 1801.500000, 1811.449951, 1821.410034, 1831.369995, 1841.329956, $
    1851.290039, 1861.250000, 1871.209961, 1872.359985, 1866.839966, 1876.910034, $
    1886.959961, 1897.020020, 1907.079956, 1917.130005, 1927.180054, 1937.229980, $
    1947.270020, 1957.310059, 1967.359985, 1977.390015, 1987.430054, 1997.459961, $
    2007.500000, 2017.520020, 2027.550049, 2037.579956, 2047.599976, 2057.620117, $
    2067.639893, 2077.649902, 2087.659912, 2097.679932, 2107.679932, 2117.689941, $
    2127.689941, 2137.699951, 2147.689941, 2157.689941, 2167.689941, 2177.679932, $
    2187.669922, 2197.659912, 2207.639893, 2217.629883, 2227.610107, 2237.580078, $
    2247.560059, 2257.530029, 2267.510010, 2277.479980, 2287.439941, 2297.409912, $
    2307.370117, 2317.330078, 2327.290039, 2337.239990, 2347.199951, 2357.149902, $
    2367.090088, 2377.040039, 2386.989990, 2396.929932, 2406.870117, 2416.800049, $
    2426.739990, 2436.669922, 2446.600098, 2456.530029, 2466.449951, 2476.379883, $
    2486.300049, 2496.219971, 8.59910, 9.03440, 10.6294, 11.3225, 12.1384, 20, 30]
      
  ; Save the result to ENVI raster format
  rasterOut.Export, outputImage, 'ENVI'
  
  ; Close Files
  rasterOut.Close
  maskRaster.Close
  rasterIn.Close
  
  RETURN, 'Completed Masking'

END ; End of File