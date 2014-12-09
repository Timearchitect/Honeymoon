class paralax {
  int type;
  float x, y, w, h, vx, vy, startX, startY;
  PImage pic;
  paralax(int tempType, PImage tempPic, int tempX, int tempY, int tempW, int tempH, float tempVx, int tempVy) {
    type=tempType;    
    pic=tempPic;
    x=tempX;
    y=tempY;
    w=tempW;
    h=tempH;
    vx=tempVx;
    vy=tempVy;
    startX=tempX;
    startY=tempY;
  }

  void update() {
    switch (type) {
    case 0:
      x+=vx;

      break;
    case 1:
      if (x>0) x=-w/2;  //reseting ground when reaching image end
      if (x<-w/2) x=0;  //reseting ground when reaching image end
      x+=vx;
      break;
    }
  }

  void paint() {
    image( pic, int(x), int(y), w, h);   // display image
  }
}

