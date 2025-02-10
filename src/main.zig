const std = @import("std");
const rl = @import("raylib");

const SCREEN_WIDTH = 1200;
const SCREEN_HEIGHT = 800;

pub fn main() anyerror!void {
    rl.initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "rayz");
    defer rl.closeWindow(); // Close window and OpenGL context

    // rl.setTargetFPS(60); // PERF: don't fix the framerate!

    var camera: rl.Camera3D = rl.Camera3D{
        .position = rl.Vector3.init(0, 20.0, 20.0),
        .target = rl.Vector3.init(0, 0, 0),
        .up = rl.Vector3.init(0, 1, 0),
        .fovy = 45.0,
        .projection = rl.CameraProjection.perspective,
    };
    rl.hideCursor();

    const floorImg = rl.genImageChecked(150, 150, 4, 4, rl.Color.blue, rl.Color.dark_blue);
    const floorTexture = try rl.loadTextureFromImage(floorImg);
    const floor = try rl.loadModelFromMesh(rl.genMeshPlane(150, 150, 1, 1));
    rl.setMaterialTexture(floor.materials, rl.MaterialMapIndex.albedo, floorTexture);

    const zero = rl.Vector3.zero();

    // blender model
    const spiral = try rl.loadModel("model/spiral_cubes.glb");
    const modelImage = rl.genImageCellular(200, 300, 30);
    // const modelImage = rl.genImagePerlinNoise(100, 100, 10, 20, 0.4);
    const modelTexture = try rl.loadTextureFromImage(modelImage);
    rl.setMaterialTexture(spiral.materials, rl.MaterialMapIndex.albedo, modelTexture);

    //---------[ MAIN LOOP ]----------------------------------------------------------------

    while (!rl.windowShouldClose()) {

        //-----[ UPDATE ]-------------------------------------------------------------------
        // const dt = rl.getFrameTime();
        rl.updateCamera(&camera, rl.CameraMode.free);
        rl.setMousePosition(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
        //----------------------------------------------------------------------------------

        //-----[ DRAW ]---------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        rl.beginMode3D(camera);

        rl.drawModel(floor, zero, 1, rl.Color.dark_brown);
        rl.drawModel(spiral, zero, 1, rl.Color.green);

        rl.endMode3D();

        rl.drawText(rl.textFormat("Raylib: %d fps", .{rl.getFPS()}), 10, 20, 20, rl.Color.green);

        //----------------------------------------------------------------------------------
    }
}
