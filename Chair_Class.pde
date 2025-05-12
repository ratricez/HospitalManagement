class Chair extends Furniture{
    Chair(PVector p){
      super(p, color(150, 100, 50)); 
    }

  void drawMe() {
    fill(col);
    rect(location.x, location.y, 30, 30);  // width and height of each chair
  }
  
  
}
