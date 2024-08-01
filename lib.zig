pub const vk = @import("vk");

pub const Allocator = enum(usize) { null_handle = 0, _ };
pub const Allocation = enum(usize) { null_handle = 0, _ };
pub const DefragmentationContext = enum(usize) { null_handle = 0, _ };
pub const VirtualAllocation = enum(u64) { null_handle = 0, _ };
pub const VirtualBlock = enum(usize) { null_handle = 0, _ };
pub const Pool = enum(usize) { null_handle = 0, _ };

/// \brief Intended usage of the allocated memory.
pub const MemoryUsage = packed struct(vk.Flags)
{
    // Obsolete, preserved for backward compatibility.
    // Prefers `VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT`.
    gpu_only: bool = false,
    // Obsolete, preserved for backward compatibility.
    // Guarantees `VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT` and `VK_MEMORY_PROPERTY_HOST_COHERENT_BIT`.
    cpu_only: bool = false,
    // Obsolete, preserved for backward compatibility.
    // Guarantees `VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT`, prefers `VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT`.
    cpu_to_gpu: bool = false,
    // Obsolete, preserved for backward compatibility.
    // Guarantees `VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT`, prefers `VK_MEMORY_PROPERTY_HOST_CACHED_BIT`.
    gpu_to_cpu: bool = false,
    // Obsolete, preserved for backward compatibility.
    // Prefers not `VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT`.
    cpu_copy: bool = false,
    // Lazily allocated GPU memory having `VK_MEMORY_PROPERTY_LAZILY_ALLOCATED_BIT`.
    // Exists mostly on mobile platforms. Using it on desktop PC or other GPUs with no such memory type present will fail the allocation.
    //
    // Usage: Memory for transient attachment images (color attachments, depth attachments etc.), created with `VK_IMAGE_USAGE_TRANSIENT_ATTACHMENT_BIT`.
    //
    // Allocations with this usage are always created as dedicated - it implies #VMA_ALLOCATION_CREATE_DEDICATED_MEMORY_BIT.
    gpu_lazily_allocated: bool = false,
    // Selects best memory type automatically.
    // This flag is recommended for most common use cases.
    //
    // When using this flag, if you want to map the allocation (using vmaMapMemory() or #VMA_ALLOCATION_CREATE_MAPPED_BIT),
    // you must pass one of the flags: #VMA_ALLOCATION_CREATE_HOST_ACCESS_SEQUENTIAL_WRITE_BIT or #VMA_ALLOCATION_CREATE_HOST_ACCESS_RANDOM_BIT
    // in VmaAllocationCreateInfo::flags.
    //
    // It can be used only with functions that let the library know `VkBufferCreateInfo` or `VkImageCreateInfo`, e.g.
    // vmaCreateBuffer(), vmaCreateImage(), vmaFindMemoryTypeIndexForBufferInfo(), vmaFindMemoryTypeIndexForImageInfo()
    // and not with generic memory allocation functions.
    auto: bool = false,
    // Selects best memory type automatically with preference for GPU (device) memory.
    //
    // When using this flag, if you want to map the allocation (using vmaMapMemory() or #VMA_ALLOCATION_CREATE_MAPPED_BIT),
    // you must pass one of the flags: #VMA_ALLOCATION_CREATE_HOST_ACCESS_SEQUENTIAL_WRITE_BIT or #VMA_ALLOCATION_CREATE_HOST_ACCESS_RANDOM_BIT
    // in VmaAllocationCreateInfo::flags.
    //
    // It can be used only with functions that let the library know `VkBufferCreateInfo` or `VkImageCreateInfo`, e.g.
    // vmaCreateBuffer(), vmaCreateImage(), vmaFindMemoryTypeIndexForBufferInfo(), vmaFindMemoryTypeIndexForImageInfo()
    // and not with generic memory allocation functions.
    auto_prefer_device: bool = false,
    // Selects best memory type automatically with preference for CPU (host) memory.
    //
    // When using this flag, if you want to map the allocation (using vmaMapMemory() or #VMA_ALLOCATION_CREATE_MAPPED_BIT),
    // you must pass one of the flags: #VMA_ALLOCATION_CREATE_HOST_ACCESS_SEQUENTIAL_WRITE_BIT or #VMA_ALLOCATION_CREATE_HOST_ACCESS_RANDOM_BIT
    // in VmaAllocationCreateInfo::flags.
    //
    // It can be used only with functions that let the library know `VkBufferCreateInfo` or `VkImageCreateInfo`, e.g.
    // vmaCreateBuffer(), vmaCreateImage(), vmaFindMemoryTypeIndexForBufferInfo(), vmaFindMemoryTypeIndexForImageInfo()
    // and not with generic memory allocation functions.
    auto_prefer_host: bool = false,

    _reserved_bit_09: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
};


/// Flags to be passed as AllocationCreateInfo::flags.
pub const AllocationCreateFlags = packed struct(vk.Flags)
{
    // Set this flag if the allocation should have its own memory block.
    //
    // Use it for special, big resources, like fullscreen images used as attachments.
    //
    // If you use this flag while creating a buffer or an image, `VkMemoryDedicatedAllocateInfo`
    // structure is applied if possible.
    dedicated_memory_bit: bool = false,

    // Set this flag to only try to allocate from existing `VkDeviceMemory` blocks and never create new such block.

    // If new allocation cannot be placed in any of the existing blocks, allocation
    // fails with `VK_ERROR_OUT_OF_DEVICE_MEMORY` error.

    // You should not use #dedicated_memory_bit and
    // #never_allocate_bit at the same time. It makes no sense.
    never_allocate_bit: bool = false,
    // Set this flag to use a memory that will be persistently mapped and retrieve pointer to it.
    //
    // Pointer to mapped memory will be returned through VmaAllocationInfo::pMappedData.
    //
    // It is valid to use this flag for allocation made from memory type that is not
    // `HOST_VISIBLE`. This flag is then ignored and memory is not mapped. This is
    // useful if you need an allocation that is efficient to use on GPU
    // (`DEVICE_LOCAL`) and still want to map it directly if possible on platforms that
    // support it (e.g. Intel GPU).
    mapped_bit: bool = false,
    // Preserved for backward compatibility. Consider using vmaSetAllocationName() instead.
    //
    // Set this flag to treat VmaAllocationCreateInfo::pUserData as pointer to a
    // null-terminated string. Instead of copying pointer value, a local copy of the
    // string is made and stored in allocation's `pName`. The string is automatically
    // freed together with the allocation. It is also used in vmaBuildStatsString().
    user_data_copy_string_bit: bool = false,
    // Allocation will be created from upper stack in a double stack pool.
    //
    // This flag is only allowed for custom pools created with #VMA_POOL_CREATE_LINEAR_ALGORITHM_BIT flag.
    upper_address_bit: bool = false,
    // Create both buffer/image and allocation, but don't bind them together.
    // It is useful when you want to bind yourself to do some more advanced binding, e.g. using some extensions.
    // The flag is meaningful only with functions that bind by default: vmaCreateBuffer(), vmaCreateImage().
    // Otherwise it is ignored.
    //
    // If you want to make sure the new buffer/image is not tied to the new memory allocation
    // through `VkMemoryDedicatedAllocateInfoKHR` structure in case the allocation ends up in its own memory block,
    // use also flag #can_alias_bit.
    dont_bind_bit: bool = false,
    // Create allocation only if additional device memory required for it, if any, won't exceed
    // memory budget. Otherwise return `VK_ERROR_OUT_OF_DEVICE_MEMORY`.
    within_budget_bit: bool = false,
    // Set this flag if the allocated memory will have aliasing resources.
    //
    // Usage of this flag prevents supplying `VkMemoryDedicatedAllocateInfoKHR` when #dedicated_memory_bit is specified.
    // Otherwise created dedicated memory will not be suitable for aliasing resources, resulting in Vulkan Validation Layer errors.
    can_alias_bit: bool = false,
    // Requests possibility to map the allocation (using vmaMapMemory() or #mapped_bit).
    //
    // - If you use #VMA_MEMORY_USAGE_AUTO or other `VMA_MEMORY_USAGE_AUTO*` value,
    //   you must use this flag to be able to map the allocation. Otherwise, mapping is incorrect.
    // - If you use other value of #VmaMemoryUsage, this flag is ignored and mapping is always possible in memory types that are `HOST_VISIBLE`.
    //   This includes allocations created in \ref custom_memory_pools.
    //
    // Declares that mapped memory will only be written sequentially, e.g. using `memcpy()` or a loop writing number-by-number,
    // never read or accessed randomly, so a memory type can be selected that is uncached and write-combined.
    //
    // Warning: Violating this declaration may work correctly, but will likely be very slow.
    // Watch out for implicit reads introduced by doing e.g. `pMappedData[i] += x;`
    // Better prepare your data in a local variable and `memcpy()` it to the mapped pointer all at once.
    host_access_sequential_write_bit: bool = false,
    // Requests possibility to map the allocation (using vmaMapMemory() or #mapped_bit).
    //
    // - If you use #VMA_MEMORY_USAGE_AUTO or other `VMA_MEMORY_USAGE_AUTO*` value,
    //   you must use this flag to be able to map the allocation. Otherwise, mapping is incorrect.
    // - If you use other value of #VmaMemoryUsage, this flag is ignored and mapping is always possible in memory types that are `HOST_VISIBLE`.
    //   This includes allocations created in \ref custom_memory_pools.
    //
    // Declares that mapped memory can be read, written, and accessed in random order,
    // so a `HOST_CACHED` memory type is preferred.
    host_access_random_bit: bool = false,
    // Together with #host_access_sequential_write_bit or #host_access_random_bit,
    // it says that despite request for host access, a not-`HOST_VISIBLE` memory type can be selected
    // if it may improve performance.
    //
    // By using this flag, you declare that you will check if the allocation ended up in a `HOST_VISIBLE` memory type
    // (e.g. using vmaGetAllocationMemoryProperties()) and if not, you will create some "staging" buffer and
    // issue an explicit transfer to write/read your data.
    // To prepare for this possibility, don't forget to add appropriate flags like
    // `VK_BUFFER_USAGE_TRANSFER_DST_BIT`, `VK_BUFFER_USAGE_TRANSFER_SRC_BIT` to the parameters of created buffer or image.
    host_access_allow_transfer_instead_bit: bool = false,
    // Allocation strategy that chooses smallest possible free range for the allocation
    // to minimize memory usage and fragmentation, possibly at the expense of allocation time.
    strategy_min_memory_bit: bool = false,
    // Allocation strategy that chooses first suitable free range for the allocation -
    // not necessarily in terms of the smallest offset but the one that is easiest and fastest to find
    // to minimize allocation time, possibly at the expense of allocation quality.
    strategy_min_time_bit: bool = false,
    // Allocation strategy that chooses always the lowest offset in available space.
    // This is not the most efficient strategy but achieves highly packed data.
    // Used internally by defragmentation, not recommended in typical usage.
    strategy_min_offset_bit: bool = false,

    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
};

pub const AllocationCreateFlagStrategyBestFit: AllocationCreateFlags = .{
    .strategy_min_memory_bit = true,
};

pub const AllocationCreateFlagStrategyFirstFit: AllocationCreateFlags = .{
    .strategy_min_time_bit = true,
};

pub const AllocationCreateFlagStrategyMask: AllocationCreateFlags = .{
    .strategy_min_memory_bit = true,
    .strategy_min_time_bit = true,
    .strategy_min_offset_bit = true
};


/// Flags to be passed as PoolCreateInfo::flags.
pub const PoolCreateFlags = packed struct(vk.Flags)
{
    _reserved_bit_00: bool = false,

    // Use this flag if you always allocate only buffers and linear images or only optimal images out of this pool and so Buffer-Image Granularity can be ignored.
    //
    // This is an optional optimization flag.
    //
    // If you always allocate using vmaCreateBuffer(), vmaCreateImage(),
    // vmaAllocateMemoryForBuffer(), then you don't need to use it because allocator
    // knows exact type of your allocations so it can handle Buffer-Image Granularity
    // in the optimal way.
    //
    // If you also allocate using vmaAllocateMemoryForImage() or vmaAllocateMemory(),
    // exact type of such allocations is not known, so allocator must be conservative
    // in handling Buffer-Image Granularity, which can lead to suboptimal allocation
    // (wasted memory). In that case, if you can make sure you always allocate only
    // buffers and linear images or only optimal images out of this pool, use this flag
    // to make allocator disregard Buffer-Image Granularity and so make allocations
    // faster and more optimal.
    // */
    ignore_buffer_image_granularity_bit: bool = false,

    // Enables alternative, linear allocation algorithm in this pool.
    //
    // Specify this flag to enable linear allocation algorithm, which always creates
    // new allocations after last one and doesn't reuse space from allocations freed in
    // between. It trades memory consumption for simplified algorithm and data
    // structure, which has better performance and uses less memory for metadata.
    //
    // By using this flag, you can achieve behavior of free-at-once, stack,
    // ring buffer, and double stack.
    // For details, see documentation chapter \ref linear_algorithm.
    linear_algorithm_bit: bool = false,

    _reserved_bit_03: bool = false,
    _reserved_bit_04: bool = false,
    _reserved_bit_05: bool = false,
    _reserved_bit_06: bool = false,
    _reserved_bit_07: bool = false,
    _reserved_bit_08: bool = false,
    _reserved_bit_09: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
};

