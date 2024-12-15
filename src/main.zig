const std = @import("std");
const debug = @import("debug.zig");
const OpCode = @import("opcode.zig").OpCode;
const Chunk = @import("chunk.zig").Chunk;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var chunk = Chunk.init(allocator);
    defer chunk.deinit();

    try chunk.write(@intFromEnum(OpCode.op_return), 123);

    const index = try chunk.add_constant(1.2);
    try chunk.write(@intFromEnum(OpCode.op_constant), 123);
    try chunk.write(index, 123);

    try debug.disassemble_chunk(&chunk, "test chunk");
}
