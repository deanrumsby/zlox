pub const OpCode = enum(u8) {
    op_constant,
    op_constant_long,
    op_negate,
    op_return,
    op_add,
    op_subtract,
    op_multiply,
    op_divide,
};
