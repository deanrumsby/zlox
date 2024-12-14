const std = @import("std");
const debug = @import("debug.zig");
const Instruction = @import("instruction.zig").Instruction;
const Chunk = @import("chunk.zig").Chunk;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var chunk = Chunk.init(allocator);
    defer chunk.deinit();

    try chunk.write(Instruction.op_return);

    const index = try chunk.add_constant(1.2);
    try chunk.write(Instruction{ .op_constant = index });

    debug.disassemble_chunk(&chunk);
}
