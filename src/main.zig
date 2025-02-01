const std = @import("std");
const rl = @import("raylib");

const SCREEN_WIDTH = 1200;
const SCREEN_HEIGHT = 800;

pub fn main() anyerror!void {
    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit();
    //
    // const allocator = &arena.allocator();
    //
    // var ball = try Ball.init(20, 20, 15, 10, allocator, 100);
    // defer ball.deinit(allocator);

    rl.initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "rayz");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    const camera: rl.Camera3D = rl.Camera3D{
        .position = rl.Vector3.init(0, 5.0, 5.0),
        .target = rl.Vector3.init(0, 0, 0),
        .up = rl.Vector3.init(0, 1, 0),
        .fovy = 45.0,
        .projection = rl.CameraProjection.perspective,
    };

    //--------------------------------------------------------------------------------------
    // Main game loop
    //--------------------------------------------------------------------------------------
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // const dt = rl.getFrameTime();

        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        rl.beginMode3D(camera);
        defer rl.endMode3D();

        rl.drawGrid(10, 1);

        rl.drawText("All you codebase are belong to us!", 190, 200, 20, rl.Color.green);
        //----------------------------------------------------------------------------------
    }
}
