class particle {
  float x, y, vx, vy, time=0, timeLimit=10, opacity=90;
  float angle, particleWidth, particleHeight;

  particle( float tempx, float tempy, float  tempVx, float  tempVy, float tempAngle) {   //    constructor
    vx=tempVx;
    vy= tempVy;
    angle=tempAngle;

    particleWidth=random(50);
    particleHeight=particleWidth;
    x = tempx;
    y = tempy;
  }

  void update() {
    x+=vx;
    y+=vy;
    time++;
    opacity-=10;
  }

  void paint() {
    noStroke();
    pushMatrix();
    translate(x, y);
    rotate(radians(angle));
    fill(255, opacity);
    rect( 0, 0, particleWidth, particleHeight);
    popMatrix();
  }
}

