const std = @import("std");
const rl = @import("raylib");
const Ball = @import("./Ball.zig").Ball;

const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 450;
const WORLD_SIZE = 20.0;

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator();

    // Create a 3D ball starting at position (0, 0, 0)
    var ball = try Ball.init(0, 0, 0, 1.0, 0.2, allocator, 50);
    defer ball.deinit(allocator);

    rl.initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "rayz - 3D Bouncing Ball");
    defer rl.closeWindow();

    // Define the 3D camera
    var camera = rl.Camera3D{
        .position = rl.Vector3.init(30.0, 20.0, 30.0),
        .target = rl.Vector3.init(0.0, 0.0, 0.0),
        .up = rl.Vector3.init(0.0, 1.0, 0.0),
        .fovy = 45.0,
        .projection = rl.CameraProjection.camera_perspective,
    };

    rl.setTargetFPS(60);

    var camera_angle: f32 = 0.0;

    while (!rl.windowShouldClose()) {
        // Update camera rotation
        camera_angle += 0.01;
        camera.position.x = @cos(camera_angle) * 30.0;
        camera.position.z = @sin(camera_angle) * 30.0;

        // Update ball physics
        ball.update();

        // Draw
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.init(20, 20, 40, 255));

        // Begin 3D mode
        rl.beginMode3D(camera);
        
        // Draw the world boundaries (wireframe cube)
        rl.drawCubeWires(
            rl.Vector3.init(0.0, 0.0, 0.0),
            WORLD_SIZE * 2,
            WORLD_SIZE * 2,
            WORLD_SIZE * 2,
            rl.Color.white.alpha(0.3)
        );

        // Draw coordinate axes for reference
        rl.drawLine3D(
            rl.Vector3.init(-WORLD_SIZE, 0, 0),
            rl.Vector3.init(WORLD_SIZE, 0, 0),
            rl.Color.red
        );
        rl.drawLine3D(
            rl.Vector3.init(0, -WORLD_SIZE, 0),
            rl.Vector3.init(0, WORLD_SIZE, 0),
            rl.Color.green
        );
        rl.drawLine3D(
            rl.Vector3.init(0, 0, -WORLD_SIZE),
            rl.Vector3.init(0, 0, WORLD_SIZE),
            rl.Color.blue
        );

        // Draw the ball with its trail
        ball.draw();

        // Draw a grid on the floor for better depth perception
        rl.drawGrid(20, 2.0);

        rl.endMode3D();

        // Draw 2D UI elements
        rl.drawText("3D Bouncing Ball with Trail", 10, 10, 20, rl.Color.white);
        rl.drawText("Camera rotates automatically", 10, 35, 16, rl.Color.gray);
        rl.drawText("Red=X, Green=Y, Blue=Z axes", 10, 55, 16, rl.Color.gray);
        
        rl.drawFPS(SCREEN_WIDTH - 100, 10);
    }
}