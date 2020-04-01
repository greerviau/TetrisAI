class NetMatrix {
  
  int rows, cols;
  float[][] NetMatrix;
  
   NetMatrix(int r, int c) {
     rows = r;
     cols = c;
     NetMatrix = new float[rows][cols];
   }
   
   NetMatrix(float[][] m) {
      NetMatrix = m;
      rows = NetMatrix.length;
      cols = NetMatrix[0].length;
   }
   
   void output() {
      for(int i = 0; i < rows; i++) {
         for(int j = 0; j < cols; j++) {
            print(NetMatrix[i][j] + " "); 
         }
         println();
      }
      println();
   }
   
   NetMatrix dot(NetMatrix n) {
     NetMatrix result = new NetMatrix(rows, n.cols);
     
     if(cols == n.rows) {
        for(int i = 0; i < rows; i++) {
           for(int j = 0; j < n.cols; j++) {
              float sum = 0;
              for(int k = 0; k < cols; k++) {
                 sum += NetMatrix[i][k]*n.NetMatrix[k][j];
              }  
              result.NetMatrix[i][j] = sum;
           }
        }
     }
     return result;
   }
   
   void randomize() {
      for(int i = 0; i < rows; i++) {
         for(int j = 0; j < cols; j++) {
            NetMatrix[i][j] = random(-1,1); 
         }
      }
   }
   
   NetMatrix single_column_net_matrix_from_array(float[] arr) {
      NetMatrix n = new NetMatrix(arr.length, 1);
      for(int i = 0; i < arr.length; i++) {
         n.NetMatrix[i][0] = arr[i]; 
      }
      return n;
   }
   
   float[] to_array() {
      float[] arr = new float[rows*cols];
      for(int i = 0; i < rows; i++) {
         for(int j = 0; j < cols; j++) {
            arr[j+i*cols] = NetMatrix[i][j]; 
         }
      }
      return arr;
   }
   
   NetMatrix add_bias() {
      NetMatrix n = new NetMatrix(rows+1, 1);
      for(int i = 0; i < rows; i++) {
         n.NetMatrix[i][0] = NetMatrix[i][0]; 
      }
      n.NetMatrix[rows][0] = 1;
      return n;
   }
   
   NetMatrix activate() {
      NetMatrix n = new NetMatrix(rows, cols);
      for(int i = 0; i < rows; i++) {
         for(int j = 0; j < cols; j++) {
            n.NetMatrix[i][j] = relu(NetMatrix[i][j]); 
         }
      }
      return n;
   }
   
   float relu(float x) {
       return max(0,x);
   }
   
   void mutate(float mutationRate) {
      for(int i = 0; i < rows; i++) {
         for(int j = 0; j < cols; j++) {
            float rand = random(1);
            if(rand<mutationRate) {
               NetMatrix[i][j] += randomGaussian()/5;
               
               if(NetMatrix[i][j] > 1) {
                  NetMatrix[i][j] = 1;
               }
               if(NetMatrix[i][j] <-1) {
                 NetMatrix[i][j] = -1;
               }
            }
         }
      }
   }
   
   NetMatrix crossover(NetMatrix partner) {
      NetMatrix child = new NetMatrix(rows, cols);
      
      int randC = floor(random(cols));
      int randR = floor(random(rows));
      
      for(int i = 0; i < rows; i++) {
         for(int j = 0;  j < cols; j++) {
            if((i  < randR) || (i == randR && j <= randC)) {
               child.NetMatrix[i][j] = NetMatrix[i][j]; 
            } else {
              child.NetMatrix[i][j] = partner.NetMatrix[i][j];
            }
         }
      }
      return child;
   }
   
   NetMatrix clone() {
      NetMatrix clone = new NetMatrix(rows, cols);
      for(int i = 0; i < rows; i++) {
         for(int j = 0; j < cols; j++) {
            clone.NetMatrix[i][j] = NetMatrix[i][j]; 
         }
      }
      return clone;
   }
}
