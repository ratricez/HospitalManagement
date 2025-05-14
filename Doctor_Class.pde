class Doctor extends Person { 
  int bedIndex = 0;    // which bed doc visiting
  boolean Examing = false;
  int waitStartTime = 0; //Stores time the doc started examining (used to time how long they examine)
  Bed[] beds;

  Doctor(int fl, color c, Bed[] beds) {
    super(fl, c);
    this.beds = beds;
    // Sets initial position of doc to bed 1 (top to bottom, left to right)
    xPos = beds[bedIndex].location.x; 
    yPos = beds[bedIndex].location.y;

  }

  void update() {
        if (bedIndex >= beds.length) {
      bedIndex = 0; // Restart from the first bed
     }

    if (Examing) {
      // Wait x seconds (1 sec = 1000 millisecs) have passed since waitStartTime
      if (millis() - waitStartTime >= 200) {
        Examing = false;
        bedIndex++;
      }
  } else {
    // Move to next bed
    if (bedIndex < beds.length) {
      // move horizontally
      xPos = beds[bedIndex].location.x;
      yPos = beds[bedIndex].location.y;
      
      // If occupied, start examining. If not, next bed.
      if (beds[bedIndex].occupied) {
        Examing = true;
        waitStartTime = millis(); // Store current time
      } else {
        bedIndex++;
        }
      }
    }
    drawPerson(); // Draw the doctor
    println("Visiting bed:", bedIndex, "Examing:", Examing);
  }
}
