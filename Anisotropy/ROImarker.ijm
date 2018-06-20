//Draw ROIs
waitForUser("Next Step is to mark ROIs and pull intenisty values");
waitForUser("The same ROIs are then placed on the anisotropy image to pull r values");
if(getBoolean("Do you want to continue?")==1){
	selectWindow("Result of GF_PA");close();
	selectWindow("Result of GF_PE");close();
	selectWindow("Result of PA-Stack");close();
	selectWindow("Result of PE-Stack");close();
	selectWindow("Result of Result of PE-Stack");close();
	selectWindow("Double_PE");close();
	selectWindow("top");close();
	selectWindow("Gfactor");close();

	run("Set Measurements...", "mean redirect=None decimal=3");
	roihw=getNumber("ROI size",15);
	ROIdir = getDirectory("Choose a Directory to save ROI List");
	run("ROI Manager...");
	roisave=getBoolean("Do you want to save the ROI sets for each slice?");
	for (i=0; i<nSlices; i++) {
     	roiManager("Reset");
     	run("Clear Results");
     	selectWindow("total.tif");
     	setSlice(i+1);
     	run("Set... ", "zoom=150 x=256 y=256");
     	roiManager("Show All");
     	selectWindow("total.tif");
     	roiManager("Show None");
     	roiManager("Show All with labels");
     	makeRectangle(10, 10, roihw, roihw);
     	if(getBoolean("Skip Image?")==0){
     	waitForUser("Draw ROI for slice "+i+1+" and Press OK");
		if(roisave==1){
		roiManager("Save", ROIdir+"Slice"+i+1+"RoiSet.zip");}
		//roiManager("Show All");
		//selectWindow("total.tif");
		//roiManager("Show None");
		//roiManager("Show All");
		
  		for (roii=0; roii<roiManager("count"); roii++){ 
 			roiManager("select", roii);
  			roiManager("Measure");}
  			//selectWindow("Results");
		//run("Measure");
		selectWindow("Results");
		String.copyResults();
		waitForUser("Copy values from Result Window and Press OK");
		run("Clear Results");
		selectWindow("anisotropy.tif");
		setSlice(i+1);
		roiManager("Show None");
		roiManager("Show All");
		for (roii=0; roii<roiManager("count"); roii++){ 
 			roiManager("select", roii);
  			roiManager("Measure");}
			selectWindow("Results");
			String.copyResults();
			waitForUser("Copy values from Result Window and Press OK");
			waitForUser("Hope you have Completed copying!");
		//selectWindow("anisotropy.tif");
			roiManager("Show None");
		//run("Next Slice [>]");
		//selectWindow("total.tif");
   		//run("Next Slice [>]");}
	}	}	