const std = @import("std");
const builtin = @import("builtin");
const debug = @import("debug.zig");
const file = @import("file.zig");
const repl = @import("repl.zig");
const VM = @import("vm.zig").VM;
const OpCode = @import("opcode.zig").OpCode;
const Chunk = @import("chunk.zig").Chunk;

pub const DEBUG = (builtin.mode == .Debug);

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var argsIterator = try std.process.argsWithAllocator(allocator);
    defer argsIterator.deinit();

    var vm = VM.init(allocator);
    defer vm.deinit();

    _ = argsIterator.skip();

    if (argsIterator.next()) |path| {
        try file.run(allocator, path);
    } else {
        try repl.run();
    }
}
