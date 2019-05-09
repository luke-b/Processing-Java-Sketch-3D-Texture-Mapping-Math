double animAngle = 0.0;

void setup() {  
    size(640, 480); 
    frameRate(200);
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
    
        float rayIntersectionX = cameraX + Math.cos(cameraAngle) * rayDistance - Math.cos(cameraAngle)*pivotDistance;
        float rayIntersectionY = cameraY + Math.sin(cameraAngle) * rayDistance - Math.sin(cameraAngle)*pivotDistance;

        float scanLineHalfLength = cameraFocalRange * rayDistance / cameraFocalDistance;
       
        float scanLineStartX = rayIntersectionX + Math.cos(cameraAngle - Math.PI/2) * scanLineHalfLength;
        float scanLineStartY = rayIntersectionY + Math.sin(cameraAngle - Math.PI/2) * scanLineHalfLength;
        
        float scanLineEndX = rayIntersectionX + Math.cos(cameraAngle + Math.PI/2) * scanLineHalfLength;
        float  scanLineEndY = rayIntersectionY + Math.sin(cameraAngle + Math.PI/2) * scanLineHalfLength;
         
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
        
        for (int screenX = 0; screenX < 640; screenX++) {
        
            u = int(Math.abs(texelX)) % 8;
            v = int(Math.abs(texelY)) % 8;
                    
            pixels[row] = grass[(u * 8)+v];   
            pixels[row2] = sky[(u * 8)+v];             
            
            row++;
            row2++;
                    
            texelX += stepX;
            texelY += stepY;
        }
                                 
}


void draw() {  // this is run repeatedly.  
      
    for (int y = 1; y < 240; y++) {
          drawRow(1000,1000,1270500,320,animAngle,320,25,y);
    }
    updatePixels();
    animAngle += 0.005;
    
}

int[] grass = {
             0xFFFFaaaa,0xFFFF0000,0xFFFF0000,0xFFFF0000,0xFF00FF00,0xFF00FF00,0xFF00FF00,0xFFaaFFaa,
             0xFFFF0000,0xFFFFaaaa,0xFFFF0000,0xFFFF0000,0xFF00FF00,0xFF00FF00,0xFFaaFFaa,0xFF00FF00,
             0xFFFF0000,0xFFFF0000,0xFFFFaaaa,0xFFFF0000,0xFF00FF00,0xFFaaFFaa,0xFF00FF00,0xFF00FF00,
             0xFFFF0000,0xFFFF0000,0xFFFF0000,0xFFFFaaaa,0xFFaaFFaa,0xFF00FF00,0xFF00FF00,0xFF00FF00,
             0xFF0000FF,0xFF0000FF,0xFF0000FF,0xFFaaaaFF,0xFFFFFF00,0xFFFFFF00,0xFFFFFF00,0xFFFFFF00,
             0xFF0000FF,0xFF0000FF,0xFFaaaaFF,0xFF0000FF,0xFFFFFF00,0xFFFFFF00,0xFFFFFF00,0xFFFFFF00,
             0xFF0000FF,0xFFaaaaFF,0xFF0000FF,0xFF0000FF,0xFFFFFF00,0xFFFFFF00,0xFFFFFF00,0xFFFFFF00,
             0xFFaaaaFF,0xFF0000FF,0xFF0000FF,0xFF0000FF,0xFFFFFF00,0xFFFFFF00,0xFFFFFF00,0xFFFFFF00
             };
             
int[] sky = {
            0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,
            0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,
             0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,
            0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,
             0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,
            0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,
             0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,
            0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF,0xFF9999FF,0xFFddddFF
            };
