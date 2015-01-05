

float fade=00;
void displayMenu() {
  int textOffsetY=int(height/2.2), textOffsetX=int(width/2.5);
  textFont (title);
  fill(100, 10);
  imageMode(CENTER);
  image( startPage, width/2, height/2, width, height);

  textMode(CENTER);
  fill(0);
  textSize(125);
  text("Honeymoon", width/2.47, height/4+100);
  textSize(48); 
  text("You are about to travel along side this", textOffsetX, textOffsetY-50);
  text("newly wed couple, on their honeymoon ", textOffsetX, textOffsetY);
  text("trip around the world.", textOffsetX, textOffsetY+50);
  text("Help the couple figure out which town is", textOffsetX, textOffsetY+110);
  text("ahead by typing the right letters.", textOffsetX, textOffsetY+160);
  text("P.S. Don't let them lose their luggage!", textOffsetX, textOffsetY+240);

  fill(0, int(sin(radians(fade))*255));
  text("press", width/5.5, height/4*3+10);
  textSize(125);
  text("[space]", width/4.4, height/4*3+40);


  fade=(fade<255)?fade+=1.5:0;  

  if (keyPressed && key == ' ') { //press space to continue
    menuScreen=false; // deactivate menu
    carSound.setGain(0); // volume
    carSound.play();
    carSound.loop();
    enterGame();
  }
  imageMode(NORMAL);
  textFont (font);
}


void displayGameOver() {
  carSound.setGain((-50) +50*fadeFactor); // low volume
  slowFactor=(slowFactor>0) ?slowFactor+=addSlow : 0;
  fadeFactor=(fadeFactor>0) ?fadeFactor+=decreaseVolume : 0;

  carAx = 0;
  fill(255, 180);
  noStroke();
  rect(displayWidth/2, 455, displayWidth, 400-emerging);
  fill(0);
  textSize(fontSize/2); 
  if ( randCityIndex > 4) {
    text ("Welcome to "+ loadedCityName[randCityIndex] +"! You've helped us reach our destination.", 150, 420);
    text ("Press [Enter] to continue playing or press [ECS] for exit", 350, 490);
    text ("Press [#] for debug mode.", 350, 560);
  } else {
    text ("We've lost all of our luggage", 300, 420);
    text ("and can't travel any further!", 300, 470);
    text ("Press [Enter] to try again.", 500, 530);
  }
  emerging*=(emerging>0)?0.93:0;
  level=0; // reseting level
  orderList.shuffle(); // shuffle te order
}
void displayVictory() {
  fill(255, 180);
  rectMode(CENTER);
  noStroke();
  rect(displayWidth/2, 435, displayWidth, 400-emerging);
  fill(0);
  textSize (fontSize/2);
  if ( randCityIndex > 4) {
    text ("Thanks for playing! You've helped us reach our destination.", 150, 400);
    text ("Press [Enter] to continue playing or press [ECS] for exit", 350, 530);
    text ("Press [#] for debug mode.", 350, 600);
    level=-1; // reseting level
    orderList.shuffle();
  } else {
    text ("Thanks! You've helped us reach our destination.", 150, 400);
    text ("Press [Enter] to continue our journey.", 350, 530);
  }
  rectMode(NORMAL);

  emerging*=(emerging>0)?0.93:0;
}
void displayCredits() {
}
void enterGame() {
  intro.pause();
  BGM.play();
  BGM.loop();
}

float emerging=400;

void smokeScreen(int dir) {
  int amount=25;
  for ( int i=0; i< amount; i++) {
    particles.add(new particle(0, width, (height/amount)*i, (280+random(50))*dir, 0, random(360), 500));  // skapar rök partiklar
  }
}

