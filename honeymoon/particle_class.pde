class particle {
  float x, y, vx, vy, time=0, timeLimit=10, opacity=90;
  float angle, particleWidth, particleHeight;
  int type;
  particle(int tempType, float tempx, float tempy, float  tempVx, float  tempVy, float tempAngle, int tempSize) {   //    constructor
    type=tempType;
    vx=tempVx;
    vy= tempVy;
    angle=tempAngle;
    particleWidth=random(tempSize);
    particleHeight=particleWidth;
    x = tempx;
    y = tempy;
  }

  void update() {
    if (type==0) {
      x+=vx;
      y+=vy;
      time++;
      opacity-=10;
    } else {
timeLimit=100;
      x+=vx;
      y+=vy;
      time++;
    }
  }

  void paint() {
    if (type==0) {
      noStroke();
      pushMatrix();
      translate(x, y);
      rotate(radians(angle));
      fill(255, opacity);
      rect( 0, 0, particleWidth, particleHeight);
      popMatrix();
    } else {

      image(balloon, x, y, particleWidth, particleHeight);
    }
  }
}

