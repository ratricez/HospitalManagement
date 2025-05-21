import g4p_controls.*; //<>//
int numPatients = 0; // start off with no patients as they are added
int numDoctors;
int numofwaiting;
int totalhealed = 0;
Chair[] chairs;
Bed[] beds;
ArrayList<Patient> patients; // all patients
ArrayList<Doctor> doctors = new ArrayList<Doctor>(); // array list of doctors
ArrayList<Patient> waitingqueue = new ArrayList<Patient>();  // queue order (chairs/outside)
ArrayList<Bed> freeBeds = new ArrayList<Bed>(); // keep track of empty beds

int nextDoctorIndex = 0; // for assignment orders

int tempDoctorvalue = 1; // starting value, in case they don't move the slider (GUI)
int tempBedvalue = 60; // same thing but for beds (GUI)
int severity = 2; // store severity for GUI

boolean docSet; // only lets the person select number of doctors once
boolean bedSet; // only lets the person select number of doctors once
boolean simulationStarted = false; // turns true when both docSet and bedSet are true

int hours, mins;
int startTime = millis();

ArrayList<Integer> waitingTimes = new ArrayList<Integer>();
int totalWaitingTime = 0;
int patientsServed = 0;

void setup() {
  size(1200, 600);
  noStroke();
  createGUI();

  chairs = new Chair[48]; // preset number of chairs
  patients = new ArrayList<Patient>();

  for (int i = 0; i < chairs.length; i++) { // set xPos and yPos values for chairs
    int row = i / 8;
    int col = i % 8;
    float x = 30 + col * 35;
    float y = 180 + row * 70;
    chairs[i] = new Chair(new PVector(x, y));
  }

}

float calculateDocAvgExhaustion(){ // function for later to calculate the average doctor energy
  float total = 0;
  for (Doctor doc : doctors) {
    total += doc.energy;
  }
  return total/doctors.size();
}
// Function to get the most recent waiting times 
float getRecentAverageWaitTimes(int recentSpan){
  if(waitingTimes.isEmpty()){
     return 0.0;    
  }
  
  int startIndex = max(0, waitingTimes.size() - recentSpan);
  int total = 0;
  int count = 0;
  
  for(int i = startIndex; i < waitingTimes.size(); i++){
    total += waitingTimes.get(i);
    count ++;
  }
  
  return count > 0 ? float(total) / count : 0.0;
  
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
  line(350, 0, 350, 600); // splitting line between waiting room and care center
  for (int i = 0; i < chairs.length; i++) { // draw the chairs
    chairs[i].drawMe();
  }
  for(int i = 0; i < beds.length; i++){ // draw the beds
        beds[i].drawMe();
  }
  
  fill(125, 122, 114, 30);
  rect(20, 20, 300, 130, 10); // top left console box
  
  for (int i = patients.size() - 1; i >= 0; i--) { // go backwards through patient list
    patients.get(i).moveToTarget(); // move patient towards current target spot (chair or bed)

    // If someone has been healed and left, remove them
    if (patients.get(i).done && patients.get(i).exiting && !patients.get(i).movingToTarget) { 
      patients.remove(i);
      continue; 
    } 
    
    // If they are healing but haven't finished leaving, make them leave
    if (patients.get(i).done && !patients.get(i).exiting) {
      patients.get(i).exitHospital();
      
    // If they are not yet assigned and not leaving
    } if (patients.get(i).occupiedBed == null && patients.get(i).occupiedChair == null && !patients.get(i).exiting) {
      // Try assigning them to a empty chair
      for (int k = 0; k < chairs.length; k++) {
        if (!chairs[k].occupied) {
          chairs[k].occupied = true;
          patients.get(i).occupiedChair = chairs[k]; // Assign the chair
          waitingqueue.add(patients.get(i)); // Add them to the waiting queue
          break; // break
        }
      }
    }

    patients.get(i).goToOccupied(); // Move patient to their spot
    patients.get(i).drawPerson(); // Draw person :)
    
    }

  for (Doctor doc : doctors) { // Drawing doctors
    doc.update();
  }

  for (Patient p : patients) {
    p.moveToTarget();
  }

  for (int i = freeBeds.size() - 1; i >= 0; i--) { // Bed assignment
    Bed b = freeBeds.get(i); // Free bed...
    if (!b.occupied && !waitingqueue.isEmpty()) { // As long as it is actually a free bed
      Patient next = waitingqueue.remove(0); // Take the next person in line and remove them from the waiting queue
      if(!next.timeRecorded){ //if the nth patient hasn't had their time recorded already
        int waitingTime = millis() - next.enteredWaitTime; //finding difference between current milli count and milli count from when the pat. entered
        waitingTimes.add(waitingTime);
        totalWaitingTime += waitingTime;
        patientsServed ++;
        next.timeRecorded = true;
      }
      next.occupiedChair.occupied = false; // Change patient (called next) chair status to false
      next.occupiedChair = null; // Change their occupied chair to nothing
      next.occupiedBed = b; // Give them the empty bed
      b.occupied = true;
      numofwaiting--; // One less person waiting
    }
  }

  // Door
  fill(160, 82, 45); // Door color (brown)
  stroke(100);
  // Door base
  rect(305, 580, 35, 50);

  // Text box (top left box)
  fill(255);
  textSize(16);
  text("Information Card:", 35, 45);
  textSize(14);
  
  text("Waiting Room: " + min(numofwaiting, 48), 35, 70);
  text("Waiting Outside: " + max(numofwaiting - 48, 0), 35, 90);

  text("Doctors Exhaustion: " + nf(calculateDocAvgExhaustion(), 1, 2), 35, 110);
  text("Total Healed: " + totalhealed, 35, 130);

  text("Expected Waiting Time: " + nf(floor((getRecentAverageWaitTimes(10) / 3000) * 10), 1, 1) + "mins", 35, 145 );

  fill(70, 70, 70);
  stroke(255);
  rect(155, 30, 160, 50, 10);
  mins = floor((millis() - startTime) / 3000) * 10;
  if (mins >= 60){
    hours += 1;
    mins = 0;
    startTime = millis();
  }
  fill(255);
  textSize(28);
  text(nf(hours, 2) + ":" + nf(mins,2), 205, 67);
}
