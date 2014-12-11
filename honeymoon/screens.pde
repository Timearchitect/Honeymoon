void displayBG() {
  image(clouds, 0, 0, clouds.width*0.4, clouds.height*0.4);  // bil
}
int fade=0;
void displayMenu() {
  int textOffsetY=height/2-25;
  textFont (title);
  fill(100, 10);
  imageMode(CENTER);
  image( startPage, width/2, height/2, width, height);

  textMode(CENTER);
  fill(0);
  textSize(125);
  text("Honeymoon", width/2-175, height/4+100);
  textSize(48);
  text("You are about to travel along side this", width/2-210, textOffsetY-50);
  text("newly wed couple, on their honeymoon ", width/2-210, textOffsetY);
  text("trip around the world.", width/2-210, textOffsetY+50);
  text("Help the couple figure out which town is", width/2-210, textOffsetY+110);
  text("ahead by typing the right letters.", width/2-210, textOffsetY+160);
  text("P.S. Don't let them lose their luggage!", width/2-210, textOffsetY+240);

  fill(0,fade);
  text("press", 350,height/4*3+10);
  textSize(125);
  text("[space]", 440,height/4*3+40);


fade=(fade<255)?fade+=1:0;

  if (keyPressed && key == ' ') { //press space to continue
    menuScreen=false; 
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
  textSize(40); 
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
  textSize (40);
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

