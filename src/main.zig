
const rl = @import("raylib");
// const rlm = @import("raylib-math");

const ball = @import("./Ball.zig");

const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 450;

pub fn main() anyerror!void {
    rl.initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "raylib-zig");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    var ballInstance = ball.Ball.init(20, 20, 15, 5);

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

        ballInstance.update();
        ballInstance.draw();

        rl.drawText("All you codebase are belong to us!", 190, 200, 20, rl.Color.green);
        //----------------------------------------------------------------------------------
    }
}
