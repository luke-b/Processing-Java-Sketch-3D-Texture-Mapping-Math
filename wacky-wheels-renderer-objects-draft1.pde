// Arrow keys control camera
// !textures have to be provided (not included)

float animAngle = 0.0;
int pixLimit = 640*480;
PImage spritesImage;

PImage grassImage;
PImage roadImage;

DisplayObject[] objects; 
 
void setup() {  
    size(640, 480); 
    frameRate(200);
    spritesImage = loadImage("C:\\Users\\HP\\Desktop\\wacky\\flowers2.png");
    
    grassImage = loadImage("C:\\Users\\HP\\Desktop\\wacky\\texture.jpg");
    roadImage = loadImage("C:\\Users\\HP\\Desktop\\wacky\\road1.jpg");
 
    // initialize random objects
    objects = new DisplayObject[100];
    for (int i = 0; i < objects.length; i++) {
      DisplayObject o = new DisplayObject();
      o.x = (i % 10)*32;
      o.y = (i / 10)*32;
      o.z = 3027005f; // level with the road 3027035f;
      o.size = 32f; //px 15;
      o.spriteIndex = (int)(Math.random()*12*7);
      objects[i] = o;
      
    }
    
    loadPixels();  
} 

void draw2dSprite(int screenX,
                  int screenY,
                  float screenSize,
                  int spriteIndex) {
                    
     int pixelSize = (int)screenSize;
     int w = spriteIndex % 12;
     int h = spriteIndex / 12;
     float xPos = (spriteIndex % 12) * 32;
     float yPos = (spriteIndex / 12 + 1) * 32;
     
     float xStep = 32f/screenSize;
     
     for (int i = 0; i < pixelSize; i++) {
       
        drawStrip(screenX+i,
                  screenY+pixelSize,
                  screenSize,
                  spritesImage.pixels,
                  spritesImage.width,
                  spritesImage.height,
                  xPos,
                  yPos,
                  32f);
                  
        xPos += xStep;
       
     }
}


void drawStrip(int screenX,
               int screenY,
               float screenHeight,
               int[] texture,
               int textureXRes,
               int textureYRes,
               float textureX,
               float textureY,
               float textureHeight) {

    if (screenX < 0) return;
    if (screenX >= 640) return;
                  
    int pixelHeight = (int)screenHeight;
    float textureStep = textureHeight/screenHeight;
    float texYPosition = textureY; 
    int screenIndex = screenY*640+screenX;
    int texXOffset = (int)textureX;
    int pixel;
               
    for (int i = 1; i < pixelHeight; i++) {
        texYPosition -= textureStep;
      if (screenIndex >= 0 && screenIndex < pixLimit) {
        
        pixel = texture[(int)(texYPosition)*textureXRes+texXOffset];
        
        if (alpha(pixel) > 100) {
            pixels[screenIndex] = pixel;
        }
      }
    
      screenIndex -= 640;
    }
}
               
void drawObject(int screenx,
                int screeny,
                float screenSize,
                int spriteIndex,
                int spriteSize,
                int[] texture,
                int rowSpriteCount,
                int textureXRes,
                int textureYRes) {

      int pixelSize = (int)screenSize;
      int xStart = (int)(screenx - screenSize/2);
      float texXStep = (float)spriteSize/screenSize;
      int sprX = spriteIndex % rowSpriteCount;
      int sprY = spriteIndex / rowSpriteCount;
      float texXPosition = sprX*spriteSize;
      int texYPosition = (sprY+1)*spriteSize;
      
    //  if (xStart < 0) return;
    //
    if (xStart >= 640) return;
                  
      for (int i = 0; i < pixelSize; i++) {
        
        drawStrip(xStart,
               screeny,
               screenSize,
               texture,
               textureXRes,
               textureYRes,
               (int)texXPosition,
               texYPosition,
               32f);
        
        xStart++;
        texXPosition += texXStep;
      }
}

 
void projectObjects(float cameraX,
                    float cameraY,
                    float cameraZ,
                    float cameraFocalDistance,
                    float cameraFocalRange,
                    float cameraFocalRangeY,
                    float pivotDistance,
                    float cos,
                    float sin) {
 
  DisplayObject o;
               
  for (int i = 0; i < objects.length; i++) {
   
    o = objects[i];
    o.px = cos * ( o.x - cameraY  + sin * pivotDistance ) - sin * ( o.y - cameraX + cos * pivotDistance) ;  // rotate by camera angle - camera X and Y switched intentionally ...
    o.py = sin * ( o.x - cameraY  + sin * pivotDistance ) + cos * ( o.y - cameraX + cos * pivotDistance);
    o.debugx = (int)o.px;
    o.debugy = (int)o.py;
    
    if (o.py > 0) { // in front of the camera = visible (o.drawOrder != -1)

      o.sx = (( o.px * cameraFocalDistance ) / o.py) + cameraFocalRange;  // project 3d coords to 2d screen coords
      o.sy = (( cameraZ - o.z ) * cameraFocalDistance ) / o.py;
      o.psize = ( o.size * cameraFocalDistance ) / o.py;
      
      o.drawOrder = (int)o.sy; // row to be drawn with
      o.sy += cameraFocalRangeY;
      
     
      
    } else { // behind the camera 
      o.drawOrder = -1; // mark invisible
    }
  }
 
}

int bufSize = 640*480;

void drawDebugMap() {
 
  for (int i = 0; i < objects.length; i++) {
    DisplayObject o = objects[i];
    
    int index = (o.debugx/10+50) + 640 * (o.debugy/10+50);
   //  int index = (int)(o.sx) + 640 * (int)(o.sy);
    
    if (index >= 0 && index < bufSize) {    
      if (o.drawOrder != -1) {
        pixels[index] = 0xffff0000;    
      } else {
        pixels[index] = 0xff000000;    
      }
    }
      
  }
  
}

