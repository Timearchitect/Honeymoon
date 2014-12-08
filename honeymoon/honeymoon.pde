
/*---------------------------------------------------------------------------------
 //                                                                              //
 //   - projekt "honeymoon"                                                      //
 //   | IDK Programmering                                                        //
 //   av: Anton Blomster , Alrik He ,David Knutsson , Therése , Joel Hagenblad    // 
 //      2014-11-27                                                              //
 //                                                                              //
 //                                                                              //
 --------------------------------------------------------------------------------*/
final String version= " 0.1.2";
import ddf.minim.*;
Minim minim;
AudioPlayer carSound, bagageSound, BGM;
float angle, zoom=1, maxZoom=5;
float groundL=0;
float carX, carY, carW, carH;



String loadedCityName[]; // här kommer all stadsnamn att förvaras
int x, y, groundX=0, groundXv=-10;
//classer
ArrayList<bokstav> chars =   new  ArrayList<bokstav>(); // empty arrayList för bokstäverna
ArrayList<bagage> lives =   new  ArrayList<bagage>(); // empty arrayList för bokstäverna
ArrayList<particle> particles =   new  ArrayList<particle>(); // empty arrayList för bokstäverna
ArrayList<paralax> layer = new  ArrayList<paralax>(); // empty arrayList för paralax lager
// bilder
PImage img1, img2, img3, img4, img5; // bagage olika versionen bilder
PImage building, ground;  // BG
PImage bgImage; // bakgrunds bild

PImage car; // bakgrunds bild
PImage wheel1; // bakgrunds bild
PImage wheel2; // bakgrunds bild
PFont font;

//--------------------------------------------------------------***************************-----------------------------------------------------------------
//--------------------------------------------------------------*-------------------------*------------------------------------------------------------------
//--------------------------------------------------------------*---------SETUP-----------*------------------------------------------------------------------
//--------------------------------------------------------------*-------------------------*------------------------------------------------------------------
//--------------------------------------------------------------***************************-----------------------------------------------------------------


void setup() {

  size(displayWidth, displayHeight, OPENGL);
  groundL=(height/5)*4;
  if (frame != null) {  // gör program fönstret skalbar
    frame.setResizable(true);
  }

  // create font
  println("loading font");
  font = loadFont("Chalkduster-48.vlw");
  textFont (font);

  // bilder
  println("loading images");
  bgImage = loadImage("graphics/parisbg.png");  
  building = loadImage("graphics/eiffel.png");
  ground = loadImage("graphics/road-gravel.png");
  img1 = loadImage("graphics/bag1.png");
  img2 = loadImage("graphics/bag2.png");
  img3 = loadImage("graphics/bag3.png");
  img4 = loadImage("graphics/bag4.png");
  img5 = loadImage("graphics/bag5.png");
  car = loadImage ("graphics/car.png");
  wheel1 = loadImage ("graphics/wheel-front.png");
  wheel2 = loadImage ("graphics/wheel-rear.png");

  println("loading cities");
  String loadedCityName[] = loadStrings("cities.txt");  //ladda in texten till string Arrayn
  println(loadedCityName);  
  int randCityIndex = int(random(loadedCityName.length-1));  // randomize city from text file
  println(randCityIndex); 
  loadedCityName[randCityIndex]=loadedCityName[randCityIndex].toUpperCase();  // konverterar till upper case
  println(loadedCityName[randCityIndex]); 
  // charCode   for ä = 228  å = 229 ö = 246 
  println(parseChar(228), parseChar(229), parseChar(246), parseChar(228-32), parseChar(229-32), parseChar(246-32)); 
  println("&#228" + "&auml" +"\206");
  println("loading class objects");

  // bilen
  println("loading graphics");
  carX= width/4;
  carY=groundL-150;
  carW=270;
  carH=160;

  // bagaget
  lives.add(new bagage( img5, int(carX+50), int(carY-(30)), 100, 90));
  lives.add(new bagage( img4, int(carX+150), int(carY-(30)), 110, 80));
  lives.add(new bagage( img3, int(carX+80), int(carY-(90)), 110, 60));
  lives.add(new bagage( img2, int(carX+100), int( carY-(150)), 110, 60));
  lives.add(new bagage( img1, int(carX+140), int(carY-(210)), 120, 80));


  // bokstäverna
  chars.add(new bokstav('N', 100, 100));
  chars.add(new bokstav('E', 130, 100));
  chars.add(new bokstav('W', 160, 100));
  chars.add(new bokstav(' ', 190, 100));
  chars.add(new bokstav('Y', 220, 100));
  chars.add(new bokstav('O', 250, 100));
  chars.add(new bokstav('R', 280, 100));
  chars.add(new bokstav('K', 310, 100));

  String wrongLetter;

  // paralax layer
  layer.add(new paralax(building, width*2, 0, building.width/2, building.height/2, -1, 0));
  layer.add(new paralax(ground, 0, int( groundL), ground.width, ground.height, -20, 0));



  // ljud och musik
  println("loading sound FX");
  minim = new Minim(this);    
  carSound= minim.loadFile("FX/carSound.mp3");
  carSound.play();
}


