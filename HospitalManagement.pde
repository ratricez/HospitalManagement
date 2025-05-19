import g4p_controls.*;
int numPatients = 0;
int numDoctors;
int numofwaiting;
Chair[] chairs;
Bed[] beds;
ArrayList<Patient> patients;
Doctor doctor;
ArrayList<Doctor> doctors = new ArrayList<Doctor>();
ArrayList<Patient> waitingqueue = new ArrayList<Patient>();  // queue order
ArrayList<Bed> freeBeds = new ArrayList<Bed>();

int tempDoctorvalue = 1; // starting value, in case they don't move the slider
int tempBedvalue = 60; // same thing but forr beds

boolean docSet; // only lets the person select number of doctors once
boolean bedSet; // only lets the person select number of doctors once

int severity=2; // store value for each patient for GUI
boolean simulationStarted = false;


void setup() {
  size(1200, 600);
  noStroke();
  createGUI();


  chairs = new Chair[48];
  patients = new ArrayList<Patient>();

  for (int i = 0; i < chairs.length; i++) {
    int row = i / 8;
    int col = i % 8;
    float x = 30 + col * 35;
    float y = 180 + row * 70;

    chairs[i] = new Chair(new PVector(x, y));
  }

  for(int i = 0; i < numPatients; i++){
    patients.add(new Patient(1, 1));
  }
}

void draw() {
  // Draw the background
  background(224, 214, 197);
  stroke(255);
  
  if (docSet == true && bedSet == true){ // once both values have been set, start animation
    simulationStarted = true;
  }
  
  if (simulationStarted == false){ // while they haven't selected starting values, don't run animation
    textSize(20);
    fill(0);
    text("Finish selecting number of beds and doctors", 400, 280);
    text("First select number of beds, then doctors", 413, 320);

    return;
  }

  freeBeds.clear(); // everytime, recheck empty beds
  for (int i = 0; i < beds.length; i++) {
    if (!beds[i].occupied) {
      freeBeds.add(beds[i]);
    }
  }

  // Drawing the scene
  line(350, 0, 350, 600);
  for (int i = 0; i < chairs.length; i++) {
    chairs[i].drawMe();
  }
  for(int i = 0; i < beds.length; i++){
        beds[i].drawMe();
  }
  
  fill(125, 122, 114, 30);
  rect(20, 20, 300, 130, 10);
  
    for(int i = 0; i < patients.size(); i++){
      if (patients.get(i).done) continue;
    
        // Chair assignment
        if (patients.get(i).occupiedBed == null) {
             for(int k = 0; k < chairs.length; k++) {
                if (!chairs[k].occupied && patients.get(i).occupiedChair == null) {
                    chairs[k].occupied = true;
                    patients.get(i).occupiedChair = chairs[k];
                    waitingqueue.add(patients.get(i));
                    numofwaiting++;
                    break;
                }
            }
        }
  
      patients.get(i).goToOccupied();
      patients.get(i).drawPerson();
  }

  for (Doctor doc : doctors) { // Drawing doctors
    doc.update();
  }

  for (Patient p : patients) {
    p.moveToTarget();
  }

  for (int i = freeBeds.size() - 1; i >= 0; i--) { // Bed assignment
    Bed b = freeBeds.get(i);
    if (!b.occupied && !waitingqueue.isEmpty()) {
      Patient next = waitingqueue.remove(0);
      next.occupiedChair.occupied = false;
      next.occupiedChair = null;
      next.occupiedBed = b;
      b.occupied = true;
      next.col = color(0);
      numofwaiting--;
    }
  }

  // === A door where patients enter from (bottom-left) ===
  fill(160, 82, 45); // door color (brown)
  stroke(100); strokeWeight(2);
  // Door base
  rect(305, 580, 35, 50); // door rectangle at (325 - 20, 600 - 50)

  // Text box
  fill(255);
  textSize(16);
  text("Information Card:", 35, 45);
  textSize(14);
  text("Waiting Room: " + numofwaiting, 35, 70);

}
