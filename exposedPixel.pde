import io.thp.psmove.*;
import processing.video.*;
import java.awt.Point;

Capture cam;
PImage img;
PSMove a;
Point centreOfLight=new Point();
int blackLevel=3;

int torchX=0,torchY=0;

void setup() {
  size(displayWidth, displayHeight);
  background(0);

  println(Capture.list());
  cam = new Capture(this, "name=Built-in iSight,size=80x60,fps=30");
  cam.start();

  img = loadImage("6-mondrian-composition-c-no-iii-with-red-yellow-and-blue-1935.jpg");  //A.png"

  a = new PSMove(0);
  a.set_leds(blackLevel, blackLevel, blackLevel);
  a.update_leds();
  
  randomSeed(0);
}

void draw() { 
  if (cam.available() == true) {
    cam.read();
    centreOfMass(cam, 100, centreOfLight);

    torchX=(int)map(centreOfLight.x, 0, cam.width, 0, img.width);
    torchY=(int)map(centreOfLight.y, 0, cam.height, 0, img.height);
    color pixel = img.get(torchX, torchY);

    int r=(int)map(red(pixel), 0, 255, blackLevel, 255);
    int g=(int)map(green(pixel), 0, 255, blackLevel, 255);
    int b=(int)map(blue(pixel), 0, 255, blackLevel, 255);

     if(brightness(pixel)==0){
      if(random(1000)>900) {
        r=255;
        g=255;
        b=255;
      }
    }

    a.set_leds(r, g, b);
    a.update_leds();
  }
  
  cam.blend(img, 0, 0, img.width, img.height, 0, 0, cam.width, cam.height, MULTIPLY);

  pushMatrix();
  scale(-1, 1);
  translate(-width, 0);
  //image(cam, (-cam.width)/2, (height-cam.height)/2, cam.width, cam.height);
  image(cam,0,0,width,height);
  popMatrix();
  
  noFill();
  stroke(255);
  ellipseMode(CENTER);
  ellipse(width-map(torchX,0,img.width,0,width),map(torchY,0,img.height,0,height),55,55);

  //rectMode(CENTER); 
  // rect(centreOfLight.x, centreOfLight.y, 50, 50);
}

float centreOfMass(PImage i, int threshold, Point centre) {  
  float var=0.0f;

  int x, y;
  float v;

  float sumOfWeightedXValues=0, sumOfWeightedYValues=0;
  float sumOfValues=0;

  i.loadPixels();
  for (int n = 0; n < i.pixels.length; n++) {
    x=n%i.width;
    y=n/i.width;

    v=brightness(i.pixels[n]);
    if (v<threshold) v=0;
    sumOfWeightedXValues+=x*v;
    sumOfWeightedYValues+=y*v;
    sumOfValues+=v;
  }
  i.updatePixels();

  if (sumOfValues>1000) {
    centre.x=(int)(sumOfWeightedXValues/sumOfValues);
    centre.y=(int)(sumOfWeightedYValues/sumOfValues);
  }
  else {
    centre.x=-100;
    centre.y=-100;
  }

  return(var);
}

