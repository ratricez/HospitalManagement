import g4p_controls.*;
int numPatients = 83;
int numofwaiting;
Chair[] chairs;
Bed[] beds;
Patient[] patients;
Doctor doctor;



void setup() {
  size(1200, 600);
  noStroke();

  chairs = new Chair[48];
  beds = new Bed[60];
  patients = new Patient[numPatients];




  for (int i = 0; i < chairs.length; i++) {
    int row = i / 8;
    int col = i % 8;
    float x = 30 + col * 35;
    float y = 180 + row * 70;

    chairs[i] = new Chair(new PVector(x, y));

  }


   for (int i = 0; i < beds.length; i++) {
    int row = i / 10;
    int col = i % 10;
    float x = 380 + col * 85;
    float y = 40 + row * 100;
    
    beds[i] = new Bed(new PVector(x,y));
  }
  
  for(int i = 0; i < numPatients; i++){
    patients[i] = new Patient(1, 3); // hard coded patient info
  }
  doctor = new Doctor(1, color(0, 0, 255), beds); // Blue doctor

      
}

void draw() {
  // Draw the background
  background(224, 214, 197);
  stroke(255);
  line(350, 0, 350, 600);
  for (int i = 0; i < chairs.length; i++) {
    chairs[i].drawMe();
  }
  for(int i = 0; i < beds.length; i++){
        beds[i].drawMe();
  }
  fill(125, 122, 114, 30);
  rect(20, 20, 300, 130, 10);
  
  // Test person
  for(int i = 0; i < numPatients; i++){
    // Try to assign a bed
    for (int j = 0; j < beds.length; j++) {
        if (!beds[j].occupied) {
            beds[j].occupied = true;
            patients[i].occupiedBed = beds[j];
            break;
        }
    }

    // If bed assignment failed, try a chair
    if (patients[i].occupiedBed == null) {
         for(int k = 0; k < chairs.length; k++) {
            if (!chairs[k].occupied && patients[i].occupiedChair == null) {
                chairs[k].occupied = true;
                patients[i].occupiedChair = chairs[k];
                numofwaiting++;
                break;
            }
        }
    }
  
    patients[i].goToOccupied();
    patients[i].drawPerson();
  }

  doctor.update();

  // Text
  fill(255);
  textSize(16);
  text("Information Card:", 35, 45);
  textSize(14);
  text("Waiting Room: " + numofwaiting, 35, 70);


}

//300, 450, 450
