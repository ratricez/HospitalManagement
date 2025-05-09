import g4p_controls.*;
int numofwaiting;
Chair[] chairs;

void setup() {
  size(1200, 600);
  background(224, 214, 197);
  noStroke();

  chairs = new Chair[48];

  for (int i = 0; i < 48; i++) {
    int row = i / 8;
    int col = i % 8;

    float x = 30 + col * 35;
    float y = 180 + row * 70;

    chairs[i] = new Chair(new PVector(x, y));
  }
}

void draw() {
  // Draw the background
  stroke(255);
  line(350, 0, 350, 600);
  for (int i = 0; i < chairs.length; i++) {
    chairs[i].drawMe();
  }
  fill(125, 122, 114, 30);
  rect(20, 20, 300, 130, 10);

  // Text
  fill(255);
  textSize(16);
  text("Information Card:", 35, 45);
  textSize(14);
  text("Waiting Room: " + numofwaiting, 35, 70);

}

//300, 450, 450
