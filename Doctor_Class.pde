class Doctor extends Person { //<>//
  int bedIndex;
  int lastCheckTime = 0;
  int startIndex, endIndex;
  boolean Examing = false;   // Is the doctor currently examining a patient?
  int waitStartTime = 0;     // When the exam started
  int examDuration = 600;   // How long doctor examines a patient (ms)
  float energy = 1;
  float targetX, targetY;    // Target position for smooth movement
  float moveSpeed = 0.05f;  // Speed of smooth movement (lerp factor)
  boolean movingToPatient = false; // Is doctor moving toward patient?
  ArrayList<Patient> docPatients = new ArrayList<Patient>();
  Patient currentPatient = null;
  int currentPatientIndex = 0; // Track which patient we're currently examining
  
  Doctor(int fl, color c) {
    super(fl, c);
    this.targetX = xPos;
    this.targetY = yPos;
  }
  
  void update() {
    int checkInterval = (int)(500/speedFactor); // ms between checks
    int adjustedExamDuration = (int)((600/energy)/speedFactor); // Have it adjusted to speed factor
    if (Examing) {  // If examination is happening
      // If we are finished an exam...
      if (millis() - waitStartTime >= adjustedExamDuration) { 
        Patient patient = currentPatient; // Get the current patient
        if (patient != null && patient.occupiedBed != null) { // As long as the patient exists and is in a bed...
          if (energy - 0.05 > 0.1) { // Reduce the doctor's energy after each exam
            energy -= 0.05;
          }
          
          // If the patient is healed
          if (patient.calcHealed()) {
            Bed bed = patient.occupiedBed;
            bed.occupied = false;
            freeBeds.add(bed); // Add their bed to the empty beds
            totalhealed++; // Increase the total count for healed patients
            patient.occupiedBed = null; // No more bed for said patient
            patient.exitHospital(); // The healed patient can go home!
            docPatients.remove(patient); // Remove them
            // If we remove the current patient, we need to adjust the index (stop bugs)
            if (currentPatientIndex > 0) {
              currentPatientIndex--;
            }
          }
        }
        Examing = false; // Stop examining
        currentPatient = null;
        // Move to next patient
      }
      drawPerson();
      return;
    }
    
    // Move to a patient
    if (movingToPatient) {
      // Allows smooth movement towards patient/target
      xPos = lerp(xPos, targetX, moveSpeed * speedFactor);
      yPos = lerp(yPos, targetY, moveSpeed * speedFactor);
      if (dist(xPos, yPos, targetX, targetY) < 1) {
        xPos = targetX;
        yPos = targetY;
        movingToPatient = false;
        Examing = true;
        waitStartTime = millis();
      }
      drawPerson();
      return;
    }
    
    // Check if it's time to find a new patient (by time intervals)
    if (millis() - lastCheckTime < checkInterval) {
      drawPerson();
      return;
    }
    
    lastCheckTime = millis();
    
    // If we have patients to check (list is not empty)
    if (!docPatients.isEmpty()) {
      // Reset index if it's out of bounds (go back to first)
      if (currentPatientIndex >= docPatients.size()) {
        currentPatientIndex = 0;
      }
      
      // Get the current patient and move index to next patient for next time
      Patient p = docPatients.get(currentPatientIndex);
      currentPatientIndex = (currentPatientIndex + 1) % docPatients.size(); // Use % so it doesn't go out of index
      
      // If patient has a bed, go examine them
      if (p.occupiedBed != null) {
        targetX = p.xPos - 15;
        targetY = p.yPos - 15;
        movingToPatient = true;
        currentPatient = p;
      }
    }
    drawPerson();
  }
}
