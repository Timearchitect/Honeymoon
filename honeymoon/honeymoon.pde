/*---------------------------------------------------------------------------------
 //                                                                              //
 //   - projekt "honeymoon"                                                      //
 //   | IDK Programmering                                                        //
 //   av: Anton Blomster , Alrik He ,David Knutsson , Therése , Joel Hagenblad    // 
 //      2014-11-27                                                              //
 //                                                                              //
 //                                                                              //
 --------------------------------------------------------------------------------*/



/* -----META    DATA-----------//
 // when editing guess words in the text doc 
 //you need to change the picture to the same name
 //and the music otherwise default placeholders is executed
 //
 */

final String version= " 0.4.1";
import ddf.minim.*;
Minim minim;
AudioPlayer carSound; // ljud
AudioPlayer bagageSound;
AudioPlayer BGM;
AudioPlayer bagageDrop ,intro;

float  zoom=1, targetZoom= 0.7, zoomFactor=0.99, maxZoom=5;
float groundL=0, angle, slowFactor=1, addSlow=-0.004, fadeFactor=1, decreaseVolume=-0.002;
float carX, carY, carW, carH, carVx, carVy, carAx, carVibrationOffsetX, carVibrationOffsetY, startBurst=25;
boolean onGround=true, gameOver, menuScreen=true, victoryScreen, animation=true, enableZoom; // screens
String wrongLetter= "", rightLetter= "";
int randCityIndex, letterSpacing= 70, fontSize=80, wrongLetterOffsetX=200, wrongLetterOffsetY=300, rightLetterOffsetX=200, rightLetterOffsetY=200;
int gameOverDelay=60, gameOverTimer;

String loadedCity[] ;// loadstrings from text
String loadedCityName[]; // här kommer all splitade stadsnamn att förvaras

//classer
ArrayList<bokstav> chars =   new  ArrayList<bokstav>(); // empty arrayList för bokstäverna
ArrayList<bagage> lives =   new  ArrayList<bagage>(); // empty arrayList för bokstäverna
ArrayList<particle> particles =   new  ArrayList<particle>(); // empty arrayList för bokstäverna
ArrayList<paralax> layer = new  ArrayList<paralax>(); // empty arrayList för paralax lager
// bilder
PImage bag1, bag2, bag3, bag4, bag5; // bagage olika versionen bilder
PImage building, ground, tree, balloon, lamp;  // BG
PImage clouds; // bakgrunds bild
PImage startPage;// screens
PImage car, wheel1, wheel2; // bil grafik
PFont font, title;

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

  println("loading cities");
  loadedCity = loadStrings("cities.txt");  //ladda in texten till string Arrayn
  println(loadedCity);  
  String loadedCityNames="";    // gör en tom string måste ha något i den för att lägger divider

  for (int i=0; loadedCity.length > i; i++) {  // sätter samman string arrayn till string med token
    if (i!=loadedCity.length-1) {
      loadedCityNames += loadedCity[i]+ "," ;   // lägger in divider
    } else {
      loadedCityNames += loadedCity[i];  // sista har ingen divider token
    }
  }

  loadedCityNames= loadedCityNames.toUpperCase(); // konvertera till uppercase
  println(loadedCityNames);

  loadedCityName=splitTokens(loadedCityNames, ",");  // splittokens  stringArray
  println(loadedCityName);

  reRoll(); // randomize from text

  // bokstäverna
  println("loading letter objects");
  createLetterObject();


  loadedCityName[randCityIndex]=loadedCityName[randCityIndex].toUpperCase();  // konverterar till upper case
  rightLetter=loadedCityName[randCityIndex];

  // charCode   for ä = 228  å = 229 ö = 246 
  println(parseChar(228), parseChar(229), parseChar(246), parseChar(228-32), parseChar(229-32), parseChar(246-32)); 
  // println("&#228" + "&auml" +"\206"); html

  // create font
  println("loading font");
  font = loadFont("Chalkduster-48.vlw");
  textFont (font);
  title = loadFont("GiddyupStd-68.vlw");

  // bilder
  print("loading images");
  clouds = loadImage("graphics/clouds.png");
  print("-");
  startPage = loadImage("graphics/startPage.jpg");
  print("-");
  building = loadImage("graphics/"+ (loadedCityName[randCityIndex]).toLowerCase()+".png");
  print("-");
  ground = loadImage("graphics/road-gravel.png");
  print("-");
  tree = loadImage("graphics/tree.png");
  print("-");
  balloon = loadImage("graphics/balloon.png");
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
  lamp = loadImage ("graphics/lamp.png");
  print("-");
  wheel1 = loadImage ("graphics/wheel-front.png");
  print("-");
  wheel2 = loadImage ("graphics/wheel-rear.png");
  println("|");

  // bilen
  println("loading graphics");
  carX= 0;
  carVx= startBurst;
  carY=groundL-150;
  carW=270;
  carH=160;

  // bagaget
  println("loading bagage  class objects");
  createBagageObject();

  // paralax layer
  println("loading paralax class objects");
  layer.add(new paralax(3, clouds, width, -200, int(width*2.5), int(height*1), -0.1, 0, 0));// cloud background
  // layer.add(new paralax(0, building, width-300, 200, width/7, height/2, -0.2, 0, 0));// background
  layer.add(new paralax(0, building, width-300, int(groundL-building.height), building.width, -building.height, -0.2, 0, 0));// background
  layer.add(new paralax(1, ground, 0, int( groundL-110), width*2, ground.height, -5, 0, 0));
  layer.add(new paralax(1, ground, 0, int( groundL-80), width*3, ground.height*3, -10, 0, 0));
  layer.add(new paralax(2, tree, 0, int( groundL-400), 350, 400, -10, 0, 0));
  layer.add(new paralax(2, tree, 500, int( groundL-450), 370, 450, -10, 0, 0));
  layer.add(new paralax(1, ground, 0, int( groundL), width*4, ground.height*7, -20, 0, 0));

  layer.add(new paralax(2, lamp, 0, int( groundL-500), lamp.width*2, lamp.height*2, -20, 0, 1)); // forground
  layer.add(new paralax(2, tree, 0, int( groundL-400), 350, 400, -10, 0, 0));
  // ljud och musik
  println("loading sound FX");
  minim = new Minim(this);    
  carSound= minim.loadFile("FX/carSound.mp3");
  carSound.setGain(-50); // volume
  carSound.play();
  carSound.loop();

  println((loadedCityName[randCityIndex]).toLowerCase());
  // bagageDrop = minim.loadFile("FX/bagageDrop.mp3");
  BGM = minim.loadFile("music/"+ (loadedCityName[randCityIndex]).toLowerCase() +".mp3");
  intro  = minim.loadFile("music/intro.mp3");
  intro.play();
  intro.loop();
}


