const std = @import("std");

const flags: []const []const u8 = &.{
    "-Wall",
};

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "list_ports",
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    exe.addIncludePath(b.path("../"));
    exe.addCSourceFile(.{ .file = b.path("list_ports.c") });
    exe.linkSystemLibrary("libserialport");
    exe.addLibraryPath(b.path("../zig-out/lib"));
    b.installArtifact(exe);
}