void drawObjectsForRow(int row) {
  
  DisplayObject o = null;
  
  int pixIndex = 0;
  int pixSize = 0;
  
  for (int i = 0; i < objects.length; i++) {
   
       if (objects[i].drawOrder == row) {
         
           o = objects[i];
           pixIndex = (int)(o.sx) + 640 * (int)(o.sy);
           pixSize = (int)o.psize;
           
           drawObject((int)o.sx,
                (int)o.sy,                
                o.psize,
                o.spriteIndex,
                32,
                spritesImage.pixels,
                12,
                spritesImage.width,
                spritesImage.height);
           
           
        //   for (int j = 0; j < pixSize; j++) {
        //     
        //     if (o.sx > 0 && o.sx < 640 &&
        //         o.sy > 0 && o.sy < 480) {
        //              pixels[pixIndex] = 0xffffffff; 
        //         }
        //     pixIndex -= 640;
        //   }
       }
  }
  
}
 
void drawRow(float cameraX,
             float cameraY,
             float cameraZ,
             float cameraFocalDistance,
             float cameraFocalRange,
             float pivotDistance, 
             int screenY,
             float cos,  // Math.cos(cameraAngle)
             float sin,  // Math.sin(cameraAngle)
             float cosLeft, // Math.cos(cameraAngle - Math.PI/2)
             float sinLeft, // Math.sin(cameraAngle - Math.PI/2)
             float cosRight, // Math.cos(cameraAngle + Math.PI/2)
             float sinRight, // Math.sin(cameraAngle + Math.PI/2)
             float scanLineStep) // = 1.0 / (cameraFocalRange * 2.0);
             {
                 
        float rayDistance = cameraZ / screenY / cameraFocalDistance;
    
        float rayIntersectionX = cameraX + cos * rayDistance - cos * pivotDistance;
        float rayIntersectionY = cameraY + sin * rayDistance - sin * pivotDistance;
 
        float scanLineHalfLength = cameraFocalRange * rayDistance / cameraFocalDistance;
       
        float scanLineStartX = rayIntersectionX + cosLeft * scanLineHalfLength;
        float scanLineStartY = rayIntersectionY + sinLeft * scanLineHalfLength;
        
        float scanLineEndX = rayIntersectionX + cosRight * scanLineHalfLength;
        float scanLineEndY = rayIntersectionY + sinRight * scanLineHalfLength;
           
        float texelX = scanLineStartX;
        float texelY = scanLineStartY;
     
        float scanLineXStep = (scanLineEndX - scanLineStartX) * scanLineStep;
        float scanLineYStep = (scanLineEndY - scanLineStartY) * scanLineStep;
        
        float stepX = scanLineXStep;
        float stepY = scanLineYStep;
        
        int u,v;
        int row = (screenY+240)*640;
            
        for (int screenX = 0; screenX < 640; screenX++) {
            u = (int)(Math.abs(texelX)) % 160;
            v = (int)(Math.abs(texelY)) % 160;
            pixels[row] = grassImage.pixels[(u * 160)+v];   
            row++;
            texelX += stepX;
            texelY += stepY;
        }
 }
 
float ride = 0;
float cn = 0;

float camx = 0;
float camy = 0; //512f*5.5f;
float camAngle = 0;
int halfScreen = 640*240; 
 
void draw() {  // this is run repeatedly.  
      
    for (int i = 0; i < halfScreen; i++) {
      pixels[i] = 0xffaaffff; 
    }
        
    float cos = (float)Math.cos(camAngle);
    float sin = (float)Math.sin(camAngle);
    float cosLeft = (float)Math.cos(camAngle - Math.PI/2);
    float sinLeft = (float)Math.sin(camAngle - Math.PI/2);
    float cosRight = (float)Math.cos(camAngle + Math.PI/2);
    float sinRight = (float)Math.sin(camAngle + Math.PI/2);
    float cameraFocalRange = 320f;
    float scanLineStep = 1f / (cameraFocalRange * 2f);
    
    projectObjects(camx,camy,3027050f,320f,320f,240f,60f,cos,sin);
        
    for (int y = 1; y < 480; y++) {
      //15270500f
     if (y < 240) {
       drawRow(camx,camy,3027050f,320f,320f,60f,y,cos,sin,cosLeft,sinLeft,cosRight,sinRight,scanLineStep);
     }
     drawObjectsForRow(y);
    }
    
    drawDebugMap();
//    draw2dSprite(320,50,128,2);
    
    ride += 1f;
    if (ride > 256) ride = 16;
    updatePixels();
    
    stroke(0);
    line(50,50,70,70);
    line(50,50,30,70);
    //image(spritesImage,0,0);
    animAngle = (float)(Math.sin(cn)*Math.PI/6);
    cn -= 0.0001;

}


class DisplayObject {
 
     public float x,y,z, size;  // map coordinates, size = square size in px
     public float sx,sy;
     public float px,py,pz,psize;  // projected screen coordinates
     public int drawOrder = -1; // -1 invisible, otherwise row to draw to
     public int spriteIndex;
     public int debugx,debugy;
     public float offset;
  
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
       camAngle -= 0.01f;
    } 
    if (keyCode == RIGHT) {
       camAngle += 0.01f;
    }
    if (keyCode == UP) {
       camx += (float)(Math.cos(camAngle)*5f);
       camy += (float)(Math.sin(camAngle)*5f);
    }
 if (keyCode == DOWN) {
       camx -= (float)(Math.cos(camAngle)*5f);
       camy -= (float)(Math.sin(camAngle)*5f);
    }
  }
}
