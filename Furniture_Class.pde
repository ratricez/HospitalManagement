class Furniture {
  PVector location;
  color col;
  boolean occupied;
  
  //CONSTRUCTOR #1 for Furniture Objects
  Furniture(PVector p, color c) {    
   this.location = p;
   this.col = c;
  }
  
 
 

  void drawMe() {
    fill(col);
    rect(location.x, location.y, 30, 30);  // width and height of each objecct
  }

}
