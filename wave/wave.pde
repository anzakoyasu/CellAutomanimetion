import ddf.minim.*;

Cell[][] cellArray;
Cell_block[][] blockArray;
PVector[][] map;

int cellSize = 2;
int numx, numy;

int geneBcount = 0;
float rateBlock = 0.55;

int time_step = 0;

Flock flock;
PVector target;
PGraphics pg;
PImage img;

Minim minim;
AudioPlayer player;

void setup(){
  size(400,300,P3D);
  //size(500,350);
  frameRate(30);
  minim = new Minim(this);
  player = minim.loadFile("ame.mp3");
  player.loop();

  
  pg = createGraphics(width, height);
  img = loadImage("tikei.png");
  pg.beginDraw();
  pg.image(img,0,0,width,height);
  pg.endDraw();
  
  
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i <50; i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }

  
  numx = floor(width/cellSize);
  numy = floor(width/cellSize);
  restart();
  noStroke();

}

void restart(){
  time_step = 0;
  geneBcount = 0;
  cellArray = new Cell[numx][numy];
  blockArray = new Cell_block[numx][numy];
  map = new PVector[numx][numy];
  for(int x = 0; x < numx; x++){
    for(int y = 0; y < numy; y++){
      Cell newCell = new Cell(x, y);
      cellArray[x][y] = newCell;
      Cell_block b = new Cell_block(x, y);
      blockArray[x][y] = b;
      map[x][y] = new PVector((noise(x)-0.5),(noise(y)-0.5));
    }
  }
  
  for(int i = 0; i < numx*numy*rateBlock; i++){
    int x = (int)random(numx);
    int y = (int)random(numy);
     blockArray[x][y].nextState = 1;
     blockArray[x][y].state = 1;
  }
  
  for(int x = 0; x < numx; x++){
    for(int y = 0; y < numy; y++){
      int above = y - 1;
      int below = y + 1;
      int left = x - 1;
      int right = x + 1;
      
      if(above < 0 ) above = numy - 1;
      if(below == numy) below = 0;
      if(left < 0) left = numx - 1;
      if(right == numx) right = 0;
      
      cellArray[x][y].addNeighbour(cellArray[left][above]);
      cellArray[x][y].addNeighbour(cellArray[left][y]);
      cellArray[x][y].addNeighbour(cellArray[left][below]);
      cellArray[x][y].addNeighbour(cellArray[x][below]);
      cellArray[x][y].addNeighbour(cellArray[right][below]);
      cellArray[x][y].addNeighbour(cellArray[right][y]);
      cellArray[x][y].addNeighbour(cellArray[right][above]);
      cellArray[x][y].addNeighbour(cellArray[x][above]);
      
      blockArray[x][y].addNeighbour(blockArray[left][above]);
      blockArray[x][y].addNeighbour(blockArray[left][y]);
      blockArray[x][y].addNeighbour(blockArray[left][below]);
      blockArray[x][y].addNeighbour(blockArray[x][below]);
      blockArray[x][y].addNeighbour(blockArray[right][below]);
      blockArray[x][y].addNeighbour(blockArray[right][y]);
      blockArray[x][y].addNeighbour(blockArray[right][above]);
      blockArray[x][y].addNeighbour(blockArray[x][above]);
    }   
  }
}

void draw(){
  geneBcount++;
  //rotateX(PI/8);
  
  colorMode(RGB);
  background(123,186,188);
  tint(255,255,255,128);
  image(pg,0,0);
  colorMode(HSB);

  
  calcRiver();
  for(int x = 0; x < numx; x++){
    for(int y = 0; y < numy; y++){
      cellArray[x][y].calcNextState();
      if(geneBcount < 19)
        blockArray[x][y].calcNextState();
    }
  }
  flock.run();
  translate(cellSize/2, cellSize/2,0);
  
  for(int x = 0; x < numx; x++){
    for(int y = 0; y < numy; y++){
      cellArray[x][y].drawMe();
     blockArray[x][y].drawMe();
    }
  }
  time_step++;
  
}

void mousePressed(){
  restart();
}

void calcRiver(){
  for(int x = 0; x < numx; x++){
    for(int y = 0; y < numy; y++){
      map[x][y].mult(cellArray[x][y].state/100);
      map[x][y].mult(cellArray[x][y].state/100);
    }
  }
}