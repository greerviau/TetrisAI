class Population {
   
   Tetris[] tetris_pop;
   Tetris best_tetris;
   
   int gen = 1;
   int same_best = 0;
   
   float best_score = 0;
   float fitness_sum = 0;
   
   Population(int size) {
      tetris_pop = new Tetris[size]; 
      for(int i = 0; i < tetris_pop.length; i++) {
         tetris_pop[i] = new Tetris(i+1); 
      }
      best_tetris = tetris_pop[0];
      best_tetris.is_best = true;
   }
   
   boolean is_done() {  //check if all the tetris_pop in the population are dead
      for(int i = 0; i < tetris_pop.length; i++) {
         if(!tetris_pop[i].dead)
           return false;
      }
      return true;
   }
   
   void update() {  //update all the tetris_pop in the generation
      if(best_tetris.dead) {
         best_tetris.is_best = false;
         best_tetris = find_best_tetris_alive();
         best_tetris.is_best = true;
      }
      for(int i = 0; i < tetris_pop.length; i++) {
        if(!tetris_pop[i].dead) {
           tetris_pop[i].update(); 
        }
      }
   }
   
   void show() {  //show either the best Tetris or all the tetris_pop
      best_tetris.show_game();
      best_tetris.show_next();
      best_tetris.brain.show(100,570,250,250,new float[5], new float[1]);
   }
   
   Tetris find_best_tetris_alive() {  //set the best Tetris of the generation
       float max = 0;
       int max_index = 0;
       for(int i = 0; i < tetris_pop.length; i++) {
          if(!tetris_pop[i].dead && tetris_pop[i].fitness() > max) {
             max = tetris_pop[i].fitness();
             max_index = i;
          }
       }
       return tetris_pop[max_index];
   }
   
   Tetris find_best_tetris() {  //set the best Tetris of the generation
       float max = 0;
       int max_index = 0;
       for(int i = 0; i < tetris_pop.length; i++) {
          if(tetris_pop[i].fitness() > max) {
             max = tetris_pop[i].fitness();
             max_index = i;
          }
       }
       return tetris_pop[max_index];
   }
   
   Tetris select_parent() {  //selects a random number in range of the fitnesssum and if a Tetris falls in that range then select it
      float rand = random(fitness_sum);
      float summation = 0;
      for(int i = 0; i < tetris_pop.length; i++) {
         summation += tetris_pop[i].fitness();
         if(summation > rand) {
           return tetris_pop[i];
         }
      }
      return tetris_pop[0];
   }
   
   void natural_selection() {
      Tetris[] newtetris_pop = new Tetris[tetris_pop.length];
      
      best_tetris = find_best_tetris();
      best_tetris.is_best = true;
      calculate_fitness_sum();
      
      newtetris_pop[0] = best_tetris.clone();  //add the best Tetris of the prior generation into the new generation
      for(int i = 1; i < tetris_pop.length; i++) {
         Tetris child = select_parent().crossover(select_parent());
         child.mutate();
         newtetris_pop[i] = child;
      }
      tetris_pop = newtetris_pop.clone();
      gen+=1;
   }
   
   void mutate() {
       for(int i = 1; i < tetris_pop.length; i++) {  //start from 1 as to not override the best Tetris placed in index 0
          tetris_pop[i].mutate(); 
       }
   }
   
   void calculate_fitness_sum() {  //calculate the sum of all the tetris_pop fitnesses
       fitness_sum = 0;
       for(int i = 0; i < tetris_pop.length; i++) {
         fitness_sum += tetris_pop[i].fitness(); 
      }
   }
}
