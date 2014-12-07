void keyPressed() {
  if(key == 'R' || key == 'r'){
  resetBagage();
  }
}

void keyReleased() {
}


void mousePressed() {
  for (int i=lives.size()-1; i >= 0 ; i-- ) { // reverse index because of display layer order
    if (lives.get(i).knockedOff == false) {
      lives.get(i).knockedOff=true;
      break;
    }
  }
  
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

