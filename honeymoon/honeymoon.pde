
/*---------------------------------------------------------------------------------
 //                                                                              //
 //   - projekt "honeymoon"                                                      //
 //   | IDK Programmering                                                        //
 //   av: Anton Blomster , Alrik He ,David Knutsson , Therése , Joel Hagenblad    // 
 //      2014-11-27                                                              //
 //                                                                              //
 //                                                                              //
 --------------------------------------------------------------------------------*/
final String version= " 0.0.2";
import ddf.minim.*;

Minim minim;
AudioPlayer BGM;


String loadedCityName[]; // här kommer all stadsnamn att förvaras
int x, y;
//classer
ArrayList<bokstav> chars =   new  ArrayList<bokstav>(); // empty arrayList för bokstäverna
ArrayList<bagage> lives =   new  ArrayList<bagage>(); // empty arrayList för bokstäverna
ArrayList<particle> particles =   new  ArrayList<particle>(); // empty arrayList för bokstäverna
PImage img1, img2, img3, img4;
PImage bgImage; // bakgrunds bild

void setup() {
  /*
  bgImage = loadImage("background.png");
   img1 = loadImage("picture1.png");
   img2 = loadImage("picture2.png");
   img3 = loadImage("picture3.png");
   img4 = loadImage("picture4.png");
   */
  size(displayWidth, displayHeight, OPENGL);
  if (frame != null) {  // gör program fönstret skalbar
    frame.setResizable(true);
  }
  String loadedCityName[] = loadStrings("cities.txt");  //ladda in texten till string Arrayn
  println(loadedCityName);   

  // charCode   for ä = 228  å = 229 ö = 246 
  println(parseChar(228), parseChar(229), parseChar(246), parseChar(228-32), parseChar(229-32), parseChar(246-32)); 
  println("&#228" + "&auml" +"\206");
  //lives.add(new bagage(img3,50,100, 280, 200));
  lives.add(new bagage(180, 150, 450, 150));
  lives.add(new bagage(100, 200, 410, 100));

  chars.add(new bokstav('e', 100, 200));
  chars.add(new bokstav('r', 100, 300));
  chars.add(new bokstav('e', 100, 400));
  chars.add(new bokstav('r', 100, 500));
  chars.add(new bokstav('e', 500, 200));
  chars.add(new bokstav('r', 500, 300));
  chars.add(new bokstav('e', 500, 400));
  chars.add(new bokstav('r', 500, 500));
}

void draw() {
  background(255/2);

  for (int i=0; i< chars.size (); i++) {   // updaterar & printar all bokstäver i arraylisten
    chars.get(i).knockOff();
    chars.get(i).paint();
  }

  for (int i=0; i< lives.size (); i++) {  // updaterar & printar all bagage i arraylisten
    lives.get(i).knockOff();
    lives.get(i).checkBounderies();
    lives.get(i).paint();
  }

  particles.add(new particle( mouseX+random(10)-5, mouseY+random(10)-5, -5+random(5), -3+random(2), random(360)));  // skapar rök partiklar

  for (int i=0; i< particles.size (); i++) {    // updaterar & printar all rök i arraylisten
    particles.get(i).paint();
    particles.get(i).update();
    if (particles.get(i).time>particles.get(i).timeLimit) { // kollar om partiklen ska tas bort beroende på hur länge den har levt
      particles.remove(i);
      i--;
    }
  }

  displayCar((width/4), (height/4)*3-100, (width/4)+250, (height/4)*3) ; // ritar bilen ()
  displayInfo();                // visar lite developer info

    if (keyPressed && key== '\b' && chars.size()>0) {   // tryck på backspace för att ta bort bokstäverna
    chars.remove(chars.size()-1);
  }
  if  ( mousePressed ) {     // clicka med musen för att ta tillbaka bagagen till dessa koordinater
    for (int i=0; i< lives.size (); i++) {
      lives.get(i).x=(width/4);
      lives.get(i).y=(height/4)*3-100;
    }
  }
}

void displayCar(float x, float y, float w, float h) {  // funktion för bilen
  int wheelOffset=50;
  rectMode(NORMAL);
  rect(x, y, w, h);
  ellipseMode(CENTER);
  ellipse(x+(w-x)-wheelOffset, h, 50, 50);
  ellipse(x+wheelOffset, h, 50, 50);
}



void displayInfo() {  // visa information
  fill(255);
  text(version, width-100, 50);
}

void keyPressed() {
}

void keyReleased() {
}


void mousePressed() {
}

