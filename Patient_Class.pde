class Patient extends Person {
    Bed occupiedBed = null;
    Chair occupiedChair = null;
    boolean done = false;

    int severity;

    // Movement control
    float targetX, targetY;
    boolean movingToTarget = false;
    float moveSpeed = 0.02; // Controls smoothness and speed of movement

    Patient(int fl, int sv) {
        super(fl, color(random(0, 255), random(0, 255), random(0, 255))); 
        this.severity = sv;

        // Start all patients at the bottom-left corner
        this.xPos = 325;
        this.yPos = 600;
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
      int base = 3; //base chance of 1/3
      int chanceNum = base * this.severity;
      if(int(random(chanceNum)) == 0){
        return true;
      }
      else return false;
    
   }
  

}
