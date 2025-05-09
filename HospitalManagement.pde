import g4p_controls.*;
int numofwaiting;
Furniture[] chairs;

void setup(){
  size(1200, 600);
  background(224, 214, 197);
  noStroke();
  
  chairs = new Furniture[50];

  for (int i = 0; i < 50; i++) {
    int row = i / 5;
    int col = i % 5;
    
    float x = 30 + col * 35;
    float y = 40 + row * 80; 
    
    chairs[i] = new Furniture(new PVector(x, y), color(150, 100, 50));
  }



}

void draw(){
  // Draw the background 
  stroke(255);
  line(350, 0, 350, 600);
  for (int i = 0; i < chairs.length; i++) {
    chairs[i].drawMe();
  }

}

//300, 450, 450