pub const PoolCreateFlagsAlgorithmMask: PoolCreateFlags = .{ .linear_algorithm_bit = true };


/// Flags to be passed as DefragmentationInfo::flags.
pub const DefragmentationFlags = packed struct(vk.Flags)
{
    // Use simple but fast algorithm for defragmentation.
    // May not achieve best results but will require least time to compute and least allocations to copy.
    algorithm_fast_bit: bool = false,
    // Default defragmentation algorithm, applied also when no `ALGORITHM` flag is specified.
    // Offers a balance between defragmentation quality and the amount of allocations and bytes that need to be moved.
    algorithm_balanced_bit: bool = false,
    // Perform full defragmentation of memory.
    // Can result in notably more time to compute and allocations to copy, but will achieve best memory packing.
    algorithm_full_bit: bool = false,
    // Use the most roboust algorithm at the cost of time to compute and number of copies to make.
    // Only available when bufferImageGranularity is greater than 1, since it aims to reduce
    // alignment issues between different types of resources.
    // Otherwise falls back to same behavior as #algorithm_full_bit.
    algorithm_extensive_bit: bool = false,

    _reserved_bit_04: bool = false,
    _reserved_bit_05: bool = false,
    _reserved_bit_06: bool = false,
    _reserved_bit_07: bool = false,
    _reserved_bit_08: bool = false,
    _reserved_bit_09: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
};

/// A bit mask to extract only `ALGORITHM` bits from entire set of flags.
pub const DefragmentationFlagsAlgorithmMask: DefragmentationFlags = .{
    .algorithm_fast_bit = true,
    .algorithm_balanced_bit = true,
    .algorithm_full_bit = true,
    .algorithm_extensive_bit = true,
};

/// Operation performed on single defragmentation move. See structure #VmaDefragmentationMove.
//
/// Default is copy: Buffer/image has been recreated at `dstTmpAllocation`, data has been copied, old buffer/image has been destroyed. `srcAllocation` should be changed to point to the new place. This is the default value set by vmaBeginDefragmentationPass().
pub const DefragmentationMoveOperation = packed struct(vk.Flags)
{
    /// Set this value if you cannot move the allocation. New place reserved at `dstTmpAllocation` will be freed. `srcAllocation` will remain unchanged.
    ignore: bool = false,
    /// Set this value if you decide to abandon the allocation and you destroyed the buffer/image. New place reserved at `dstTmpAllocation` will be freed, along with `srcAllocation`, which will be destroyed.
    destroy: bool = false,

    _reserved_bit_02: bool = false,
    _reserved_bit_03: bool = false,
    _reserved_bit_04: bool = false,
    _reserved_bit_05: bool = false,
    _reserved_bit_06: bool = false,
    _reserved_bit_07: bool = false,
    _reserved_bit_08: bool = false,
    _reserved_bit_09: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
};

/// Flags to be passed as VirtualBlockCreateInfo::flags.
pub const VirtualBlockCreateFlags = packed struct(vk.Flags)
{
    // Enables alternative, linear allocation algorithm in this virtual block.
    //
    // Specify this flag to enable linear allocation algorithm, which always creates
    // new allocations after last one and doesn't reuse space from allocations freed in
    // between. It trades memory consumption for simplified algorithm and data
    // structure, which has better performance and uses less memory for metadata.
    //
    // By using this flag, you can achieve behavior of free-at-once, stack,
    // ring buffer, and double stack.
    // For details, see documentation chapter \ref linear_algorithm.
    linear_algorithm_bit: bool = false,

    _reserved_bit_01: bool = false,
    _reserved_bit_02: bool = false,
    _reserved_bit_03: bool = false,
    _reserved_bit_04: bool = false,
    _reserved_bit_05: bool = false,
    _reserved_bit_06: bool = false,
    _reserved_bit_07: bool = false,
    _reserved_bit_08: bool = false,
    _reserved_bit_09: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
};

// Bit mask to extract only `ALGORITHM` bits from entire set of flags.
pub const VirtualBlockCreateFlagsAlgorithmMask: VirtualBlockCreateFlags = .{ .linear_algorithm_bit = true };


/// Flags to be passed as VirtualAllocationCreateInfo::flags.
pub const VirtualAllocationCreateFlags = packed struct(vk.Flags)
{
    _reserved_bit_00: bool = false,
    _reserved_bit_01: bool = false,
    _reserved_bit_02: bool = false,
    _reserved_bit_03: bool = false,

    // Allocation will be created from upper stack in a double stack pool.
    //
    // This flag is only allowed for virtual blocks created with #VirtualBlockCreateFlags.linear_algorithm_bit flag.
    upper_address_bit: bool = false,

    _reserved_bit_05: bool = false,
    _reserved_bit_06: bool = false,
    _reserved_bit_07: bool = false,
    _reserved_bit_08: bool = false,
    _reserved_bit_09: bool = false,
    _reserved_bit_10: bool = false,

    // Allocation strategy that tries to minimize memory usage.
    strategy_min_memory_bit: bool = false,
    // Allocation strategy that tries to minimize allocation time.
    strategy_min_time_bit: bool = false,
    // Allocation strategy that chooses always the lowest offset in available space.
    // This is not the most efficient strategy but achieves highly packed data.
    strategy_min_offset_bit: bool = false,

    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
};

// A bit mask to extract only `STRATEGY` bits from entire set of flags.
//
// These strategy flags are binary compatible with equivalent flags in #AllocationCreateFlags.
pub const VirtualAllocationCreateFlagsStrategyMask: VirtualAllocationCreateFlags = .{
    .strategy_min_memory_bit = true,
    .strategy_min_offset_bit = true,
    .strategy_min_time_bit = true,
};

/// Callback function called after successful vkAllocateMemory.
pub const PfnAllocateDeviceMemoryFunction = ?*const fn (
    allocator: Allocator,
    memory_type: u32,
    memory: vk.DeviceMemory,
    size: vk.DeviceSize,
    p_user_data: ?*anyopaque
) callconv(vk.vulkan_call_conv) void;

/// Callback function called before vkFreeMemory.
pub const PfnFreeDeviceMemoryFunction = ?*const fn (
    allocator: Allocator,
    memory_type: u32,
    memory: vk.DeviceMemory,
    size: vk.DeviceSize,
    p_user_data: ?*anyopaque
) callconv(vk.vulkan_call_conv) void;


// Set of callbacks that the library will call for `vkAllocateMemory` and `vkFreeMemory`.
//
// Provided for informative purpose, e.g. to gather statistics about number of
// allocations or total amount of memory allocated in Vulkan.
//
// Used in AllocatorCreateInfo::p_device_memory_callbacks.
pub const DeviceMemoryCallbacks = extern struct {
    /// Optional, can be null.
    pfn_allocate: PfnAllocateDeviceMemoryFunction,
    /// Optional, can be null.
    pfn_free: PfnFreeDeviceMemoryFunction,
    /// Optional, can be null.
    p_user_data: ?*anyopaque,
};

// Pointers to some Vulkan functions - a subset used by the library.
//
// Used in AllocatorCreateInfo::p_vulkan_functions.
pub const VulkanFunctions = struct
{
    /// Required when using VMA_DYNAMIC_VULKAN_FUNCTIONS.
    vkGetInstanceProcAddr: vk.PfnGetInstanceProcAddr,
    /// Required when using VMA_DYNAMIC_VULKAN_FUNCTIONS.
    vkGetDeviceProcAddr: vk.PfnGetDeviceProcAddr,
    vkGetPhysicalDeviceProperties: vk.PfnGetPhysicalDeviceProperties,
    vkGetPhysicalDeviceMemoryProperties: vk.PfnGetPhysicalDeviceMemoryProperties,
    vkAllocateMemory: vk.PfnAllocateMemory,
    vkFreeMemory: vk.PfnFreeMemory,
    vkMapMemory: vk.PfnMapMemory,
    vkUnmapMemory: vk.PfnUnmapMemory,
    vkFlushMappedMemoryRanges: vk.PfnFlushMappedMemoryRanges,
    vkInvalidateMappedMemoryRanges: vk.PfnInvalidateMappedMemoryRanges,
    vkBindBufferMemory: vk.PfnBindBufferMemory,
    vkBindImageMemory: vk.PfnBindImageMemory,
    vkGetBufferMemoryRequirements: vk.PfnGetBufferMemoryRequirements,
    vkGetImageMemoryRequirements: vk.PfnGetImageMemoryRequirements,
    vkCreateBuffer: vk.PfnCreateBuffer,
    vkDestroyBuffer: vk.PfnDestroyBuffer,
    vkCreateImage: vk.PfnCreateImage,
    vkDestroyImage: vk.PfnDestroyImage,
    vkCmdCopyBuffer: vk.PfnCmdCopyBuffer,
    /// Fetch "vkGetBufferMemoryRequirements2" on Vulkan >= 1.1, fetch "vkGetBufferMemoryRequirements2KHR" when using VK_KHR_dedicated_allocation extension.
    vkGetBufferMemoryRequirements2KHR: vk.PfnGetBufferMemoryRequirements2KHR,
    /// Fetch "vkGetImageMemoryRequirements2" on Vulkan >= 1.1, fetch "vkGetImageMemoryRequirements2KHR" when using VK_KHR_dedicated_allocation extension.
    vkGetImageMemoryRequirements2KHR: vk.PfnGetImageMemoryRequirements2KHR,
    /// Fetch "vkBindBufferMemory2" on Vulkan >= 1.1, fetch "vkBindBufferMemory2KHR" when using VK_KHR_bind_memory2 extension.
    vkBindBufferMemory2KHR: vk.PfnBindBufferMemory2KHR,
    /// Fetch "vkBindImageMemory2" on Vulkan >= 1.1, fetch "vkBindImageMemory2KHR" when using VK_KHR_bind_memory2 extension.
    vkBindImageMemory2KHR: vk.PfnBindImageMemory2KHR,
    /// Fetch from "vkGetPhysicalDeviceMemoryProperties2" on Vulkan >= 1.1, but you can also fetch it from "vkGetPhysicalDeviceMemoryProperties2KHR" if you enabled extension VK_KHR_get_physical_device_properties2.
    vkGetPhysicalDeviceMemoryProperties2KHR: vk.PfnGetPhysicalDeviceMemoryProperties2KHR,
    /// Fetch from "vkGetDeviceBufferMemoryRequirements" on Vulkan >= 1.3, but you can also fetch it from "vkGetDeviceBufferMemoryRequirementsKHR" if you enabled extension VK_KHR_maintenance4.
    vkGetDeviceBufferMemoryRequirements: vk.PfnGetDeviceBufferMemoryRequirementsKHR,
    /// Fetch from "vkGetDeviceImageMemoryRequirements" on Vulkan >= 1.3, but you can also fetch it from "vkGetDeviceImageMemoryRequirementsKHR" if you enabled extension VK_KHR_maintenance4.
    vkGetDeviceImageMemoryRequirements: vk.PfnGetDeviceImageMemoryRequirementsKHR,
};

