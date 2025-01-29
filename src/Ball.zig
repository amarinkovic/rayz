const rl = @import("raylib");

const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 450;

pub const Ball = struct {
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
