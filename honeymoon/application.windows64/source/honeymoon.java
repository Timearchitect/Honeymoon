import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class honeymoon extends PApplet {

/*---------------------------------------------------------------------------------
 //                                                                              //
 //   - projekt "honeymoon"                                                      //
 //   | IDK Programmering                                                        //
 //   av: Anton Blomster , Alrik He ,David Knutsson , Ther\u00e9se , Joel Hagenblad    // 
 //      2014-11-27                                                              //
 //                                                                              //
 //                                                                              //
 --------------------------------------------------------------------------------*/

final String version= " 0.2.2";

Minim minim;
AudioPlayer carSound, bagageSound, BGM; // ljud

float angle, zoom=1, maxZoom=5;
float groundL=0;
float carX, carY, carW, carH, carVx, carVy, carAx, carVibrationOffsetX, carVibrationOffsetY;
boolean onGround=true, gameOver=false;
String wrongLetter= "", rightLetter= "";
int randCityIndex;


String loadedCity[] ;// loadstrings from text
String loadedCityName[]; // h\u00e4r kommer all splitade stadsnamn att f\u00f6rvaras

//classer
ArrayList<bokstav> chars =   new  ArrayList<bokstav>(); // empty arrayList f\u00f6r bokst\u00e4verna
ArrayList<bagage> lives =   new  ArrayList<bagage>(); // empty arrayList f\u00f6r bokst\u00e4verna
ArrayList<particle> particles =   new  ArrayList<particle>(); // empty arrayList f\u00f6r bokst\u00e4verna
ArrayList<paralax> layer = new  ArrayList<paralax>(); // empty arrayList f\u00f6r paralax lager
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

public void setup() {

  size(displayWidth, displayHeight, OPENGL);
  groundL=(height/5)*4;
  if (frame != null) {  // g\u00f6r program f\u00f6nstret skalbar
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
  String loadedCityNames="";    // g\u00f6r en tom string
  for (int i=0; loadedCity.length > i; i++) {  // s\u00e4tter samman string arrayn till string med token
    if (i!=loadedCity.length-1) {
      loadedCityNames += loadedCity[i]+ "," ;   // l\u00e4gger in divider
    } else {
      loadedCityNames += loadedCity[i];  // sista har ingen divider token
    }
  }

  loadedCityNames= loadedCityNames.toUpperCase(); // konvertera till uppercase
  println(loadedCityNames);

  loadedCityName=splitTokens(loadedCityNames, ",");  // splittokens  
  println(loadedCityName);


  randCityIndex = PApplet.parseInt(random(loadedCityName.length-1));  // randomize city from text file
  println("Total " + (loadedCityName.length -1) + " index, randomized: "  + randCityIndex +" is: "+ loadedCityName[randCityIndex]);
  println("loading letter objects");
  // bokst\u00e4verna
  for (int i=0; loadedCityName[randCityIndex].length () > i; i++) {   // create char object
    println(loadedCityName[randCityIndex].charAt(i));
    chars.add(new bokstav(loadedCityName[randCityIndex].charAt(i), 200+i*40, 200));  // add letters
  }

  loadedCityName[randCityIndex]=loadedCityName[randCityIndex].toUpperCase();  // konverterar till upper case
  rightLetter=loadedCityName[randCityIndex];

  // charCode   for \u00e4 = 228  \u00e5 = 229 \u00f6 = 246 
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
  lives.add(new bagage( bag5, PApplet.parseInt(50), PApplet.parseInt(-(30)), 100, 90));
  lives.add(new bagage( bag4, PApplet.parseInt(150), PApplet.parseInt(-(30)), 110, 80));
  lives.add(new bagage( bag3, PApplet.parseInt(80), PApplet.parseInt(-(90)), 110, 60));
  lives.add(new bagage( bag2, PApplet.parseInt(100), PApplet.parseInt(-(150)), 110, 60));
  lives.add(new bagage( bag1, PApplet.parseInt(140), PApplet.parseInt(-(210)), 120, 80));

  // paralax layer
  layer.add(new paralax(0,building, width, 0, building.width/2, building.height/2, -0.5f, 0));
  layer.add(new paralax(1,ground, 0, PApplet.parseInt( groundL-110), width*2, ground.height/2, -5, 0));
  layer.add(new paralax(1,ground, 0, PApplet.parseInt( groundL-80), ground.width, ground.height, -10, 0));
  layer.add(new paralax(1,ground, 0, PApplet.parseInt( groundL), ground.width, ground.height, -20, 0));

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


public void draw() {
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

  for (int i=0; i< chars.size (); i++) {   // updaterar & printar all bokst\u00e4ver i arraylisten
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

  particles.add(new particle( mouseX+random(10)-5, mouseY+random(10)-5, -5+random(5), -3+random(2), random(360)));  // skapar r\u00f6k partiklar

  for (int i=0; i< particles.size (); i++) {    // updaterar & printar all r\u00f6k i arraylisten
    particles.get(i).paint();
    particles.get(i).update();
    if (particles.get(i).time>particles.get(i).timeLimit) { // kollar om partiklen ska tas bort beroende p\u00e5 hur l\u00e4nge den har levt
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



public void displayInfo() {  // visa information
  fill(255);
  textSize(26);
  text("version: "+version, width-400, 50);
  text("Zoom: " +  nf(zoom, 1, 1), width-300, 100);
  text("gameOver: " + gameOver, width-300, 150);
   text("Car X Velocity : " + carVx +"    Car Y Velocity : " + carVy , width-300, 200);
}

public void displayBG() {
  image(bgImage, 0, 0, bgImage.width*0.4f, bgImage.height*0.4f);  // bil
}

public void reRoll() {
}

public void resetGame() {
  resetBagage();
  resetWord();
  reRoll();
  wrongLetter="";
  rightLetter="";
  gameOver=false;
}

public void resetBagage() {
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

public void resetWord() {
  for (int i=0; i< chars.size (); i++) {
    chars.get(i).show=false;
  }
}

// Davids del

class bagage {
  float x, y, bagageWidth, bagageHeight, vx=-8, vy=20, gravitation=4, angle=0, rotationV=0 ,vibrationOffsetX,vibrationOffsetY,parentX,parentY;
  boolean knockedOff=false;
  PImage img;
  float startX, startVx=-5, startVy=20, startY, startAngle=0, startRotationV=0;

  bagage( PImage tempImg, int tempX, int tempY, int tempWidth, int tempHeight) {   //    constructor
  parentX=carX;
  parentY=carY;
    startX=tempX;
    startVx=-8;
    startVy=20;
    startY=tempY;
    startAngle=0;
    startRotationV=0;

    img=tempImg;
    bagageWidth=tempWidth;
    bagageHeight=tempHeight;
    x = tempX;
    y = tempY;
  }
  public void knockOff() {
    knockedOff=true;
      vx=random(-10)-2-carVx;
      vy=random(-20) +carVy;
  }
  
  public void update() {
    if (knockedOff==true) {
      x=x+vx;
      y=y+vy;
      vy+=gravitation;
      vy*=0.97f; // decay
      angle-=rotationV;
    }
    else{
    vibrationOffsetX=carVibrationOffsetX;
    vibrationOffsetY=carVibrationOffsetY;
    parentX=carX;
    parentY=carY;
    }
  }

  public void checkBounderies() {
    if (y+bagageWidth/2>groundL-parentY) {  // when reaching ground
     particles.add(new particle( x+parentX, y+bagageHeight/2+parentY, -20+random(10), -8+random(4), random(360)));  // skapar r\u00f6k partiklar
      vy= vy*-1;
      vy=vy+random(5)-3;
      vx=vx+random(2)-1.6f;
      rotationV=rotationV+random(20)-10;
    }
  }

  public void paint() {
    pushMatrix();
    translate(x+parentX, y+parentY);
    rotate(radians(angle));
    image(img, PApplet.parseInt(-bagageWidth/2+vibrationOffsetX), PApplet.parseInt(-bagageHeight/2+vibrationOffsetY), bagageWidth, bagageHeight);
    rectMode(CENTER);
    fill(255, 0, 0);
    popMatrix();
  }
}
//--------------------------------------------------------------***************************-----------------------------------------------------------------
//--------------------------------------------------------------*---------------------------*------------------------------------------------------------------
//--------------------------------------------------------------*-------UTANF\u00d6R KLASSEN-----*------------------------------------------------------------------
//--------------------------------------------------------------*---------------------------*------------------------------------------------------------------
//--------------------------------------------------------------***************************-----------------------------------------------------------------


public void loseLife(){
int life=lives.size ()-1;
for (int i=lives.size ()-1; i >= 0; i-- ) {
if(lives.get(i).knockedOff==true)life--;

}
if(life==0)gameOver=true; // check if game over

    for (int i=lives.size ()-1; i >= 0; i-- ) { // reverse index because of display layer order
      if (!lives.get(i).knockedOff) {
        lives.get(i).knockOff(); // knock the bagage off the car
        break;
      }
    }
    
}

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



  public void update() {

    if (keyPressed) {
      if(parseInt(key)>96 ){
      key = parseChar(parseInt(key)-32); // konvertera till stor
      println(key);
      }
      if (key == Char) {
        show = true;
      }
    }
  }

  public void paint() {
    stroke(0);
    strokeWeight(5);
    fill(0);
    textSize(48);
    if (show && !noDisplay) {
      text (Char, x, y);
    } else if(show == false && noDisplay == false){
      line (x, y, x+30, y);
    }
  }
  
}



public void updateCar() {

  carVibrationOffsetX=random(3)-1.5f;
  carVibrationOffsetY=random(3)-1.5f;
  carVx+=carAx;
  carVx*=0.95f;
  carVy*=0.95f;

  carX+=carVx;
  carY+=carVy;
  if (carY< groundL-carH) {
    carY*=1.02f;
  }else{ //onGround
  carVy=0;
  onGround=true;
  }
}

public void displayCar(float x, float y, float w, float h) {  // funktion f\u00f6r bilen
  int wheelOffset=10, wheelSize=60;

  angle += 15+carVx; // rotate
  imageMode(CORNER);
  image(car, PApplet.parseInt(x+carVibrationOffsetX), PApplet.parseInt(y+carVibrationOffsetY), w, h);  // bil chassi

  if( onGround)particles.add(new particle( x+w-wheelSize, y+h+wheelSize/4, -5+random(5), -3+random(2), random(360)));  // skapar r\u00f6k partiklar
  pushMatrix();
  translate( x+w-wheelOffset*8+random(2) +wheelSize/2, y+h-wheelSize/2+random(2)+wheelSize/2);            // front wheel
  rotate(radians(angle));
  image(wheel1, 0-wheelSize/2, 0-wheelSize/2, wheelSize, wheelSize);  // hjul F
  popMatrix();

  if( onGround)particles.add(new particle( x+wheelSize/2, y+h+wheelSize/4, -5+random(5), -3+random(2), random(360)));  // skapar r\u00f6k partiklar
  pushMatrix();
  translate( x+wheelOffset+wheelSize/2+random(2), y+h-wheelSize/2+random(2)+wheelSize/2);            // front wheel
  rotate(radians(angle));
  image(wheel2, 0-wheelSize/2, 0-wheelSize/2, wheelSize, wheelSize); // hjul B
  popMatrix();
}

public void keyPressed() {


  if (keyCode== UP)if (onGround)carVy+= -30;
  onGround=false;
  if (keyCode== LEFT) if (carAx>-1) {
    carAx+= -0.1f; 
    carVx+= -5;
  }
  if (keyCode== RIGHT)if (carAx<1) {
    carAx+= 0.1f;
    carVx+= 5;
  }

  if ( key== '\b' && chars.size()>0) {   // tryck p\u00e5 backspace f\u00f6r att ta bort bokst\u00e4verna
    chars.remove(chars.size()-1); // tar bort den sista bokstaven
  }



  if (keyCode == ENTER) {

    resetGame();
  }
  if (keyCode == BACKSPACE) {
    println("\""+wrongLetter + "\" Are int the wrongLetter pool");
    println("\""+rightLetter + "\" Are int the rightLetter pool");
  }

  if ((key >= 'A' && key <= 'z')  || key == '\u00e5' || key == '\u00c5' || key == '\u00e4' || key == '\u00c4' || key == '\u00f6' || key == '\u00d6') {
    if (key >= 'a') key=PApplet.parseChar(key-32);   //ENG  alphabet convert key to upper case
    if  (key==229) key=PApplet.parseChar(key-32); // \u00e5
    if  (key==228) key=PApplet.parseChar(key-32); // \u00e4
    if  (key==246) key=PApplet.parseChar(key-32); // \u00f6
    println(PApplet.parseChar(key));

    if ( checkLetters(rightLetter, key) == true) {
    } 
    else {
      if (  checkLetters(wrongLetter, key)==false) {   // when key does not exist in the pool. Add key to the pool
        wrongLetter=wrongLetter + str(key);     
        loseLife(); // drop bagage
      }
    }
  }
}


public void keyReleased() {
}


public void mousePressed() {
  if  (mouseButton == RIGHT) {     // clicka med musen f\u00f6r att ta tillbaka bagagen till dessa koordinater
    resetGame();
  } else {
    loseLife();
  }
}

public void mouseWheel(MouseEvent event) {  // krympa och f\u00f6rstora
  int temp = event.getCount() ;
  zoom += temp * 0.05f;
  if (zoom<=0) {
    zoom=0.1f;
  }

  if (zoom > maxZoom) {
    zoom=maxZoom;
  }
}

public boolean checkLetters(String string, int charCode) {   // check letters to string
  boolean match = false;
  for (int i=0; i < string.length (); i++) {
    println(PApplet.parseInt(string.charAt(i)) + "   " + charCode);
    if ( PApplet.parseInt(string.charAt(i))==charCode) {    // if the key is in the  letter pool return true
      match=true;
    }
  }
  println(match);
  return match;
}

class paralax {
  int type;
  float x, y, w, h, vx, vy, startX, startY;
  PImage pic;
  paralax(int tempType, PImage tempPic, int tempX, int tempY, int tempW, int tempH, float tempVx, int tempVy) {
    type=tempType;    
    pic=tempPic;
    x=tempX;
    y=tempY;
    w=tempW;
    h=tempH;
    vx=tempVx;
    vy=tempVy;
    startX=tempX;
    startY=tempY;
  }

  public void update() {
    switch (type) {
    case 0:
      x+=vx;

      break;
    case 1:
      if (x>0) x=-w/2;  //reseting ground when reaching image end
      if (x<-w/2) x=0;  //reseting ground when reaching image end
      x+=vx;
      break;
    }
  }

  public void paint() {
    image( pic, PApplet.parseInt(x), PApplet.parseInt(y), w, h);   // display image
  }
}

class particle {
  float x, y, vx, vy, time=0, timeLimit=10, opacity=90;
  float angle, particleWidth, particleHeight;

  particle( float tempx, float tempy, float  tempVx, float  tempVy, float tempAngle) {   //    constructor
    vx=tempVx;
    vy= tempVy;
    angle=tempAngle;

    particleWidth=random(50);
    particleHeight=particleWidth;
    x = tempx;
    y = tempy;
  }

  public void update() {
    x+=vx;
    y+=vy;
    time++;
    opacity-=10;
  }

  public void paint() {
    noStroke();
    pushMatrix();
    translate(x, y);
    rotate(radians(angle));
    fill(255, opacity);
    rect( 0, 0, particleWidth, particleHeight);
    popMatrix();
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--hide-stop", "honeymoon" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
