final int CELL_SIZE = 40;
final int ROWS = 20;
final int COLS = 10;
final int FPS = 300;

final int HIDDEN_LAYERS = 1;
final int HIDDEN_NODES = 4;

final boolean HUMAN_PLAY = false;
final boolean CHECK_NEXT = true;
final boolean GUIDE = false;

final int[][][] tetrominos = {
            {{1, 1, 1},
            {0, 1, 0}},
            
            {{0, 2, 2},
            {2, 2, 0}},
            
            {{3, 3, 0},
            {0, 3, 3}},
            
            {{4, 0, 0},
            {4, 4, 4}},
            
            {{0, 0, 5},
            {5, 5, 5}},
            
            {{6, 6, 6, 6}},
            
            {{7, 7},
            {7, 7}}
          };
          
final color[] colors = { color(0,0,0), color(255,0,0), color(0,255,0), color(0,0,255), color(255,255,0), color(255,0,255), color(0, 255,255), color(255,255,255) };

int highscore = 0;

float mutation_rate = 0.05;
float default_mutation_rate = mutation_rate;

Population pop;

Tetris player;

void settings() {
   size(920,880); 
}

void setup() {
    frameRate(FPS);
    if(HUMAN_PLAY)
      player = new Tetris();
    else
      pop = new Population(200);
}

void draw() {
    background(0);
    if(HUMAN_PLAY) {
        player.update();
        player.show_game();
        player.show_next();
        if(player.dead) {
           highscore = player.score;
           player = new Tetris(); 
        }
    } else {
      if(pop.is_done()) {
          int new_highscore = pop.find_best_tetris().score;
          if(new_highscore > highscore)
              highscore = new_highscore;
          pop.natural_selection();
      } else{
          pop.update();
          pop.show(); 
      }
      stroke(0);
      fill(255);
      textSize(30);
      textAlign(LEFT);
      text("Generation : "+pop.gen,100,460);
      text("Mutation Rate : "+mutation_rate*100+"%",100,500);
      text("Species: "+pop.best_tetris.species_id, 100,540);
    }
    show();
}

void show() {
    
    //WALL
    stroke(0);
    for(int i = 0; i < ROWS+2; i++) {
       fill(100);
       rect(0,i*CELL_SIZE, CELL_SIZE, CELL_SIZE);
       rect(440,i*CELL_SIZE, CELL_SIZE, CELL_SIZE);
       rect(880,i*CELL_SIZE, CELL_SIZE, CELL_SIZE);
    }
    for(int i = 0; i < width/CELL_SIZE; i++) {
       fill(100);
       rect(40+i*CELL_SIZE,0, CELL_SIZE, CELL_SIZE);
       rect(40+i*CELL_SIZE,840, CELL_SIZE, CELL_SIZE);
    }
    fill(255);
    textAlign(LEFT);
    textSize(30);
    if(HUMAN_PLAY) {
      text("Score: "+player.score, 100,90);
      text("Lines: "+player.lines, 100,130);
      text("Tetris: "+player.tetris, 100,170);
    } else {
      text("Score: "+pop.best_tetris.score, 100,90);
      text("Lines: "+pop.best_tetris.lines, 100,130);
      text("Tetris: "+pop.best_tetris.tetris, 100,170);
    }
    text("Highscore : "+highscore,100,210);
}

void keyPressed() {
  if(key == CODED && HUMAN_PLAY) {
     switch(keyCode) {
        case UP:
          player.move(0);
          break;
        case DOWN:
          player.move(1);
          break;
        case LEFT:
          player.move(2);
          break;
        case RIGHT:
          player.move(3);
          break;
     }
  }
}
