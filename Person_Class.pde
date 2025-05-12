class Person{
  float xPos, yPos; // floor 0 = waiting room, floor 1 = in-patient
  int floor;
  color col;
  
  
  Person(int fl, color c){
    this.floor = fl;
    this.col = c;
  }
  
  void drawPerson(){
    fill(this.col);
    noStroke();
    circle(xPos, yPos, 15);

  }
}
