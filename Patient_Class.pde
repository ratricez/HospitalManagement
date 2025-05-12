class Patient extends Person{
    Bed occupiedBed = null;
    Chair occupiedChair = null;
    Patient(int fl){
      super(fl, color(255, 223, 179)); 
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
  

}
