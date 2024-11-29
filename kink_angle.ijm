													//Code to calculate the kink angle

// Adjust the path here as per need
// There's another script to find the index of an item in the roi manager, by referring to its name. Check in file - script_getindexnumber_fromRoiname.ijm

//path = 'Y:/Students/Aman/quant_pipeline/screenshots/new_ss/attempt_65_only_epi_growth-0160.JPG'
//no = 65 //change evrytime //this variable is intended for the name of the file at the time of saving
//name = File.getName(path);
//ts = replace(substring(name, lastIndexOf(name, ".") - 4), '.', '_'); //replaces the dot in ".JPG" with "_JPG", so that there is no issue with file format
//open(path)

//Prompt to select the working folder - #@ File (style="directory") imageFolder;

//Variable for the length of the perpendicular lines. lineExt_1 for first perpendicular line, lineExt_2 for the second perpendicular line
lineExt_1 = -200;
lineExt_2 = -200;

Dialog.create("Attempt number");
		Dialog.addMessage("...Input the attempt number of the specific image...");
		Dialog.addNumber("attempt number: ", 31);
		Dialog.show();
		number_attempt = Dialog.getNumber();

Dialog.create("Image classifier");
		Dialog.addMessage("...Check the box if the image is multicolored, leave unchecked otherwise...");
		Dialog.addCheckbox("*", false);
		Dialog.show();
		user_input = Dialog.getCheckbox();

//if image is clearly sectioned into colors, without mixture then run multicolor_images();
function multicolor_images(){
	run("32-bit");
	run("Despeckle");
	run("ROF Denoise");
	run("Find Edges");
	run("Brightness/Contrast...");}

//if image is just two colored run this function
function binarycolor_images(){
	run("Make Composite");
	run("Channels Tool...");
	}

//func for adding and renaming rois in the manager
function AddToRoi(index, name){
	run("ROI Manager...");
	roiManager("Add");
	roiManager("Select", index);
	roiManager("Rename", name);
	}


if(user_input == 1)
	multicolor_images();
else
	binarycolor_images();

//this prompts the user to make then first line

while (selectionType() < 0) {
	//setTool("line");
	waitForUser('draw the base of the chalaza'); }

AddToRoi(0, "manual_line");

//mark the midpoint
getSelectionCoordinates(x, y);
x_mid = (x[0] + x[1]) / 2;
y_mid = (y[0] + y[1]) / 2;

//make point
makePoint(x_mid, y_mid);

// Add to ROI
AddToRoi(1, "midpoint");

// Code to find and plot the perpendicular line

//calculate slope of line and the intercept for the new line based on the mid-point.

m = (y[1] - y[0])/(x[1] - x[0]);

if(m!=0)
	cNew = y_mid + ((1/m)*x_mid);
else 
	cNew = y_mid;

// calculate 2nd coordinate to connect to (midX, midY).

if(m==1 || m==-1){					// if vertical, new is horizontal
	newX = x_mid + lineExt_1;
	newY = y_mid;
}
else if(m==0){						// if horizontal, new is vertical.
	newX = x_mid;
	newY = y_mid + lineExt_1;
}	
else{
	newX = x_mid + lineExt_1;
	newY = -(1/m)*newX + cNew;
}

// make a new perpendicular line.
makeLine(x_mid, y_mid, newX, newY);	// draw the line

//add perpendicular to ROI M

AddToRoi(2, "perpendicular_line");

//Make a point at the end of perpendicular line just plotted. useful for angle calculation

makePoint(newX, newY);
AddToRoi(3, "perpendicular_line_endpoint");

//Testing the ROIs
roiManager("Show None");
roiManager("Show All");

//drawing the second line (for eg. from inclined surface)
run("Select None");
while (selectionType() < 0) {
	//setTool("line");
	waitForUser('draw the neck of the nucellus'); }

AddToRoi(4, "manual_line_2");

//mark the midpoint of second line and rename it
getSelectionCoordinates(x, y);
x_mid = (x[0] + x[1]) / 2;
y_mid = (y[0] + y[1]) / 2;
makePoint(x_mid, y_mid);
AddToRoi(5, "midpoint_2");

//code for perpendicular line. Could be made into a function to reduce the redundancy!!

//calculate slope of line and the intercept for the new line based on the mid-point.

m = (y[1] - y[0])/(x[1] - x[0]);

if(m!=0)
	cNew = y_mid + ((1/m)*x_mid);
else 
	cNew = y_mid;

