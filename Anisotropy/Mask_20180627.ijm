/*
When you present your images in PPT, it is recommended that you highlight the cells,
and avoid showing the anisotropy values of the areas where there are no cells.
To do this, one needs to make use of the total intensity image stack,
threshold the image such that the cells are highlighted,
create a mask of this selection, transfer and apply this mask on the anisotropy map.
This Macro let's you carrry out the above explained process in an intuitive manner
*/

//perform auto threshold based on the ROI placed on the background area in the image
makeRectangle(10,10,20,20);//make a rectangle template recently active image on the image
waitForUser("Place the ROI where there is background in the image");
if (selectionType==-1)
    exit("A background-defining ROI is\nrequired but none was found.");

factor = getArgument();
if (factor=="")
    factor = getNumber("Multiplier (Mean + ??*SDeviation):", 3);
getStatistics(area, mean, min, max, std);
setThreshold(mean+factor*std, pow(2, bitDepth));

if(getBoolean("Are you happy with the threshold?")==0){
	run("Threshold...");
	waitForUser("1. Set the Threshold \n2. Press Apply \n3. Deselet Nan Background Checkbox \n Press OK");
	}
else 	{
	run("8-bit");run("Convert to Mask");
	}
run("Erode");
run("Dilate");
run("Divide...", "value=255.000");//this makes the image into a binary image.
imageCalculator("Multiply create 32-bit", "cell-1","ani-vis");//this makes the background to zero
selectWindow("Result of cell-1");
run("physics");
setMinAndMax(100, 350);
