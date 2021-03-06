/*
Use this macro to put a color bar beside the  anisotropy map
*/

selectWindow("Cell_1_PA.tif");
run("RGB Color");
newImage("Cell_1_PA.tif-LUT", "RGB black", 800, 800, 1);
selectWindow("Cell_1_PA.tif");
run("Select All");
run("Copy");
selectWindow("Cell_1_PA.tif-LUT");
makeRectangle(0, 0, 512, 512);
run("Paste");
selectWindow("Area Ramp.tif");
makeRectangle(0, 0, 61, 292);
run("Copy");
selectWindow("Cell_1_PA.tif-LUT");
makeRectangle(512, 0, 61, 292);
run("Paste");
roiManager("Show All");
roiManager("Show None");
