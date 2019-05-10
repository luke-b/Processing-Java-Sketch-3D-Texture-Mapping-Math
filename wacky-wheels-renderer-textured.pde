// Arrow keys control camera
// 3x 512x512px textures have to be provided (not included)

float animAngle = 0.0;
PImage skyImage;
PImage grassImage;
PImage roadImage;
 
void setup() {  
    size(640, 480); 
    frameRate(200);
    skyImage = loadImage("clouds1.jpg");
    grassImage = loadImage("grass1.png");
    roadImage = loadImage("road1.jpg");
    loadPixels();  
} 
 
 
void drawRow(float cameraX,
             float cameraY,
             float cameraZ,
             float cameraFocalDistance,
             float cameraAngle,
             float cameraFocalRange,
             float pivotDistance, 
             int screenY) {
                 
        float rayDistance = cameraZ / screenY / cameraFocalDistance;
    
        float rayIntersectionX = (float)(cameraX + Math.cos(cameraAngle) * rayDistance - Math.cos(cameraAngle)*pivotDistance);
        float rayIntersectionY = (float)(cameraY + Math.sin(cameraAngle) * rayDistance - Math.sin(cameraAngle)*pivotDistance);
 
        float scanLineHalfLength = cameraFocalRange * rayDistance / cameraFocalDistance;
       
        float scanLineStartX =  (float)(rayIntersectionX + Math.cos(cameraAngle - Math.PI/2) * scanLineHalfLength);
        float scanLineStartY = (float)(rayIntersectionY + Math.sin(cameraAngle - Math.PI/2) * scanLineHalfLength);
        
        float scanLineEndX =  (float)(rayIntersectionX + Math.cos(cameraAngle + Math.PI/2) * scanLineHalfLength);
        float  scanLineEndY = (float)(rayIntersectionY + Math.sin(cameraAngle + Math.PI/2) * scanLineHalfLength);
         
        float scanLineStep = 1.0 / (cameraFocalRange * 2.0);
           
        float texelX = scanLineStartX;
        float texelY = scanLineStartY;
     
        float scanLineXStep = (scanLineEndX - scanLineStartX) * scanLineStep;
        float scanLineYStep = (scanLineEndY - scanLineStartY) * scanLineStep;
        
        float stepX = scanLineXStep;
        float stepY = scanLineYStep;
        
        int u,v;
 
        int row = (screenY+240)*640;
        int row2 = (240-screenY)*640;
        
        float diff = (float)(Math.sin((rayDistance+cameraX)/1000)*300);
        
        for (int screenX = 0; screenX < 640; screenX++) {
        
            u = (int)(Math.abs(texelX)) % 512;
            v = (int)(Math.abs(texelY-diff)) % 512;
          
                  
            if (texelY > 512*5+diff && texelY < 512*6+diff) {
                pixels[row] = roadImage.pixels[(u * 512)+v];   
            } else {
                pixels[row] = grassImage.pixels[(u * 512)+v];   
            }
           
            pixels[row2] = skyImage.pixels[(u * 512)+v];             
            
            
            row++;
            row2++;
                    
            texelX += stepX;
            texelY += stepY;
        }
                                 
}
 
float ride = 0;
float cn = 0;

float camx = 0;
float camy = 512f*5.5f;
float camAngle = 0;
 
void draw() {  // this is run repeatedly.  
      
    for (int y = 1; y < 240; y++) {
          drawRow(camx,camy,15270500f,320f,camAngle,320f,30f,y);
    }
    ride += 1f;
    updatePixels();
    animAngle = (float)(Math.sin(cn)*Math.PI/6);
    cn -= 0.0001;
    
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
       camAngle -= 0.1f;
    } 
    if (keyCode == RIGHT) {
       camAngle += 0.1f;
    }
    if (keyCode == UP) {
       camx += (float)(Math.cos(camAngle)*20f);
       camy += (float)(Math.sin(camAngle)*20f);
    }
 if (keyCode == DOWN) {
       camx -= (float)(Math.cos(camAngle)*20f);
       camy -= (float)(Math.sin(camAngle)*20f);
    }
  }
}
 
