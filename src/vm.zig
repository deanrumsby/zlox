const std = @import("std");
const Allocator = std.mem.Allocator;
const Chunk = @import("chunk.zig").Chunk;
const OpCode = @import("opcode.zig").OpCode;
const Value = @import("value.zig").Value;
const debug = @import("debug.zig");
const DEBUG = @import("main.zig").DEBUG;
const math = @import("math.zig");
const ArrayList = std.ArrayList;

const Result = enum {
    ok,
    compile_error,
    runtime_error,
};

pub const VM = struct {
    chunk: *Chunk,
    ip: usize,
    stack: ArrayList(Value),

    pub fn init(allocator: Allocator) VM {
        return VM{
            .chunk = undefined,
            .ip = 0,
            .stack = ArrayList(Value).init(allocator),
        };
    }

    pub fn deinit(self: *VM) void {
        if (self.chunk != undefined) {
            self.chunk.deinit();
        }
        self.stack.deinit();
    }

    pub fn interpret(self: *VM, chunk: *Chunk) !Result {
        self.chunk = chunk;
        self.ip = 0;
        return self.run();
    }

    fn push(self: *VM, value: Value) !void {
        try self.stack.append(value);
    }

    fn pop(self: *VM) Value {
        return self.stack.pop();
    }

    fn run(self: *VM) !Result {
        while (true) {
            if (comptime DEBUG) {
                debug.print_stack_contents(&self.stack);
                _ = try debug.disassemble_instruction(self.chunk, self.ip);
            }
            const opcode: OpCode = @enumFromInt(self.read_byte());
            switch (opcode) {
                .op_return => {
                    const value = self.pop();
                    debug.print_value(value);
                    return Result.ok;
                },

                .op_constant => {
                    const value = self.read_constant();
                    try self.push(value);
                },

                .op_constant_long => {
                    const value = self.read_constant_long();
                    try self.push(value);
                },

                .op_negate => {
                    const value = self.pop();
                    try self.push(-value);
                },

                .op_add => try self.binary_op(math.add),

                .op_subtract => try self.binary_op(math.subtract),

                .op_multiply => try self.binary_op(math.multiply),

                .op_divide => try self.binary_op(math.divide),
            }
        }
    }

    fn binary_op(self: *VM, op: *const fn (a: Value, b: Value) Value) !void {
        const b = self.pop();
        const a = self.pop();
        const value = op(a, b);
        try self.push(value);
    }

    fn read_byte(self: *VM) u8 {
        const byte = self.chunk.code.items[self.ip];
        self.ip += 1;
        return byte;
    }

    fn read_constant(self: *VM) Value {
        const index = self.read_byte();
        return self.chunk.constants.items[index];
    }

    // TODO still need to implement
    fn read_constant_long(self: *VM) Value {
        const index = self.read_byte();
        return self.chunk.constants.items[index];
    }
};
