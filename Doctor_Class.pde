class Doctor extends Person { //<>//
  int bedIndex;
  int lastCheckTime = 0;
  int checkInterval = 500; // ms between checks
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
        if (energy - 0.05 > 0.1) energy -= 0.01;
        if (patient.calcHealed()) {
          Bed bed = patient.occupiedBed;
          bed.occupied = false;
          freeBeds.add(bed);
          totalhealed++;
          patient.occupiedBed = null;
          patient.exitHospital();
          docPatients.remove(patient);
        }
      }

      Examing = false;
      currentPatient = null;
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

  for (Patient p : docPatients) {
    if (p.occupiedBed != null) {
      targetX = p.xPos - 15;
      targetY = p.yPos - 15;
      movingToPatient = true;
      currentPatient = p;
      drawPerson();
      return;
    }
  }

  drawPerson();
}
}
