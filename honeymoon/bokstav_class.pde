//Joels del

class bokstav {
  int x, y;
  boolean show=false;
  char Char;
  boolean noDisplay = false;



  bokstav(char tempChar, int tempx, int tempy) {   //    constructor
    Char=tempChar;
    x = tempx;
    y = tempy;
    textSize (48);
    fill (0);
        if (Char == ' ' || Char  == '!' || Char == '?' || Char == '.' || Char == ',' || Char == '-'){
        noDisplay = true;
    }
  }



  void update() {

    if (keyPressed) {
      if(parseInt(key)>96){
      key = parseChar(parseInt(key)-32); // konvertera till stor
      println(key);
      }
      if (key == Char) {
        show = true;
      }
    }
  }

  void paint() {
    stroke(0);
    fill(0);
    textSize(48);
    if (show && !noDisplay) {
      text (Char, x, y);
    } else if(show == false && noDisplay == false){
      line (x, y, x+20, y);
    }
  }
  
}

