const std = @import("std");
const print = std.debug.print;
const Chunk = @import("chunk.zig").Chunk;
const OpCode = @import("opcode.zig").OpCode;
const Value = @import("value.zig").Value;

pub fn disassemble_chunk(chunk: *Chunk, name: []const u8) !void {
    print("== {s} ==\n", .{name});
    var offset: usize = 0;
    while (offset < chunk.code.items.len) {
        offset = try disassemble_instruction(chunk, offset);
        print("\n", .{});
    }
}

fn disassemble_instruction(chunk: *Chunk, offset: usize) !usize {
    // print the instruction offset
    print("{x:0>4} ", .{offset});

    try print_line_number(chunk, offset);

    const opcode: OpCode = @enumFromInt(chunk.code.items[offset]);
    return switch (opcode) {
        .op_constant => try print_constant_instruction(offset, chunk),
        .op_constant_long => try print_constant_instruction(offset, chunk) + 2,
        .op_return => print_simple_instruction(offset, opcode),
    };
}

fn print_line_number(chunk: *Chunk, offset: usize) !void {
    const line_number = try chunk.get_line_number(offset);
    if (offset > 0 and line_number == try chunk.get_line_number(offset - 1)) {
        print("   | ", .{});
    } else {
        print("{d:0>4} ", .{line_number});
    }
}

fn print_value(value: Value) void {
    print("{d}", .{value});
}

fn print_constant_instruction(offset: usize, chunk: *Chunk) !usize {
    if (offset + 1 > chunk.code.items.len) {
        return error.UnexpectedEnd;
    }
    const index = chunk.code.items[offset + 1];
    if (index < 0 or index > chunk.constants.items.len) {
        return error.InvalidAddress;
    }
    const constant = chunk.constants.items[index];
    // print the instruction name and the location of the constant in the constants pool
    print("{s} {x:0>4} ", .{ @tagName(OpCode.op_constant), index });
    print_value(constant);
    return offset + 2;
}

fn print_simple_instruction(offset: usize, opcode: OpCode) usize {
    print("{s}", .{@tagName(opcode)});
    return offset + 1;
}
