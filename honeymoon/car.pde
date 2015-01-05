

void updateCar() {

  carVibrationOffsetX=random(3)-1.5;
  carVibrationOffsetY=random(3)-1.5;
  carVx+=carAx;
  carVx*=0.95;
  carVy*=0.95;
  carX+=carVx;
  carY+=carVy;
  if (carY< groundL-carH) {
    carY*=1.02;
  } else { //onGround
    carVy=0;
    onGround=true;
  }
}

void displayCar(float x, float y, float w, float h) {  // funktion för bilen
  int wheelOffset=10, wheelSize=60;

  angle += (15+carVx)*slowFactor; // rotate
  imageMode(CORNER);
  image(car, int(x+carVibrationOffsetX), int(y+carVibrationOffsetY), w, h);  // bil chassi

  if ( onGround && slowFactor!=0)particles.add(new particle(0, int(x+w-wheelSize), int(y+h+wheelSize/4), -5+random(5), -3+random(2), random(360), 50));  // skapar rök partiklar
  pushMatrix();
  translate( x+w-wheelOffset*8+random(2) +wheelSize/2, y+h-wheelSize/2+random(2)+wheelSize/2);            // front wheel
  rotate(radians(angle));
  image(wheel1, 0-wheelSize/2, 0-wheelSize/2, wheelSize, wheelSize);  // hjul F
  popMatrix();

  if ( onGround && slowFactor!=0)particles.add(new particle(0, int(x+wheelSize/2), int(y+h+wheelSize/4), -5+random(5), -3+random(2), random(360), 50));  // skapar rök partiklar
  pushMatrix();
  translate( x+wheelOffset+wheelSize/2+random(2), y+h-wheelSize/2+random(2)+wheelSize/2);            // front wheel
  rotate(radians(angle));
  image(wheel2, 0-wheelSize/2, 0-wheelSize/2, wheelSize, wheelSize); // hjul B
  popMatrix();
}

