//Joels del

class bokstav {
  int x, y;
  boolean show;
  char Char;


  bokstav(char tempChar, int tempX, int tempY) {   //    constructor
    Char=tempChar;
    x = tempX;
    y = tempY;
  }





  void knockOff() {
    x=x+1;
  }
  
  void paint() {
    text(Char, x, y);
  }
}

