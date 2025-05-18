//class Doctor extends Person { 
//  int patIndex = 0;    // which bed doc visiting
//  boolean Examing = false;
//  int waitStartTime = 0; //Stores time the doc started examining (used to time how long they examine)
  

//  Doctor(int fl, color c) {
//    super(fl, c);
//  }

//  void update() {
//      if (patIndex >= patients.size()) {
//        patIndex = 0; // Restart from the first patient
//     }

//    if (Examing && patients.get(patIndex).occupiedBed != null) {
//      if (millis() - waitStartTime >= 1000) {
//        if (patients.get(patIndex).calcHealed()) {
//          patients.remove(patIndex);
//          Examing = false;
//          // Don't increment patIndex here because the next patient will shift into this index
//        } else {
//          Examing = false;
//          patIndex++;
//        }
//      }
//  } else {
//    // Move to next bed
//    if (patIndex < patients.size() && patients.get(patIndex).occupiedBed != null) {
//      // move horizontally
//      xPos = patients.get(patIndex).xPos - 15; 
//      yPos = patients.get(patIndex).yPos - 15; 
      
//      // If occupied, start examining. If not, next bed.
//      if (patients.get(patIndex).occupiedBed != null) { //<>//
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


  Doctor(int fl, color c, int startIndex, int endIndex) {
    super(fl, c);
    this.startIndex = startIndex;
    this.endIndex = endIndex;
    this.bedIndex = startIndex;
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
          xPos = patientInBed.xPos - 15;
          yPos = patientInBed.yPos - 15;

          // Start examining patient
          Examing = true;
          waitStartTime = millis();

          drawPerson();
          return; // start exam this frame, done for now
        }
      }

      // Check the next bed if no one
      bedIndex++;
      if (bedIndex > endIndex) { // if they have reached a bed outside their range of beds, go back to first
        bedIndex = startIndex;
      }
      checkedBeds++;
    }

    drawPerson();
  }
}
