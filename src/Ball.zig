const std = @import("std");
const rl = @import("raylib");

const FixedFifo = @import("./FixedFifo.zig").FixedFifo;

const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 450;

pub const Ball = struct {
    positions: FixedFifo(rl.Vector2),
    size: f32,
    speed: rl.Vector2,

    pub fn init(x: f32, y: f32, size: f32, speed: f32, allocator: *const std.mem.Allocator, length: usize) !Ball {
        var fifo = try FixedFifo(rl.Vector2).init(allocator, length);
        fifo.push(rl.Vector2.init(x, y));

        if (fifo.head()) |head| {
            std.debug.print("      INIT HEAD >>>>>>>>> x = {}, y = {}\n", .{ head.x, head.y });
        }
        return Ball{
            .positions = fifo,
            .size = size,
            .speed = rl.Vector2.init(speed, speed),
        };
    }

    pub fn deinit(self: *Ball, allocator: *const std.mem.Allocator) void {
        self.positions.deinit(allocator);
    }

    pub fn update(self: *Ball) void {
        if (self.position.head() == null) {
            std.debug.print(" -- NO HEAD!!!", .{});
        }

        const head = self.positions.head() orelse return;

        const new_head = rl.Vector2.init(head.x + self.speed.x, head.y + self.speed.y);
        self.positions.push(new_head);

        // check for y collisions
        if (head.y <= self.size or head.y + self.size >= SCREEN_HEIGHT) {
            self.speed.y *= -1;
            std.debug.print(" -- flip Y\n", .{});
        }

        // check for x collisions
        if (head.x <= self.size or head.x + self.size >= SCREEN_WIDTH) {
            self.speed.x *= -1;
            std.debug.print(" -- flip X\n", .{});
        }
    }

    pub fn draw(self: *Ball) void {
        if (self.positions.head()) |head| {
            rl.drawCircleV(head, self.size, rl.Color.red);
        }
    }
};
