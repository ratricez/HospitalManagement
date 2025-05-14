void keyPressed() {
  if (key == 'r') {
    int rand = int(random(40)); // Get a random patient index from 0 to 49
    if (patients[rand].occupiedBed != null) {
      patients[rand].occupiedBed.occupied = false; // Free the bed
      Bed freedBed = patients[rand].occupiedBed;
      patients[rand].occupiedBed.occupied = false;
      patients[rand].occupiedBed = null;
      patients[rand].done = true;
      
      if (!waitingqueue.isEmpty()) {
          Patient waitingPatient = waitingqueue.remove(0);
          waitingPatient.occupiedChair.occupied = false;
          waitingPatient.occupiedChair = null;
          waitingPatient.occupiedBed = freedBed;
          freedBed.occupied = true;
          numofwaiting--;
      }

      // need to literally remove patient from patients don't forget
      println("Removed Patient " + rand);
     for (int i = 0; i < beds.length; i++) {
       if (beds[i].occupied == false){
         print(beds[i]);
       }
     }
    }
  }
  
}
