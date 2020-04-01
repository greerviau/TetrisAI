class Matrix {
   int[][] matrix;
   int rows, cols;
   public Matrix(int r, int c) {
      rows = r;
      cols = c;
      matrix = new int[rows][cols];
   }
   
   void insert_at(float x, float y, int val) {
      int X = int(x);
      int Y = int(y);
      matrix[Y][X] = val;
   }
   
   void insert_all_at(float x, float y, int[][] M) {
      int X = int(x);
      int Y = int(y);
      for(int i = 0; i < M.length; i++) {
          for(int j = 0; j < M[0].length; j++) {
             matrix[i+Y][j+X] = max(matrix[i+Y][j+X], M[i][j]); 
          }
      }
   }
   
   boolean is_row_full(int r) {
    boolean full = true;
    for (int c = 0 ; c < matrix[r].length ; c++) {
      if (matrix[r][c] == 0) {
        full = false;
      }
    }
    return full;
  }
   
   int[][] get_matrix() {
     return matrix;
   }
   
   int[] get_row(int r) {
     return matrix[r];
   }
   
   int[] get_col(int c) {
      int[] column = new int[rows];
      for(int i = 0; i < rows; i++) {
         column[i] = matrix[i][c];
      }
      return column;
   }
   
   int get_col_height(int c) {
      int h = 0;
      for (int r = 0 ; r < matrix.length ; r++) {
        boolean full = is_row_full(r);
        if(matrix[r][c] != 0 && h == 0 && !full) {
          h = matrix.length - r;
  
        }
        if (h > 0 && full) {
          h--;
        }
      }
  
      return h;
   }
   
   int get_at(int x, int y) {
      return matrix[y][x]; 
   }
   
   boolean check_collision(float x, float y, int[][] M) {
      int X = int(x);
      int Y = int(y);
      if(x < 0 || x + M[0].length > cols) {
          return true;
      } if(y+M.length > rows) {
          return true;
      } 
      for(int i = 0; i < M.length; i++) {
          for(int j = 0; j < M[0].length; j++) {
              if(M[i][j] != 0 && matrix[Y+i][X+j] != 0) {
                  return true;
              }
          }
      }
      return false;
   }
   
   int clear_lines() {
        int cleared = 0;
        for(int i = 0; i < ROWS; i++) {
            int[] line = matrix[i];
            boolean clearable = true;
            for(int k = 0; k < line.length; k++) {
                if(line[k] == 0)
                    clearable = false;
            }
            if(clearable) {
                cleared += 1;
                for(int j = i; j > 0; j--) {
                    matrix[j] = matrix[j-1];
                }
            }
        }
        return cleared;
    }
    
    int count_holes() {
        int holes = 0;
        for(int i = 0; i < cols; i++) {
             int[] column = get_col(i);
             boolean start_counting = false;
             for(int j = 0; j < column.length; j++) {
                 if(column[j] != 0 && !start_counting) {
                     start_counting = true;
                 } else if(column[j] == 0 && start_counting) {
                     holes++;
                 }
             }
         }
         return holes;
    }
    
    int calculate_terrain() {
        int bumpiness = 0;
        int prevHeight = -1;
        for (int c = 0 ; c < COLS ; c++) {
          int h = get_col_height(c);
          if (prevHeight != -1) {
            bumpiness += abs(h - prevHeight);
          }
      
          prevHeight = h;
        }
      
        return bumpiness;
    }
    
    int get_max_height() {
       int max_h = 0;
       for (int c = 0 ; c < COLS ; c++) {
          int h = get_col_height(c);
          if (h > max_h) {
             max_h = h;
          }
        }
        return max_h;
    }
    
    int get_min_height() {
       int min_h = ROWS;
       for (int c = 0 ; c < COLS ; c++) {
          int h = get_col_height(c);
          if (h < min_h) {
             min_h = h;
          }
        }
        return min_h;
    }
   
    Matrix copy() {
      Matrix m_copy = new Matrix(rows, cols);
      for(int i = 0; i < rows; i++) {
          for(int j = 0; j < cols; j++) {
              m_copy.insert_at(j, i, matrix[i][j]);
          }
      }
      return m_copy;
    }
   
    String to_string() {
       String str = "";
       for(int i = 0; i < rows; i++) {
          for(int j = 0; j < cols; j++) {
             str+=str(matrix[i][j]); 
          }
          str+="\n";
       }
       return str;
    }
}
