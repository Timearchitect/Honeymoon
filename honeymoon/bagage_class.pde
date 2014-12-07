// Davids del

class bagage {
  float x, y, bagageWidth, bagageHeight, vx=-8, vy=20, gravitation=4, angle=0, rotationV=0;
  boolean knockedOff=false;
  PImage img;
  float startX, startVx=-5, startVy=20, startY, startAngle=0, startRotationV=0;

  bagage( PImage tempImg, int tempX, int tempY, int tempWidth, int tempHeight) {   //    constructor
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

  void update() {
    if (knockedOff==true) {
      x=x+vx;
      y=y+vy;
      vy+=gravitation;
      vy*=0.97; // decay
      angle-=rotationV;
    }
  }

  void checkBounderies() {
    if (y+bagageWidth/2>groundL) {  // when reaching ground
     particles.add(new particle( x, y+bagageHeight/2, -20+random(10), -8+random(4), random(360)));  // skapar rök partiklar
      vy= vy*-1;
      vy=vy+random(5)-3;
      vx=vx+random(1)-0.6;
      rotationV=rotationV+random(20)-10;
    }
  }

  void paint() {
    pushMatrix();
    translate(x, y);
    rotate(radians(angle));
    image(img, -bagageWidth/2, -bagageHeight/2, bagageWidth, bagageHeight);
    rectMode(CENTER);
    fill(255, 0, 0);
    popMatrix();
  }
}

