const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const Instruction = @import("instruction.zig").Instruction;
const Value = @import("value.zig").Value;

/// A chunk of zlox bytecode
pub const Chunk = struct {
    /// The instructions contained in the chunk
    code: ArrayList(Instruction),

    /// The constants contained in the chunk
    constants: ArrayList(Value),

    /// Initialise a chunk with a given allocator
    pub fn init(allocator: Allocator) Chunk {
        return Chunk{
            .code = ArrayList(Instruction).init(allocator),
            .constants = ArrayList(Value).init(allocator),
        };
    }

    /// Free the memory used by the chunk
    pub fn deinit(self: *Chunk) void {
        self.code.deinit();
        self.constants.deinit();
    }

    /// Writes an instruction to the chunk
    pub fn write(self: *Chunk, instruction: Instruction) !void {
        try self.code.append(instruction);
    }

    /// Adds a constant to the chunks constant pool
    /// Returns the index of the constant within the pool
    pub fn add_constant(self: *Chunk, constant: Value) !u8 {
        try self.constants.append(constant);
        return @intCast(self.constants.items.len - 1);
    }
};
