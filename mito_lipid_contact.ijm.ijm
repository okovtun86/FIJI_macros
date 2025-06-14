// enter pixel size in nm
Dialog.create("Parameters");
Dialog.addNumber("Pixel size (nm/pixel):", 8);
Dialog.show();
pixelSize = Dialog.getNumber();

// define expansion radii
radius24 = round(24 / pixelSize); 
radius56 = round(56 / pixelSize); 

run("Set Measurements...", "area mean min limit redirect=None decimal=3");

// open and name stacks
open(); titleMito = getTitle(); rename("MitoMask");
open(); titleLD = getTitle(); rename("LDMask");

nSliceStack = nSlices;
width = getWidth();
height = getHeight();

newImage("InteractionMap_24nm", "8-bit black", width, height, nSliceStack);
newImage("InteractionMap_56nm", "8-bit black", width, height, nSliceStack);

print("Slice   SurfaceArea   Contact_24   Contact_56   %_24   %_56");

for (i = 1; i <= nSliceStack; i++) {
    // mito outer surface (perimeter)
    selectWindow("MitoMask");
    setSlice(i);
    run("Duplicate...", "title=mito_slice");
    
    rename("Mito_orig");
    run("Duplicate...", "title=mito_eroded");
    run("Erode");

    imageCalculator("Subtract create", "Mito_orig", "mito_eroded");
    rename("Mito_surface");

    // mito surface area
    setThreshold(255,255);
    run("Measure");
    surfaceArea = getResult("Area", 0);
    run("Clear Results");

    // lipid droplet expansion
    selectWindow("LDMask");
    setSlice(i);
    run("Duplicate...", "title=LD_orig");

    // 24nm radius
    run("Duplicate...", "title=LD_24");
    for (r = 0; r < radius24; r++) run("Dilate");

    // 56nm radius
    run("Duplicate...", "title=LD_56");
    for (r = 0; r < radius56; r++) run("Dilate");

    // interaction maps
    imageCalculator("AND create", "Mito_surface", "LD_24");
    rename("Interaction_24");
    setThreshold(255,255);
    run("Measure");
    contact24 = getResult("Area", 0);
    run("Clear Results");

    imageCalculator("AND create", "Mito_surface", "LD_56");
    rename("Interaction_56");
    setThreshold(255,255);
    run("Measure");
    contact56 = getResult("Area", 0);
    run("Clear Results");

    // save interaction slices
    selectWindow("Interaction_24");
    run("Select All");
    run("Copy");
    selectWindow("InteractionMap_24nm");
    setSlice(i);
    run("Paste");

    selectWindow("Interaction_56");
    run("Select All");
    run("Copy");
    selectWindow("InteractionMap_56nm");
    setSlice(i);
    run("Paste");

    // output
    pct24 = contact24 * 100.0 / surfaceArea;
    pct56 = contact56 * 100.0 / surfaceArea;

    print(i + "      " + surfaceArea + "      " + contact24 + "      " + contact56 + "      " + pct24 + "      " + pct56);

    close("Mito_orig");
    close("mito_eroded");
    close("Mito_surface");
    close("LD_orig");
    close("LD_24");
    close("LD_56");
    close("Interaction_24");
    close("Interaction_56");
}

