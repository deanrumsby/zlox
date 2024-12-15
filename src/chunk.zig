const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const Value = @import("value.zig").Value;

/// The number of instructions for a given line
const LineNumberInstructionsCount = struct {
    line_number: u16,
    instruction_count: u16,
};

/// A chunk of zlox bytecode
pub const Chunk = struct {
    /// The raw bytes contained in the chunk
    code: ArrayList(u8),

    /// The constants contained in the chunk
    constants: ArrayList(Value),

    /// The line numbers and their respective instruction counts
    /// In order of line number
    /// Data only exists for lines that contain instructions
    lines: ArrayList(LineNumberInstructionsCount),

    /// Initialise a chunk with a given allocator
    pub fn init(allocator: Allocator) Chunk {
        return Chunk{
            .code = ArrayList(u8).init(allocator),
            .constants = ArrayList(Value).init(allocator),
            .lines = ArrayList(LineNumberInstructionsCount).init(allocator),
        };
    }

    /// Free the memory used by the chunk
    pub fn deinit(self: *Chunk) void {
        self.code.deinit();
        self.constants.deinit();
    }

    /// Writes a byte to the chunk
    pub fn write(self: *Chunk, byte: u8, line_number: u16) !void {
        try self.code.append(byte);
        try self.add_line_number(line_number);
    }

    /// Adds a constant to the chunks constant pool
    /// Returns the index of the constant within the pool
    pub fn add_constant(self: *Chunk, constant: Value) !u8 {
        try self.constants.append(constant);
        return @intCast(self.constants.items.len - 1);
    }

    /// Given an instruction offset, will determine the line number of the instruction
    pub fn get_line_number(self: *Chunk, index: usize) !u16 {
        var counter: u32 = 0;
        for (self.lines.items) |line| {
            counter += line.instruction_count;
            if (counter >= index) {
                return line.line_number;
            }
        }
        return error.NoLineNumber;
    }

    fn add_line_number(self: *Chunk, line_number: u16) !void {
        if (self.lines.items.len == 0) {
            // the first instruction written
            try self.lines.append(.{ .line_number = line_number, .instruction_count = 1 });
        }
        var last = self.lines.pop();
        if (last.line_number == line_number) {
            // the instruction is on the same line as the previous instruction
            last.instruction_count += 1;
            try self.lines.append(last);
        } else {
            // the instruction is on a new line
            try self.lines.append(last);
            try self.lines.append(.{ .line_number = line_number, .instruction_count = 1 });
        }
    }
};
