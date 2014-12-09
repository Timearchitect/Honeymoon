/*---------------------------------------------------------------------------------
 //                                                                              //
 //   - projekt "honeymoon"                                                      //
 //   | IDK Programmering                                                        //
 //   av: Anton Blomster , Alrik He ,David Knutsson , Therése , Joel Hagenblad    // 
 //      2014-11-27                                                              //
 //                                                                              //
 //                                                                              //
 --------------------------------------------------------------------------------*/

final String version= " 0.2.0";
import ddf.minim.*;
Minim minim;
AudioPlayer carSound, bagageSound, BGM; // ljud

float angle, zoom=1, maxZoom=5;
float groundL=0;
float carX, carY, carW, carH, carVx, carVy, carAx, carVibrationOffsetX, carVibrationOffsetY;
boolean onGround=true, gameOver=false;
String wrongLetter= "", rightLetter= "";
int randCityIndex;


String loadedCity[] ;// loadstrings from text
String loadedCityName[]; // här kommer all splitade stadsnamn att förvaras

//classer
ArrayList<bokstav> chars =   new  ArrayList<bokstav>(); // empty arrayList för bokstäverna
ArrayList<bagage> lives =   new  ArrayList<bagage>(); // empty arrayList för bokstäverna
ArrayList<particle> particles =   new  ArrayList<particle>(); // empty arrayList för bokstäverna
ArrayList<paralax> layer = new  ArrayList<paralax>(); // empty arrayList för paralax lager
// bilder
PImage bag1, bag2, bag3, bag4, bag5; // bagage olika versionen bilder
PImage building, ground;  // BG
PImage bgImage; // bakgrunds bild
PImage car, wheel1, wheel2; // bakgrunds bild
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
  print("loading images");
  bgImage = loadImage("graphics/parisbg.png");
  print("-");
  building = loadImage("graphics/eiffel.png");
  print("-");
  ground = loadImage("graphics/road-gravel.png");
  print("-");
  bag1 = loadImage("graphics/bag1.png");
  print("-");
  bag2 = loadImage("graphics/bag2.png");
  print("-");
  bag3 = loadImage("graphics/bag3.png");
  print("-");
  bag4 = loadImage("graphics/bag4.png");
  print("-");
  bag5 = loadImage("graphics/bag5.png");
  print("-");
  car = loadImage ("graphics/car.png");
  print("-");
  wheel1 = loadImage ("graphics/wheel-front.png");
  print("-");
  wheel2 = loadImage ("graphics/wheel-rear.png");
  println("|");


  println("loading cities");
   loadedCity = loadStrings("cities.txt");  //ladda in texten till string Arrayn
  println(loadedCity);  
  String loadedCityNames="";    // gör en tom string
  for (int i=0; loadedCity.length > i; i++) {  // sätter samman string arrayn till string med token
    if (i!=loadedCity.length-1) {
      loadedCityNames += loadedCity[i]+ "," ;   // lägger in divider
    } else {
      loadedCityNames += loadedCity[i];  // sista har ingen divider token
    }
  }

  loadedCityNames= loadedCityNames.toUpperCase(); // konvertera till uppercase
  println(loadedCityNames);

  loadedCityName=splitTokens(loadedCityNames, ",");  // splittokens  
  println(loadedCityName);


  randCityIndex = int(random(loadedCityName.length-1));  // randomize city from text file
  println("Total " + (loadedCityName.length -1) + " index, randomized: "  + randCityIndex +" is: "+ loadedCityName[randCityIndex]);
  println("loading letter objects");
  // bokstäverna
  for (int i=0; loadedCityName[randCityIndex].length () > i; i++) {   // create char object
    println(loadedCityName[randCityIndex].charAt(i));
    chars.add(new bokstav(loadedCityName[randCityIndex].charAt(i), 200+i*35, 200));  // add letters
  }

  loadedCityName[randCityIndex]=loadedCityName[randCityIndex].toUpperCase();  // konverterar till upper case
  rightLetter=loadedCityName[randCityIndex];

  // charCode   for ä = 228  å = 229 ö = 246 
  println(parseChar(228), parseChar(229), parseChar(246), parseChar(228-32), parseChar(229-32), parseChar(246-32)); 
  // println("&#228" + "&auml" +"\206");
  println("loading bagage & paralax class objects");

  // bilen
  println("loading graphics");
  carX= width/5;
  carVx= 20;
  carY=groundL-150;
  carW=270;
  carH=160;

  // bagaget
  lives.add(new bagage( bag5, int(50), int(-(30)), 100, 90));
  lives.add(new bagage( bag4, int(150), int(-(30)), 110, 80));
  lives.add(new bagage( bag3, int(80), int(-(90)), 110, 60));
  lives.add(new bagage( bag2, int(100), int(-(150)), 110, 60));
  lives.add(new bagage( bag1, int(140), int(-(210)), 120, 80));

  // paralax layer
  layer.add(new paralax(building, width*2, 0, building.width/2, building.height/2, -1, 0));
  layer.add(new paralax(ground, 0, int( groundL-100), ground.width, ground.height, -10, 0));
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
  background(127);
  pushMatrix();
  translate(mouseX-width/2, mouseY-height/2);
  scale(zoom);

  fill(50, 100, 255);   
  rectMode(NORMAL);
  rect(0, 0, width, height);   // blue background

  //displayBG();
  image( building, width-500, 0, 300, height-300);  // byggnaden

  for (int i=0; i< layer.size (); i++) {   // updaterar & printar all paralax lageri arraylisten
    layer.get(i).update();
    layer.get(i).paint();
  }

  for (int i=0; i< chars.size (); i++) {   // updaterar & printar all bokstäver i arraylisten
    chars.get(i).update();
    chars.get(i).paint();
  }

  updateCar();
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
  fill(255, 0, 0);
  textSize(80);
  textAlign(RIGHT);
  text(wrongLetter, width/2, height-100);
  textAlign(NORMAL);

  popMatrix(); // for zoom
  displayInfo();                // visar lite developer info
}


//--------------------------------------------------------------***************************-----------------------------------------------------------------
//--------------------------------------------------------------*-------------------------*------------------------------------------------------------------
//--------------------------------------------------------------*---------FUNKTIONER------*------------------------------------------------------------------
//--------------------------------------------------------------*-------------------------*------------------------------------------------------------------
//--------------------------------------------------------------***************************-----------------------------------------------------------------



void displayInfo() {  // visa information
  fill(255);
  textSize(26);
  text("version: "+version, width-400, 50);
  text("Zoom: " +  nf(zoom, 1, 1), width-300, 100);
  text("gameOver: " + gameOver, width-300, 150);
   text("Car X Velocity : " + carVx +"    Car Y Velocity : " + carVy , width-300, 200);
}

void displayBG() {
  image(bgImage, 0, 0, bgImage.width*0.4, bgImage.height*0.4);  // bil
}

void reRoll() {
}

void resetGame() {
  resetBagage();
  resetWord();
  reRoll();
  wrongLetter="";
  rightLetter="";
  gameOver=false;
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

