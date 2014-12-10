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
        if (Char == ' ' || Char  == '!' || Char == '?' || Char == '.' || Char == ',' || Char == '-'){
        noDisplay = true;
    }
  }

  void update() {
    if (keyPressed && !gameOver) {
      if(parseInt(key)>96 ){
      key = parseChar(parseInt(key)-32); // konvertera till stor
      //println(key);
      }
      if (key == Char) {
        show = true;
      }
    }
  }

  void paint() {
    stroke(0);
    strokeWeight(5);
    fill(0);
    textSize(fontSize);
    if (show && !noDisplay) {
      text (Char, x, y);
    } else if(show == false && noDisplay == false){
      //line (x, y, x+font.size(), y);
      text ('_', x, y);
    }
  }
  
}

