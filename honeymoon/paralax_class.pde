class paralax {
  int type, zIndex;
  float x, y, w, h, vx, vy, startX, startY;
  PImage pic;
  paralax(int tempType, PImage tempPic, int tempX, int tempY, int tempW, int tempH, float tempVx, int tempVy, int tempZIndex) {
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
    zIndex = tempZIndex;
  }

  void update() {
    switch (type) {
    case 0:
    
      if(x<width/2)x=width/2;
      break;
    case 1: // fullsceen x 2
      if (x>0) x=-w/2;  //reseting ground when reaching image end backwards
      if (x<-w/2) x=0;  //reseting ground when reaching image end forwards
  
      break;

    case 2:
      if (x+w<0) x=width +random(width*2);  //reseting ground when reaching image end forwards

      break;

    case 3: // fullsceen x 2 sky
      if (x>0) x=-w/2;  //reseting ground when reaching image end backwards
      if (x<-w/2) x=0;  //reseting ground when reaching image end forwards
  
      break;

    default: // fullsceen x 2
      if (x>0) x=-w/2;  //reseting ground when reaching image end backwards
      if (x<-w/2) x=0;  //reseting ground when reaching image end forwards
     
    }
     x+=vx*slowFactor;
  }

  void paint() {


    if (type==3) {   
      //tint(255, 220);
      image( pic, int(x), int(y), w, h);   // display image
      //  tint(255, 255);
    } else {

      image( pic, int(x), int(y), w, h);   // display image
    }
  }
}

