// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");
// const rlm = @import("raylib-math");

const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 450;

const Ball = struct {
    position: [3]rl.Vector2,
    size: f32,
    speed: rl.Vector2,

    pub fn init(x: f32, y: f32, size: f32, speed: f32) Ball {
        return Ball{
            .position = [3]rl.Vector2{
                rl.Vector2.init(x, y),
                rl.Vector2.init(x, y),
                rl.Vector2.init(x, y),
            },
            .size = size,
            .speed = rl.Vector2.init(speed, speed),
        };
    }

    pub fn update(self: *Ball) void {
        self.position[2] = self.position[1];
        self.position[1] = self.position[0];

        self.position[0].x += self.speed.x;
        self.position[0].y += self.speed.y;

        // check for y collisions
        if (self.position[0].y <= self.size or self.position[0].y + self.size >= SCREEN_HEIGHT) {
            self.speed.y *= -1;
        }

        // check for x collisions
        if (self.position[0].x <= self.size or self.position[0].x + self.size >= SCREEN_WIDTH) {
            self.speed.x *= -1;
        }
    }

    pub fn draw(self: *Ball) void {
        rl.drawCircleV(self.position[0], self.size, rl.Color.red);
        rl.drawCircleV(self.position[1], self.size, rl.Color.red.alpha(0.7));
        rl.drawCircleV(self.position[2], self.size, rl.Color.red.alpha(0.3));
    }
};

pub fn main() anyerror!void {
    rl.initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "raylib-zig");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    var ball = Ball.init(20, 20, 15, 5);

    //--------------------------------------------------------------------------------------
    // Main game loop
    //--------------------------------------------------------------------------------------
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        ball.update();
        ball.draw();

        rl.drawText("All you codebase are belong to us!", 190, 200, 20, rl.Color.green);
        //----------------------------------------------------------------------------------
    }
}
