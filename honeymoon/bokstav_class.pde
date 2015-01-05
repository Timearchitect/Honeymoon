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
    if (Char == ' ' || Char  == '!' || Char == '?' || Char == '.' || Char == ',' || Char == '-') {
      noDisplay = true;
    }
  }

  void update() {

    if (keyPressed && !gameOver && !menuScreen) {
      if (parseInt(key)>96 || key == 'å'|| key == 'ä' ||  key == 'ö' ) {
        key = parseChar(parseInt(key)-32); // konvertera till stor
      }
      if (key == Char) {
        show = true;
         carVx =25/loadedCityName[randCityIndex].length(); // move car
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
    } else if (!show && !noDisplay) {
      //line (x, y, x+font.size(), y);
      text ('_', x, y);
    }
  }
}

