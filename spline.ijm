myImageID = getImageID();
setTool(5);                                      
beep();
waitForUser("Draw your polyline");
selectImage(myImageID);
if (selectionType() != 6) {
    exit("...no line!!!");
}
run("Fit Spline");

function AddToRoi(index, name){
	run("ROI Manager...");
	roiManager("Add");
	roiManager("Select", index);
	roiManager("Rename", name);
	}


AddToRoi(0, "segmented_line");
//run("Measure");

//Find midpoint
getSelectionCoordinates(x, y);

mid = floor(lengthOf(x) / 2);
midx = x[mid];
midy = y[mid];


//Mark midpoint
makePoint(midx, midy);

AddToRoi(1, "midpoint");


waitForUser("Draw your polyline from chalaza");
selectImage(myImageID);
if (selectionType() != 6) {
    exit("...no line!!!");
}
run("Fit Spline");
AddToRoi(2, "segmented_line_2");

getSelectionCoordinates(x, y);

mid_2 = lengthOf(x)/2;

midx_2 = x[mid_2];

midy_2 = y[mid_2];

//Mark midpoint
makePoint(midx_2, midy_2);
AddToRoi(3, "midpoint_2");

makeLine(midx, midy, midx_2, midy_2);
AddToRoi(4, "connecting_line");

roiManager("Show All");