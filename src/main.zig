const std = @import("std");

const OpCode = enum {
    op_return,
};

const Chunk = std.ArrayList(OpCode);

pub fn disassemble_chunk(chunk: *Chunk) void {
    for (chunk.items, 0..) |opcode, index| {
        std.debug.print("{x:0>4} {s}", .{ index, @tagName(opcode) });
    }
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var chunk = Chunk.init(allocator);

    try chunk.append(OpCode.op_return);

    disassemble_chunk(&chunk);
}
