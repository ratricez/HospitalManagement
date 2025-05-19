//class Doctor extends Person { 
//  int patIndex = 0;    // which bed doc visiting
//  boolean Examing = false;
//  int waitStartTime = 0; //Stores time the doc started examining (used to time how long they examine)
//  int startIndex = 0;
//  int endIndex = 10;

//  Doctor(int fl, color c) { // change input later to include startindex and endindex
//    super(fl, c);
//  }

//  void update() {
//      if (patients.size() == 0 || bedIndex > endIndex || bedIndex >= patients.size()) {
//        bedIndex = startIndex;
//        return;
//      }

//      if (Examing && patients.get(patIndex).occupiedBed != null) {
//        if (millis() - waitStartTime >= 500) {
//          if (patients.get(patIndex).calcHealed()) {
//            Bed freedBed = patients.get(patIndex).occupiedBed;
//            freedBed.occupied = false;
          
//            // Remove the healed patient
//            patients.remove(patIndex);
//            Examing = false;
          
//            // Now assign the freed bed to first person in queue
//            if (!waitingqueue.isEmpty()) {
//              Patient nextPatient = waitingqueue.remove(0); // First in, first out... (not by chair spot)
//              nextPatient.occupiedChair.occupied = false;
//              nextPatient.occupiedChair = null;
//              nextPatient.occupiedBed = freedBed;
//              nextPatient.col = color(0); //testing stuff
//              freedBed.occupied = true;
//              numofwaiting--;
//            }          
//            // Don't increment patIndex here because the next patient will shift into this index
//            } else {
//              Examing = false;
//              patIndex++;
//            }
//        }
//    } else {
//    // Move to next bed
//    if (patIndex < patients.size() && patients.get(patIndex).occupiedBed != null) {
//      // move horizontally
//      xPos = patients.get(patIndex).xPos - 15; 
//      yPos = patients.get(patIndex).yPos - 15; 
      
//      // If occupied, start examining. If not, next bed.
//      if (patients.get(patIndex).occupiedBed != null) {
//        Examing = true;
//        waitStartTime = millis(); // Store current time
//      } else {
//        patIndex++;
//        }
//      }
//    }
//    drawPerson(); // Draw the doctor
//    //println("Visiting bed:", patIndex, "Examing:", Examing);
//  }
//}

class Doctor extends Person {  
  int bedIndex;
  int lastCheckTime = 0;
  int checkInterval = 500; // ms between checks
  int startIndex, endIndex;

  boolean Examing = false;   // Is the doctor currently examining a patient?
  int waitStartTime = 0;     // When the exam started
  int examDuration = 1000;   // How long doctor examines a patient (ms)

  float targetX, targetY;    // Target position for smooth movement
  float moveSpeed = 0.05f;  // Speed of smooth movement (lerp factor)
  boolean movingToPatient = false; // Is doctor moving toward patient?

  Doctor(int fl, color c, int startIndex, int endIndex) {
    super(fl, c);
    this.startIndex = startIndex;
    this.endIndex = endIndex;
    this.bedIndex = endIndex; // Start from bottom right
    this.targetX = xPos;
    this.targetY = yPos;
  }

  void update() {
    int bedsToCheck = endIndex - startIndex + 1; // number of beds

    // If currently examining a patient, handle timing and healing logic
    if (Examing) {
      if (millis() - waitStartTime >= examDuration) {
        Bed currentBed = beds[bedIndex];
        Patient patientInBed = null;

        for (Patient p : patients) { // check for which patient is in the bed
          if (p.occupiedBed == currentBed) {
            patientInBed = p;
            break;
          }
        }

        if (patientInBed != null) {
          if (patientInBed.calcHealed()) {
            // Patient healed — free bed and remove patient
            currentBed.occupied = false;
            patients.remove(patientInBed);

            // Assign next waiting patient to this freed bed
            if (!waitingqueue.isEmpty()) {
              Patient next = waitingqueue.remove(0);
              next.occupiedChair.occupied = false;
              next.occupiedChair = null;
              next.occupiedBed = currentBed;
              currentBed.occupied = true;
              next.col = color(0);
              numofwaiting--;
            }
          }
        }

        // End exam and move to previous bed (right to left)
        Examing = false;
        bedIndex--;
        if (bedIndex < startIndex) {
          bedIndex = endIndex; // wrap around
        }
      }
      // Draw doctor while examining
      drawPerson();
      return;
    }

    // If doctor is moving toward patient, update position smoothly
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

    // Not examining and not moving — check interval timing before next bed check
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
          // Set target position near patient and start moving
          targetX = patientInBed.xPos - 15;
          targetY = patientInBed.yPos - 15;
          movingToPatient = true;

          drawPerson();
          return; // movement starts this frame, done for now
        }
      }

      // Move to previous bed (right to left)
      bedIndex--;
      if (bedIndex < startIndex) { // wrap around to end
        bedIndex = endIndex;
      }
      checkedBeds++;
    }

    // If no patients found, just draw doctor in current position
    drawPerson();
  }
}
