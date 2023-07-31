int cols, rows;
int w = 40; // Tamaño de cada celda
int[][] grid;
boolean[][] visited;
int playerX, playerY;
boolean gameWon = false;

void setup() {
  size(400, 400);
  cols = width / w;
  rows = height / w;
  grid = new int[cols][rows];
  visited = new boolean[cols][rows];
  initializeGrid();
  generateMaze(0, 0);
  playerX = 0;
  playerY = 0;
}

void draw() {
  background(255);
  drawMaze();
  if (!gameWon) {
    drawPlayer();
    checkWin();
  } else {
    showWinMessage();
  }
}

void initializeGrid() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j] = 1; // Todas las celdas son obstáculos inicialmente
      visited[i][j] = false; // Ninguna celda ha sido visitada
    }
  }
}

void generateMaze(int x, int y) {
  visited[x][y] = true;
  
  int[] neighbors = getNeighbors(x, y);
  while (neighbors.length > 0) {
    int nextIndex = int(random(neighbors.length));
    int nextX = neighbors[nextIndex] / rows;
    int nextY = neighbors[nextIndex] % rows;
    
    if (!visited[nextX][nextY]) {
      removeWall(x, y, nextX, nextY);
      generateMaze(nextX, nextY);
    }
    
    neighbors = getNeighbors(x, y);
  }
}

int[] getNeighbors(int x, int y) {
  ArrayList<Integer> neighbors = new ArrayList<Integer>();
  
  if (x > 0) neighbors.add((x - 1) * rows + y); // Izquierda
  if (x < cols - 1) neighbors.add((x + 1) * rows + y); // Derecha
  if (y > 0) neighbors.add(x * rows + y - 1); // Arriba
  if (y < rows - 1) neighbors.add(x * rows + y + 1); // Abajo
  
  neighbors.removeIf((n) -> visited[n / rows][n % rows]);
  
  int[] result = new int[neighbors.size()];
  for (int i = 0; i < neighbors.size(); i++) {
    result[i] = neighbors.get(i);
  }
  return result;
}

void removeWall(int x1, int y1, int x2, int y2) {
  int dx = x2 - x1;
  int dy = y2 - y1;
  
  if (dx == 1) {
    grid[x1][y1] &= ~2; // Derecha
    grid[x2][y2] &= ~8; // Izquierda
  } else if (dx == -1) {
    grid[x1][y1] &= ~8; // Izquierda
    grid[x2][y2] &= ~2; // Derecha
  }
  
  if (dy == 1) {
    grid[x1][y1] &= ~4; // Abajo
    grid[x2][y2] &= ~1; // Arriba
  } else if (dy == -1) {
    grid[x1][y1] &= ~1; // Arriba
    grid[x2][y2] &= ~4; // Abajo
  }
}

void drawMaze() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int x = i * w;
      int y = j * w;
      if ((grid[i][j] & 1) > 0) line(x, y, x + w, y); // Arriba
      if ((grid[i][j] & 2) > 0) line(x + w, y, x + w, y + w); // Derecha
      if ((grid[i][j] & 4) > 0) line(x, y + w, x + w, y + w); // Abajo
      if ((grid[i][j] & 8) > 0) line(x, y, x, y + w); // Izquierda
    }
  }
}

void drawPlayer() {
  int x = playerX * w + w/2;
  int y = playerY * w + w/2;
  fill(255, 0, 0);
  ellipse(x, y, w/2, w/2); // Dibujar jugador como un círculo rojo
}

void checkWin() {
  if (playerX == cols - 1 && playerY == rows - 1) {
    gameWon = true;
  }
}

void showWinMessage() {
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(30);
  text("¡Ganaste!", width/2, height/2);
}
void keyPressed() {
  if (key == 'w' && playerY > 0 && (grid[playerX][playerY] & 1) == 0) {
    playerY--;
  } else if (key == 's' && playerY < rows - 1 && (grid[playerX][playerY + 1] & 1) == 0) {
    playerY++;
  } else if (key == 'a' && playerX > 0 && (grid[playerX][playerY] & 8) == 0) {
    playerX--;
  } else if (key == 'd' && playerX < cols - 1 && (grid[playerX + 1][playerY] & 8) == 0) {
    playerX++;
  }
}
