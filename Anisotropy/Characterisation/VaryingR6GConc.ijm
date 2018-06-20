//Anisotropy Characterization
//Read further if you are doing Varying Rhodamine 6G concentration experiment for
//Characterization of Anisotropy on an imaging system

waitForUser("Starting Varying Rhodamine 6G concentration Analysis");
close("*");
conclist="10 20 50 100 200 500 1000 2000 5000 10000";
conc=split(conclist, " ");
isstack=getBoolean("Do you have a stack of images?");//returns 0 if the user says "NO"
      if(isstack == 0){
concFolderdir = getDirectory("Choose Image Directory ");
     for (i=0; i<conc.length; i++) {
     	
      folder=conc[i]+"uM";

      	dir=concFolderdir+folder+"_1\\Pos0\\";//File.directory;
		print(dir);
		if(File.exists(dir)==1){
		open(dir);
		setSlice(1);
		setMetadata("Label", folder+"_PA");
		setSlice(2);
		setMetadata("Label", folder+"_PE");
		run("Stack to Images");
		
		}/*else{
     if(getBoolean(visco[i]+"uM folder does not exist \n Do you want to continue")==0){
     	exit("Analysis stopped");} */
     	}
     
     run("Images to Stack", "name=PE-Stack title=PE use");
	selectWindow("PE-Stack");
	//saveAs("Tiff", FolderListdir+"/PE-Stack.tif");
	
	run("Images to Stack", "name=PA-Stack title=PA use");
	selectWindow("PA-Stack");
     //saveAs("Tiff", FolderListdir+"/PA-Stack.tif");
      }
      
    gfacFolderdir 	= getDirectory("Choose G-Factor Image Directory ");
     	open(gfacFolderdir+"\\Pos0\\");
     	setSlice(1);
		setMetadata("Label", "GF_PA");
		setSlice(2);
		setMetadata("Label", "GF_PE");
		run("Stack to Images");
    gfacbgFolderdir = getDirectory("Choose G-Factor Background Image Directory ");
     	open(gfacbgFolderdir+"\\Pos0\\");
     	setSlice(1);
		setMetadata("Label", "GF-BG_PA");
		setSlice(2);
		setMetadata("Label", "GF-BG_PE");
		run("Stack to Images");
     
imageCalculator("Subtract create 32-bit", "GF_PA","GF-BG_PA");
imageCalculator("Subtract create 32-bit", "GF_PE","GF-BG_PE");
imageCalculator("Divide create 32-bit", "Result of GF_PA","Result of GF_PE");
selectWindow("Result of Result of GF_PA");
rename("Gfactor");

/*selectWindow("Result of GF_PE");
close();
selectWindow("Result of GF_PA");
close();*/

//Open Background Image
	bgFolderdir = getDirectory("Choose Background Image Directory ");
     	open(bgFolderdir+"\\Pos0\\");
     	setSlice(1);
		setMetadata("Label", "BG_PA");
		setSlice(2);
		setMetadata("Label", "BG_PE");
		run("Stack to Images");
imageCalculator("Subtract create 32-bit stack", "PA-Stack","BG_PA");
imageCalculator("Subtract create 32-bit stack", "PE-Stack","BG_PE");
////////////////////////////

//////PE*Gfac
imageCalculator("Multiply create 32-bit stack", "Result of PE-Stack","Gfactor");
////////////////////////////

//Close some image windows
/*selectWindow("PE-Stack");
close();
selectWindow("PA-Stack");
close();
selectWindow("Gfactor");
close();*/
////////////////////////

//2*PE
selectWindow("Result of Result of PE-Stack");
run("Duplicate...", "title=Double_PE duplicate");
run("Multiply...", "value=2 stack");
////////////////////////////////////

//Numerator
imageCalculator("Subtract create 32-bit stack", "Result of PA-Stack","Result of Result of PE-Stack");
selectWindow("Result of Result of PA-Stack");
rename("top");

imageCalculator("Add create 32-bit stack", "Result of PA-Stack","Double_PE");
selectWindow("Result of Result of PA-Stack");
rename("total");

imageCalculator("Divide create 32-bit stack", "top","total");
run("Multiply...", "value=1000 stack");
rename("anisotropy");

selectWindow("total");


//Close some image windows
selectWindow("Result of Result of PE-Stack");close();
selectWindow("Result of PE-Stack");close();
selectWindow("BG_PE");close();
selectWindow("BG_PA");close();
selectWindow("GF-BG_PE");close();
selectWindow("GF-BG_PA");close();
selectWindow("GF_PE");close();
selectWindow("GF_PA");close();
////////////////////////////////////


selectWindow("anisotropy");
run("physics");
makeRectangle(153, 161, 183, 176);
run("Plot Z-axis Profile");
rename("Varying Rhodamine Concentration");
run("Duplicate...", "title=Ani-Vis duplicate");
selectWindow("Ani-Vis");
setMinAndMax(100, 350);
call("ij.ImagePlus.setDefault16bitRange", 16);
run("Gaussian Blur...", "sigma=1 stack");




