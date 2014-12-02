//Joels del

class bokstav {
  int x, y;
  boolean show;
  char Char;


  bokstav(char tempChar, int tempx, int tempy) {   //    constructor
    Char=tempChar;
    x = tempx;
    y = tempy;
  }





  void knockOff() {
    x=x+1;
  }
  
  void paint() {
    text(Char, x, y);
  }
}

