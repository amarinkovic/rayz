const std = @import("std");

pub fn FixedFifo(comptime T: type) type {
    return struct {
        items: []T,
        start: usize = 0,
        end: usize = 0,
        size: usize = 0,

        const Self = @This();

        pub fn init(allocator: *const std.mem.Allocator, capacity: usize) !Self {
            return Self{
                .items = try allocator.alloc(T, capacity),
            };
        }

        pub fn deinit(self: *Self, allocator: *const std.mem.Allocator) void {
            allocator.free(self.items);
        }

        pub fn push(self: *Self, value: T) void {
            if (self.size == self.items.len) {
                self.start = (self.start + 1) % self.items.len;
            } else {
                self.size += 1;
            }
            self.items[self.end] = value;
            self.end = (self.end + 1) % self.items.len;
        }

        pub fn head(self: *Self) ?T {
            if (self.size == 0) {
                return null;
            }

            return self.items[self.end % self.items.len];
        }

        pub fn is_empty(self: *Self) bool {
            return self.size == 0;
        }

        pub fn get(self: *const Self, index: usize) T {
            return self.items[(self.start + index) % self.items.len];
        }
    };
}
