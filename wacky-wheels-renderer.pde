void setup() {  
    size(320, 200); 
    frameRate(60);
} 

int getColor(double cameraX,
             double cameraY,
             double cameraZ,
             double cameraFocalDistance,
             double cameraAngle,
             double cameraFocalRange, 
             int screenX,
             int screenY) {
                 
        double rayDistance = cameraZ / screenY / cameraFocalDistance;

        double rayIntersectionX = cameraX + Math.cos(cameraAngle) * rayDistance;
        double rayIntersectionY = cameraY + Math.sin(cameraAngle) * rayDistance;

        double scanLineHalfLength = cameraFocalRange * rayDistance / cameraFocalDistance;
       
        double scanLineStartX = rayIntersectionX + Math.cos(cameraAngle - Math.PI/2) * scanLineHalfLength;
        double scanLineStartY = rayIntersectionY + Math.sin(cameraAngle - Math.PI/2) * scanLineHalfLength;
        
        double scanLineEndX = rayIntersectionX + Math.cos(cameraAngle + Math.PI/2) * scanLineHalfLength;
        double scanLineEndY = rayIntersectionY + Math.sin(cameraAngle + Math.PI/2) * scanLineHalfLength;
         
        double scanLineStep = 1.0 / (cameraFocalRange * 2.0);
        
        double texelX = scanLineStartX + (scanLineEndX - scanLineStartX) * scanLineStep * screenX;
        double texelY = scanLineStartY + (scanLineEndY - scanLineStartY) * scanLineStep * screenX;
        
        return getMapTexelColor(texelX,texelY);                         
}

int getMapTexelColor(double texelX,double texelY) {
 
     int u = Math.round(texelX);
     int v = Math.round(texelY);
    
     return ((u + v) % 2);    
}

double animAngle = 0.0;

void draw() {  // this is run repeatedly.  

    animAngle += 0.1;
        
    for (int x = 0; x < 320; x++) {
      for (int y = 0; y < 100; y++) {
        
           if (getColor(0,0,10500,100,animAngle,160,x,y) == 0) {
                 stroke(255,0,0);
               } else {
                 stroke(0,255,0);
               }
    
              rect(x,y+100,1,1);   
        }
    }
}

