class Bed extends Furniture{
  
  Bed(PVector p){
    super(p, color(40, 30, 180));
  }
  
  void drawMe(){
    fill(col);
    rect(location.x, location.y, 30, 30);  // width and height of each objecct
    fill(255);
    rect(location.x+5, location.y, 20, 10);
    
  }
  

}
