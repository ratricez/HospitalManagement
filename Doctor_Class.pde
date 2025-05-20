class Doctor extends Person {
  int bedIndex;
  int lastCheckTime = 0;
  int checkInterval = 500; // ms between checks
  int startIndex, endIndex;

  boolean Examing = false;   // Is the doctor currently examining a patient?
  int waitStartTime = 0;     // When the exam started
  int examDuration = 300;   // How long doctor examines a patient (ms)
  float energy = 1;

  float targetX, targetY;    // Target position for smooth movement
  float moveSpeed = 0.05f;  // Speed of smooth movement (lerp factor)
  boolean movingToPatient = false; // Is doctor moving toward patient?
 
  Doctor(int fl, color c, int startIndex, int endIndex) {
    super(fl, c);
    this.startIndex = startIndex;
    this.endIndex = endIndex;
    this.bedIndex = startIndex; // Start from bottom right
    this.targetX = xPos;
    this.targetY = yPos;

  }

  void update() {
    int bedsToCheck = endIndex - startIndex + 1;

    // If currently examining a patient, handle timing and healing logic
    if (Examing) {
      if (millis() - waitStartTime >= examDuration/energy) {
        Bed currentBed = beds[bedIndex];
        Patient patientInBed = null;

        for (Patient p : patients) {
          if (p.occupiedBed == currentBed) {
            patientInBed = p;
            break;
          }
        }

        if (patientInBed != null) {
          if(energy - 0.05 > 0.1) energy -= 0.05;
          if (patientInBed.calcHealed()) {
            // Patient healed — free bed and send to exit
            currentBed.occupied = false;
            freeBeds.add(currentBed);

            patientInBed.occupiedBed = null;
            patientInBed.exitHospital();  // Triggers movement to door
          }
        }

        // End exam and move to next bed
        Examing = false;
        bedIndex++;
        if (bedIndex > endIndex) {
          bedIndex = startIndex;
        }
      }
      // Draw doctor while examining
      drawPerson();
      return;
    }

    if (movingToPatient) {
      xPos = lerp(xPos, targetX, moveSpeed);
      yPos = lerp(yPos, targetY, moveSpeed);

      // Check if doctor arrived at patient
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

    // Not examining: check timing interval before moving on
    if (millis() - lastCheckTime < checkInterval) {
      drawPerson();
      return;
    }
    lastCheckTime = millis();

    int checkedBeds = 0;

    // Loop until we find a patient to examine or checked all beds in range
    while (checkedBeds < bedsToCheck) {
      Bed currentBed = beds[bedIndex];

      if (currentBed.occupied) {
        // Find patient in this bed
        Patient patientInBed = null;
        for (Patient p : patients) {
          if (p.occupiedBed == currentBed) {
            patientInBed = p;
            break;
          }
        }

        if (patientInBed != null) {
          // Move doctor to patient
          targetX = patientInBed.xPos - 15;
          targetY = patientInBed.yPos - 15;
          movingToPatient = true;
          // Start examining patient
          drawPerson();
          return; // start exam this frame, done for now
        }
      }

      // Bed unoccupied or no patient found, check next bed
      bedIndex++;
      if (bedIndex > endIndex) {
        bedIndex = startIndex;
      }
      checkedBeds++;
    }

    // draw doctor at current position
    drawPerson();
  }
}