pub const AllocatorCreateFlags = packed struct(vk.Flags)
{
    // Allocator and all objects created from it will not be synchronized internally, so you must guarantee they are used from only one thread at a time or synchronized externally by you.
    //
    // Using this flag may increase performance because internal mutexes are not used.
    externally_synchronized_bit: bool = false,
    // Enables usage of VK_KHR_dedicated_allocation extension.
    //
    // The flag works only if AllocatorCreateInfo::vulkan_api_version `== VK_API_VERSION_1_0`.
    // When it is `VK_API_VERSION_1_1`, the flag is ignored because the extension has been promoted to Vulkan 1.1.
    //
    // Using this extension will automatically allocate dedicated blocks of memory for
    // some buffers and images instead of suballocating place for them out of bigger
    // memory blocks (as if you explicitly used #VMA_ALLOCATION_CREATE_DEDICATED_MEMORY_BIT
    // flag) when it is recommended by the driver. It may improve performance on some
    // GPUs.
    //
    // You may set this flag only if you found out that following device extensions are
    // supported, you enabled them while creating Vulkan device passed as
    // AllocatorCreateInfo::device, and you want them to be used internally by this
    // library:
    //
    // - VK_KHR_get_memory_requirements2 (device extension)
    // - VK_KHR_dedicated_allocation (device extension)
    //
    // When this flag is set, you can experience following warnings reported by Vulkan
    // validation layer. You can ignore them.
    //
    // > vkBindBufferMemory(): Binding memory to buffer 0x2d but vkGetBufferMemoryRequirements() has not been called on that buffer.
    khr_dedicated_allocation_bit: bool = false,
    // Enables usage of VK_KHR_bind_memory2 extension.
    //
    // The flag works only if AllocatorCreateInfo::vulkan_api_version `== VK_API_VERSION_1_0`.
    // When it is `VK_API_VERSION_1_1`, the flag is ignored because the extension has been promoted to Vulkan 1.1.
    //
    // You may set this flag only if you found out that this device extension is supported,
    // you enabled it while creating Vulkan device passed as AllocatorCreateInfo::device,
    // and you want it to be used internally by this library.
    //
    // The extension provides functions `vkBindBufferMemory2KHR` and `vkBindImageMemory2KHR`,
    // which allow to pass a chain of `pNext` structures while binding.
    // This flag is required if you use `pNext` parameter in vmaBindBufferMemory2() or vmaBindImageMemory2().
    khr_bind_memory2_bit: bool = false,
    // Enables usage of VK_EXT_memory_budget extension.
    //
    // You may set this flag only if you found out that this device extension is supported,
    // you enabled it while creating Vulkan device passed as VmaAllocatorCreateInfo::device,
    // and you want it to be used internally by this library, along with another instance extension
    // VK_KHR_get_physical_device_properties2, which is required by it (or Vulkan 1.1, where this extension is promoted).
    //
    // The extension provides query for current memory usage and budget, which will probably
    // be more accurate than an estimation used by the library otherwise.
    ext_memory_budget_bit: bool = false,
    // Enables usage of VK_AMD_device_coherent_memory extension.
    //
    // You may set this flag only if you:
    //
    // - found out that this device extension is supported and enabled it while creating Vulkan device passed as VmaAllocatorCreateInfo::device,
    // - checked that `VkPhysicalDeviceCoherentMemoryFeaturesAMD::deviceCoherentMemory` is true and set it while creating the Vulkan device,
    // - want it to be used internally by this library.
    //
    // The extension and accompanying device feature provide access to memory types with
    // `VK_MEMORY_PROPERTY_DEVICE_COHERENT_BIT_AMD` and `VK_MEMORY_PROPERTY_DEVICE_UNCACHED_BIT_AMD` flags.
    // They are useful mostly for writing breadcrumb markers - a common method for debugging GPU crash/hang/TDR.
    //
    // When the extension is not enabled, such memory types are still enumerated, but their usage is illegal.
    // To protect from this error, if you don't create the allocator with this flag, it will refuse to allocate any memory or create a custom pool in such memory type,
    // returning `VK_ERROR_FEATURE_NOT_PRESENT`.
    amd_device_coherent_memory_bit: bool = false,
    // Enables usage of "buffer device address" feature, which allows you to use function
    // `vkGetBufferDeviceAddress*` to get raw GPU pointer to a buffer and pass it for usage inside a shader.
    //
    // You may set this flag only if you:
    //
    // 1. (For Vulkan version < 1.2) Found as available and enabled device extension
    // VK_KHR_buffer_device_address.
    // This extension is promoted to core Vulkan 1.2.
    // 2. Found as available and enabled device feature `VkPhysicalDeviceBufferDeviceAddressFeatures::bufferDeviceAddress`.
    //
    // When this flag is set, you can create buffers with `VK_BUFFER_USAGE_SHADER_DEVICE_ADDRESS_BIT` using VMA.
    // The library automatically adds `VK_MEMORY_ALLOCATE_DEVICE_ADDRESS_BIT` to
    // allocated memory blocks wherever it might be needed.
    //
    // For more information, see documentation chapter \ref enabling_buffer_device_address.
    buffer_device_address_bit: bool = false,
    // Enables usage of VK_EXT_memory_priority extension in the library.
    //
    // You may set this flag only if you found available and enabled this device extension,
    // along with `VkPhysicalDeviceMemoryPriorityFeaturesEXT::memoryPriority == VK_TRUE`,
    // while creating Vulkan device passed as AllocatorCreateInfo::device.
    //
    // When this flag is used, AllocationCreateInfo::priority and PoolCreateInfo::priority
    // are used to set priorities of allocated Vulkan memory. Without it, these variables are ignored.
    //
    // A priority must be a floating-point value between 0 and 1, indicating the priority of the allocation relative to other memory allocations.
    // Larger values are higher priority. The granularity of the priorities is implementation-dependent.
    // It is automatically passed to every call to `vkAllocateMemory` done by the library using structure `VkMemoryPriorityAllocateInfoEXT`.
    // The value to be used for default priority is 0.5.
    // For more details, see the documentation of the VK_EXT_memory_priority extension.
    ext_memory_priority_bit: bool = false,
    // Enables usage of VK_KHR_maintenance4 extension in the library.
    //
    // You may set this flag only if you found available and enabled this device extension,
    // while creating Vulkan device passed as VmaAllocatorCreateInfo::device.
    khr_maintenance4_bit: bool = false,
    // Enables usage of VK_KHR_maintenance5 extension in the library.
    //
    // You should set this flag if you found available and enabled this device extension,
    // while creating Vulkan device passed as VmaAllocatorCreateInfo::device.
    khr_maintenance5_bit: bool = false,

    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
};

/// Description of a Allocator to be created.
pub const AllocatorCreateInfo = extern struct
{
    // Flags for created allocator. Use #VmaAllocatorCreateFlagBits enum.
    flags: AllocatorCreateFlags,
    // Vulkan physical device.
    // It must be valid throughout whole lifetime of created allocator.
    physical_device: vk.PhysicalDevice,
    // Vulkan device.
    // It must be valid throughout whole lifetime of created allocator.
    device: vk.Device,
    // Preferred size of a single `VkDeviceMemory` block to be allocated from large heaps > 1 GiB. Optional.
    // Set to 0 to use default, which is currently 256 MiB.
    preferred_large_heap_block_size: vk.DeviceSize = 0,
    // Custom CPU memory allocation callbacks. Optional.
    // Optional, can be null. When specified, will also be used for all CPU-side memory allocations.
    p_allocation_callbacks: ?*const vk.AllocationCallbacks = null,
    // Informative callbacks for `vkAllocateMemory`, `vkFreeMemory`. Optional.
    // Optional, can be null.
    p_device_memory_callbacks: ?*const DeviceMemoryCallbacks = null,
    // Either null or a pointer to an array of limits on maximum number of bytes that can be allocated out of particular Vulkan memory heap.
    //
    // If not NULL, it must be a pointer to an array of
    // `VkPhysicalDeviceMemoryProperties::memoryHeapCount` elements, defining limit on
    // maximum number of bytes that can be allocated out of particular Vulkan memory
    // heap.
    //
    // Any of the elements may be equal to `VK_WHOLE_SIZE`, which means no limit on that
    // heap. This is also the default in case of `pHeapSizeLimit` = NULL.
    //
    // If there is a limit defined for a heap:
    //
    // - If user tries to allocate more memory from that heap using this allocator,
    //   the allocation fails with `VK_ERROR_OUT_OF_DEVICE_MEMORY`.
    // - If the limit is smaller than heap size reported in `VkMemoryHeap::size`, the
    //   value of this limit will be reported instead when using vmaGetMemoryProperties().
    //
    // Warning! Using this feature may not be equivalent to installing a GPU with
    // smaller amount of memory, because graphics driver doesn't necessary fail new
    // allocations with `VK_ERROR_OUT_OF_DEVICE_MEMORY` result when memory capacity is
    // exceeded. It may return success and just silently migrate some device memory
    // blocks to system RAM. This driver behavior can also be controlled using
    // VK_AMD_memory_overallocation_behavior extension.
    // */
    p_heap_size_limit: ?*const vk.DeviceSize = null,

    // Pointers to Vulkan functions. Can be null.
    //
    // For details see [Pointers to Vulkan functions](@ref config_Vulkan_functions).
    p_vulkan_functions: ?*const VulkanFunctions = null,
    // Handle to Vulkan instance object.
    //
    // Starting from version 3.0.0 this member is no longer optional, it must be set!
    instance: vk.Instance,
    // Optional. Vulkan version that the application uses.
    //
    // It must be a value in the format as created by macro `VK_MAKE_VERSION` or a constant like: `VK_API_VERSION_1_1`, `VK_API_VERSION_1_0`.
    // The patch version number specified is ignored. Only the major and minor versions are considered.
    // Only versions 1.0, 1.1, 1.2, 1.3 are supported by the current implementation.
    // Leaving it initialized to zero is equivalent to `VK_API_VERSION_1_0`.
    // It must match the Vulkan version used by the application and supported on the selected physical device,
    // so it must be no higher than `VkApplicationInfo::apiVersion` passed to `vkCreateInstance`
    // and no higher than `VkPhysicalDeviceProperties::apiVersion` found on the physical device used.
    vulkan_api_version: u32 = vk.API_VERSION_1_3,
    // Either null or a pointer to an array of external memory handle types for each Vulkan memory type.
    //
    // If not NULL, it must be a pointer to an array of `VkPhysicalDeviceMemoryProperties::memoryTypeCount`
    // elements, defining external memory handle types of particular Vulkan memory type,
    // to be passed using `VkExportMemoryAllocateInfoKHR`.
    //
    // Any of the elements may be equal to 0, which means not to use `VkExportMemoryAllocateInfoKHR` on this memory type.
    // This is also the default in case of `pTypeExternalMemoryHandleTypes` = NULL.
    p_type_external_memory_handle_types: ?*const vk.ExternalMemoryHandleTypeFlagsKHR = null,
};

/// Information about existing #VmaAllocator object.
pub const AllocatorInfo = extern struct
{
    // Handle to Vulkan instance object.
    //
    // This is the same value as has been passed through AllocatorCreateInfo::instance.
    instance: vk.Instance,
    // Handle to Vulkan physical device object.
    //
    // This is the same value as has been passed through AllocatorCreateInfo::physical_device.
    physical_device: vk.PhysicalDevice,
    // Handle to Vulkan device object.
    //
    // This is the same value as has been passed through AllocatorCreateInfo::device.
    device: vk.Device,
};


// Calculated statistics of memory usage e.g. in a specific memory type, heap, custom pool, or total.
//
// These are fast to calculate.
// See functions: getHeapBudgets(), getPoolStatistics().
pub const Statistics = extern struct
{
    // Number of `vk.DeviceMemory` objects - Vulkan memory blocks allocated.
    block_count: u32,

    // Number of #VmaAllocation objects allocated.
    //
    // Dedicated allocations have their own blocks, so each one adds 1 to `allocation_count` as well as `block_count`.
    allocation_count: u32,

    // Number of bytes allocated in `vk.DeviceMemory` blocks.

    // note: To avoid confusion, please be aware that what Vulkan calls an "allocation" - a whole `vk.DeviceMemory` object
    // (e.g. as in `vk.PhysicalDeviceLimits::max_memory_allocation_count`) is called a "block" in VMA, while VMA calls
    // "allocation" an Allocation object that represents a memory region sub-allocated from such block, usually for a single buffer or image.
    blockBytes: vk.DeviceSize,

    // Total number of bytes occupied by all #VmaAllocation objects.
    //
    // Always less or equal than `blockBytes`.
    // Difference `(blockBytes - allocationBytes)` is the amount of memory allocated from Vulkan
    // but unused by any #VmaAllocation.
    allocationBytes: vk.DeviceSize,
};


