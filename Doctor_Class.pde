class Doctor extends Person { 
  int patIndex = 0;    // which bed doc visiting
  boolean Examing = false;
  int waitStartTime = 0; //Stores time the doc started examining (used to time how long they examine)
  

  Doctor(int fl, color c) {
    super(fl, c);
  }

  void update() {
      if (patIndex >= patients.size()) {
        patIndex = 0; // Restart from the first patient
     }

    if (Examing && patients.get(patIndex).occupiedBed != null) {
      if (millis() - waitStartTime >= 1000) {
        if (patients.get(patIndex).calcHealed()) {
          patients.remove(patIndex);
          Examing = false;
          // Don't increment patIndex here because the next patient will shift into this index
        } else {
          Examing = false;
          patIndex++;
        }
      }
  } else {
    // Move to next bed
    if (patIndex < patients.size() && patients.get(patIndex).occupiedBed != null) {
      // move horizontally
      xPos = patients.get(patIndex).xPos - 15; 
      yPos = patients.get(patIndex).yPos - 15; 
      
      // If occupied, start examining. If not, next bed.
      if (patients.get(patIndex).occupiedBed != null) { //<>//
        Examing = true;
        waitStartTime = millis(); // Store current time
      } else {
        patIndex++;
        }
      }
    }
    drawPerson(); // Draw the doctor
    //println("Visiting bed:", patIndex, "Examing:", Examing);
  }
}
