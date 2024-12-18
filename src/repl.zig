const std = @import("std");

pub fn run() !void {
    const in = std.io.getStdIn().reader();
    const out = std.io.getStdOut().writer();
    var buffer: [4096]u8 = undefined;

    while (true) {
        try out.print("> ", .{});
        const msg = try in.readUntilDelimiter(&buffer, '\n');

        if (std.mem.eql(u8, msg, "exit")) {
            break;
        }

        std.debug.print("msg: {s}\n", .{msg});
    }

    std.debug.print("goodbye!\n", .{});
}