// More detailed statistics than #VmaStatistics.
//
// These are slower to calculate. Use for debugging purposes.
// See functions: vmaCalculateStatistics(), vmaCalculatePoolStatistics().
//
// Previous version of the statistics API provided averages, but they have been removed
// because they can be easily calculated as:
//
// \code
// VkDeviceSize allocationSizeAvg = detailedStats.statistics.allocationBytes / detailedStats.statistics.allocationCount;
// VkDeviceSize unusedBytes = detailedStats.statistics.blockBytes - detailedStats.statistics.allocationBytes;
// VkDeviceSize unusedRangeSizeAvg = unusedBytes / detailedStats.unusedRangeCount;
// \endcode
pub const DetailedStatistics = extern struct 
{
    /// Basic statistics.
    statistics: Statistics,
    /// Number of free ranges of memory between allocations.
    unused_range_count: u32,
    /// Smallest allocation size. `VK_WHOLE_SIZE` if there are 0 allocations.
    allocation_size_min: vk.DeviceSize,
    /// Largest allocation size. 0 if there are 0 allocations.
    allocation_size_max: vk.DeviceSize,
    /// Smallest empty range size. `VK_WHOLE_SIZE` if there are 0 empty ranges.
    unused_range_size_min: vk.DeviceSize,
    /// Largest empty range size. 0 if there are 0 empty ranges.
    unused_range_size_max: vk.DeviceSize,
};


// General statistics from current state of the Allocator -
// total memory usage across all memory heaps and types.
//
// These are slower to calculate. Use for debugging purposes.
// See function calculateStatistics().
pub const TotalStatistics = extern struct
{
    memory_type: [vk.MAX_MEMORY_TYPES]DetailedStatistics,
    memory_heap: [vk.MAX_MEMORY_HEAPS]DetailedStatistics,
    total: DetailedStatistics,
};

// Statistics of current memory usage and available budget for a specific memory heap.
//
// These are fast to calculate.
// See function getHeapBudgets().
pub const Budget = extern struct
{
    // Statistics fetched from the library.
    statistics: Statistics,
    // Estimated current memory usage of the program, in bytes.
    //
    // Fetched from system using VK_EXT_memory_budget extension if enabled.
    //
    // It might be different than `statistics.block_bytes` (usually higher) due to additional implicit objects
    // also occupying the memory, like swapchain, pipelines, descriptor heaps, command buffers, or
    // `vk.DeviceMemory` blocks allocated outside of this library, if any.
    usage: vk.DeviceSize,
    // Estimated amount of memory available to the program, in bytes.
    //
    // Fetched from system using VK_EXT_memory_budget extension if enabled.
    //
    // It might be different (most probably smaller) than `VkMemoryHeap::size[heapIndex]` due to factors
    // external to the program, decided by the operating system.
    // Difference `budget - usage` is the amount of additional memory that can probably
    // be allocated without problems. Exceeding the budget may result in various problems.
    budget: vk.DeviceSize,
};


// Parameters of new #Allocation.

// To be used with functions like createBuffer(), createImage(), and many others.
pub const AllocationCreateInfo = extern struct
{
    /// Use #VmaAllocationCreateFlagBits enum.
    flags: AllocationCreateFlags = .{},
    // Intended usage of memory.
    //
    // You can leave #VMA_MEMORY_USAGE_UNKNOWN if you specify memory requirements in other way.
    // If `pool` is not null, this member is ignored.
    usage: MemoryUsage = .{},
    // Flags that must be set in a Memory Type chosen for an allocation.
    //
    // Leave 0 if you specify memory requirements in other way.
    // If `pool` is not null, this member is ignored.
    required_flags: vk.MemoryPropertyFlags = .{},
    // Flags that preferably should be set in a memory type chosen for an allocation.
    //
    // Set to 0 if no additional flags are preferred.
    // If `pool` is not null, this member is ignored.
    preferred_flags: vk.MemoryPropertyFlags = .{},
    // Bitmask containing one bit set for every memory type acceptable for this allocation.
    //
    // Value 0 is equivalent to `UINT32_MAX` - it means any memory type is accepted if
    // it meets other requirements specified by this structure, with no further
    // restrictions on memory type index. \n
    // If `pool` is not null, this member is ignored.
    memory_type_bits: u32 = 0,
    // Pool that this allocation should be created in.
    //
    // Leave `.null_handle` to allocate from default pool. If not null, members:
    // `usage`, `required_flags`, `preferred_flags`, `memory_type_bits` are ignored.
    pool: Pool = .null_handle,
    // Custom general-purpose pointer that will be stored in Allocation, can be read as AllocationInfo::p_user_data and changed using setAllocationUserData().
    //
    // If #VMA_ALLOCATION_CREATE_USER_DATA_COPY_STRING_BIT is used, it must be either
    // null or pointer to a null-terminated string. The string will be then copied to
    // internal buffer, so it doesn't need to be valid after allocation call.
    p_user_data: ?*anyopaque = null,
    // A floating-point value between 0 and 1, indicating the priority of the allocation relative to other memory allocations.
    //
    // It is used only when #VMA_ALLOCATOR_CREATE_EXT_MEMORY_PRIORITY_BIT flag was used during creation of the #VmaAllocator object
    // and this allocation ends up as dedicated or is explicitly forced as dedicated using #VMA_ALLOCATION_CREATE_DEDICATED_MEMORY_BIT.
    // Otherwise, it has the priority of a memory block where it is placed and this variable is ignored.
    priority: f32 = 0.0,
};

/// Describes parameter of created #VmaPool.
pub const PoolCreateInfo = extern struct
{
    // Vulkan memory type index to allocate this pool from.
    memory_type_index: u32,
    // Use combination of PoolCreateFlagBits.
    flags: PoolCreateFlags,
    // Size of a single `vk.DeviceMemory` block to be allocated as part of this pool, in bytes. Optional.
    //
    // Specify nonzero to set explicit, constant size of memory blocks used by this
    // pool.
    //
    // Leave 0 to use default and let the library manage block sizes automatically.
    // Sizes of particular blocks may vary.
    // In this case, the pool will also support dedicated allocations.
    block_size: vk.DeviceSize = 0,
    // Minimum number of blocks to be always allocated in this pool, even if they stay empty.
    //
    // Set to 0 to have no preallocated blocks and allow the pool be completely empty.
    min_block_count: usize,
    // Maximum number of blocks that can be allocated in this pool. Optional.
    //
    // Set to 0 to use default, which is `SIZE_MAX`, which means no limit.
    //
    // Set to same value as VmaPoolCreateInfo::minBlockCount to have fixed amount of memory allocated
    // throughout whole lifetime of this pool.
    max_block_count: usize = 0,
    // A floating-point value between 0 and 1, indicating the priority of the allocations in this pool relative to other memory allocations.
    //
    // It is used only when #VMA_ALLOCATOR_CREATE_EXT_MEMORY_PRIORITY_BIT flag was used during creation of the #VmaAllocator object.
    // Otherwise, this variable is ignored.
    priority: f32,
    // Additional minimum alignment to be used for all allocations created from this pool. Can be 0.
    //
    // Leave 0 (default) not to impose any additional alignment. If not 0, it must be a power of two.
    // It can be useful in cases where alignment returned by Vulkan by functions like `vkGetBufferMemoryRequirements` is not enough,
    // e.g. when doing interop with OpenGL.
    min_allocation_alignment: vk.DeviceSize = 0,
    // Additional `p_next` chain to be attached to `vk.MemoryAllocateInfo` used for every allocation made by this pool. Optional.
    //
    // Optional, can be null. If not null, it must point to a `p_next` chain of structures that can be attached to `vk.MemoryAllocateInfo`.
    // It can be useful for special needs such as adding `vk.ExportMemoryAllocateInfoKHR`.
    // Structures pointed by this member must remain alive and unchanged for the whole lifetime of the custom pool.
    //
    // Please note that some structures, e.g. `vk.MemoryPriorityAllocateInfoEXT`, `vk.MemoryDedicatedAllocateInfoKHR`,
    // can be attached automatically by this library when using other, more convenient of its features.
    p_memory_allocate_next: ?*anyopaque,
};


// Parameters of #VmaAllocation objects, that can be retrieved using function vmaGetAllocationInfo().
//
// There is also an extended version of this structure that carries additional parameters: #VmaAllocationInfo2.
pub const AllocationInfo = extern struct
{
    // Memory type index that this allocation was allocated from.
    //
    // It never changes.
    memory_type: u32,
    // Handle to Vulkan memory object.
    //
    // Same memory object can be shared by multiple allocations.
    //
    // It can change after the allocation is moved during \ref defragmentation.
    device_memory: vk.DeviceMemory,
    // Offset in `VkDeviceMemory` object to the beginning of this allocation, in bytes. `(deviceMemory, offset)` pair is unique to this allocation.
    //
    // You usually don't need to use this offset. If you create a buffer or an image together with the allocation using e.g. function
    // createBuffer(), createImage(), functions that operate on these resources refer to the beginning of the buffer or image,
    // not entire device memory block. Functions like mapMemory(), bindBufferMemory() also refer to the beginning of the allocation
    // and apply this offset automatically.
    //
    // It can change after the allocation is moved during \ref defragmentation.
    offset: vk.DeviceSize,
    // Size of this allocation, in bytes.
    //
    // It never changes.
    //
    // note: Allocation size returned in this variable may be greater than the size
    // requested for the resource e.g. as `vk.BufferCreateInfo::size`. Whole size of the
    // allocation is accessible for operations on memory e.g. using a pointer after
    // mapping with mapMemory(), but operations on the resource e.g. using
    // `vk.CmdCopyBuffer` must be limited to the size of the resource.
    size: vk.DeviceSize,
    // Pointer to the beginning of this allocation as mapped data.
    //
    // If the allocation hasn't been mapped using mapMemory() and hasn't been
    // created with #VMA_ALLOCATION_CREATE_MAPPED_BIT flag, this value is null.
    //
    // It can change after call to mapMemory(), unmapMemory().
    // It can also change after the allocation is moved during \ref defragmentation.
    p_mapped_data: ?*anyopaque,
    // Custom general-purpose pointer that was passed as AllocationCreateInfo::p_user_data or set using vmaSetAllocationUserData().
    //
    // It can change after call to setAllocationUserData() for this allocation.
    p_user_data: ?*anyopaque,
    // Custom allocation name that was set with setAllocationName().
    //
    // It can change after call to setAllocationName() for this allocation.
    //
    // Another way to set custom name is to pass it in AllocationCreateInfo::p_user_data with
    // additional flag #VMA_ALLOCATION_CREATE_USER_DATA_COPY_STRING_BIT set [DEPRECATED].
    p_name: ?[*:0]u8,
};

/// Extended parameters of a #VmaAllocation object that can be retrieved using function vmaGetAllocationInfo2().
pub const AllocationInfo2 = extern struct
{
    // Basic parameters of the allocation.
    //
    // If you need only these, you can use function vmaGetAllocationInfo() and structure #VmaAllocationInfo instead.
    allocation_info: AllocationInfo,
    // Size of the `VkDeviceMemory` block that the allocation belongs to.
    //
    // In case of an allocation with dedicated memory, it will be equal to `allocationInfo.size`.
    block_size: vk.DeviceSize,
    //`VK_TRUE` if the allocation has dedicated memory, `VK_FALSE` if it was placed as part of a larger memory block.
    //
    // When `VK_TRUE`, it also means `vk.MemoryDedicatedAllocateInfo` was used when creating the allocation
    // (if VK_KHR_dedicated_allocation extension or Vulkan version >= 1.1 is enabled).
    //
    dedicatedMemory: vk.Bool32,
};

// Callback function called during beginDefragmentation() to check custom criterion about ending current defragmentation pass.
//
// Should return true if the defragmentation needs to stop current pass.
pub const PfnCheckDefragmentationBreakFunction = ?*const fn (p_user_data: ?*anyopaque) vk.Bool32;

// Parameters for defragmentation.
//
// To be used with function vmaBeginDefragmentation().
pub const DefragmentationInfo = extern struct
{
    /// \brief Use combination of #VmaDefragmentationFlagBits.
    flags: DefragmentationFlags,
    // Custom pool to be defragmented.
    //
    // If null then default pools will undergo defragmentation process.
    pool: Pool,
    // Maximum numbers of bytes that can be copied during single pass, while moving allocations to different places.
    //
    // `0` means no limit.
    max_bytes_per_pass: vk.DeviceSize,
    // Maximum number of allocations that can be moved during single pass to a different place.
    //
    // `0` means no limit.
    max_allocations_per_pass: u32,
    // Optional custom callback for stopping vmaBeginDefragmentation().
    //
    // Have to return true for breaking current defragmentation pass.
    pfn_break_callback: PfnCheckDefragmentationBreakFunction,
    /// Optional data to pass to custom callback for stopping pass of defragmentation.
    p_break_callback_user_data: ?*anyopaque,
};

