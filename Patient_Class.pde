class Patient extends Person{
    Bed occupiedBed = null;
    Chair occupiedChair = null;
    boolean done = false;

    int severity;
    Patient(int fl, int sv){
      super(fl, color(random(0,255),random(0,255), random(0,255))); 
      this.severity = sv;
    }
    
  
  void goToOccupied(){
    if(this.occupiedBed != null){
      this.xPos = this.occupiedBed.location.x + 15;
      this.yPos = this.occupiedBed.location.y + 15;
    }
    if(this.occupiedChair != null){
      this.xPos = this.occupiedChair.location.x + 15;
      this.yPos = this.occupiedChair.location.y + 15;
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
