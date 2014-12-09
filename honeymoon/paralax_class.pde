class paralax {
  float x, y, w, h, vx, vy;
  PImage pic;
  paralax(PImage tempPic, int tempX, int tempY, int tempW, int tempH, int tempVx, int tempVy) {
    pic=tempPic;
    x=tempX;
    y=tempY;
    w=tempW;
    h=tempH;
    vx=tempVx;
    vy=tempVy;
  }

  void update() {
    if (x>0) x=-w/2;  //reseting ground when reaching image end
    if (x<-w/2) x=0;  //reseting ground when reaching image end
    x+=vx;
  }

  void paint() {
    image( pic, int(x), int(y),w,h);   // display image
  }
}