/// Single move of an allocation to be done for defragmentation.
pub const DefragmentationMove = extern struct
{
    /// Operation to be performed on the allocation by vmaEndDefragmentationPass(). Default value is #VMA_DEFRAGMENTATION_MOVE_OPERATION_COPY. You can modify it.
    operation: DefragmentationMoveOperation,
    /// Allocation that should be moved.
    src_allocation: Allocation,
    // Temporary allocation pointing to destination memory that will replace `src_allocation`.
    //
    // Warning: Do not store this allocation in your data structures! It exists only temporarily, for the duration of the defragmentation pass,
    // to be used for binding new buffer/image to the destination memory using e.g. bindBufferMemory().
    // endDefragmentationPass() will destroy it and make `src_allocation` point to this memory.
    dst_tmp_allocation: Allocation,
};


// Parameters for incremental defragmentation steps.
//
// To be used with function vmaBeginDefragmentationPass().
pub const DefragmentationPassMoveInfo = extern struct
{
    /// Number of elements in the `pMoves` array.
    move_count: u32,
    // Array of moves to be performed by the user in the current defragmentation pass.
    //
    // Pointer to an array of `moveCount` elements, owned by VMA, created in vmaBeginDefragmentationPass(), destroyed in vmaEndDefragmentationPass().
    //
    // For each element, you should:
    //
    // 1. Create a new buffer/image in the place pointed by DefragmentationMove::dst_memory + DefragmentationMove::dst_offset.
    // 2. Copy data from the DefragmentationMove::src_allocation e.g. using `vkCmdCopyBuffer`, `vkCmdCopyImage`.
    // 3. Make sure these commands finished executing on the GPU.
    // 4. Destroy the old buffer/image.
    //
    // Only then you can finish defragmentation pass by calling endDefragmentationPass().
    // After this call, the allocation will point to the new place in memory.
    //
    // Alternatively, if you cannot move specific allocation, you can set DefragmentationMove::operation to #VMA_DEFRAGMENTATION_MOVE_OPERATION_IGNORE.
    //
    // Alternatively, if you decide you want to completely remove the allocation:
    //
    // 1. Destroy its buffer/image.
    // 2. Set DefragmentationMove::operation to #VMA_DEFRAGMENTATION_MOVE_OPERATION_DESTROY.
    //
    // Then, after endDefragmentationPass() the allocation will be freed.
    p_moves: [*]DefragmentationMove,
};


/// Statistics returned for defragmentation process in function endDefragmentation().
pub const DefragmentationStats = extern struct
{
    /// Total number of bytes that have been copied while moving allocations to different places.
    bytes_moved: vk.DeviceSize,
    /// Total number of bytes that have been released to the system by freeing empty `vk.DeviceMemory` objects.
    bytes_freed: vk.DeviceSize,
    /// Number of allocations that have been moved to different places.
    allocations_moved: u32,
    /// Number of empty `vk.DeviceMemory` objects that have been released to the system.
    device_memory_blocks_freed: u32,
};


/// Parameters of created VirtualBlock object to be passed to createVirtualBlock().
pub const VirtualBlockCreateInfo = extern struct
{
    // Total size of the virtual block.
    //
    // Sizes can be expressed in bytes or any units you want as long as you are consistent in using them.
    // For example, if you allocate from some array of structures, 1 can mean single instance of entire structure.
    size: vk.DeviceSize,

    // Use combination of #VmaVirtualBlockCreateFlagBits.
    flags: VirtualBlockCreateFlags,

    // Custom CPU memory allocation callbacks. Optional.
    //
    // Optional, can be null. When specified, they will be used for all CPU-side memory allocations.
    p_allocator: ?*const vk.AllocationCallbacks,
};


/// Parameters of created virtual allocation to be passed to vmaVirtualAllocate().
pub const VirtualAllocationCreateInfo = extern struct
{
    // Size of the allocation.
    //
    // Cannot be zero.
    size: vk.DeviceSize,
    // Required alignment of the allocation. Optional.
    //
    // Must be power of two. Special value 0 has the same meaning as 1 - means no special alignment is required, so allocation can start at any offset.
    alignment: vk.DeviceSize,
    // Use combination of #VmaVirtualAllocationCreateFlagBits.
    flags: VirtualAllocationCreateFlags,
    // Custom pointer to be associated with the allocation. Optional.
    //
    // It can be any value and can be used for user-defined purposes. It can be fetched or changed later.
    p_user_data: ?*anyopaque,
};


/// Parameters of an existing virtual allocation, returned by vmaGetVirtualAllocationInfo().
pub const VirtualAllocationInfo = extern struct
{
    // Offset of the allocation.
    //
    // Offset at which the allocation was made.
    offset: vk.DeviceSize,
    // Size of the allocation.
    //
    // Same value as passed in VirtualAllocationCreateInfo::size.
    size: vk.DeviceSize,
    // Custom pointer associated with the allocation.
    //
    // Same value as passed in VirtualAllocationCreateInfo::p_user_data or to setVirtualAllocationUserData().
    p_user_data: ?*anyopaque,
};


/// Functions
/// Creates #Allocator object.
pub fn createAllocator(p_create_info: *const AllocatorCreateInfo, p_allocator: *const Allocator) !vk.Result {
    const result = vmaCreateAllocator(p_create_info, p_allocator);
    switch (result) {
        vk.Result.success => {},
        else => return error.Unknown,
    }
    return result;
}
extern fn vmaCreateAllocator(
    p_create_info: *const AllocatorCreateInfo,
    p_allocator: *const Allocator) vk.Result;

/// Destroys allocator object.
pub fn destroyAllocator(allocator: Allocator) void { vmaDestroyAllocator(allocator); }
extern fn vmaDestroyAllocator(allocator: Allocator) void;



// Returns information about existing #Allocator object - handle to Vulkan device etc.
//
// It might be useful if you want to keep just the #Allocator handle and fetch other required handles to
// `vk.PhysicalDevice`, `vk.Device` etc. every time using this function.
extern fn vmaGetAllocatorInfo(
    allocator: Allocator,
    p_allocator_info: *AllocatorInfo) void;

// PhysicalDeviceProperties are fetched from physicalDevice by the allocator.
// You can access it here, without fetching it again on your own.
extern fn vmaGetPhysicalDeviceProperties(
    allocator: Allocator,
    pp_physical_device_properties: *const *vk.PhysicalDeviceProperties) void;

// PhysicalDeviceMemoryProperties are fetched from physicalDevice by the allocator.
// You can access it here, without fetching it again on your own.
extern fn vmaGetMemoryProperties(
    allocator: Allocator,
    pp_physical_device_memory_properties: *const * vk.PhysicalDeviceMemoryProperties) void;

// Given Memory Type Index, returns Property Flags of this memory type.
//
// This is just a convenience function. Same information can be obtained using
// getMemoryProperties().
extern fn vmaGetMemoryTypeProperties(
    allocator: Allocator,
    memory_type_index: u32,
    p_flags: *vk.MemoryPropertyFlags) void;

// Sets index of the current frame.
extern fn vmaSetCurrentFrameIndex(
    allocator: Allocator,
    frame_index: u32) void;


// Retrieves statistics from current state of the Allocator.
//
// This function is called "calculate" not "get" because it has to traverse all
// internal data structures, so it may be quite slow. Use it for debugging purposes.
// For faster but more brief statistics suitable to be called every frame or every allocation,
// use getHeapBudgets().
//
// Note that when using allocator from multiple threads, returned information may immediately
// become outdated.
extern fn vmaCalculateStatistics(
    allocator: Allocator,
    pStats: *TotalStatistics) void;

// Retrieves information about current memory usage and budget for all memory heaps.
//
// \param allocator
// \param[out] pBudgets Must point to array with number of elements at least equal to number of memory heaps in physical device used.
//
// This function is called "get" not "calculate" because it is very fast, suitable to be called
// every frame or every allocation. For more detailed statistics use vmaCalculateStatistics().
//
// Note that when using allocator from multiple threads, returned information may immediately
// become outdated.
// */
extern fn vmaGetHeapBudgets(
    allocator: Allocator,
    pBudgets: [*]Budget) void;

// Helps to find memoryTypeIndex, given memoryTypeBits and VmaAllocationCreateInfo.
//
// This algorithm tries to find a memory type that:
//
// - Is allowed by memoryTypeBits.
// - Contains all the flags from pAllocationCreateInfo->requiredFlags.
// - Matches intended usage.
// - Has as many flags from pAllocationCreateInfo->preferredFlags as possible.
//
// Returns VK_ERROR_FEATURE_NOT_PRESENT if not found. Receiving such result
// from this function or any other allocating function probably means that your
// device doesn't support any memory type with requested features for the specific
// type of resource you want to use it for. Please check parameters of your
// resource, like image layout (OPTIMAL versus LINEAR) or mip level count.
extern fn vmaFindMemoryTypeIndex(
    allocator: Allocator,
    memory_type_bits: u32,
    p_allocation_create_info: *const AllocationCreateInfo,
    p_memory_type_index: *u32) vk.Result;

// Helps to find memoryTypeIndex, given VkBufferCreateInfo and AllocationCreateInfo.
//
// It can be useful e.g. to determine value to be used as PoolCreateInfo::memory_type_index.
// It internally creates a temporary, dummy buffer that never has memory bound.
extern fn vmaFindMemoryTypeIndexForBufferInfo(
    allocator: Allocator,
    p_buffer_create_info: *const vk.BufferCreateInfo,
    p_allocation_create_info: *const AllocationCreateInfo,
    p_memory_type_index: *u32) vk.Result;

// Helps to find memoryTypeIndex, given VkImageCreateInfo and VmaAllocationCreateInfo.
//
// It can be useful e.g. to determine value to be used as VmaPoolCreateInfo::memoryTypeIndex.
// It internally creates a temporary, dummy image that never has memory bound.
extern fn vmaFindMemoryTypeIndexForImageInfo(
    allocator: Allocator,
    p_image_create_info: *const vk.ImageCreateInfo,
    p_allocation_create_info: *const AllocationCreateInfo,
    p_memory_type_index: *u32) vk.Result;

// Allocates Vulkan device memory and creates #VmaPool object.
//
// \param allocator Allocator object.
// \param pCreateInfo Parameters of pool to create.
// \param[out] pPool Handle to created pool.
extern fn vmaCreatePool(
    allocator: Allocator,
    p_create_info: *const PoolCreateInfo,
    p_pool: *Pool) vk.Result;

// Destroys #VmaPool object and frees Vulkan device memory.
extern fn vmaDestroyPool(
    allocator: Allocator,
    pool: Pool) void;


// Retrieves statistics of existing #VmaPool object.
//
// \param allocator Allocator object.
// \param pool Pool object.
// \param[out] pPoolStats Statistics of specified pool.
extern fn vmaGetPoolStatistics(
    allocator: Allocator,
    pool: Pool,
    p_pool_stats: *Statistics) void;

// Retrieves detailed statistics of existing #VmaPool object.
//
// \param allocator Allocator object.
// \param pool Pool object.
// \param[out] pPoolStats Statistics of specified pool.
extern fn vmaCalculatePoolStatistics(
    allocator: Allocator,
    pool: Pool,
    p_pool_stats: *DetailedStatistics) void;

// Checks magic number in margins around all allocations in given memory pool in search for corruptions.
//
// Corruption detection is enabled only when `VMA_DEBUG_DETECT_CORRUPTION` macro is defined to nonzero,
// `VMA_DEBUG_MARGIN` is defined to nonzero and the pool is created in memory type that is
// `HOST_VISIBLE` and `HOST_COHERENT`. For more information, see [Corruption detection](@ref debugging_memory_usage_corruption_detection).
//
// Possible return values:
//
// - `VK_ERROR_FEATURE_NOT_PRESENT` - corruption detection is not enabled for specified pool.
// - `VK_SUCCESS` - corruption detection has been performed and succeeded.
// - `VK_ERROR_UNKNOWN` - corruption detection has been performed and found memory corruptions around one of the allocations.
//   `VMA_ASSERT` is also fired in that case.
// - Other value: Error returned by Vulkan, e.g. memory mapping failure.
extern fn vmaCheckPoolCorruption(
    allocator: Allocator,
    pool: Pool) vk.Result;

