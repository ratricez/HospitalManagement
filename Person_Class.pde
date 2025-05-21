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
    rect(this.xPos - 4, this.yPos + -3, 9, 15, 25);
    stroke(0);
    fill(this.col);
    circle(this.xPos, this.yPos - 7, 10);

  }
}
