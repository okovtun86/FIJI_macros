originalTitle = getTitle();

run("Colour Deconvolution2", "vectors=[User values] output=[8bit_Transmittance] simulated "
 + "[r1]=0.158 [g1]=0.353 [b1]=0.922 "
 + "[r2]=0.151 [g2]=0.591 [b2]=0.793 "
 + "[r3]=0.0 [g3]=0.0 [b3]=0.0");

colour2Title = "";
n_img = nImages();
for (i = 0; i < n_img; i++) {
    selectImage(i + 1);
    title = getTitle();
    if (endsWith(title, "(Colour_2)")) {
        colour2Title = title;
        selectWindow(title);
        break;
    }
}

run("Duplicate...", "title=Colour_2_mask");
run("Enhance Local Contrast (CLAHE)", "blocksize=127 histogram=256 maximum=3 mask=*None*");

setAutoThreshold("Otsu light");
setOption("BlackBackground", true);
run("Convert to Mask");

run("Set Measurements...", "area mean redirect=[" + colour2Title + "] decimal=3");
run("Analyze Particles...", "size=50-Infinity show=Overlay display summarize");
