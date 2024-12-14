const OpCode = enum(u8) {
    op_constant,
    op_return,
};

pub const Instruction = union(OpCode) {
    op_constant: u8,
    op_return: void,
};
