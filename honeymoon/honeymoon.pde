
/*---------------------------------------------------------------------------------
 //                                                                              //
 //   - projekt "honeymoon"                                                      //
 //   | IDK Programmering                                                        //
 //   av: Anton Blomster , Alrik He ,David Knutsson , Therése , Joel Hagenblad    // 
 //      2014-11-27                                                              //
 //                                                                              //
 //                                                                              //
 --------------------------------------------------------------------------------*/
final String version= " 0.0.6";
import ddf.minim.*;
float angle, zoom=1, maxZoom=5;
float groundH=0;
float carX, carY, carW, carH;
//AudioPlayer BGM;


String loadedCityName[]; // här kommer all stadsnamn att förvaras
int x,y,groundX=0,groundXv=-10;
//classer
ArrayList<bokstav> chars =   new  ArrayList<bokstav>(); // empty arrayList för bokstäverna
ArrayList<bagage> lives =   new  ArrayList<bagage>(); // empty arrayList för bokstäverna
ArrayList<particle> particles =   new  ArrayList<particle>(); // empty arrayList för bokstäverna
// bilder
PImage img1, img2, img3, img4, img5; // bagage olika versionen bilder
PImage building, ground;  // BG
PImage bgImage; // bakgrunds bild

PImage car; // bakgrunds bild
PImage wheel1; // bakgrunds bild
PImage wheel2; // bakgrunds bild

//--------------------------------------------------------------***************************-----------------------------------------------------------------
//--------------------------------------------------------------*-------------------------*------------------------------------------------------------------
//--------------------------------------------------------------*---------SETUP-----------*------------------------------------------------------------------
//--------------------------------------------------------------*-------------------------*------------------------------------------------------------------
//--------------------------------------------------------------***************************-----------------------------------------------------------------


void setup() {
  // ljud och musik
  bgImage = loadImage("graphics/parisbg.png");  
  println("loading graphics");
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

  size(displayWidth, displayHeight, OPENGL);
  groundH=(height/5)*4;
  if (frame != null) {  // gör program fönstret skalbar
    frame.setResizable(true);
  }
  println("loading cities");
  String loadedCityName[] = loadStrings("cities.txt");  //ladda in texten till string Arrayn
  println(loadedCityName);   

  // charCode   for ä = 228  å = 229 ö = 246 
  println(parseChar(228), parseChar(229), parseChar(246), parseChar(228-32), parseChar(229-32), parseChar(246-32)); 
  println("&#228" + "&auml" +"\206");
  println("loading class objects");
  // bilen
  carX= width/4;
  carY=groundH-150;
  carW=270;
  carH=160;
  // bagaget
  lives.add(new bagage( img1, int(carX+140), int(carY-(220)), 120, 80));
  lives.add(new bagage( img2, int(carX+100), int( carY-(160)), 110, 60));
  lives.add(new bagage( img3, int(carX+80), int(carY-(120)), 110, 60));
  lives.add(new bagage( img4, int(carX+150), int(carY-(70)), 120, 90));
  lives.add(new bagage( img5, int(carX+50), int(carY-(50)), 100, 90));

  // bokstäverna
  chars.add(new bokstav('e', 100, 200));
  chars.add(new bokstav('r', 100, 300));
  chars.add(new bokstav('e', 100, 400));
  chars.add(new bokstav('r', 100, 500));
  chars.add(new bokstav('e', 500, 200));
  chars.add(new bokstav('r', 500, 300));
  chars.add(new bokstav('e', 500, 400));
  chars.add(new bokstav('r', 500, 500));

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

 fill(50,100,255,150);   
 rectMode(NORMAL);
 rect(0,0,width,height);   // background
 
  println(zoom);
  //displayBG();
  image( building, width-500, 0, 300, height-300);  // byggnaden
  if(groundX<-ground.width/2) groundX=0;  //reseting ground when reaching image end
  groundX+=groundXv;
  image( ground, groundX, groundH);   // mark


  for (int i=0; i< chars.size (); i++) {   // updaterar & printar all bokstäver i arraylisten
    chars.get(i).knockOff();
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

  if  ( mousePressed ) {     // clicka med musen för att ta tillbaka bagagen till dessa koordinater
    for (int i=0; i< lives.size (); i++) {
      lives.get(i).x= lives.get(i).startX;
      lives.get(i).vx= lives.get(i).startVx;
      lives.get(i).vy= lives.get(i).startVy;
      lives.get(i).y= lives.get(i).startY;
      lives.get(i).angle=lives.get(i).startAngle;
      lives.get(i).rotationV=lives.get(i).startRotationV;
    }
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
  pushMatrix();
  translate( x+w-wheelOffset*8+random(2) +wheelSize/2, y+h-wheelSize/2+random(2)+wheelSize/2);
  rotate(radians(angle));
  image(wheel1, 0-wheelSize/2, 0-wheelSize/2, wheelSize, wheelSize);  // hjul
  popMatrix();

  //ellipse(x+(w-x)-wheelOffset, h, 50, 50);

  pushMatrix();
  translate( x+wheelOffset+wheelSize/2+random(2), y+h-wheelSize/2+random(2)+wheelSize/2);
  rotate(radians(angle));
  image(wheel2, 0-wheelSize/2, 0-wheelSize/2, wheelSize, wheelSize); // hjul
  popMatrix();
  //ellipse(x+wheelOffset, h, 50, 50);
}


void displayInfo() {  // visa information
  fill(255);
  text("version: "+version, width-100, 50);
  text("Zoom: " +  nf(zoom, 1, 1), width-100, 100);
}

void displayBG() {
  image(bgImage, x, y, bgImage.width*0.4, bgImage.height*0.4);  // bil
}

void keyPressed() {
}

void keyReleased() {
}


void mousePressed() {
}

void mouseWheel(MouseEvent event) {  // krympa och förstora
  int temp = event.getCount() ;
  zoom += temp * 0.05;
  if (zoom<=0) {
    zoom=0;
  }

  if (zoom > maxZoom) {
    zoom=maxZoom;
  }
}

