class particle {
  int type, x, y, time=0, timeLimit=10;
  float  angle, w, h, vx, vy, ax, opacity=90;

  particle(int tempType, int tempx, int tempy, float  tempVx, float  tempVy, float tempAngle, int tempSize) {   //    constructor
    type=tempType;
    vx=tempVx;
    vy= tempVy;
    angle=tempAngle;
    w=random(tempSize)+1;
    h=w;
    x = tempx;
    y = tempy;
  }

  void update() {
    vx+=ax;
    x+=vx;
    y+=vy;
    time++;
    if (type==0) { // smoke particle
      opacity-=10;
    } else {    // ballon particle
      timeLimit=100;
    }
  }

  void speedTrough() { // switchig screen
    ax=-2;
  }

  void paint() {
    if (type==0) { // smoke
      noStroke();
      pushMatrix();
      translate(x, y);
      rotate(radians(angle));
      fill(255, opacity);
      rect( 0, 0, w, h);
      popMatrix();
    } else {

      image(balloon, x, y, w, h);
      // string on the balloons
      PVector p1= new PVector(x+w/2, y+h), p2=new PVector(x+w/2, y+h*4), c1=new PVector(x+w/2+sin(radians(y+vy))*w, y+h*2), c2 =new PVector(x+w/2-sin(radians(y+vy))*w, y+h*3);
      noFill();
      stroke(255, 100, 100);
      strokeWeight(int(w/40));
      bezier(int(p1.x), int(p1.y), int(c1.x), int(c1.y), int(c2.x), int(c2.y), int(p2.x), int(p2.y));
    }
  }
}

