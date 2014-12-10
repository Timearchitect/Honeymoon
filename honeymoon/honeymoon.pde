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
 // press [#] to enable cheat/dev mode!
 */

final String version= " 0.4.7";
import ddf.minim.*;
Minim minim;
AudioPlayer carSound; // ljud
AudioPlayer bagageSound;
AudioPlayer BGM;
AudioPlayer prevBGM;
AudioPlayer bagageDrop, intro;

float  zoom=1, targetZoom= 0.7, zoomFactor=0.99, maxZoom=5;
float groundL=0, angle, slowFactor=1, addSlow=-0.004, fadeFactor=1, decreaseVolume=-0.002;
float carX, carY, carW, carH, carVx, carVy, carAx, carVibrationOffsetX, carVibrationOffsetY, startBurst=25;
boolean onGround=true, gameOver, menuScreen=true, victoryScreen, animation=true, enableZoom=true, cheatEnabled; // screens
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
PImage building, gravel, stone, sand, bridge, river, tree, balloon, lamp, sol, skyline, palm, palm2, giza2, camel;  // BG
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
  //currentCityName=loadedCityName[randCityIndex];
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

  skyline = loadImage("graphics/new york-skyline.png");
  print("-");
  clouds = loadImage("graphics/clouds.png");
  print("-");
  giza2 = loadImage("graphics/giza2.png");
  print("-");
  sol = loadImage("graphics/sol.png");
  print("-");
  camel = loadImage("graphics/camel.png");
  print("-");
  palm = loadImage("graphics/palm.png");
  print("-");
  palm2 = loadImage("graphics/palm2.png");
  print("-");
  startPage = loadImage("graphics/startPage.jpg");
  print("-");
  building = loadImage("graphics/"+ (loadedCityName[randCityIndex]).toLowerCase()+".png");
  print("-");
  gravel = loadImage("graphics/road-gravel.png");
  print("-");
  sand = loadImage("graphics/road-sand.png");
  print("-");
  stone = loadImage("graphics/road-stone.jpg");
  print("-");
  bridge = loadImage("graphics/road-bridge2.png");
  print("-");
  river= loadImage("graphics/river.png");
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

  createLayer();

  // ljud och musik
  println("loading sound FX");
  minim = new Minim(this);    
  carSound= minim.loadFile("FX/carSound.mp3");
  carSound.setGain(0); // volume
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
 // zoomAnimation();
  BGM.setGain(-100 +(100*fadeFactor));

  if (menuScreen) {
    displayMenu();
  }

  if (!menuScreen ) {
     background(127);
    if (cheatEnabled) {
      pushMatrix();
      translate(mouseX-width/2, mouseY-height/2);
      scale(zoom);
    }

    fill(80, 120, 255);   
    rectMode(NORMAL);
    rect(0, 0, width, height);   // blue sky background

    for (int i=0; i< layer.size (); i++) {   // updaterar & printar all paralax lageri arraylisten
      if (layer.get(i).zIndex==0) {
        layer.get(i).update();
        layer.get(i).paint();
      }
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
    
        for (int i=0; i< chars.size (); i++) {   // updaterar & printar all bokstäver i arraylisten
      chars.get(i).update();
      chars.get(i).paint();
    }

    fill(255, 0, 0);
    textSize(fontSize/2);
    text(wrongLetter, wrongLetterOffsetX, wrongLetterOffsetY);   // display all wrong letters
    if (cheatEnabled)popMatrix(); // for zoom
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
  
  if(cheatEnabled){
  text("Zoom: " +  nf(zoom, 1, 1), width-300, 100);
  text("Cheating enabled , press [#] to disable." , 100, 50);
  text("gameOver: " + gameOver, width-300, 150);
  text("Car X Velocity : " +nf(carVx,1,1) +"    Car Y Velocity : " + carVy, width-300, 200);
  text("BGM: " +  BGM.position() +" millis", width-300, 250); 
  //text("prevBGM: " +  prevBGM.position(), width-300, 300);
  }
}


void reRoll() {
  int  prevRand=randCityIndex;
  while ( randCityIndex==prevRand ) {
    randCityIndex = int(random(loadedCityName.length));  // randomize city from text file
    println("Total index in text file: " + (loadedCityName.length -1) + " index, randomized to: "  + randCityIndex +" equals: "+ loadedCityName[randCityIndex]);
  }
}

void createLayer() {  

  for  (int i=layer.size(); 0<i; i--) {
    layer.remove(i-1);
    println(i-1);
  }
  building = loadImage("graphics/"+ (loadedCityName[randCityIndex]).toLowerCase()+".png");



  switch (randCityIndex) {
  case   0: //paris
    layer.add(new paralax(3, clouds, width, -200, int(width*2.5), int(height*1), -0.1, 0, 0));// cloud background
    layer.add(new paralax(2, sol, width/2, 200, int( sol.width*1), int(sol.height*1), 0, 0.01, 0));// cloud background
    layer.add(new paralax(0, building, width-300, int(groundL-100), building.width, building.height, -0.2, 0, 0));// background
    layer.add(new paralax(1, gravel, 0, int( groundL-110), int(width*2), gravel.height, -5, 0, 0));
    layer.add(new paralax(1, gravel, 0, int( groundL-80), int(width*3), int(gravel.height*3), -10, 0, 0));
    layer.add(new paralax(1, gravel, 0, int( groundL-20), int(width*3), int(gravel.height*4), -10, 0, 0));
    layer.add(new paralax(4, tree, (width/4)*3, int( groundL-450), 360, 440, -10, 0, 0));
    layer.add(new paralax(4, tree, width, int( groundL-450), 360, 440, -10, 0, 0));
    layer.add(new paralax(4, tree, width/4, int( groundL-450), 360, 440, -10, 0, 0));
    layer.add(new paralax(4, tree, (width/4)*2, int( groundL-450), 360, 440, -10, 0, 0));
    
    layer.add(new paralax(2, tree, (width/4)*2, 100, tree.width*4, tree.height*4, -50, 0, 1));
    layer.add(new paralax(2, tree, (width/4)*2,  0, tree.width*3, tree.height*3, -35, 0, 1));
    break;

  case   1: //london
    layer.add(new paralax(3, clouds, width, -200, int(width*2.5), int(height*1), -0.1, 0, 0));// cloud background
    // layer.add(new paralax(2, sol, width/2, 200, int( sol.width*2), int(sol.height*2), 0, 0.01, 0));// cloud background
    layer.add(new paralax(0, building, width-300, int(groundL-100), building.width, building.height, -0.2, 0, 0));// background
    layer.add(new paralax(1, gravel, 0, int( groundL-110), int(width*2), gravel.height, -5, 0, 0));
    layer.add(new paralax(2, tree, 0, int( groundL-300), tree.width/3, tree.height/3, -5, 0, 0));
    layer.add(new paralax(1, gravel, 0, int( groundL-80), int(width*3), int(gravel.height*2.5), -10, 0, 0));
    layer.add(new paralax(2, lamp, 0, int( groundL-400), 100, 400, -10, 0, 0));
    layer.add(new paralax(2, lamp, 500, int( groundL-450), 100, 450, -10, 0, 0));
    layer.add(new paralax(1, river, 0, int( groundL+50), int(width*4), int(bridge.height*2), -22, 0, 0));

    layer.add(new paralax(1, bridge, 0, int( groundL), int(width*4), int(bridge.height*2), -35, 0, 1));
    layer.add(new paralax(4, tree, 0, int( groundL-500), int(tree.width*2), int(tree.height*2), -30, 0, 1)); // forground

    //  layer.add(new paralax(1, bridge, 0, int( groundL), int(width*4), int(bridge.height*2), -20, 0, 1));
    layer.add(new paralax(2, lamp, 0, int( groundL-500), int(lamp.width*2), int(lamp.height*2), -40, 0, 1)); // forground
    break;
    
  case   2: //new york
    layer.add(new paralax(3, clouds, width, -200, int(width*2.5), int(height*1), -0.1, 0, 0));// cloud background
    layer.add(new paralax(2, skyline, 0, 100, int( width*1), int(height*0.5), 0, 0, 0));// cloud background
    layer.add(new paralax(1, river, 0, int( groundL-250), int(width*4), int(bridge.height*2), -0.2, 0, 0));
    layer.add(new paralax(0, building, width-300, int(groundL-100), building.width, building.height, -0.2, 0, 0));// background
    layer.add(new paralax(1, stone, 0, int( groundL-150), int(width*2), stone.height*2, -5, 0, 0));
    layer.add(new paralax(1, gravel, 0, int( groundL-50), int(width*3), int(gravel.height*6), -10, 0, 0));
    layer.add(new paralax(2, lamp, 0, int( groundL-400), 100, 400, -10, 0, 0));
    layer.add(new paralax(2, lamp, 500, int( groundL-450), 100, 400, -10, 0, 0));

    layer.add(new paralax(2, lamp, 0, int( groundL-500), int(lamp.width*2), int(lamp.height*2), -20, 0, 1)); // forground
    break;
    
  case   3: //giza
    //layer.add(new paralax(3, clouds, width, -200, int(width*2.5), int(height*1), -0.1, 0, 0));// cloud background
    layer.add(new paralax(2, sol, width/2, 200, int( sol.width*2), int(sol.height*2), 0, 0.01, 0));// cloud background
    layer.add(new paralax(0, building, width-300, int(groundL-100), building.width, building.height, -0.2, 0, 0));// background
    layer.add(new paralax(0, giza2, width-100, int(groundL-100), giza2.width, giza2.height, -0.2, 0, 0));// background
    layer.add(new paralax(4, camel, 1000, int( groundL-155), int( camel.width), camel.height, -1, 0, 0));
    layer.add(new paralax(1, sand, 0, int( groundL-110), int(width*2), gravel.height, -5, 0, 0));
    layer.add(new paralax(1, sand, 0, int( groundL-80), int(width*3), int(gravel.height*3), -10, 0, 0));
    layer.add(new paralax(1, sand, 0, int( groundL), int(width*4), int(sand.height*3), -20, 0, 0));

    layer.add(new paralax(2, palm, 500, int( groundL-450), 370, 450, -10, 0, 0));
    layer.add(new paralax(2, palm2, 800, int( groundL-450), 370, 450, -10, 0, 0));
    break;
    
  case   4: //pisa
    layer.add(new paralax(3, clouds, width, -200, int(width*2.5), int(height*1), -0.1, 0, 0));// cloud background
    layer.add(new paralax(2, sol, width/3, 200, int( sol.width*1), int(sol.height*1), 0, 0.01, 0));// cloud background
    layer.add(new paralax(0, building, width-300, int(groundL-100), building.width, building.height, -0.2, 0, 0));// background
    layer.add(new paralax(1, gravel, 0, int( groundL-110), int(width*2), gravel.height, -5, 0, 0));
    layer.add(new paralax(1, stone, 0, int( groundL-80), int(width*3), int(stone.height*3), -10, 0, 0));
    layer.add(new paralax(2, tree, 0, int( groundL-400), 350, 400, -10, 0, 0));
    layer.add(new paralax(2, tree, 500, int( groundL-450), 370, 450, -10, 0, 0));
    layer.add(new paralax(2, tree, 800, int( groundL-450), 370, 450, -10, 0, 0));
    layer.add(new paralax(1, river, 0, int( groundL+50), int(width*4), int(bridge.height*2), -22, 0, 0));

    layer.add(new paralax(1, bridge, 0, int( groundL), int(width*4), int(bridge.height*2), -20, 0, 1));
    layer.add(new paralax(2, lamp, 0, int( groundL-500), int(lamp.width*2), int(lamp.height*2), -20, 0, 1)); // forground
    layer.add(new paralax(2, lamp, 500, int( groundL-500), int(lamp.width*2), int(lamp.height*2), -20, 0, 1)); // forground
    break;
    
  default:
    layer.add(new paralax(3, clouds, width, -200, int(width*2.5), int(height*1), -0.1, 0, 0));// cloud background
    layer.add(new paralax(2, sol, width/2, 200, int( sol.width*2), int(sol.height*2), 0, 0.01, 0));// cloud background
    layer.add(new paralax(0, building, width-300, int(groundL-100), building.width, building.height, -0.2, 0, 0));// background
    layer.add(new paralax(1, gravel, 0, int( groundL-110), int(width*2), gravel.height, -5, 0, 0));
    layer.add(new paralax(1, gravel, 0, int( groundL-80), int(width*3), int(gravel.height*3), -10, 0, 0));
    layer.add(new paralax(2, tree, 0, int( groundL-400), 350, 400, -10, 0, 0));
    layer.add(new paralax(2, tree, 500, int( groundL-450), 370, 450, -10, 0, 0));
    layer.add(new paralax(1, river, 0, int( groundL+50), int(width*4), int(bridge.height*2), -22, 0, 0));

    layer.add(new paralax(1, bridge, 0, int( groundL), int(width*4), int(bridge.height*2), -20, 0, 1));
    layer.add(new paralax(2, lamp, 0, int( groundL-500), int(lamp.width*2), int(lamp.height*2), -20, 0, 1)); // forground
  }
}

void resetGame() {
  reRoll(); // random från text
  resetBagage();
  resetWord();
  createLayer();
  //PImage temp = loadImage("graphics/"+ (loadedCityName[randCityIndex]).toLowerCase()+".png");

  /*
  layer.get(2).w =temp.width ;
   layer.get(2).h =temp.height ;
   building= temp;
   layer.get(2).pic=building;
   layer.get(2).x=width-layer.get(1).w;
   */

  /*
  if ( prevBGM.isPlaying()) prevBGM.pause();
   prevBGM = minim.loadFile("music/"+ (loadedCityName[randCityIndex]).toLowerCase() +".mp3");
   prevBGM.pause();
   prevBGM.play(BGM.position()); */

  BGM.pause();
  resetMusic();  // reset music to BGM 


  gameOver=false;
  createLetterObject();
  createBagageObject();
  carX= 0;
  carAx=0;
  carY=groundL-carH-0;
  carVy=-10;
  carVx=startBurst;
  zoom=1;
  targetZoom= 0.7;
  zoomFactor=0.99;
  victoryScreen=false;
  gameOverTimer=0;
  slowFactor=1;
  fadeFactor=1;
  emerging=400;
  
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
  wrongLetter="";
  rightLetter="";
}

void resetMusic() {
  BGM.pause();
  BGM = minim.loadFile("music/"+ (loadedCityName[randCityIndex]).toLowerCase() +".mp3");
  BGM.rewind();
  BGM.play();
  BGM.setGain(100);  // restore volume
  carSound.setGain(0); // restore car volume
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
  if (amount>=chars.size()) {   // ----------------------------------------WIN--------------- !!!
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
      if (targetZoom<zoom) { 
        zoom=targetZoom; 
        animation=false;
      }
    } else {

      if (targetZoom>zoom) {
        zoom=targetZoom; 
        animation = false;
      }
    }
  }
}

