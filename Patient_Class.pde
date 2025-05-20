class Patient extends Person {
    Bed occupiedBed = null;
    Chair occupiedChair = null;
    boolean done = false;
    int base = 3; 

    int severity;

    // Movement control
    float targetX, targetY;
    boolean movingToTarget = false;
    float moveSpeed = 0.02; // Controls smoothness and speed of movement

    Patient(int fl, int sv) {
        super(fl, color(100)); 
        this.severity = sv;

        // Start all patients at the bottom-left corner
        this.xPos = 325;
        this.yPos = 600;

         // Assign color based on severity [Medical Triage]
        if (severity == 1) {
            this.col = color(0, 255, 0);      // Green = can be delayed 
        } else if (severity == 2) {
            this.col = color(245, 255, 0);   // Yellow = urgent/as soon as possible
        } else if (severity == 3) {
            this.col = color(255, 0, 0);    // Red = Emergency 
        } else {
            this.col = color(100);         // Default gray
          }
    }

    void goToOccupied() {
        if (this.occupiedBed != null) {
            targetX = this.occupiedBed.location.x + 15;
            targetY = this.occupiedBed.location.y + 15;
            movingToTarget = true;
        }
        if (this.occupiedChair != null) {
            targetX = this.occupiedChair.location.x + 15;
            targetY = this.occupiedChair.location.y + 15;
            movingToTarget = true;
        }
    }

    void moveToTarget() {
        if (movingToTarget) {
            xPos = lerp(xPos, targetX, moveSpeed);
            yPos = lerp(yPos, targetY, moveSpeed);

            if (dist(xPos, yPos, targetX, targetY) < 1) {
                xPos = targetX;
                yPos = targetY;
                movingToTarget = false;
            }
        }
    }
  
    boolean calcHealed(){
      int chanceNum = base * this.severity;
      println(chanceNum);
      if(int(random(chanceNum)) == 0){
        return true;
      }
      else{
            if(base - 1 != 0) base -= 1;
            return false;
    }
    
   }
  

}
