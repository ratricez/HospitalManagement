import g4p_controls.*;
int numPatients = 68;
int numDoctors;
int numofwaiting;
Chair[] chairs;
Bed[] beds;
ArrayList<Patient> patients;
Doctor doctor;
ArrayList<Doctor> doctors = new ArrayList<Doctor>();
ArrayList<Patient> waitingqueue = new ArrayList<Patient>();  // queue order

int tempDoctorvalue = 1;
int tempBedvalue = 60;

boolean docSet; // only lets the person select number of doctors once
boolean bedSet; // only lets the person select number of doctors once

int severity; // store value for each patient for GUI
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
  //doctor = new Doctor(1, color(0, 0, 255)); // Blue doctor

      
}

void draw() {
  // Draw the background
  background(224, 214, 197);
  stroke(255);
  
  if (docSet == true && bedSet == true){
    simulationStarted = true;
  }
  
  if (simulationStarted == false){
    textSize(20);
    fill(0);
    text("Finish selecting number of beds and doctors", 400, 280);
    text("First select number of beds, then doctors", 413, 320);

    return;
  }

  
  line(350, 0, 350, 600);
  for (int i = 0; i < chairs.length; i++) {
    chairs[i].drawMe();
  }
  for(int i = 0; i < beds.length; i++){
        beds[i].drawMe();
  }
  fill(125, 122, 114, 30);
  rect(20, 20, 300, 130, 10);
  println(tempDoctorvalue);
  
    for(int i = 0; i < patients.size(); i++){
      if (patients.get(i).done) continue;
  
        // Try to assign a bed
        for (int j = 0; j < beds.length; j++) {
            if (!beds[j].occupied) {
                beds[j].occupied = true;
                patients.get(i).occupiedBed = beds[j];
                break;
            }
        }
    
        // If bed assignment failed, try a chair
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

  //for (Patient p: patients) {
  //  p.goToOccupied();
  //  p.drawPerson();
  //}

  for (Doctor doc : doctors) {
    doc.update();
  }

  // Text
  fill(255);
  textSize(16);
  text("Information Card:", 35, 45);
  textSize(14);
  text("Waiting Room: " + numofwaiting, 35, 70);


}

//300, 450, 450
