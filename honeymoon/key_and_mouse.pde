void keyPressed() {


  if (keyCode== UP)if (onGround)carVy+= -30;
  onGround=false;
  if (keyCode== LEFT) if (carAx>-1) {
    carAx+= -0.1; 
    carVx+= -5;
  }
  if (keyCode== RIGHT)if (carAx<1) {
    carAx+= 0.1;
    carVx+= 5;
  }

  if ( key== '\b' && chars.size()>0) {   // tryck på backspace för att ta bort bokstäverna
    chars.remove(chars.size()-1); // tar bort den sista bokstaven
  }



  if (keyCode == ENTER) {

    resetGame();

  }
  if (keyCode == BACKSPACE) {
    println("\""+wrongLetter + "\" Are int the wrongLetter pool");
    println("\""+rightLetter + "\" Are int the rightLetter pool");
  }

  if ((key >= 'A' && key <= 'z')  || key == 'å' || key == 'Å' || key == 'ä' || key == 'Ä' || key == 'ö' || key == 'Ö') {
    if (key >= 'a') key=char(key-32);   //ENG  alphabet convert key to upper case
    if  (key==229) key=char(key-32); // å
    if  (key==228) key=char(key-32); // ä
    if  (key==246) key=char(key-32); // ö
    println(char(key));

    if ( checkLetters(rightLetter, key) == true) {
    } else if (  checkLetters(wrongLetter, key)==false) {   // when key does not exist in the pool. Add key to the pool
      wrongLetter=wrongLetter + str(key);     
      loseLife(); // drop bagage
    }
  }
}




void keyReleased() {
}


void mousePressed() {
  if  (mouseButton == RIGHT) {     // clicka med musen för att ta tillbaka bagagen till dessa koordinater
    resetGame();
  } else {
    loseLife();
  }
}

void mouseWheel(MouseEvent event) {  // krympa och förstora
  int temp = event.getCount() ;
  zoom += temp * 0.05;
  if (zoom<=0) {
    zoom=0.1;
  }

  if (zoom > maxZoom) {
    zoom=maxZoom;
  }
}

boolean checkLetters(String string, int charCode) {   // check letters to string
  boolean match = false;
  for (int i=0; i < string.length (); i++) {
    println(int(string.charAt(i)) + "   " + charCode);
    if ( int(string.charAt(i))==charCode) {    // if the key is in the  letter pool return true
      match=true;
    }
  }
  println(match);
  return match;
}