// Retrieves name of a custom pool.
//
// After the call `pp_name` is either null or points to an internally-owned null-terminated string
// containing name of the pool that was previously set. The pointer becomes invalid when the pool is
// destroyed or its name is changed using setPoolName().
extern fn vmaGetPoolName(
    allocator: Allocator,
    pool: Pool,
    pp_name: **const u8) void;

// Sets name of a custom pool.
//
// `p_name` can be either null or pointer to a null-terminated string with new name for the pool.
// Function makes internal copy of the string, so it can be changed or freed immediately after this call.
extern fn vmaSetPoolName(
    allocator: Allocator,
    pool: Pool,
    pName: ?*const u8) void;

// General purpose memory allocation.
//
// \param allocator
// \param p_vk_memory_requirements
// \param p_create_info
// \param[out] p_allocation Handle to allocated memory.
// \param[out] p_allocation_info Optional. Information about allocated memory. It can be later fetched using function vmaGetAllocationInfo().
//
// You should free the memory using freeMemory() or freeMemoryPages().
//
// It is recommended to use allocateMemoryForBuffer(), vmaAllocateMemoryForImage(),
// createBuffer(), createImage() instead whenever possible.
extern fn vmaAllocateMemory(
    allocator: Allocator,
    p_vk_memory_requirements: *const vk.MemoryRequirements,
    p_create_info: *const AllocationCreateInfo,
    p_allocation: ?*Allocation,
    p_allocation_info: *AllocationInfo) vk.Result;

// General purpose memory allocation for multiple allocation objects at once.
//
// \param allocator Allocator object.
// \param p_vk_memory_requirements Memory requirements for each allocation.
// \param p_create_info Creation parameters for each allocation.
// \param allocation_count Number of allocations to make.
// \param[out] p_allocations Pointer to array that will be filled with handles to created allocations.
// \param[out] p_allocation_info Optional. Pointer to array that will be filled with parameters of created allocations.
//
// You should free the memory using freeMemory() or freeMemoryPages().
//
// Word "pages" is just a suggestion to use this function to allocate pieces of memory needed for sparse binding.
// It is just a general purpose allocation function able to make multiple allocations at once.
// It may be internally optimized to be more efficient than calling allocateMemory() `allocationCount` times.
//
// All allocations are made using same parameters. All of them are created out of the same memory pool and type.
// If any allocation fails, all allocations already made within this function call are also freed, so that when
// returned result is not `VK_SUCCESS`, `pAllocation` array is always entirely filled with `VK_NULL_HANDLE`.
extern fn vmaAllocateMemoryPages(
    allocator: Allocator,
    p_vk_memory_requirements: [*]const vk.MemoryRequirements,
    p_create_info: [*]const AllocationCreateInfo,
    allocation_count: usize,
    p_allocations: [*]Allocation,
    p_allocation_info: [*]AllocationInfo) vk.Result;

// Allocates memory suitable for given `vk.Buffer`.
//
// \param allocator
// \param buffer
// \param p_create_info
// \param[out] p_allocation Handle to allocated memory.
// \param[out] p_allocation_info Optional. Information about allocated memory. It can be later fetched using function vmaGetAllocationInfo().
//
// It only creates Allocation. To bind the memory to the buffer, use bindBufferMemory().
//
// This is a special-purpose function. In most cases you should use createBuffer().
//
// You must free the allocation using freeMemory() when no longer needed.
extern fn vmaAllocateMemoryForBuffer(
    allocator: Allocator,
    buffer: vk.Buffer,
    p_create_info: *const AllocationCreateInfo,
    p_allocation: *Allocation,
    p_allocation_info: *AllocationInfo) vk.Result;

// Allocates memory suitable for given `VkImage`.
//
// \param allocator
// \param image
// \param p_create_info
// \param[out] p_allocation Handle to allocated memory.
// \param[out] p_allocation_info Optional. Information about allocated memory. It can be later fetched using function getAllocationInfo().
//
// It only creates #Allocation. To bind the memory to the buffer, use bindImageMemory().
//
// This is a special-purpose function. In most cases you should use createImage().
//
// You must free the allocation using freeMemory() when no longer needed.
extern fn vmaAllocateMemoryForImage(
    allocator: Allocator,
    image: vk.Image,
    p_create_info: *const AllocationCreateInfo,
    p_allocation: *Allocation,
    p_allocation_info: *AllocationInfo) vk.Result;

// Frees memory previously allocated using vmaAllocateMemory(), vmaAllocateMemoryForBuffer(), or vmaAllocateMemoryForImage().
// Passing `VK_NULL_HANDLE` as `allocation` is valid. Such function call is just skipped.
extern fn vmaFreeMemory(
    allocator: Allocator,
    allocation: Allocation) void;

// Frees memory and destroys multiple allocations.
//
// Word "pages" is just a suggestion to use this function to free pieces of memory used for sparse binding.
// It is just a general purpose function to free memory and destroy allocations made using e.g. allocateMemory(),
// allocateMemoryPages() and other functions.
// It may be internally optimized to be more efficient than calling freeMemory() `allocation_count` times.
//
// Allocations in `p_allocations` array can come from any memory pools and types.
// Passing `VK_NULL_HANDLE` as elements of `p_allocations` array is valid. Such entries are just skipped.
extern fn vmaFreeMemoryPages(
    allocator: Allocator,
    allocationCount: usize,
    pAllocations: [*]Allocation) void;

// Returns current information about specified allocation.
//
// Current parameters of given allocation are returned in `p_allocation_info`.
//
// Although this function doesn't lock any mutex, so it should be quite efficient,
// you should avoid calling it too often.
// You can retrieve same AllocationInfo structure while creating your resource, from function
// createBuffer(), createImage(). You can remember it if you are sure parameters don't change
// (e.g. due to defragmentation).
//
// There is also a new function getAllocationInfo2() that offers extended information
// about the allocation, returned using new structure #AllocationInfo2.
extern fn vmaGetAllocationInfo(
    allocator: Allocator,
    allocation: Allocation,
    p_allocation_info: *AllocationInfo) void;

// Returns extended information about specified allocation.
//
// Current parameters of given allocation are returned in `p_allocation_info`.
// Extended parameters in structure #AllocationInfo2 include memory block size
// and a flag telling whether the allocation has dedicated memory.
// It can be useful e.g. for interop with OpenGL.
extern fn vmaGetAllocationInfo2(
    allocator: Allocator,
    allocation: Allocation,
    p_allocation_info: *AllocationInfo2) void;

// Sets pUserData in given allocation to new value.
//
// The value of pointer `pUserData` is copied to allocation's `pUserData`.
// It is opaque, so you can use it however you want - e.g.
// as a pointer, ordinal number or some handle to you own data.
extern fn vmaSetAllocationUserData(
    allocator: Allocator,
    allocation: Allocation,
    p_user_data: ?*anyopaque) void;

// Sets pName in given allocation to new value.
//
// `p_name` must be either null, or pointer to a null-terminated string. The function
// makes local copy of the string and sets it as allocation's `p_name`. String
// passed as p_name doesn't need to be valid for whole lifetime of the allocation -
// you can free it after this call. String previously pointed by allocation's
// `p_name` is freed from memory.
extern fn vmaSetAllocationName(
    allocator: Allocator,
    allocation: Allocation,
    pName: ?[*:0]u8) void;

// Given an allocation, returns Property Flags of its memory type.
//
// This is just a convenience function. Same information can be obtained using
// vmaGetAllocationInfo() + vmaGetMemoryProperties().
extern fn vmaGetAllocationMemoryProperties(
    allocator: Allocator,
    allocation: Allocation,
    pFlags: *vk.MemoryPropertyFlags) void;

// Maps memory represented by given allocation and returns pointer to it.
//
// Maps memory represented by given allocation to make it accessible to CPU code.
// When succeeded, `pp_data.*` contains pointer to first byte of this memory.
//
// \warning
// If the allocation is part of a bigger `vk.DeviceMemory` block, returned pointer is
// correctly offsetted to the beginning of region assigned to this particular allocation.
// Unlike the result of `vkMapMemory`, it points to the allocation, not to the beginning of the whole block.
// You should not add VmaAllocationInfo::offset to it!
//
// Mapping is internally reference-counted and synchronized, so despite raw Vulkan
// function `vkMapMemory()` cannot be used to map same block of `VkDeviceMemory`
// multiple times simultaneously, it is safe to call this function on allocations
// assigned to the same memory block. Actual Vulkan memory will be mapped on first
// mapping and unmapped on last unmapping.
//
// If the function succeeded, you must call unmapMemory() to unmap the
// allocation when mapping is no longer needed or before freeing the allocation, at
// the latest.
//
// It also safe to call this function multiple times on the same allocation. You
// must call unmapMemory() same number of times as you called mapMemory().
//
// It is also safe to call this function on allocation created with
// #VMA_ALLOCATION_CREATE_MAPPED_BIT flag. Its memory stays mapped all the time.
// You must still call unmapMemory() same number of times as you called
// mapMemory(). You must not call unmapMemory() additional time to free the
// "0-th" mapping made automatically due to #VMA_ALLOCATION_CREATE_MAPPED_BIT flag.
//
// This function fails when used on allocation made in memory type that is not
// `HOST_VISIBLE`.
//
// This function doesn't automatically flush or invalidate caches.
// If the allocation is made from a memory types that is not `HOST_COHERENT`,
// you also need to use invalidateAllocation() / flushAllocation(), as required by Vulkan specification.
extern fn vmaMapMemory(
    allocator: Allocator,
    allocation: Allocation,
    pp_data: ?**anyopaque) vk.Result;

// Unmaps memory represented by given allocation, mapped previously using mapMemory().
//
// For details, see description of mapMemory().
//
// This function doesn't automatically flush or invalidate caches.
// If the allocation is made from a memory types that is not `HOST_COHERENT`,
// you also need to use invalidateAllocation() / flushAllocation(), as required by Vulkan specification.
extern fn vmaUnmapMemory(
    allocator: Allocator,
    allocation: Allocation) void;

// Flushes memory of given allocation.
//
// Calls `vkFlushMappedMemoryRanges()` for memory associated with given range of given allocation.
// It needs to be called after writing to a mapped memory for memory types that are not `HOST_COHERENT`.
// Unmap operation doesn't do that automatically.
//
// - `offset` must be relative to the beginning of allocation.
// - `size` can be `VK_WHOLE_SIZE`. It means all memory from `offset` the the end of given allocation.
// - `offset` and `size` don't have to be aligned.
//   They are internally rounded down/up to multiply of `nonCoherentAtomSize`.
// - If `size` is 0, this call is ignored.
// - If memory type that the `allocation` belongs to is not `HOST_VISIBLE` or it is `HOST_COHERENT`,
//   this call is ignored.
//
// Warning! `offset` and `size` are relative to the contents of given `allocation`.
// If you mean whole allocation, you can pass 0 and `VK_WHOLE_SIZE`, respectively.
// Do not pass allocation's offset as `offset`!!!
//
// This function returns the `VkResult` from `vkFlushMappedMemoryRanges` if it is
// called, otherwise `VK_SUCCESS`.
extern fn vmaFlushAllocation(
    allocator: Allocator,
    allocation: Allocation,
    offset: vk.DeviceSize,
    size: vk.DeviceSize) vk.Result;

// Invalidates memory of given allocation.
//
// Calls `vkInvalidateMappedMemoryRanges()` for memory associated with given range of given allocation.
// It needs to be called before reading from a mapped memory for memory types that are not `HOST_COHERENT`.
// Map operation doesn't do that automatically.
//
// - `offset` must be relative to the beginning of allocation.
// - `size` can be `VK_WHOLE_SIZE`. It means all memory from `offset` the the end of given allocation.
// - `offset` and `size` don't have to be aligned.
//   They are internally rounded down/up to multiply of `nonCoherentAtomSize`.
// - If `size` is 0, this call is ignored.
// - If memory type that the `allocation` belongs to is not `HOST_VISIBLE` or it is `HOST_COHERENT`,
//   this call is ignored.
//
// Warning! `offset` and `size` are relative to the contents of given `allocation`.
// If you mean whole allocation, you can pass 0 and `VK_WHOLE_SIZE`, respectively.
// Do not pass allocation's offset as `offset`!!!
//
// This function returns the `VkResult` from `vkInvalidateMappedMemoryRanges` if
// it is called, otherwise `VK_SUCCESS`.
extern fn vmaInvalidateAllocation(
    allocator: Allocator,
    allocation: Allocation,
    offset: vk.DeviceSize,
    size: vk.DeviceSize) vk.Result;

