class Cell_block extends Cell{
  //aquarium aggression
  int meido = (int)random(30,90);
  Cell_block(float ex, float ey){
    super(ex,ey);
    nextState = 0;
    state = nextState;
    
    if(random(100)>97) meido = 200;
    else if(random(100) < 20) meido = 0;

  }
  
  void calcNextState(){
    float total = 0;
    for(int i = 0; i < neighbors.length; i++){
      total+= neighbors[i].state;
    }
    
    if(total>=4){
      nextState = 1;
    }else{
      nextState = 0;
    }
  }
  
  void drawMe(){
    state = nextState;
    
    if(state == 0){
      fill(140,30,meido);
      rect(x,y, cellSize*2, cellSize*2);
    }
  }
}