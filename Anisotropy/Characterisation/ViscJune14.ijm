//Varying Glycerol Concentration

close("*");
waitForUser("Starting Varying Glycerol Concentration Analysis");
viscolist="10 20 30 40 50 60 70 80 90 100";
visco=split(viscolist, " ");
isstack=getBoolean("Do you have a stack of images?");//returns 0 if the user says "NO"
      if(isstack == 0){
viscoFolderdir = getDirectory("Choose Glycerol Concentration Image Directory ");
bgviscoFolderdir = getDirectory("Choose Glycerol Concentration Background Image Directory ");
for (i=0; i<visco.length; i++) {
    viscofolder=visco[i]+"Gly_1";
    viscodir=viscoFolderdir+viscofolder+"\\Pos0\\";//File.directory;
		print(viscodir);
		if(File.exists(viscodir)==1){
		open(viscodir);
		setSlice(1);
		setMetadata("Label", viscofolder+"_PA");
		setSlice(2);
		setMetadata("Label", viscofolder+"_PE");
		run("Stack to Images");}
		else{
     if(getBoolean(visco[i]+"uM folder does not exist \n Do you want to continue")==0){
     	exit("Analysis stopped");} 
     	}
	bgviscoFolder=visco[i]+"Gly_1";
	bgviscodir=bgviscoFolderdir+bgviscoFolder+"\\Pos0\\";
		print(bgviscodir);
		if(File.exists(bgviscodir)==1){
		open(bgviscodir);
		setSlice(1);
		setMetadata("Label", bgviscoFolder+"_BG_PA");
		setSlice(2);
		setMetadata("Label", bgviscoFolder+"_BG_PE");
		run("Stack to Images");
		}
		else{
     if(getBoolean(visco[i]+"uM folder does not exist \n Do you want to continue")==0){
     	exit("Analysis stopped");} 
     	}
	imageCalculator("Subtract create 32-bit", viscofolder+"_PA", bgviscoFolder+"_BG_PA");
	selectWindow("Result of "+viscofolder+"_PA");
	rename(visco[i]+"_PA");
	selectWindow(viscofolder+"_PA");	close();
	selectWindow(bgviscoFolder+"_BG_PA");	close();
	imageCalculator("Subtract create 32-bit", viscofolder+"_PE", bgviscoFolder+"_BG_PE");
	selectWindow("Result of "+viscofolder+"_PE");
	rename(visco[i]+"_PE");
	selectWindow(viscofolder+"_PE");	close();
	selectWindow(bgviscoFolder+"_BG_PE");	close();
	}
		
     }
    
     run("Images to Stack", "name=PA-Stack title=PA use");
	selectWindow("PA-Stack");
	
     run("Images to Stack", "name=PE-Stack title=PE use");
	selectWindow("PE-Stack");
	//saveAs("Tiff", FolderListdir+"/PE-Stack.tif");
	
	
     //saveAs("Tiff", FolderListdir+"/PA-Stack.tif");

//Find G-Factor      
gfacFolderdir 	= getDirectory("Choose G-Factor Image Directory ");
     	open(gfacFolderdir+"\\Pos0\\");
     	setSlice(1);
		setMetadata("Label", "GF_PA");
		setSlice(2);
		setMetadata("Label", "GF_PE");
		run("Stack to Images");
    bggfacFolderdir = getDirectory("Choose G-Factor Background Image Directory ");
     	open(bggfacFolderdir+"\\Pos0\\");
     	setSlice(1);
		setMetadata("Label", "GF-BG_PA");
		setSlice(2);
		setMetadata("Label", "GF-BG_PE");
		run("Stack to Images");
     
imageCalculator("Subtract create 32-bit", "GF_PA","GF-BG_PA");
selectWindow("Result of GF_PA");
imageCalculator("Subtract create 32-bit", "GF_PE","GF-BG_PE");
selectWindow("Result of GF_PE");
imageCalculator("Divide create 32-bit", "Result of GF_PA","Result of GF_PE");
selectWindow("Result of Result of GF_PA");
rename("Gfactor");
/////////////////
selectWindow("Result of GF_PE");close();
selectWindow("Result of GF_PA");close();

//PE*Gfac
imageCalculator("Multiply create 32-bit stack", "PE-Stack","Gfactor");
////////////////////////////

//Close some image windows
selectWindow("PE-Stack");close();
selectWindow("Gfactor");close();
////////////////////////

//2*PE
selectWindow("Result of PE-Stack");
run("Duplicate...", "title=Double_PE duplicate");
run("Multiply...", "value=2 stack");
////////////////////////////////////

//Numerator: PA-PE
imageCalculator("Subtract create 32-bit stack", "PA-Stack","Result of PE-Stack");
selectWindow("Result of PA-Stack");
rename("top");
//////////////////////////////////////

//Denominator: PA+2*PE
imageCalculator("Add create 32-bit stack", "PA-Stack","Double_PE");
selectWindow("Result of PA-Stack");
rename("total");
//////////////////////////////////


imageCalculator("Divide create 32-bit stack", "top","total");
run("Multiply...", "value=1000 stack");
rename("anisotropy");
//run("Save", "save=/Users/thomas/Desktop/Pos4corr_An.tif");
selectWindow("total");
//run("Save", "save=/Users/thomas/Desktop/Pos4corr_Tot.tif");

//Close some image windows
/*selectWindow("Result of PA.tif");
close();
selectWindow("Double_PE");
close();
selectWindow("top");
close();
selectWindow("Result of Result of PE.tif");
close();
////////////////////////////////////
*/

selectWindow("anisotropy");
run("physics");
selectWindow("anisotropy");
//setMinAndMax(100, 350);
call("ij.ImagePlus.setDefault16bitRange", 16);
run("Gaussian Blur...", "sigma=1 stack");


     