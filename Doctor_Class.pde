class Doctor extends Person { //<>//
  int lastCheckTime = 0;
  int checkInterval = 500; // ms between checks

  boolean Examing = false;   // Is the doctor currently examining a patient?
  int waitStartTime = 0;     // When the exam started
  int examDuration = 600;   // How long doctor examines a patient (ms)
  float energy = 1;

  float targetX, targetY;    // Target position for smooth movement
  float moveSpeed = 0.05f;  // Speed of smooth movement (lerp factor)
  boolean movingToPatient = false; // Is doctor moving toward patient?
  ArrayList<Patient> docPatients = new ArrayList<Patient>();
  Patient currentPatient = null;
  int patientIndex = 0;

  Doctor(int fl, color c) {
    super(fl, c);
    this.targetX = xPos;
    this.targetY = yPos;
  }

  void update() {
    if (Examing) {
      if (millis() - waitStartTime >= examDuration / energy) {
        Patient patient = currentPatient;

        if (patient != null && patient.occupiedBed != null) {
          if (energy - 0.01 > 0.1) {
            energy -= 0.05;
          }
          
          if (patient.calcHealed()) {
            Bed bed = patient.occupiedBed;
            bed.occupied = false;
            freeBeds.add(bed);
            totalhealed++;
            patient.occupiedBed = null;
            patient.exitHospital();
            docPatients.remove(patient);

            // Decrease index since list shrunk
            if (patientIndex > 0) {
              patientIndex--;
            }
          }
        }

        Examing = false;
        currentPatient = null;

        // Move to the next patient index
        patientIndex++;
        if (patientIndex >= docPatients.size()) {
          patientIndex = 0;
        }
      }

      drawPerson();
      return;
    }

    if (movingToPatient) {
      xPos = lerp(xPos, targetX, moveSpeed);
      yPos = lerp(yPos, targetY, moveSpeed);

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

    if (millis() - lastCheckTime < checkInterval) {
      drawPerson();
      return;
    }
    lastCheckTime = millis();

    if (docPatients.size() > 0) {
      if (patientIndex >= docPatients.size()) {
        patientIndex = 0;
      }

      Patient p = docPatients.get(patientIndex);
      if (p.occupiedBed != null) {
        targetX = p.xPos - 15;
        targetY = p.yPos - 15;
        movingToPatient = true;
        currentPatient = p;
      } else {
        // No bed, skip to next
        patientIndex++;
        if (patientIndex >= docPatients.size()) {
          patientIndex = 0;
        }
      }
    }

    drawPerson();
  }
}
