class Cell{
  float x, y;
  float state;
  float nextState;
  float lastState = 0;
  float rate_step = 300;
  
  boolean nearBlock = false;
  
  Cell[] neighbors;
  
  Cell(float ex, float ey){
    x = ex * cellSize;
    y = ey * cellSize;
    nextState = ((x/300) + (y/200)+ random(-5,5)) * 14;
    state = nextState;
    neighbors = new Cell[0];
  }
  
  void addNeighbour(Cell cell){
    neighbors = (Cell[])append(neighbors, cell);
  }
  
  void calcNextState(){
    float total = 0;
    for(int i = 0; i < neighbors.length; i++){
      total+= neighbors[i].state;
    }
    float average = int(total/8);
    
    total = 0;
    Cell_block b =  blockArray[(int)x%numx][(int)y%numy];
    for(int i = 0; i < b.neighbors.length; i++){
      if(b.neighbors[i].state == 0)
        total++;
    }

    if(total >=3){
      nearBlock = true;
    }else{
      nearBlock = false;
    }
    
    if(random(100)>99.98){
      int r = (int)random(0,20);
      stroke(255,110);
      line(x,y,0+r,x,y-50,40+r);
      noStroke();
    }
    
    if(average == 255){
    //  nextState= 0;
    }else if(average == 0){
      if(time_step % rate_step < 90){
        nextState = 255;
        rate_step = random(100,450);
      }
      
    }else{
      nextState = state + average;
      if(lastState > 0 ) nextState -= lastState;
      if(nextState >= 255) {
        nextState = 255;
        if(random(100) > 70 && time_step > 30){
          int r = (int)random(0,20);
          stroke(255,110);
          line(x,y,0+r,x,y-50,40+r);
          noStroke();
        }

      }else if(nextState < 0 ) {
        nextState = 0;
      }
    }
    
    lastState=state;
  }
 
  void drawMe(){
    state = nextState;
    
    if(nearBlock){
      colorMode(RGB);
      fill(255,255,255,random(250));
      colorMode(HSB);
      ellipse(x*cellSize+cellSize,y*cellSize+cellSize, cellSize+2*cellSize, cellSize+2*cellSize);
    }
    fill(138,180,state/255*140+40,state/255*200);
    rect(x,y, cellSize+0, cellSize+0);
   
  }
}