//--------------------------------------------------------------***************************-----------------------------------------------------------------
//--------------------------------------------------------------*-------------------------*------------------------------------------------------------------
//--------------------------------------------------------------*---------LOOP------------*------------------------------------------------------------------
//--------------------------------------------------------------*-------------------------*------------------------------------------------------------------
//--------------------------------------------------------------***************************-----------------------------------------------------------------


void draw() {
  background(255/2);
  pushMatrix();
  translate(mouseX-width/2, mouseY-height/2);
  scale(zoom);

  fill(50, 100, 255, 150);   
  rectMode(NORMAL);
  rect(0, 0, width, height);   // background

  //displayBG();
  image( building, width-500, 0, 300, height-300);  // byggnaden

  for (int i=0; i< layer.size (); i++) {   // updaterar & printar all bokstäver i arraylisten
    layer.get(i).update();
    layer.get(i).paint();
  }

  for (int i=0; i< chars.size (); i++) {   // updaterar & printar all bokstäver i arraylisten
    chars.get(i).update();
    chars.get(i).paint();
  }

  displayCar(carX, carY, carW, carH); // ritar bilen ()
  for (int i=0; i< lives.size (); i++) {  // updaterar & printar all bagage i arraylisten
    lives.get(i).update();
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

  if (keyPressed && key== '\b' && chars.size()>0) {   // tryck på backspace för att ta bort bokstäverna
    chars.remove(chars.size()-1); // tar bort den sista bokstaven
  }

  if  ( mousePressed && mouseButton == RIGHT) {     // clicka med musen för att ta tillbaka bagagen till dessa koordinater
    resetBagage();
    resetWord();
  }


  popMatrix(); // for zoom
  displayInfo();                // visar lite developer info
}


//--------------------------------------------------------------***************************-----------------------------------------------------------------
//--------------------------------------------------------------*-------------------------*------------------------------------------------------------------
//--------------------------------------------------------------*---------FUNKTIONER------*------------------------------------------------------------------
//--------------------------------------------------------------*-------------------------*------------------------------------------------------------------
//--------------------------------------------------------------***************************-----------------------------------------------------------------


void displayCar(float x, float y, float w, float h) {  // funktion för bilen
  int wheelOffset=10, wheelSize=58;
  angle += 15;
  rectMode(NORMAL);
  imageMode(CORNER);
  //rect(x, y, w, h);
  image(car, x+random(2), y+random(2), w, h);  // bil

  ellipseMode(CENTER);

  particles.add(new particle( x+w-wheelSize, y+h+wheelSize/4, -5+random(5), -3+random(2), random(360)));  // skapar rök partiklar
  pushMatrix();
  translate( x+w-wheelOffset*8+random(2) +wheelSize/2, y+h-wheelSize/2+random(2)+wheelSize/2);
  rotate(radians(angle));
  image(wheel1, 0-wheelSize/2, 0-wheelSize/2, wheelSize, wheelSize);  // hjul F
  popMatrix();

  particles.add(new particle( x+wheelSize/2, y+h+wheelSize/4, -5+random(5), -3+random(2), random(360)));  // skapar rök partiklar
  pushMatrix();
  translate( x+wheelOffset+wheelSize/2+random(2), y+h-wheelSize/2+random(2)+wheelSize/2);
  rotate(radians(angle));
  image(wheel2, 0-wheelSize/2, 0-wheelSize/2, wheelSize, wheelSize); // hjul B
  popMatrix();
}

void displayInfo() {  // visa information
  fill(255);
  textSize(26);
  text("version: "+version, width-400, 50);
  text("Zoom: " +  nf(zoom, 1, 1), width-300, 100);
}

void displayBG() {
  image(bgImage, x, y, bgImage.width*0.4, bgImage.height*0.4);  // bil
}

void resetBagage() {
  for (int i=0; i< lives.size (); i++) {
    lives.get(i).x= lives.get(i).startX;
    lives.get(i).vx= lives.get(i).startVx;
    lives.get(i).vy= lives.get(i).startVy;
    lives.get(i).y= lives.get(i).startY;
    lives.get(i).angle=lives.get(i).startAngle;
    lives.get(i).rotationV=lives.get(i).startRotationV;
    lives.get(i).knockedOff= false;
  }
}

void resetWord() {
  for (int i=0; i< chars.size (); i++) {
    chars.get(i).show=false;
  }
}

