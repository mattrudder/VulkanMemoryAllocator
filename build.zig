const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const vk = b.addModule("vk", .{
        .root_source_file = b.path("vk.zig"),
        .target = target,
        .optimize = optimize,
    });
    const zvma = b.addModule("root", .{
        .root_source_file = b.path("lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    zvma.addImport("vk", vk);
    
    const vma = b.addStaticLibrary(.{
        .name = "vma",
        .target = target,
        .optimize = optimize,
    });

    zvma.linkLibrary(vma);

    const vulkan_sdk = try std.process.getEnvVarOwned(b.allocator, "VULKAN_SDK");

    const options = .{
        .vulkan_sdk = b.option([]const u8, "vulkan_sdk", "Path to the Vulkan SDK. Needed on Windows to specify where the SDK is installed. Defaults to the environment variable %VULKAN_SDK%") orelse vulkan_sdk,
    };

    const options_step = b.addOptions();
    inline for (std.meta.fields(@TypeOf(options))) |field| {
        options_step.addOption(field.type, field.name, @field(options, field.name));
    }

    vma.defineCMacro("VMA_VULKAN_VERSION", "1003000"); // Vulkan 1.3
    vma.defineCMacro("VMA_STATIC_VULKAN_FUNCTIONS", "0"); // Dynamically load functions
    vma.defineCMacro("VMA_DYNAMIC_VULKAN_FUNCTIONS", "0"); // Use fn ptrs defined by `p_vulkan_functions`

    vma.addIncludePath(b.path("include"));
    vma.addIncludePath(b.path("src"));
    vma.addIncludePath(b.path("include"));
    vma.addCSourceFile(.{
        .file = b.path("src/VmaUsage.cpp"),
    });
    vma.linkLibCpp();

    if (!std.mem.eql(u8, "", options.vulkan_sdk)) {
        const vk_include_path = try std.fs.path.join(b.allocator, &.{ options.vulkan_sdk, "include" });
        defer b.allocator.free(vk_include_path);

        vma.addIncludePath(.{ .cwd_relative = vk_include_path });
    }

    b.installArtifact(vma);
}