const std = @import("std");
const rl = @import("raylib");
// const rlm = @import("raylib-math"); // FIX: fix math module

const FixedFifo = @import("./FixedFifo.zig").FixedFifo;
const Ball = @import("./Ball.zig").Ball;

const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 450;

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator();

    var fifo = try FixedFifo.init(allocator, 3);
    defer fifo.deinit(allocator);

    rl.initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "rayz");
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
