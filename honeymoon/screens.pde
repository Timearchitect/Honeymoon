void displayBG() {
  image(clouds, 0, 0, clouds.width*0.4, clouds.height*0.4);  // bil
}
void displayMenu() {
  int textOffsetY=height/2-25;
  textFont (title);
  fill(100, 10);
  imageMode(CENTER);
  image( startPage,width/2,height/2,width,height);
  rectMode(NORMAL);
  textMode(CENTER);
  fill(0);
  textSize(125);
  text("Honeymoon" , width/2-175, height/4+100);
  textSize(48);
  text("You are about to travel along side this" , width/2-210, textOffsetY-50);
    text("newly wed couple, on their honeymoon " , width/2-210, textOffsetY);
    text("trip around the world.", width/2-210, textOffsetY+50);
   text("Help the couple figure out which town is" , width/2-210, textOffsetY+110);
   text("ahead by typing the right letters." , width/2-210, textOffsetY+160);
   text("P.S. Don't let them lose their luggage!" , width/2-210, textOffsetY+240);
  //rect(0, 0, displayWidth, displayHeight);
  
  if(keyPressed && key == ' '){ menuScreen=false; enterGame();}
  
  imageMode(NORMAL);
  
  textFont (font);
}


void displayVictory() {
 // fill(255, 190);
//  rectMode(NORMAL);
 // rect(0, 0, displayWidth, displayHeight);
 fill(0);
textSize (40);
text ("Thanks! You've helped us reach our destination.", 150, 400);
text ("Press 'Enter' to continue our journey.", 350, 530);

}
void displayGameOver() {

 slowFactor=(slowFactor>0) ?slowFactor+=addSlow : 0;
  fadeFactor=(fadeFactor>0) ?fadeFactor+=decreaseVolume : 0;
carAx = 0;
 // fill(0, 200);
 // rectMode(NORMAL);
 // rect(0, 0, displayWidth, displayHeight);
  fill(0);
  textSize(40); 
  text ("We've lost all of our luggage,", 300, 420);
  text ("we can't travel any further!", 300, 470);
  text ("Press 'Enter' to try again.", 500, 530); 
}

void enterGame(){
  BGM.play();
  BGM.loop();
}
