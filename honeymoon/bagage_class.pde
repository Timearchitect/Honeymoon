// Davids del

class bagage {
  float x, y, bagageWidth, bagageHeight, vx=-8, vy=20, gravitation=4, angle=0, rotationV=0, vibrationOffsetX, vibrationOffsetY, parentX, parentY;
  boolean knockedOff;
  PImage img;
  float startX, startVx=-5, startVy=20, startY, startAngle=0, startRotationV=0;


  bagage( PImage tempImg, int tempX, int tempY, int tempWidth, int tempHeight) {   //    constructor

    parentX=carX;
    parentY=carY;
    startX=tempX;
    startVx=-8;
    startVy=20;
    startY=tempY;
    startAngle=0;
    startRotationV=0;

    img=tempImg;
    bagageWidth=tempWidth;
    bagageHeight=tempHeight;
    x = tempX;
    y = tempY;
  }
  void knockOff() {
    knockedOff=true;
    vx=random(-10)-2-carVx;
    vy=random(-20) +carVy;
    // bagageDrop.rewind();
    //bagageDrop.play();
  }

  void update() {
    if (knockedOff) {
      x=x+vx;
      y=y+vy;
      vy+=gravitation;
      vy*=0.97; // decay
      angle-=rotationV;
    } else {
      vibrationOffsetX=carVibrationOffsetX;
      vibrationOffsetY=carVibrationOffsetY;
      parentX=carX;
      parentY=carY;
    }
  }

  void checkBounderies() {
    if (y+bagageWidth/2>groundL-parentY) {  // when reaching ground bounceing off ground
      particles.add(new particle( x+parentX, y+bagageHeight/2+parentY, -20+random(10), -8+random(4), random(360)));  // skapar rök partiklar
      vy= vy*-1;
      vy=vy+random(5)-3;
      vx=vx+random(2)-1.6;
      rotationV=rotationV+random(20)-10;
      // bagageDrop.rewind();
      //bagageDrop.play();
    }

    if (x<0 || x>width) {
      //bagageDrop.mute();
    }
  }

  void paint() {
    pushMatrix();
    translate(int(x+parentX), int(y+parentY));
    rotate(radians(angle));
    image(img, int(-bagageWidth/2+vibrationOffsetX), int(-bagageHeight/2+vibrationOffsetY), bagageWidth, bagageHeight);
    rectMode(CENTER);
    fill(255, 0, 0);
    popMatrix();
  }
}
//--------------------------------------------------------------***************************-----------------------------------------------------------------
//--------------------------------------------------------------*---------------------------*------------------------------------------------------------------
//--------------------------------------------------------------*-------UTANFÖR KLASSEN-----*------------------------------------------------------------------
//--------------------------------------------------------------*---------------------------*------------------------------------------------------------------
//--------------------------------------------------------------***************************-----------------------------------------------------------------


void loseLife() {
  int life=lives.size ()-1;
  for (int i=lives.size ()-1; i >= 0; i-- ) {
    if (lives.get(i).knockedOff==true)life--;
  }
  if (life==0)gameOver=true; // check if game over

  for (int i=lives.size ()-1; i >= 0; i-- ) { // reverse index because of display layer order
    if (!lives.get(i).knockedOff) {
      lives.get(i).knockOff(); // knock the bagage off the car
      break;
    }
  }
}

