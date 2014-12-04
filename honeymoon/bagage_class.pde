// Davids del

class bagage{
  float x, y, bagageWidth, bagageHeight, vx=-3, vy=20,gravitation=5,angle=0;
  boolean knockedOff=true;
  PImage img;
// bagage(PImage tempImg, int tempHeight, int tempWidth, int tempx, int tempy) {   //    constructor
  bagage( int tempHeight, int tempWidth, int tempX, int tempY) {   //    constructor
  //img=tempImg;
    bagageWidth=tempWidth;
    bagageHeight=tempHeight;
    x = tempX;
    y = tempY;
  }


  void knockOff() {
    if (knockedOff==true) {
      x=x+vx;
      y=y+vy;
      vy+=gravitation;
      vy*=0.99; // decay
      angle-=10;
    }
  }

  void checkBounderies() {
    if (y>height) {
      //vy*=-1;
      vy= vy*-1;
    }
  }

  void paint() {
    pushMatrix();
    translate(x,y);
    rotate(radians(angle));
   // image(img,x,y,bagageWidth,bagageHeight);
    rectMode(CENTER);
    rect( 0, 0, bagageWidth, bagageHeight);
    popMatrix();
  }
}

