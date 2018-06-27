 makeRectangle(10,10,20,20);
waitForUser("Place the ROI where there is background in the image");
if (selectionType==-1)
    exit("A background-defining ROI is\nrequired but none was found.");

factor = getArgument();
if (factor=="")
    factor = getNumber("Multiplier (Mean + ??*SDeviation):", 3);
getStatistics(area, mean, min, max, std);
setThreshold(mean+factor*std, pow(2, bitDepth));
//setAutoThreshold("Default dark");
//run("Threshold...");
if(getBoolean("Are you happy with the threshold?")==0){
	run("Threshold...");
	waitForUser("1. Set the Threshold \n2. Press Apply \n3. Deselet Nan Background Checkbox \n Press OK");
	}else {run("8-bit");run("Convert to Mask");}
run("Erode");
run("Dilate");
run("Divide...", "value=255.000");
imageCalculator("Multiply create 32-bit", "cell-1","ani-vis");
selectWindow("Result of cell-1");
run("physics");
setMinAndMax(100, 350);