//--------------------------------------------------------------***************************-----------------------------------------------------------------
//--------------------------------------------------------------*-------------------------*------------------------------------------------------------------
//--------------------------------------------------------------*---------LOOP------------*------------------------------------------------------------------
//--------------------------------------------------------------*-------------------------*------------------------------------------------------------------
//--------------------------------------------------------------***************************-----------------------------------------------------------------


void draw() {
  zoomAnimation();
  BGM.setGain(-100 +(100*fadeFactor));


  if (menuScreen) {
    displayMenu();
  }

  if (!menuScreen ) {
    background(127);
    if (enableZoom) {
      pushMatrix();
      translate(mouseX-width/2, mouseY-height/2);
      scale(zoom);
    }

    fill(50, 100, 255);   
    rectMode(NORMAL);
    rect(0, 0, width, height);   // blue sky background

    for (int i=0; i< layer.size (); i++) {   // updaterar & printar all paralax lageri arraylisten
      if (layer.get(i).zIndex==0) {
        layer.get(i).update();
        layer.get(i).paint();
      }
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

    checkCorrectCity(); // check if all the letters are correct

    for (int i=0; i< particles.size (); i++) {    // updaterar & printar all rök i arraylisten
      particles.get(i).paint();
      particles.get(i).update();
      if (particles.get(i).time>particles.get(i).timeLimit) { // kollar om partiklen ska tas bort beroende på hur länge den har levt
        particles.remove(i);
        i--;
      }
    }

    for (int i=0; i< layer.size (); i++) {   // updaterar & printar all fore ground paralax lageri arraylisten
      if (layer.get(i).zIndex==1) {
        layer.get(i).update();
        layer.get(i).paint();
      }
    }



    fill(255, 0, 0);
    textSize(fontSize/2);
    text(wrongLetter, wrongLetterOffsetX, wrongLetterOffsetY);   // display all wrong letters
    if (enableZoom)popMatrix(); // for zoom
  }
  if (gameOver==true)gameOverTimer++;
  if (gameOver && gameOverDelay<gameOverTimer) {
    displayGameOver();
    //gameOvertimer=0;
  }
  if (victoryScreen == true) {
    displayVictory();
  }

  displayInfo();                // visar lite developer info
}


//--------------------------------------------------------------***************************-----------------------------------------------------------------
//--------------------------------------------------------------*-------------------------*------------------------------------------------------------------
//--------------------------------------------------------------*---------FUNKTIONER------*------------------------------------------------------------------
//--------------------------------------------------------------*-------------------------*------------------------------------------------------------------
//--------------------------------------------------------------***************************-----------------------------------------------------------------

void displayInfo() {  // visa information
  fill(0);
  textSize(26);
  text("version: "+version, width-400, 50);
  text("Zoom: " +  nf(zoom, 1, 1), width-300, 100);
  text("gameOver: " + gameOver, width-300, 150);
  text("Car X Velocity : " + carVx +"    Car Y Velocity : " + carVy, width-300, 200);
}


void reRoll() {
  int  prevRand=randCityIndex;
  while ( randCityIndex==prevRand ) {
    randCityIndex = int(random(loadedCityName.length));  // randomize city from text file
    println("Total index in text file: " + (loadedCityName.length -1) + " index, randomized to: "  + randCityIndex +" equals: "+ loadedCityName[randCityIndex]);
  }
}

void resetGame() {
  reRoll(); // random från text
  resetBagage();
  resetWord();
  PImage temp = loadImage("graphics/"+ (loadedCityName[randCityIndex]).toLowerCase()+".png");
  layer.get(1).w =temp.width ;
  layer.get(1).h =temp.height ;
  building= temp;
  layer.get(1).pic=building;
  layer.get(1).x=width-layer.get(1).w;
  resetMusic();
  wrongLetter="";
  rightLetter="";
  gameOver=false;
  createLetterObject();
  createBagageObject();
  carX= 0;
  carAx=0;
  carVx=startBurst;
  zoom=1;
  targetZoom= 0.7;
  zoomFactor=0.99;
  victoryScreen=false;
  gameOverTimer=0;
  slowFactor=1;
  fadeFactor=1;
  BGM.setGain(100);  // restore volume
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

void resetMusic() {
  BGM.pause();
  BGM = minim.loadFile("music/"+ (loadedCityName[randCityIndex]).toLowerCase() +".mp3");
  BGM.rewind();
  BGM.play();
}

void createLetterObject() {

  for (int i=chars.size (); 0< i; i--) {   // create char object
    print(i +" removed ");
    chars.remove(i-1);
  }
  for (int i=0; loadedCityName[randCityIndex].length () > i; i++) {   // create char object
    println(loadedCityName[randCityIndex].charAt(i));
    chars.add(new bokstav(loadedCityName[randCityIndex].charAt(i), rightLetterOffsetX+i*letterSpacing, rightLetterOffsetY));  // add letters
  }
  rightLetter=loadedCityName[randCityIndex];  // set te right letters again for checking keys if right
}

void createBagageObject() {

  for (int i=lives.size (); 0< i; i--) {   // create char object
    print(i +" removed ");
    lives.remove(i-1);
  }
  lives.add(new bagage( bag5, int(50 +random(50)-25), int(-(30)), 100, 90));
  lives.add(new bagage( bag4, int(150+random(50)-25), int(-(30)), 110, 80));
  lives.add(new bagage( bag3, int(80+random(90)-45), int(-(90)), 110, 60));
  lives.add(new bagage( bag2, int(100+random(80)-40), int(-(140)), 110, 60));
  lives.add(new bagage( bag1, int(110+random(50)-25), int(-(190)), 120, 50));
}

void checkCorrectCity() {

  int amount=0;
  for (int i=0; i<chars.size (); i++) {   // check right
    if (chars.get(i).show==true ||  chars.get(i).noDisplay==true) {
      amount++;
    }
  }
  if (amount>=chars.size()) {   // ----------------------------------------WIN !!!
    carAx = 2;
    targetZoom= 1;
    zoomFactor=1.01;
    victoryScreen=true;
  }   // turbo car drive
}

void zoomAnimation() {
  if (animation) {

    zoom*=zoomFactor;
    if (zoomFactor<1 ) {
      println(zoomFactor);
      if (targetZoom<zoom){ zoom=targetZoom; 
      animation=false;}
    } else {

      if (targetZoom>zoom) {zoom=targetZoom; 
      animation = false;}
    }
  }
}



