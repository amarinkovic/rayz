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

    // rl.setTargetFPS(60); // PERF: don't fix the framerate!

    const camera: rl.Camera3D = rl.Camera3D{
        .position = rl.Vector3.init(0, 20.0, 20.0),
        .target = rl.Vector3.init(0, 0, 0),
        .up = rl.Vector3.init(0, 1, 0),
        .fovy = 45.0,
        .projection = rl.CameraProjection.perspective,
    };

    // const mesh_cilinder = rl.genMeshCylinder(1, 2, 26);
    // const model_cilinder = try rl.loadModelFromMesh(mesh_cilinder);

    // const image = rl.genImageCellular(200, 300, 10);
    const image = rl.genImagePerlinNoise(100, 100, 10, 20, 0.4);
    const texture = try rl.loadTextureFromImage(image);
    //
    // rl.setMaterialTexture(model_cilinder.materials, rl.MaterialMapIndex.albedo, texture);

    // var position = rl.Vector3.zero();
    const position = rl.Vector3.zero();

    // blender model
    const blender = try rl.loadModel("model/spiral_cubes.glb");
    rl.setMaterialTexture(blender.materials, rl.MaterialMapIndex.albedo, texture);

    //--------------------------------------------------------------------------------------
    // Main game loop
    //--------------------------------------------------------------------------------------
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // const dt = rl.getFrameTime();
        // position.x += 2 * dt;

        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        rl.beginMode3D(camera);
        defer rl.endMode3D();

        rl.drawGrid(50, 0.5);
        // rl.drawModel(model_cilinder, position, 1, rl.Color.red);
        rl.drawModel(blender, position, 1, rl.Color.red);

        rl.drawText("All you codebase are belong to us!", 190, 200, 20, rl.Color.green);
        //----------------------------------------------------------------------------------
    }
}
