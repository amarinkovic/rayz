const std = @import("std");

pub const FixedFifo = struct {
    items: []u32,
    start: usize = 0,
    end: usize = 0,
    size: usize = 0,

    pub fn init(allocator: *const std.mem.Allocator, capacity: usize) !FixedFifo {
        return FixedFifo{
            .items = try allocator.alloc(u32, capacity),
        };
    }

    pub fn deinit(self: *FixedFifo, allocator: *const std.mem.Allocator) void {
        allocator.free(self.items);
    }

    pub fn push(self: *FixedFifo, value: u32) void {
        if (self.size == self.items.len) {
            self.start = (self.start + 1) % self.items.len;
        } else {
            self.size += 1;
        }
        self.items[self.end] = value;
        self.end = (self.end + 1) % self.items.len;
    }

    pub fn get(self: *const FixedFifo, index: usize) u32 {
        return self.items[(self.start + index) % self.items.len];
    }
};
