class Person{
  int xPos, yPos, floor;
  color col;
  
  Person(int fl, color c){
    this.floor = fl;
    this.col = c;
  }
  
  void drawPerson(){
    circle(this.xPos, this.yPos, 15);
    
  }
}
