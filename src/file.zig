const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn run(allocator: Allocator, path: []const u8) !void {
    const file = std.fs.cwd().openFile(path, .{}) catch |err| {
        std.log.err("Failed to open file: {s}", .{@errorName(err)});
        return;
    };
    defer file.close();

    const source = try file.reader().readAllAlloc(allocator, std.math.maxInt(usize));
    std.debug.print("{s}", .{source});
}
