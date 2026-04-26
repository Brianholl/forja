#include <raylib.h>
#include <stdio.h>

#define COLS 20
#define ROWS 15
#define TILE 32

static const char MAP[ROWS][COLS + 1] = {
    "####################",
    "#........#.........#",
    "#.####.#.#.#######.#",
    "#.#....#...#.......#",
    "#.#.####.###.#####.#",
    "#.#.#.......#....#.#",
    "#...#.#####.####.#.#",
    "###.#.#...#......#.#",
    "#...#.#.#.########.#",
    "#.###.#.#..........#",
    "#.....#.###.######.#",
    "#.#####.#...#......#",
    "#.......#.###.####.#",
    "#########.........E#",
    "####################",
};

static int  px = 1, py = 1;
static int  pasos = 0;
static bool ganaste = false;

static bool transitable(int x, int y) {
    if (x < 0 || x >= COLS || y < 0 || y >= ROWS) return false;
    return MAP[y][x] != '#';
}

static void mover(int dx, int dy) {
    int nx = px + dx, ny = py + dy;
    if (transitable(nx, ny)) {
        px = nx; py = ny;
        pasos++;
        if (MAP[ny][nx] == 'E') ganaste = true;
    }
}

int main(void) {
    InitWindow(COLS * TILE, ROWS * TILE + 40, "Rogue de la Forja");
    SetTargetFPS(60);

    while (!WindowShouldClose()) {
        if (!ganaste) {
            if (IsKeyPressed(KEY_UP))    mover(0, -1);
            if (IsKeyPressed(KEY_DOWN))  mover(0,  1);
            if (IsKeyPressed(KEY_LEFT))  mover(-1, 0);
            if (IsKeyPressed(KEY_RIGHT)) mover( 1, 0);
        }
        if (IsKeyPressed(KEY_R)) {
            px = 1; py = 1; pasos = 0; ganaste = false;
        }

        BeginDrawing();
        ClearBackground(BLACK);

        for (int y = 0; y < ROWS; y++) {
            for (int x = 0; x < COLS; x++) {
                char c = MAP[y][x];
                Rectangle rec = { (float)(x * TILE), (float)(y * TILE), TILE, TILE };
                if (c == '#') {
                    DrawRectangleRec(rec, DARKGRAY);
                    DrawRectangleLinesEx(rec, 1, (Color){80, 80, 80, 255});
                } else if (c == 'E') {
                    DrawRectangleRec(rec, DARKGREEN);
                    DrawText("E", x * TILE + 10, y * TILE + 8, 18, GREEN);
                }
            }
        }

        DrawRectangle(px * TILE + 4, py * TILE + 4, TILE - 8, TILE - 8, GOLD);
        DrawText("@", px * TILE + 9, py * TILE + 6, 20, BLACK);

        char hud[80];
        snprintf(hud, sizeof(hud), "Pasos: %d   [Flechas] mover   [R] reiniciar", pasos);
        DrawText(hud, 8, ROWS * TILE + 10, 16, LIGHTGRAY);

        if (ganaste) {
            DrawRectangle(0, ROWS * TILE / 2 - 30, COLS * TILE, 70, (Color){0, 0, 0, 200});
            DrawText("¡Llegaste a la salida!", COLS * TILE / 2 - 130, ROWS * TILE / 2 - 20, 24, GOLD);
            char fin[64];
            snprintf(fin, sizeof(fin), "Pasos: %d   [R] para jugar de nuevo", pasos);
            DrawText(fin, COLS * TILE / 2 - 120, ROWS * TILE / 2 + 15, 16, LIGHTGRAY);
        }

        EndDrawing();
    }

    CloseWindow();
    return 0;
}
