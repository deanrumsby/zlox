const Value = @import("value.zig").Value;

pub fn add(a: Value, b: Value) Value {
    return a + b;
}

pub fn subtract(a: Value, b: Value) Value {
    return a - b;
}

pub fn multiply(a: Value, b: Value) Value {
    return a * b;
}

pub fn divide(a: Value, b: Value) Value {
    return a / b;
}
