
Anisotropy Analysis

1. Analyse cells for Anisotropy_20180620.ijm

This macro helps you analyse images of cells when doing Anisotropy Experiments!
Do have correct background and Gfactor images.
The macro lets you create a stack if you have a folder of cell images.
It also let's you load a stack of cell images, provided PA and PE channels are separate.
If you have a stack, the stacks has to be named PA-Stack and PE-Stack respectively. These stacks will be
background and Gfactor corrected for with the macro. Each of the stacks will be time-registered
(frame alligned, StackReg translation only) and next the PA and PE stacks will 
be alligned with respect to each other (MultiStackReg, Affine translation/Load a specific transform).
Finally the total intensity and anisotropy will be calculated.

2. ROImaker.ijm

This macro helps you draw ROIs, save them, pull the intensity values from the total intenisty image stack and later, apply the same ROI set to the corresponding anisotropy map image pull out the intenisty value.



Code Credits: Amit Cherian (NCBS-2018), Thomas Van Zanten (NCBS 2018),
Prof. Satyajit Mayor Lab
National Centre for Biological Sciences,
GKVK Post, Bellary Road
Bangalore 560065
 
