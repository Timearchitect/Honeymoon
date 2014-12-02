
/*---------------------------------------------------------------------------------
 //                                                                              //
 //   - projekt "honeymoon"                                                      //
 //   | IDK Programmering                                                        //
 //   av: Anton Blomster , Alrik He ,David Knutsson , Therése , Joel Hagenblad    // 
 //      2014-11-27                                                              //
 //                                                                              //
 //                                                                              //
 --------------------------------------------------------------------------------*/
final String version= " 0.0.2";
import ddf.minim.*;

Minim minim;
AudioPlayer BGM;


String loadedCityName[];
int x, y;
//classer
ArrayList<bokstav> chars =   new  ArrayList<bokstav>(); // empty arrayList för bokstäverna
ArrayList<bagage> lives =   new  ArrayList<bagage>(); // empty arrayList för bokstäverna




void setup() {
  size(displayWidth, displayHeight, OPENGL);
  if (frame != null) {  // resize
    frame.setResizable(true);
  }
  String loadedCityName[] = loadStrings("cities.txt");
  println(loadedCityName);

  // charCode   for ä = 228  å = 229 ö = 246 
  println(parseChar(228), parseChar(229), parseChar(246), parseChar(228-32), parseChar(229-32), parseChar(246-32)); 
  println("&#228" + "&auml" +"\206");


  chars.add(new bokstav('e', 100, 200));
  chars.add(new bokstav('r', 100, 300));
  chars.add(new bokstav('e', 100, 400));
  chars.add(new bokstav('r', 100, 500));
  chars.add(new bokstav('e', 500, 200));
  chars.add(new bokstav('r', 500, 300));
  chars.add(new bokstav('e', 500, 400));
  chars.add(new bokstav('r', 500, 500));
}

void draw() {
  background(255/2);

  displayInfo();
  for (int i=0; i< chars.size (); i++) {
    chars.get(i).knockOff();
    chars.get(i).paint();
  }
  if (keyPressed && key== '\b' && chars.size()>0) {

    chars.remove(chars.size()-1);
  }
}


void displayInfo() {
  fill(255);
  text(version, width-100, 50);
}

void keyPressed() {
}

void keyReleased() {
}


void mousePressed() {
}

