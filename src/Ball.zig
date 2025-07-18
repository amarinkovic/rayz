const std = @import("std");
const rl = @import("raylib");

const FixedFifo = @import("./FixedFifo.zig").FixedFifo;

const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 450;
const WORLD_SIZE = 20.0;

pub const Ball = struct {
    positions: FixedFifo(rl.Vector3),
    size: f32,
    speed: rl.Vector3,

    pub fn init(x: f32, y: f32, z: f32, size: f32, speed: f32, allocator: *const std.mem.Allocator, length: usize) !Ball {
        var fifo = try FixedFifo(rl.Vector3).init(allocator, length);
        fifo.push(rl.Vector3.init(x, y, z));

        return Ball{
            .positions = fifo,
            .size = size,
            .speed = rl.Vector3.init(speed * 0.7, speed, speed * 0.5),
        };
    }

    pub fn deinit(self: *Ball, allocator: *const std.mem.Allocator) void {
        self.positions.deinit(allocator);
    }

    pub fn update(self: *Ball) void {
        const head = self.positions.head() orelse return;

        const new_head = rl.Vector3.init(
            head.x + self.speed.x,
            head.y + self.speed.y,
            head.z + self.speed.z
        );
        self.positions.push(new_head);

        // check for y collisions (floor and ceiling)
        if (head.y <= -WORLD_SIZE + self.size) {
            self.speed.y = @abs(self.speed.y);
        } else if (head.y >= WORLD_SIZE - self.size) {
            self.speed.y = @abs(self.speed.y) * -1;
        }

        // check for x collisions (left and right walls)
        if (head.x <= -WORLD_SIZE + self.size) {
            self.speed.x = @abs(self.speed.x);
        } else if (head.x >= WORLD_SIZE - self.size) {
            self.speed.x = @abs(self.speed.x) * -1;
        }

        // check for z collisions (front and back walls)
        if (head.z <= -WORLD_SIZE + self.size) {
            self.speed.z = @abs(self.speed.z);
        } else if (head.z >= WORLD_SIZE - self.size) {
            self.speed.z = @abs(self.speed.z) * -1;
        }
    }

    pub fn draw(self: *Ball) void {
        for (0..self.positions.size) |i| {
            const sphere_pos = self.positions.get(i);

            const size_f32: f32 = @floatFromInt(self.positions.size);
            const i_f32: f32 = @floatFromInt(i);
            const alpha = i_f32 / size_f32;
            const sphere_size = self.size * alpha * alpha;

            // Create a color that fades from red to orange based on position in trail
            const color = rl.Color.init(
                255,
                @intFromFloat(100 + (155 * alpha)),
                @intFromFloat(50 * alpha),
                @intFromFloat(255 * alpha)
            );

            rl.drawSphere(sphere_pos, sphere_size, color);
        }
    }
};