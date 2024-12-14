const std = @import("std");
const print = std.debug.print;
const Chunk = @import("chunk.zig").Chunk;
const Instruction = @import("instruction.zig").Instruction;
const Value = @import("value.zig").Value;

pub fn disassemble_chunk(chunk: *Chunk) void {
    for (chunk.code.items, 0..) |instruction, index| {
        print("{x:0>4} ", .{index});
        switch (instruction) {
            .op_constant => |c_index| print_constant_instruction(c_index, chunk),
            .op_return => print_simple_instruction(instruction),
        }
        print("\n", .{});
    }
}

fn print_value(value: Value) void {
    print("{d}", .{value});
}

fn print_constant_instruction(index: u8, chunk: *Chunk) void {
    const constant = chunk.constants.items[index];
    print("{s} {x:0>4} ", .{ @tagName(Instruction.op_constant), index });
    print_value(constant);
}

fn print_simple_instruction(instruction: Instruction) void {
    print("{s}", .{@tagName(instruction)});
}