// Flushes memory of given set of allocations.
//
// Calls `vkFlushMappedMemoryRanges()` for memory associated with given ranges of given allocations.
// For more information, see documentation of vmaFlushAllocation().
//
// \param allocator
// \param allocationCount
// \param allocations
// \param offsets If not null, it must point to an array of offsets of regions to flush, relative to the beginning of respective allocations. Null means all offsets are zero.
// \param sizes If not null, it must point to an array of sizes of regions to flush in respective allocations. Null means `VK_WHOLE_SIZE` for all allocations.
//
// This function returns the `VkResult` from `vkFlushMappedMemoryRanges` if it is
// called, otherwise `VK_SUCCESS`.
extern fn vmaFlushAllocations(
    allocator: Allocator,
    allocationCount: u32,
    allocations: [*]const Allocation,
    offsets: [*]const vk.DeviceSize,
    sizes: [*]const vk.DeviceSize) vk.Result;

// Invalidates memory of given set of allocations.
//
// Calls `vkInvalidateMappedMemoryRanges()` for memory associated with given ranges of given allocations.
// For more information, see documentation of vmaInvalidateAllocation().
//
// \param allocator
// \param allocationCount
// \param allocations
// \param offsets If not null, it must point to an array of offsets of regions to flush, relative to the beginning of respective allocations. Null means all offsets are zero.
// \param sizes If not null, it must point to an array of sizes of regions to flush in respective allocations. Null means `VK_WHOLE_SIZE` for all allocations.
//
// This function returns the `VkResult` from `vkInvalidateMappedMemoryRanges` if it is
// called, otherwise `VK_SUCCESS`.
extern fn vmaInvalidateAllocations(
    allocator: Allocator,
    allocationCount: u32,
    allocations: [*]const Allocation,
    offsets: [*]const vk.DeviceSize,
    sizes: [*]const vk.DeviceSize) vk.Result;

// Maps the allocation temporarily if needed, copies data from specified host pointer to it, and flushes the memory from the host caches if needed.
//
// \param allocator
// \param pSrcHostPointer Pointer to the host data that become source of the copy.
// \param dstAllocation   Handle to the allocation that becomes destination of the copy.
// \param dstAllocationLocalOffset  Offset within `dstAllocation` where to write copied data, in bytes.
// \param size            Number of bytes to copy.
//
// This is a convenience function that allows to copy data from a host pointer to an allocation easily.
// Same behavior can be achieved by calling mapMemory(), `memcpy()`, unmapMemory(), flushAllocation().
//
// This function can be called only for allocations created in a memory type that has `VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT` flag.
// It can be ensured e.g. by using #VMA_MEMORY_USAGE_AUTO and #VMA_ALLOCATION_CREATE_HOST_ACCESS_SEQUENTIAL_WRITE_BIT or
// #VMA_ALLOCATION_CREATE_HOST_ACCESS_RANDOM_BIT.
// Otherwise, the function will fail and generate a Validation Layers error.
//
// `dst_allocation_local_offset` is relative to the contents of given `dst_allocation`.
// If you mean whole allocation, you should pass 0.
// Do not pass allocation's offset within device memory block this parameter!
extern fn vmaCopyMemoryToAllocation(
    allocator: Allocator,
    p_src_host_pointer: [*]u8,
    dst_allocation: Allocation,
    dst_allocation_local_offset: vk.DeviceSize ,
    size: vk.DeviceSize) vk.Result;

// Invalidates memory in the host caches if needed, maps the allocation temporarily if needed, and copies data from it to a specified host pointer.
//
// \param allocator
// \param src_allocation   Handle to the allocation that becomes source of the copy.
// \param src_allocation_local_offset  Offset within `src_allocation` where to read copied data, in bytes.
// \param p_dst_host_pointer Pointer to the host memory that become destination of the copy.
// \param size            Number of bytes to copy.
//
// This is a convenience function that allows to copy data from an allocation to a host pointer easily.
// Same behavior can be achieved by calling invalidateAllocation(), mapMemory(), `memcpy()`, unmapMemory().
//
// This function should be called only for allocations created in a memory type that has `VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT`
// and `VK_MEMORY_PROPERTY_HOST_CACHED_BIT` flag.
// It can be ensured e.g. by using #VMA_MEMORY_USAGE_AUTO and #VMA_ALLOCATION_CREATE_HOST_ACCESS_RANDOM_BIT.
// Otherwise, the function may fail and generate a Validation Layers error.
// It may also work very slowly when reading from an uncached memory.
//
// `src_allocation_local_offset` is relative to the contents of given `src_allocation`.
// If you mean whole allocation, you should pass 0.
// Do not pass allocation's offset within device memory block as this parameter!
extern fn vmaCopyAllocationToMemory(
    allocator: Allocator,
    src_allocation: Allocation,
    src_allocation_local_offset: vk.DeviceSize,
    p_dst_host_pointer: [*]u8,
    size: vk.DeviceSize) vk.Result;

// Checks magic number in margins around all allocations in given memory types (in both default and custom pools) in search for corruptions.
//
// \param allocator
// \param memory_type_bits Bit mask, where each bit set means that a memory type with that index should be checked.
//
// Corruption detection is enabled only when `VMA_DEBUG_DETECT_CORRUPTION` macro is defined to nonzero,
// `VMA_DEBUG_MARGIN` is defined to nonzero and only for memory types that are
// `HOST_VISIBLE` and `HOST_COHERENT`. For more information, see [Corruption detection](@ref debugging_memory_usage_corruption_detection).
//
// Possible return values:
//
// - `VK_ERROR_FEATURE_NOT_PRESENT` - corruption detection is not enabled for any of specified memory types.
// - `VK_SUCCESS` - corruption detection has been performed and succeeded.
// - `VK_ERROR_UNKNOWN` - corruption detection has been performed and found memory corruptions around one of the allocations.
//   `VMA_ASSERT` is also fired in that case.
// - Other value: Error returned by Vulkan, e.g. memory mapping failure.
extern fn vmaCheckCorruption(
    allocator: Allocator,
    memory_type_bits: u32) vk.Result;

// Begins defragmentation process.
//
// \param allocator Allocator object.
// \param p_info Structure filled with parameters of defragmentation.
// \param[out] pContext Context object that must be passed to endDefragmentation() to finish defragmentation.
// \returns
// - `VK_SUCCESS` if defragmentation can begin.
// - `VK_ERROR_FEATURE_NOT_PRESENT` if defragmentation is not supported.
//
// For more information about defragmentation, see documentation chapter:
// [Defragmentation](@ref defragmentation).
extern fn vmaBeginDefragmentation(
    allocator: Allocator,
    p_info: *const DefragmentationInfo,
    p_context: *DefragmentationContext) vk.Result;

// Ends defragmentation process.
//
// \param allocator Allocator object.
// \param context Context object that has been created by beginDefragmentation().
// \param[out] pStats Optional stats for the defragmentation. Can be null.
//
// Use this function to finish defragmentation started by beginDefragmentation().
extern fn vmaEndDefragmentation(
    allocator: Allocator,
    context: DefragmentationContext,
    pStats: ?*DefragmentationStats) void;

// Starts single defragmentation pass.
//
// \param allocator Allocator object.
// \param context Context object that has been created by vmaBeginDefragmentation().
// \param[out] pPassInfo Computed information for current pass.
// \returns
// - `VK_SUCCESS` if no more moves are possible. Then you can omit call to vmaEndDefragmentationPass() and simply end whole defragmentation.
// - `VK_INCOMPLETE` if there are pending moves returned in `pPassInfo`. You need to perform them, call vmaEndDefragmentationPass(),
//   and then preferably try another pass with vmaBeginDefragmentationPass().
extern fn vmaBeginDefragmentationPass(
    allocator: Allocator,
    context: DefragmentationContext,
    pPassInfo: *DefragmentationPassMoveInfo) vk.Result;

// Ends single defragmentation pass.
//
// \param allocator Allocator object.
// \param context Context object that has been created by vmaBeginDefragmentation().
// \param pPassInfo Computed information for current pass filled by vmaBeginDefragmentationPass() and possibly modified by you.
//
// Returns `VK_SUCCESS` if no more moves are possible or `VK_INCOMPLETE` if more defragmentations are possible.
//
// Ends incremental defragmentation pass and commits all defragmentation moves from `pPassInfo`.
// After this call:
//
// - Allocations at `pPassInfo[i].srcAllocation` that had `pPassInfo[i].operation ==` #VMA_DEFRAGMENTATION_MOVE_OPERATION_COPY
//   (which is the default) will be pointing to the new destination place.
// - Allocation at `pPassInfo[i].srcAllocation` that had `pPassInfo[i].operation ==` #VMA_DEFRAGMENTATION_MOVE_OPERATION_DESTROY
//   will be freed.
//
// If no more moves are possible you can end whole defragmentation.
extern fn vmaEndDefragmentationPass(
    allocator: Allocator,
    context: DefragmentationContext,
    pPassInfo: *DefragmentationPassMoveInfo) vk.Result;

// Binds buffer to allocation.
//
// Binds specified buffer to region of memory represented by specified allocation.
// Gets `VkDeviceMemory` handle and offset from the allocation.
// If you want to create a buffer, allocate memory for it and bind them together separately,
// you should use this function for binding instead of standard `vkBindBufferMemory()`,
// because it ensures proper synchronization so that when a `VkDeviceMemory` object is used by multiple
// allocations, calls to `vkBind*Memory()` or `vkMapMemory()` won't happen from multiple threads simultaneously
// (which is illegal in Vulkan).
//
// It is recommended to use function vmaCreateBuffer() instead of this one.
extern fn vmaBindBufferMemory(
    allocator: Allocator,
    allocation: Allocation,
    buffer: vk.Buffer) vk.Result;

// Binds buffer to allocation with additional parameters.
//
// \param allocator
// \param allocation
// \param allocationLocalOffset Additional offset to be added while binding, relative to the beginning of the `allocation`. Normally it should be 0.
// \param buffer
// \param pNext A chain of structures to be attached to `VkBindBufferMemoryInfoKHR` structure used internally. Normally it should be null.
//
// This function is similar to vmaBindBufferMemory(), but it provides additional parameters.
//
// If `pNext` is not null, #VmaAllocator object must have been created with #VMA_ALLOCATOR_CREATE_KHR_BIND_MEMORY2_BIT flag
// or with VmaAllocatorCreateInfo::vulkanApiVersion `>= VK_API_VERSION_1_1`. Otherwise the call fails.
extern fn vmaBindBufferMemory2(
    allocator: Allocator,
    allocation: Allocation,
    allocationLocalOffset: vk.DeviceSize,
    buffer: vk.Buffer,
    pNext: ?*anyopaque) vk.Result;

// Binds image to allocation.
//
// Binds specified image to region of memory represented by specified allocation.
// Gets `VkDeviceMemory` handle and offset from the allocation.
// If you want to create an image, allocate memory for it and bind them together separately,
// you should use this function for binding instead of standard `vkBindImageMemory()`,
// because it ensures proper synchronization so that when a `VkDeviceMemory` object is used by multiple
// allocations, calls to `vkBind*Memory()` or `vkMapMemory()` won't happen from multiple threads simultaneously
// (which is illegal in Vulkan).
//
// It is recommended to use function vmaCreateImage() instead of this one.
extern fn vmaBindImageMemory(
    allocator: Allocator,
    allocation: Allocation,
    image: vk.Image) vk.Result;

// Binds image to allocation with additional parameters.
//
// \param allocator
// \param allocation
// \param allocationLocalOffset Additional offset to be added while binding, relative to the beginning of the `allocation`. Normally it should be 0.
// \param image
// \param pNext A chain of structures to be attached to `VkBindImageMemoryInfoKHR` structure used internally. Normally it should be null.
//
// This function is similar to vmaBindImageMemory(), but it provides additional parameters.
//
// If `pNext` is not null, #VmaAllocator object must have been created with #VMA_ALLOCATOR_CREATE_KHR_BIND_MEMORY2_BIT flag
// or with VmaAllocatorCreateInfo::vulkanApiVersion `>= VK_API_VERSION_1_1`. Otherwise the call fails.
extern fn vmaBindImageMemory2(
    allocator: Allocator,
    allocation: Allocation,
    allocationLocalOffset: vk.DeviceSize,
    image: vk.Image,
    pNext: ?*anyopaque) vk.Result;