//calculate 2nd coordinate to connect to (midX, midY).

if(m==1 || m==-1){					// if vertical, new is horizontal
	newX = x_mid + lineExt_2;
	newY = y_mid;
}
else if(m==0){						// if horizontal, new is vertical.
	newX = x_mid;
	newY = y_mid + lineExt_2;
}	
else{
	newX = x_mid + lineExt_2;
	newY = -(1/m)*newX + cNew;
}

//one for below. Since the perpendicular line needs to go above and below the midpoint. Not just above as in the first case

if(m==1 || m==-1){					// if vertical, new is horizontal
	newX2 = x_mid - lineExt_2;
	newY2 = y_mid;
}
else if(m==0){						// if horizontal, new is vertical.
	newX2 = x_mid;
	newY2 = y_mid - lineExt_2;
}	
else{
	newX2 = x_mid - lineExt_2;
	newY2 = -(1/m)*newX2 + cNew;
}

// make a new perpendicular line.
makeLine(newX2, newY2, newX, newY);	// draw the line

//add to roi
AddToRoi(6, "perpendicular_line_2");

//make point
makePoint(newX, newY); 
//add to roi
AddToRoi(7, "perpendicular_line_2_endpoint_A");

//make point
makePoint(newX2, newY2); 
//add to roi
AddToRoi(8, "perpendicular_line_2_endpoint_B");

run("Labels...", "color=white font=12 show use draw");
run("Select None");

////////////////////////The part where you find the intersection point of the two plotted lines

roiManager("Show None");
roiManager("Show All");
run("Select None");

//roiManager("Select", 7);
roiManager("Select", 7);
getSelectionCoordinates(xpoints, ypoints);

// get the coordinates of the 2nd perpendicular line - first point(let's say point A) and store those into two variables

A_x0 = xpoints[0];
A_y0 = ypoints[0];

roiManager("Select", 8);
getSelectionCoordinates(xpoints, ypoints);

// get the coordinates of the 2nd perpendicular line - point B

A_x1 = xpoints[0];
A_y1 = ypoints[0];

print(A_x0, A_y0, A_x1, A_y1);

m1 = (A_y1 - A_y0)/(A_x1 - A_x0);

print(m1);

run("Select None");

roiManager("Select", 1);
// get the coordinates of the midpoint of the line drawn manually
getSelectionCoordinates(xpoints, ypoints);

midmanual_x0 = xpoints[0];
midmanual_y0 = ypoints[0];

roiManager("Select", 3);
getSelectionCoordinates(xpoints, ypoints);

firstpl_x0 = xpoints[0];
firstpl_y0 = ypoints[0];

print(midmanual_x0, midmanual_y0, firstpl_x0, firstpl_y0);
m2 = (firstpl_y0 - midmanual_y0)/(firstpl_x0 - midmanual_x0);

print(m2);  //slope for the perpendicular line is negative infinity

x_intersection = midmanual_x0;

y_intersection = m1 * (x_intersection - A_x0) + A_y0;

print(x_intersection, y_intersection);

makePoint(x_intersection, y_intersection);
AddToRoi(9, "intersection_point");

//Uncomment below line to label the lines and the point
//run("Labels...", "color=white font=12 show use draw");

//Run the angle tool
makeSelection("angle", newArray(A_x0, x_intersection, firstpl_x0), newArray(A_y0, y_intersection, firstpl_y0));
//Display the measure
run("Measure");

AddToRoi(10, "kink angle");

outputPath=getDirectory("image")+ number_attempt + "__roiset.zip";
//Save the ROIs as a zip file
roiManager("save",outputPath);

roiManager("show all");

//To avoid getting greyscale images
run("RGB Color");

wait(5000); //to delay by 5 seconds

Dialog.create("Save prompt");
		Dialog.addMessage("Do you want to save a snapshot of your work?");
		Dialog.addChoice("Select an option: ", newArray("yes", "no"), "no");
		Dialog.show();
		user_choice = Dialog.getChoice();

imagePath = getDirectory("image");

file_name = ".tif";

if (user_choice == "yes"){

	Dialog.create("time stamp");
		Dialog.addNumber("time stamp: ", 31);
		Dialog.show();
		time_stamp = Dialog.getNumber();
	
	run("Capture Image");
	
	saveAs("Tiff", imagePath +"attempt_"+ number_attempt + "_timestamp_" + time_stamp + file_name); // add _"attempt_number:"time_stamp 
	//to close the screenshot window
	close();
} else {
		exit
}