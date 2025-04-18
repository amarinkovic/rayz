const std = @import("std");
const rl = @import("raylib");

const SCREEN_WIDTH = 1200;
const SCREEN_HEIGHT = 800;

pub fn main() anyerror!void {
    // window
    rl.setConfigFlags(rl.ConfigFlags{ .window_undecorated = true });
    rl.setConfigFlags(rl.ConfigFlags{ .msaa_4x_hint = true });

    rl.initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "rayz");
    defer rl.closeWindow(); // Close window and OpenGL context

    // camera
    var camera: rl.Camera3D = rl.Camera3D{
        .position = rl.Vector3.init(0, 20.0, 20.0),
        .target = rl.Vector3.init(0, 0, 0),
        .up = rl.Vector3.init(0, 1, 0),
        .fovy = 45.0,
        .projection = rl.CameraProjection.perspective,
    };
    rl.disableCursor();

    // floor
    const floorImg = rl.genImageChecked(151, 150, 4, 4, rl.Color.blue, rl.Color.dark_blue);
    const floorTexture = try rl.loadTextureFromImage(floorImg);
    const floor = try rl.loadModelFromMesh(rl.genMeshPlane(150, 150, 1, 1));
    rl.setMaterialTexture(floor.materials, rl.MaterialMapIndex.albedo, floorTexture);

    defer rl.unloadModel(floor);
    defer rl.unloadTexture(floorTexture);

    const lightShader = try rl.loadShader("resources/shaders/glsl330/lighting.vs", "resources/shaders/glsl330/lighting.fs");
    defer rl.unloadShader(lightShader);

    // main blender model
    const model = try rl.loadModel("resources/models/head.glb");
    // const modelImage = rl.genImageCellular(200, 300, 30);
    // const modelTexture = try rl.loadTextureFromImage(modelImage);
    // rl.setMaterialTexture(model.materials, rl.MaterialMapIndex.albedo, modelTexture);

    // defer rl.unloadTexture(modelTexture);
    defer rl.unloadModel(model);

    const bloomShader = try rl.loadShader(null, "resources/shaders/bloom.glsl");
    defer rl.unloadShader(bloomShader);

    const renderTexture = try rl.loadRenderTexture(SCREEN_WIDTH, SCREEN_HEIGHT);
    defer rl.unloadRenderTexture(renderTexture);

    const zero2 = rl.Vector2.zero();
    const zero3 = rl.Vector3.zero();

    const renderArea = rl.Rectangle{ .height = SCREEN_HEIGHT * -1, .width = SCREEN_WIDTH, .x = 0, .y = 0 };

    //---------[ MAIN LOOP ]----------------------------------------------------------------

    while (!rl.windowShouldClose()) {

        //-----[ UPDATE ]-------------------------------------------------------------------
        // const dt = rl.getFrameTime();
        rl.updateCamera(&camera, rl.CameraMode.free);
        //----------------------------------------------------------------------------------

        //-----[ DRAW ]---------------------------------------------------------------------
        rl.beginTextureMode(renderTexture);
        rl.beginMode3D(camera);

        rl.clearBackground(rl.Color.black);
        rl.drawModel(floor, zero3, 1, rl.Color.dark_brown);

        rl.endMode3D();
        rl.endTextureMode();

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        rl.beginShaderMode(bloomShader);
        rl.drawTextureRec(renderTexture.texture, renderArea, zero2, rl.Color.white);
        rl.endShaderMode();

        // render main model
        rl.beginMode3D(camera);
        rl.drawModel(model, zero3, 1, rl.Color.green);
        rl.endMode3D();

        // 2d overlay
        rl.drawText(rl.textFormat("Raylib: %d fps", .{rl.getFPS()}), 10, 20, 20, rl.Color.green);

        //----------------------------------------------------------------------------------
    }
}