// Creates a new `VkBuffer`, allocates and binds memory for it.
//
// \param allocator
// \param pBufferCreateInfo
// \param pAllocationCreateInfo
// \param[out] pBuffer Buffer that was created.
// \param[out] pAllocation Allocation that was created.
// \param[out] pAllocationInfo Optional. Information about allocated memory. It can be later fetched using function vmaGetAllocationInfo().
//
// This function automatically:
//
// -# Creates buffer.
// -# Allocates appropriate memory for it.
// -# Binds the buffer with the memory.
//
// If any of these operations fail, buffer and allocation are not created,
// returned value is negative error code, `*pBuffer` and `*pAllocation` are null.
//
// If the function succeeded, you must destroy both buffer and allocation when you
// no longer need them using either convenience function vmaDestroyBuffer() or
// separately, using `vkDestroyBuffer()` and vmaFreeMemory().
//
// If #VMA_ALLOCATOR_CREATE_KHR_DEDICATED_ALLOCATION_BIT flag was used,
// VK_KHR_dedicated_allocation extension is used internally to query driver whether
// it requires or prefers the new buffer to have dedicated allocation. If yes,
// and if dedicated allocation is possible
// (#VMA_ALLOCATION_CREATE_NEVER_ALLOCATE_BIT is not used), it creates dedicated
// allocation for this buffer, just like when using
// #VMA_ALLOCATION_CREATE_DEDICATED_MEMORY_BIT.
//
// \note This function creates a new `VkBuffer`. Sub-allocation of parts of one large buffer,
// although recommended as a good practice, is out of scope of this library and could be implemented
// by the user as a higher-level logic on top of VMA.
// */
extern fn vmaCreateBuffer(
    allocator: Allocator,
    pBufferCreateInfo: *const vk.BufferCreateInfo,
    pAllocationCreateInfo: *const AllocationCreateInfo,
    pBuffer: *vk.Buffer,
    pAllocation: *Allocation,
    pAllocationInfo: ?*AllocationInfo) vk.Result;

// Creates a buffer with additional minimum alignment.
//
// Similar to vmaCreateBuffer() but provides additional parameter `minAlignment` which allows to specify custom,
// minimum alignment to be used when placing the buffer inside a larger memory block, which may be needed e.g.
// for interop with OpenGL.
extern fn vmaCreateBufferWithAlignment(
    allocator: Allocator,
    pBufferCreateInfo: *const vk.BufferCreateInfo,
    pAllocationCreateInfo: *const AllocationCreateInfo,
    minAlignment: vk.DeviceSize ,
    pBuffer: *vk.Buffer,
    pAllocation: *Allocation,
    pAllocationInfo: ?*AllocationInfo) vk.Result;

// Creates a new `VkBuffer`, binds already created memory for it.
//
// \param allocator
// \param allocation Allocation that provides memory to be used for binding new buffer to it.
// \param pBufferCreateInfo
// \param[out] pBuffer Buffer that was created.
//
// This function automatically:
//
// -# Creates buffer.
// -# Binds the buffer with the supplied memory.
//
// If any of these operations fail, buffer is not created,
// returned value is negative error code and `*pBuffer` is null.
//
// If the function succeeded, you must destroy the buffer when you
// no longer need it using `vkDestroyBuffer()`. If you want to also destroy the corresponding
// allocation you can use convenience function vmaDestroyBuffer().
//
// \note There is a new version of this function augmented with parameter `allocationLocalOffset` - see vmaCreateAliasingBuffer2().
extern fn vmaCreateAliasingBuffer(
    allocator: Allocator,
    allocation: Allocation,
    pBufferCreateInfo: *const vk.BufferCreateInfo,
    pBuffer: *vk.Buffer) vk.Result;

// Creates a new `VkBuffer`, binds already created memory for it.
//
// \param allocator
// \param allocation Allocation that provides memory to be used for binding new buffer to it.
// \param allocationLocalOffset Additional offset to be added while binding, relative to the beginning of the allocation. Normally it should be 0.
// \param pBufferCreateInfo 
// \param[out] pBuffer Buffer that was created.
//
// This function automatically:
//
// -# Creates buffer.
// -# Binds the buffer with the supplied memory.
//
// If any of these operations fail, buffer is not created,
// returned value is negative error code and `*pBuffer` is null.
//
// If the function succeeded, you must destroy the buffer when you
// no longer need it using `vkDestroyBuffer()`. If you want to also destroy the corresponding
// allocation you can use convenience function vmaDestroyBuffer().
//
// \note This is a new version of the function augmented with parameter `allocationLocalOffset`.
extern fn vmaCreateAliasingBuffer2(
    allocator: Allocator,
    allocation: Allocation,
    allocationLocalOffset: vk.DeviceSize ,
    pBufferCreateInfo: *const vk.BufferCreateInfo,
    pBuffer: *vk.Buffer) vk.Result;

// Destroys Vulkan buffer and frees allocated memory.
//
// This is just a convenience function equivalent to:
//
// \code
// vkDestroyBuffer(device, buffer, allocationCallbacks);
// vmaFreeMemory(allocator, allocation);
// \endcode
//
// It is safe to pass null as buffer and/or allocation.
extern fn vmaDestroyBuffer(
    allocator: Allocator,
    buffer: vk.Buffer,
    allocation: Allocation) void;

pub const CreateImageResult = struct {
    image: vk.Image,
    allocation: Allocation,
    info: AllocationInfo,
};

pub fn createImage(allocator: Allocator, p_image_create_info: *const vk.ImageCreateInfo, p_allocation_create_info: *const AllocationCreateInfo) !CreateImageResult {
    var image: vk.Image = .null_handle;
    var allocation: Allocation = undefined;
    var info: AllocationInfo = undefined;
    const result = vmaCreateImage(allocator, p_image_create_info, p_allocation_create_info, &image, &allocation, &info);
    switch (result) {
        .success => {
            return .{
                .image = image,
                .allocation = allocation,
                .info = info,
            };
        },
        else => return error.Unknown,
    }
}

/// Function similar to vmaCreateBuffer().
extern fn vmaCreateImage(
    allocator: Allocator,
    pImageCreateInfo: *const vk.ImageCreateInfo,
    pAllocationCreateInfo: *const AllocationCreateInfo,
    pImage: *vk.Image,
    pAllocation: *Allocation,
    pAllocationInfo: ?*AllocationInfo) vk.Result;

/// Function similar to vmaCreateAliasingBuffer() but for images.
extern fn vmaCreateAliasingImage(
    allocator: Allocator,
    allocation: Allocation,
    pImageCreateInfo: *const vk.ImageCreateInfo,
    pImage: *vk.Image) vk.Result;

/// Function similar to vmaCreateAliasingBuffer2() but for images.
extern fn vmaCreateAliasingImage2(
    allocator: Allocator,
    allocation: Allocation,
    allocationLocalOffset: vk.DeviceSize ,
    pImageCreateInfo: *const vk.ImageCreateInfo,
    pImage: *vk.Image) vk.Result;


pub fn destroyImage(
    allocator: Allocator,
    image: vk.Image,
    allocation: Allocation) void {
    vmaDestroyImage(allocator, image, allocation);
}
// Destroys Vulkan image and frees allocated memory.
//
// This is just a convenience function equivalent to:
//
// \code
// vkDestroyImage(device, image, allocationCallbacks);
// vmaFreeMemory(allocator, allocation);
// \endcode
//
// It is safe to pass null as image and/or allocation.
extern fn vmaDestroyImage(
    allocator: Allocator,
    image: vk.Image,
    allocation: Allocation) void;

// Creates new #VmaVirtualBlock object.
//
// \param pCreateInfo Parameters for creation.
// \param[out] pVirtualBlock Returned virtual block object or `VMA_NULL` if creation failed.
extern fn vmaCreateVirtualBlock(
    pCreateInfo: *const VirtualBlockCreateInfo,
    pVirtualBlock: *VirtualBlock) vk.Result;

// Destroys #VmaVirtualBlock object.
//
// Please note that you should consciously handle virtual allocations that could remain unfreed in the block.
// You should either free them individually using vmaVirtualFree() or call vmaClearVirtualBlock()
// if you are sure this is what you want. If you do neither, an assert is called.
//
// If you keep pointers to some additional metadata associated with your virtual allocations in their `pUserData`,
// don't forget to free them.
extern fn vmaDestroyVirtualBlock(
    virtualBlock: VirtualBlock) void;

// Returns true of the #VmaVirtualBlock is empty - contains 0 virtual allocations and has all its space available for new allocations.
extern fn vmaIsVirtualBlockEmpty(
    virtualBlock: VirtualBlock) vk.Bool32;

// Returns information about a specific virtual allocation within a virtual block, like its size and `pUserData` pointer.
extern fn vmaGetVirtualAllocationInfo(
    virtualBlock: VirtualBlock,
    allocation: VirtualAllocation,
    pVirtualAllocInfo: *VirtualAllocationInfo) void;

// Allocates new virtual allocation inside given #VmaVirtualBlock.
//
// If the allocation fails due to not enough free space available, `VK_ERROR_OUT_OF_DEVICE_MEMORY` is returned
// (despite the function doesn't ever allocate actual GPU memory).
// `pAllocation` is then set to `VK_NULL_HANDLE` and `pOffset`, if not null, it set to `UINT64_MAX`.
//
// \param virtualBlock Virtual block
// \param pCreateInfo Parameters for the allocation
// \param[out] pAllocation Returned handle of the new allocation
// \param[out] pOffset Returned offset of the new allocation. Optional, can be null.
extern fn vmaVirtualAllocate(
    virtualBlock: VirtualBlock,
    pCreateInfo: *const VirtualAllocationCreateInfo,
    pAllocation: VirtualAllocation,
    pOffset: ?*vk.DeviceSize) vk.Result;

// Frees virtual allocation inside given #VmaVirtualBlock.
//
// It is correct to call this function with `allocation == VK_NULL_HANDLE` - it does nothing.
extern fn vmaVirtualFree(
    virtualBlock: VirtualBlock,
    allocation: VirtualAllocation) void;

// Frees all virtual allocations inside given #VmaVirtualBlock.
//
// You must either call this function or free each virtual allocation individually with vmaVirtualFree()
// before destroying a virtual block. Otherwise, an assert is called.
//
// If you keep pointer to some additional metadata associated with your virtual allocation in its `pUserData`,
// don't forget to free it as well.
extern fn vmaClearVirtualBlock(
    virtualBlock: VirtualBlock) void;

// Changes custom pointer associated with given virtual allocation.
extern fn vmaSetVirtualAllocationUserData(
    virtualBlock: VirtualBlock,
    allocation: VirtualAllocation,
    pUserData: ?*anyopaque) void;

// Calculates and returns statistics about virtual allocations and memory usage in given #VmaVirtualBlock.
//
// This function is fast to call. For more detailed statistics, see vmaCalculateVirtualBlockStatistics().
extern fn vmaGetVirtualBlockStatistics(
    virtualBlock: VirtualBlock,
    pStats: *Statistics) void;

// Calculates and returns detailed statistics about virtual allocations and memory usage in given #VmaVirtualBlock.
//
// This function is slow to call. Use for debugging purposes.
// For less detailed statistics, see vmaGetVirtualBlockStatistics().
extern fn vmaCalculateVirtualBlockStatistics(
    virtualBlock: VirtualBlock,
    pStats: *DetailedStatistics) void;

// Builds and returns a null-terminated string in JSON format with information about given #VmaVirtualBlock.
// \param virtualBlock Virtual block.
// \param[out] ppStatsString Returned string.
// \param detailedMap Pass `VK_FALSE` to only obtain statistics as returned by vmaCalculateVirtualBlockStatistics(). Pass `VK_TRUE` to also obtain full list of allocations and free spaces.
//
// Returned string must be freed using vmaFreeVirtualBlockStatsString().
extern fn vmaBuildVirtualBlockStatsString(
    virtualBlock: VirtualBlock,
    ppStatsString: **u8,
    detailedMap: vk.Bool32) void;

/// Frees a string returned by vmaBuildVirtualBlockStatsString().
extern fn vmaFreeVirtualBlockStatsString(
    virtualBlock: VirtualBlock,
    pStatsString: ?*u8) void;

// Builds and returns statistics as a null-terminated string in JSON format.
// \param allocator
// \param[out] ppStatsString Must be freed using vmaFreeStatsString() function.
// \param detailedMap
extern fn vmaBuildStatsString(
    allocator: Allocator,
    ppStatsString: **u8,
    detailedMap: vk.Bool32 ) void;

extern fn vmaFreeStatsString(
    allocator: Allocator,
    pStatsString: ?*u8) void;
