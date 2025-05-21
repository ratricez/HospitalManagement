class Doctor extends Person {
  int lastCheckTime = 0;
  int checkInterval = 500; // ms between checks

  boolean Examing = false;   // Is the doctor currently examining a patient?
  int waitStartTime = 0;     // When the exam started
  int examDuration = 600;   // How long doctor examines a patient (ms)
  float energy = 1;

  float targetX, targetY;    // Target position for smooth movement
  float moveSpeed = 0.05f;  // Speed of smooth movement (lerp factor)
  boolean movingToPatient = false; // Is doctor moving toward patient?
  ArrayList<Patient> docPatients = new ArrayList<Patient>(); // Doctor's patients
  Patient currentPatient = null;
  int patientIndex = 0;

  Doctor(int fl, color c) {
    super(fl, c);
    this.targetX = xPos;
    this.targetY = yPos;
  }

  void update() {
    if (Examing) { // If the doctor is examining a patient
    // Check the total time is bigger than enough time for exam (based on doctors energy)
      if (millis() - waitStartTime >= examDuration / energy) {
        Patient patient = currentPatient; // Find the current patient

        // If the patient exists and is in a bed
        if (patient != null && patient.occupiedBed != null) {
          if (energy - 0.01 > 0.1) { // Reduce the doctor's energy slightly after each exam
            energy -= 0.05;
          }
          
          // If the patient is healed...
          if (patient.calcHealed()) {
            Bed bed = patient.occupiedBed;
            bed.occupied = false;
            freeBeds.add(bed); // Add their bed to empty beds
            totalhealed++; // Increase the total count for healed patients
            patient.occupiedBed = null; // No longer in a bed
            patient.exitHospital(); // Make the healed patient leave
            docPatients.remove(patient); // Remove them from the list
          }
        }
        // Reset the examining state
        Examing = false;
        currentPatient = null;

        // Move to the next patient
        if (patientIndex >= docPatients.size()) {
          patientIndex = 0;
        }
      }

      drawPerson(); // Draw doctor
      return;
    }

    // If the doctor is moving...
    if (movingToPatient) {
      // Smoothly move towards target
      xPos = lerp(xPos, targetX, moveSpeed);
      yPos = lerp(yPos, targetY, moveSpeed);

      // Check if they have arrived at the patient
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

    // If not enough time has happened for the exam, return
    if (millis() - lastCheckTime < checkInterval) {
      drawPerson();
      return;
    }
    lastCheckTime = millis(); // Update the last time checked

    // If the doctor has someone...
    if (docPatients.size() > 0) {
      // Stop anything weird happening when it's larger than list size by making it 0
      if (patientIndex >= docPatients.size()) {
        patientIndex = 0;
      }

      // Current patient...
      Patient p = docPatients.get(patientIndex);
      // If they are in a bed and not healed
      if (p.occupiedBed != null && !p.calcHealed()) {
        // Set the target position beside the patient
        targetX = p.xPos - 15;
        targetY = p.yPos - 15;
        movingToPatient = true;
        currentPatient = p;
      } else {
        // If there is no bed, skip to someone else
        patientIndex++;
        if (patientIndex >= docPatients.size()) {
          patientIndex = 0;
        }
      }
    }

    drawPerson(); // Just always draw the doctor
  }
}
