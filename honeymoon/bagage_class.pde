// Davids del

class bagage {
  int x, y,bagageWidth,bagageHeight;
  boolean knockedOff;
  


  bagage(int tempHeight,int tempWidth, int tempx, int tempy) {   //    constructor
   bagageWidth=tempWidth;
   bagageHeight=tempHeight;
    x = tempx;
    y = tempy;
  }


  void knockOff() {
    x=x+1;
  }
  
  void paint() {
    rect( x, y,bagageWidth,bagageHeight);
  }
}
