const std = @import("std");
const builtin = @import("builtin");
const debug = @import("debug.zig");
const VM = @import("vm.zig").VM;
const OpCode = @import("opcode.zig").OpCode;
const Chunk = @import("chunk.zig").Chunk;

pub const DEBUG = (builtin.mode == .Debug);

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var vm = VM.init(allocator);
    defer vm.deinit();

    var chunk = Chunk.init(allocator);

    const index_a = try chunk.add_constant(1.2);
    try chunk.write(@intFromEnum(OpCode.op_constant), 123);
    try chunk.write(index_a, 123);

    const index_b = try chunk.add_constant(3.4);
    try chunk.write(@intFromEnum(OpCode.op_constant), 124);
    try chunk.write(index_b, 124);

    try chunk.write(@intFromEnum(OpCode.op_add), 125);

    const index_c = try chunk.add_constant(5.6);
    try chunk.write(@intFromEnum(OpCode.op_constant), 126);
    try chunk.write(index_c, 126);

    try chunk.write(@intFromEnum(OpCode.op_divide), 127);

    try chunk.write(@intFromEnum(OpCode.op_negate), 127);

    try chunk.write(@intFromEnum(OpCode.op_return), 125);

    _ = try vm.interpret(&chunk);
}
