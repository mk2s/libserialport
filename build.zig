const std = @import("std");

const flags: []const []const u8 = &.{ "-Wall", "-DLIBSERIALPORT_MSBUILD" };

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

    const dynlib = b.addSharedLibrary(.{
        .name = "libserialport",
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    dynlib.addCSourceFiles(.{ .files = &.{ "serialport.c", "timing.c", "windows.c" }, .flags = flags });
    dynlib.linkSystemLibrary("setupApi");
    b.installArtifact(dynlib);

    const staticlib = b.addStaticLibrary(.{
        .name = "libserialport",
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    staticlib.addCSourceFiles(.{ .files = &.{ "serialport.c", "timing.c", "windows.c" }, .flags = flags });
    staticlib.linkSystemLibrary("setupApi");
    b.installArtifact(staticlib);
}
