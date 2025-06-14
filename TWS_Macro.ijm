// define the input and output folders
inputDir = "C:/Users/okovt/OneDrive/Desktop/tws_test";
outputDir = "C:/Users/okovt/OneDrive/Desktop/tws_result";
classifierPath = "/C:/Users/okovt/OneDrive/Desktop/classifier.model";

// get the list of image files in the directory
list = getFileList(inputDir);

for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".tif")) {
        // open the image
        open(inputDir + "/" + list[i]);
        
        // run Trainable Weka Segmentation
        run("Trainable Weka Segmentation");
        wait(5000); //wait for 5 seconds

        // check if the segmentation window is open
        if (!isOpen("Trainable Weka Segmentation v4.0.0")) {
            print("Error: Trainable Weka Segmentation window did not open.");
            close();
            continue;
        }

        // load the classifier and get the result
        selectWindow("Trainable Weka Segmentation v4.0.0");
        call("trainableSegmentation.Weka_Segmentation.loadClassifier", classifierPath);
        call("trainableSegmentation.Weka_Segmentation.getResult");
        wait(5000); // wait for 5 seconds to ensure classification is complete
        
        // select the classified image and save it
        classifiedTitle = "Classified image";
        if (isOpen(classifiedTitle)) {
            selectWindow(classifiedTitle);
            savePath = outputDir + "/" + replace(list[i], ".tif", "_classified");
            print("Saving classified image to: " + savePath);
            saveAs("TIFF", savePath);
        } else {
            print("Error: Classified image window did not open.");
        }
        
        // close the classified image
        if (isOpen(classifiedTitle)) {
            selectWindow(classifiedTitle);
            close();
        }
        
        // close any additional open windows to clean up
        run("Close All");
        wait(1000); // wait 1 second to ensure all windows are closed
    }
}
