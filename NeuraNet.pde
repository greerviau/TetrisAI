class NeuralNet {
  
  int iNodes, hNodes, oNodes, hLayers;
  NetMatrix[] weights;
  
  NeuralNet(int input, int hidden, int output, int hiddenLayers) {
    iNodes = input;
    hNodes = hidden;
    oNodes = output;
    hLayers = hiddenLayers;
    
    weights = new NetMatrix[hLayers+1];
    weights[0] = new NetMatrix(hNodes, iNodes+1);
    for(int i=1; i<hLayers; i++) {
       weights[i] = new NetMatrix(hNodes,hNodes+1); 
    }
    weights[weights.length-1] = new NetMatrix(oNodes,hNodes+1);
    
    for(NetMatrix w : weights) {
       w.randomize(); 
    }
  }
  
  void mutate(float mr) {
     for(NetMatrix w : weights) {
        w.mutate(mr); 
     }
  }
  
  float[] output(float[] inputsArr) {
     NetMatrix inputs = weights[0].single_column_net_matrix_from_array(inputsArr);
     
     NetMatrix curr_bias = inputs.add_bias();
     
     for(int i=0; i<hLayers; i++) {
        NetMatrix hidden_ip = weights[i].dot(curr_bias); 
        NetMatrix hidden_op = hidden_ip.activate();
        curr_bias = hidden_op.add_bias();
     }
     
     NetMatrix output_ip = weights[weights.length-1].dot(curr_bias);
     NetMatrix output = output_ip;
     
     return output.to_array();
  }
  
  NeuralNet crossover(NeuralNet partner) {
     NeuralNet child = new NeuralNet(iNodes,hNodes,oNodes,hLayers);
     for(int i=0; i<weights.length; i++) {
        child.weights[i] = weights[i].crossover(partner.weights[i]);
     }
     return child;
  }
  
  NeuralNet clone() {
     NeuralNet clone = new NeuralNet(iNodes,hNodes,oNodes,hLayers);
     for(int i=0; i<weights.length; i++) {
        clone.weights[i] = weights[i].clone(); 
     }
     
     return clone;
  }
  
  void load(NetMatrix[] weight) {
      for(int i=0; i<weights.length; i++) {
         weights[i] = weight[i]; 
      }
  }
  
  NetMatrix[] pull() {
     NetMatrix[] model = weights.clone();
     return model;
  }
  
  void show(float x, float y, float w, float h, float[] vision, float[] decision) {
     float space = 5;
     float nSize = (h - (space*(iNodes-2))) / iNodes;
     float nSpace = (w - (weights.length*nSize)) / weights.length;
     float hBuff = (h - (space*(hNodes-1)) - (nSize*hNodes))/2;
     float oBuff = (h - (space*(oNodes-1)) - (nSize*oNodes))/2;
     
     int maxIndex = 0;
     for(int i = 1; i < decision.length; i++) {
        if(decision[i] > decision[maxIndex]) {
           maxIndex = i; 
        }
     }
     
     int lc = 1;  //Layer Count
     
     strokeWeight(3);
     //DRAW WEIGHTS
     for(int i = 0; i < weights[0].rows; i++) {  //INPUT TO HIDDEN
        for(int j = 0; j < weights[0].cols-1; j++) {
            if(weights[0].NetMatrix[i][j] < 0) {
               stroke(255,0,0); 
            } else {
               stroke(0,0,255); 
            }
            line(x+nSize,y+(nSize/2)+(j*(space+nSize)),x+nSize+nSpace,y+hBuff+(nSize/2)+(i*(space+nSize)));
        }
     }
     
     lc++;
     
     for(int a = 1; a < hLayers; a++) {
       for(int i = 0; i < weights[a].rows; i++) {  //HIDDEN TO HIDDEN
          for(int j = 0; j < weights[a].cols-1; j++) {
              if(weights[a].NetMatrix[i][j] < 0) {
                 stroke(255,0,0); 
              } else {
                 stroke(0,0,255); 
              }
              line(x+(lc*nSize)+((lc-1)*nSpace),y+hBuff+(nSize/2)+(j*(space+nSize)),x+(lc*nSize)+(lc*nSpace),y+hBuff+(nSize/2)+(i*(space+nSize)));
          }
       }
       lc++;
     }
     
     for(int i = 0; i < weights[weights.length-1].rows; i++) {  //HIDDEN TO OUTPUT
        for(int j = 0; j < weights[weights.length-1].cols-1; j++) {
            if(weights[weights.length-1].NetMatrix[i][j] < 0) {
               stroke(255,0,0); 
            } else {
               stroke(0,0,255); 
            }
            line(x+(lc*nSize)+((lc-1)*nSpace),y+hBuff+(nSize/2)+(j*(space+nSize)),x+(lc*nSize)+(lc*nSpace),y+oBuff+(nSize/2)+(i*(space+nSize)));
        }
     }
     strokeWeight(1);
     lc = 0;
     
     //DRAW NODES
     for(int i = 0; i < iNodes; i++) {  //DRAW INPUTS
         if(vision[i] != 0) {
           fill(0,255,0);
         } else {
           fill(255); 
         }
         stroke(0);
         ellipseMode(CORNER);
         ellipse(x,y+(i*(nSize+space)),nSize,nSize);
         textSize(nSize/2);
         textAlign(CENTER,CENTER);
         fill(0);
         text(i,x+(nSize/2),y+(nSize/2)+(i*(nSize+space)));
     }
     
     lc++;
     
     for(int a = 0; a < hLayers; a++) {
       for(int i = 0; i < hNodes; i++) {  //DRAW HIDDEN
           fill(255);
           stroke(0);
           ellipseMode(CORNER);
           ellipse(x+(lc*nSize)+(lc*nSpace),y+hBuff+(i*(nSize+space)),nSize,nSize);
       }
       lc++;
     }
     
     for(int i = 0; i < oNodes; i++) {  //DRAW OUTPUTS
         fill(255); 
         stroke(0);
         ellipseMode(CORNER);
         ellipse(x+(lc*nSpace)+(lc*nSize),y+oBuff+(i*(nSize+space)),nSize,nSize);
     }
     fill(0);
     textSize(15);
     textAlign(CENTER,CENTER);
     text("Score",x+(lc*nSize)+(lc*nSpace)+nSize/2,y+oBuff+(nSize/2)-2);
  }
}
