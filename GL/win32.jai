#scope_file

win32 :: #import "Win32";

#scope_export

GL_Context :: win32.HGLRC;

create_context :: inline (win : window.Handle, flags := GL_Context_Creation_Flags.MULTISAMPLED) -> GL_Context #must
{
	hdc := win32.GetDC (win);
	pfd : win32.PIXELFORMATDESCRIPTOR;
	pfd.nSize = size_of (win32.PIXELFORMATDESCRIPTOR);
	pfd.nVersion = 1;
	pfd.dwFlags = win32.PFD_DRAW_TO_WINDOW | win32.PFD_SUPPORT_OPENGL | win32.PFD_DOUBLEBUFFER;
	pfd.iPixelType = win32.PFD_TYPE_RGBA;
	pfd.cColorBits   = 32;
	pfd.cDepthBits   = 24;
	pfd.cStencilBits = 8;

	if flagged (flags, .MULTISAMPLED) && !wglChoosePixelFormatARB
		log.error ("Cannot create multisampled GL context because wglChoosePixelFormatARB is not loaded.");

	pixel_format : s32;
	if flagged (flags, .MULTISAMPLED) && wglChoosePixelFormatARB != null
	{
		attributes := s32.[
			WGL_DRAW_TO_WINDOW_ARB, 1,
			WGL_SUPPORT_OPENGL_ARB, 1,
			WGL_DOUBLE_BUFFER_ARB, 1,
			WGL_PIXEL_TYPE_ARB, WGL_TYPE_RGBA_ARB,
			WGL_COLOR_BITS_ARB, 32,
			WGL_DEPTH_BITS_ARB, 24,
			WGL_STENCIL_BITS_ARB, 8,
			WGL_SAMPLE_BUFFERS_ARB, 1,
			WGL_SAMPLES_ARB, 4,
			0
		];
		num_formats : u32;
		float_attributes := f32.[ 0, 0 ];

		valid := wglChoosePixelFormatARB (hdc, attributes.data, float_attributes.data, 1, *pixel_format, *num_formats);

		// We don't have multisampling, so let Windows choose the closest pixel format from the descriptor.
		if !valid || num_formats < 1
		{
			log.error ("wglChoosePixelFormatARB failed. GL context creation flags were %.", flags);
			pixel_format = win32.ChoosePixelFormat (hdc, *pfd);
		}
	}
	else
	{
		pixel_format = win32.ChoosePixelFormat (hdc, *pfd);
	}

	win32.SetPixelFormat (hdc, pixel_format, *pfd);

	ctx := wglCreateContext (hdc);
	make_context_current (win, ctx);

	return ctx;
}

destroy_context :: inline (win : window.Handle, ctx : GL_Context)
{
	if get_current_context () == ctx
		make_context_current (win, null);

	wglDeleteContext (ctx);
}

make_context_current :: inline (win : window.Handle, ctx : GL_Context)
{
	hdc := win32.GetDC (win);
	wglMakeCurrent (hdc, ctx);
}

get_current_context :: inline () -> GL_Context #must
{
	return wglGetCurrentContext ();
}

get_proc_address :: wglGetProcAddress;

#scope_module

gl_lib :: #foreign_system_library "Opengl32";

GL_Extensions :: struct
	#type_info_none
{
	wglCreateContext  :: (hdc : win32.HDC) -> win32.HANDLE #foreign gl_lib;
	wglDeleteContext  :: (hglrc : win32.HGLRC) -> win32.BOOL #foreign gl_lib;
	wglMakeCurrent    :: (hdc : win32.HDC, hglrc : win32.HGLRC) -> win32.BOOL #foreign gl_lib;
	wglGetCurrentContext :: () -> win32.HGLRC #foreign gl_lib;
	wglGetProcAddress :: (procname : *u8) -> *void #foreign gl_lib;

	// Extension flags:
	
	WGL_3DFX_multisample : bool;
	WGL_3DL_stereo_control : bool;
	WGL_AMD_gpu_association : bool;
	WGL_ARB_buffer_region : bool;
	WGL_ARB_context_flush_control : bool;
	WGL_ARB_create_context : bool;
	WGL_ARB_create_context_no_error : bool;
	WGL_ARB_create_context_profile : bool;
	WGL_ARB_create_context_robustness : bool;
	WGL_ARB_extensions_string : bool;
	WGL_ARB_framebuffer_sRGB : bool;
	WGL_ARB_make_current_read : bool;
	WGL_ARB_multisample : bool;
	WGL_ARB_pbuffer : bool;
	WGL_ARB_pixel_format : bool;
	WGL_ARB_pixel_format_float : bool;
	WGL_ARB_render_texture : bool;
	WGL_ARB_robustness_application_isolation : bool;
	WGL_ARB_robustness_share_group_isolation : bool;
	WGL_ATI_pixel_format_float : bool;
	WGL_EXT_colorspace : bool;
	WGL_EXT_create_context_es2_profile : bool;
	WGL_EXT_create_context_es_profile : bool;
	WGL_EXT_depth_float : bool;
	WGL_EXT_display_color_table : bool;
	WGL_EXT_extensions_string : bool;
	WGL_EXT_framebuffer_sRGB : bool;
	WGL_EXT_make_current_read : bool;
	WGL_EXT_multisample : bool;
	WGL_EXT_pbuffer : bool;
	WGL_EXT_pixel_format : bool;
	WGL_EXT_pixel_format_packed_float : bool;
	WGL_EXT_swap_control : bool;
	WGL_EXT_swap_control_tear : bool;
	WGL_I3D_digital_video_control : bool;
	WGL_I3D_gamma : bool;
	WGL_I3D_genlock : bool;
	WGL_I3D_image_buffer : bool;
	WGL_I3D_swap_frame_lock : bool;
	WGL_I3D_swap_frame_usage : bool;
	WGL_NV_DX_interop : bool;
	WGL_NV_DX_interop2 : bool;
	WGL_NV_copy_image : bool;
	WGL_NV_delay_before_swap : bool;
	WGL_NV_float_buffer : bool;
	WGL_NV_gpu_affinity : bool;
	WGL_NV_multisample_coverage : bool;
	WGL_NV_present_video : bool;
	WGL_NV_render_depth_texture : bool;
	WGL_NV_render_texture_rectangle : bool;
	WGL_NV_swap_group : bool;
	WGL_NV_vertex_array_range : bool;
	WGL_NV_video_capture : bool;
	WGL_NV_video_output : bool;
	WGL_OML_sync_control : bool;
	
	// Extension enums:
	
	// WGL_3DFX_multisample
	WGL_SAMPLE_BUFFERS_3DFX :: 0x2060;
	WGL_SAMPLES_3DFX :: 0x2061;
	
	// WGL_3DL_stereo_control
	WGL_STEREO_EMITTER_ENABLE_3DL :: 0x2055;
	WGL_STEREO_EMITTER_DISABLE_3DL :: 0x2056;
	WGL_STEREO_POLARITY_NORMAL_3DL :: 0x2057;
	WGL_STEREO_POLARITY_INVERT_3DL :: 0x2058;
	
	// WGL_AMD_gpu_association
	WGL_GPU_VENDOR_AMD :: 0x1F00;
	WGL_GPU_RENDERER_STRING_AMD :: 0x1F01;
	WGL_GPU_OPENGL_VERSION_STRING_AMD :: 0x1F02;
	WGL_GPU_FASTEST_TARGET_GPUS_AMD :: 0x21A2;
	WGL_GPU_RAM_AMD :: 0x21A3;
	WGL_GPU_CLOCK_AMD :: 0x21A4;
	WGL_GPU_NUM_PIPES_AMD :: 0x21A5;
	WGL_GPU_NUM_SIMD_AMD :: 0x21A6;
	WGL_GPU_NUM_RB_AMD :: 0x21A7;
	WGL_GPU_NUM_SPI_AMD :: 0x21A8;
	
	// WGL_ARB_buffer_region
	WGL_FRONT_COLOR_BUFFER_BIT_ARB :: 0x00000001;
	WGL_BACK_COLOR_BUFFER_BIT_ARB :: 0x00000002;
	WGL_DEPTH_BUFFER_BIT_ARB :: 0x00000004;
	WGL_STENCIL_BUFFER_BIT_ARB :: 0x00000008;
	
	// WGL_ARB_context_flush_control
	WGL_CONTEXT_RELEASE_BEHAVIOR_ARB :: 0x2097;
	WGL_CONTEXT_RELEASE_BEHAVIOR_NONE_ARB :: 0;
	WGL_CONTEXT_RELEASE_BEHAVIOR_FLUSH_ARB :: 0x2098;
	
	// WGL_ARB_create_context
	WGL_CONTEXT_DEBUG_BIT_ARB :: 0x00000001;
	WGL_CONTEXT_FORWARD_COMPATIBLE_BIT_ARB :: 0x00000002;
	WGL_CONTEXT_MAJOR_VERSION_ARB :: 0x2091;
	WGL_CONTEXT_MINOR_VERSION_ARB :: 0x2092;
	WGL_CONTEXT_LAYER_PLANE_ARB :: 0x2093;
	WGL_CONTEXT_FLAGS_ARB :: 0x2094;
	ERROR_INVALID_VERSION_ARB :: 0x2095;
	
	// WGL_ARB_create_context_no_error
	WGL_CONTEXT_OPENGL_NO_ERROR_ARB :: 0x31B3;
	
	// WGL_ARB_create_context_profile
	WGL_CONTEXT_PROFILE_MASK_ARB :: 0x9126;
	WGL_CONTEXT_CORE_PROFILE_BIT_ARB :: 0x00000001;
	WGL_CONTEXT_COMPATIBILITY_PROFILE_BIT_ARB :: 0x00000002;
	ERROR_INVALID_PROFILE_ARB :: 0x2096;
	
	// WGL_ARB_create_context_robustness
	WGL_CONTEXT_ROBUST_ACCESS_BIT_ARB :: 0x00000004;
	WGL_LOSE_CONTEXT_ON_RESET_ARB :: 0x8252;
	WGL_CONTEXT_RESET_NOTIFICATION_STRATEGY_ARB :: 0x8256;
	WGL_NO_RESET_NOTIFICATION_ARB :: 0x8261;
	
	// WGL_ARB_extensions_string
	
	// WGL_ARB_framebuffer_sRGB
	WGL_FRAMEBUFFER_SRGB_CAPABLE_ARB :: 0x20A9;
	
	// WGL_ARB_make_current_read
	ERROR_INVALID_PIXEL_TYPE_ARB :: 0x2043;
	ERROR_INCOMPATIBLE_DEVICE_CONTEXTS_ARB :: 0x2054;
	
	// WGL_ARB_multisample
	WGL_SAMPLE_BUFFERS_ARB :: 0x2041;
	WGL_SAMPLES_ARB :: 0x2042;
	
	// WGL_ARB_pbuffer
	WGL_DRAW_TO_PBUFFER_ARB :: 0x202D;
	WGL_MAX_PBUFFER_PIXELS_ARB :: 0x202E;
	WGL_MAX_PBUFFER_WIDTH_ARB :: 0x202F;
	WGL_MAX_PBUFFER_HEIGHT_ARB :: 0x2030;
	WGL_PBUFFER_LARGEST_ARB :: 0x2033;
	WGL_PBUFFER_WIDTH_ARB :: 0x2034;
	WGL_PBUFFER_HEIGHT_ARB :: 0x2035;
	WGL_PBUFFER_LOST_ARB :: 0x2036;
	
	// WGL_ARB_pixel_format
	WGL_NUMBER_PIXEL_FORMATS_ARB :: 0x2000;
	WGL_DRAW_TO_WINDOW_ARB :: 0x2001;
	WGL_DRAW_TO_BITMAP_ARB :: 0x2002;
	WGL_ACCELERATION_ARB :: 0x2003;
	WGL_NEED_PALETTE_ARB :: 0x2004;
	WGL_NEED_SYSTEM_PALETTE_ARB :: 0x2005;
	WGL_SWAP_LAYER_BUFFERS_ARB :: 0x2006;
	WGL_SWAP_METHOD_ARB :: 0x2007;
	WGL_NUMBER_OVERLAYS_ARB :: 0x2008;
	WGL_NUMBER_UNDERLAYS_ARB :: 0x2009;
	WGL_TRANSPARENT_ARB :: 0x200A;
	WGL_TRANSPARENT_RED_VALUE_ARB :: 0x2037;
	WGL_TRANSPARENT_GREEN_VALUE_ARB :: 0x2038;
	WGL_TRANSPARENT_BLUE_VALUE_ARB :: 0x2039;
	WGL_TRANSPARENT_ALPHA_VALUE_ARB :: 0x203A;
	WGL_TRANSPARENT_INDEX_VALUE_ARB :: 0x203B;
	WGL_SHARE_DEPTH_ARB :: 0x200C;
	WGL_SHARE_STENCIL_ARB :: 0x200D;
	WGL_SHARE_ACCUM_ARB :: 0x200E;
	WGL_SUPPORT_GDI_ARB :: 0x200F;
	WGL_SUPPORT_OPENGL_ARB :: 0x2010;
	WGL_DOUBLE_BUFFER_ARB :: 0x2011;
	WGL_STEREO_ARB :: 0x2012;
	WGL_PIXEL_TYPE_ARB :: 0x2013;
	WGL_COLOR_BITS_ARB :: 0x2014;
	WGL_RED_BITS_ARB :: 0x2015;
	WGL_RED_SHIFT_ARB :: 0x2016;
	WGL_GREEN_BITS_ARB :: 0x2017;
	WGL_GREEN_SHIFT_ARB :: 0x2018;
	WGL_BLUE_BITS_ARB :: 0x2019;
	WGL_BLUE_SHIFT_ARB :: 0x201A;
	WGL_ALPHA_BITS_ARB :: 0x201B;
	WGL_ALPHA_SHIFT_ARB :: 0x201C;
	WGL_ACCUM_BITS_ARB :: 0x201D;
	WGL_ACCUM_RED_BITS_ARB :: 0x201E;
	WGL_ACCUM_GREEN_BITS_ARB :: 0x201F;
	WGL_ACCUM_BLUE_BITS_ARB :: 0x2020;
	WGL_ACCUM_ALPHA_BITS_ARB :: 0x2021;
	WGL_DEPTH_BITS_ARB :: 0x2022;
	WGL_STENCIL_BITS_ARB :: 0x2023;
	WGL_AUX_BUFFERS_ARB :: 0x2024;
	WGL_NO_ACCELERATION_ARB :: 0x2025;
	WGL_GENERIC_ACCELERATION_ARB :: 0x2026;
	WGL_FULL_ACCELERATION_ARB :: 0x2027;
	WGL_SWAP_EXCHANGE_ARB :: 0x2028;
	WGL_SWAP_COPY_ARB :: 0x2029;
	WGL_SWAP_UNDEFINED_ARB :: 0x202A;
	WGL_TYPE_RGBA_ARB :: 0x202B;
	WGL_TYPE_COLORINDEX_ARB :: 0x202C;
	
	// WGL_ARB_pixel_format_float
	WGL_TYPE_RGBA_FLOAT_ARB :: 0x21A0;
	
	// WGL_ARB_render_texture
	WGL_BIND_TO_TEXTURE_RGB_ARB :: 0x2070;
	WGL_BIND_TO_TEXTURE_RGBA_ARB :: 0x2071;
	WGL_TEXTURE_FORMAT_ARB :: 0x2072;
	WGL_TEXTURE_TARGET_ARB :: 0x2073;
	WGL_MIPMAP_TEXTURE_ARB :: 0x2074;
	WGL_TEXTURE_RGB_ARB :: 0x2075;
	WGL_TEXTURE_RGBA_ARB :: 0x2076;
	WGL_NO_TEXTURE_ARB :: 0x2077;
	WGL_TEXTURE_CUBE_MAP_ARB :: 0x2078;
	WGL_TEXTURE_1D_ARB :: 0x2079;
	WGL_TEXTURE_2D_ARB :: 0x207A;
	WGL_MIPMAP_LEVEL_ARB :: 0x207B;
	WGL_CUBE_MAP_FACE_ARB :: 0x207C;
	WGL_TEXTURE_CUBE_MAP_POSITIVE_X_ARB :: 0x207D;
	WGL_TEXTURE_CUBE_MAP_NEGATIVE_X_ARB :: 0x207E;
	WGL_TEXTURE_CUBE_MAP_POSITIVE_Y_ARB :: 0x207F;
	WGL_TEXTURE_CUBE_MAP_NEGATIVE_Y_ARB :: 0x2080;
	WGL_TEXTURE_CUBE_MAP_POSITIVE_Z_ARB :: 0x2081;
	WGL_TEXTURE_CUBE_MAP_NEGATIVE_Z_ARB :: 0x2082;
	WGL_FRONT_LEFT_ARB :: 0x2083;
	WGL_FRONT_RIGHT_ARB :: 0x2084;
	WGL_BACK_LEFT_ARB :: 0x2085;
	WGL_BACK_RIGHT_ARB :: 0x2086;
	WGL_AUX0_ARB :: 0x2087;
	WGL_AUX1_ARB :: 0x2088;
	WGL_AUX2_ARB :: 0x2089;
	WGL_AUX3_ARB :: 0x208A;
	WGL_AUX4_ARB :: 0x208B;
	WGL_AUX5_ARB :: 0x208C;
	WGL_AUX6_ARB :: 0x208D;
	WGL_AUX7_ARB :: 0x208E;
	WGL_AUX8_ARB :: 0x208F;
	WGL_AUX9_ARB :: 0x2090;
	
	// WGL_ARB_robustness_application_isolation
	WGL_CONTEXT_RESET_ISOLATION_BIT_ARB :: 0x00000008;
	
	// WGL_ARB_robustness_share_group_isolation
	// WGL_CONTEXT_RESET_ISOLATION_BIT_ARB :: 0x00000008;
	
	// WGL_ATI_pixel_format_float
	WGL_TYPE_RGBA_FLOAT_ATI :: 0x21A0;
	
	// WGL_EXT_colorspace
	WGL_COLORSPACE_EXT :: 0x3087;
	WGL_COLORSPACE_SRGB_EXT :: 0x3089;
	WGL_COLORSPACE_LINEAR_EXT :: 0x308A;
	
	// WGL_EXT_create_context_es2_profile
	WGL_CONTEXT_ES2_PROFILE_BIT_EXT :: 0x00000004;
	
	// WGL_EXT_create_context_es_profile
	WGL_CONTEXT_ES_PROFILE_BIT_EXT :: 0x00000004;
	
	// WGL_EXT_depth_float
	WGL_DEPTH_FLOAT_EXT :: 0x2040;
	
	// WGL_EXT_display_color_table
	
	// WGL_EXT_extensions_string
	
	// WGL_EXT_framebuffer_sRGB
	WGL_FRAMEBUFFER_SRGB_CAPABLE_EXT :: 0x20A9;
	
	// WGL_EXT_make_current_read
	ERROR_INVALID_PIXEL_TYPE_EXT :: 0x2043;
	
	// WGL_EXT_multisample
	WGL_SAMPLE_BUFFERS_EXT :: 0x2041;
	WGL_SAMPLES_EXT :: 0x2042;
	
	// WGL_EXT_pbuffer
	WGL_DRAW_TO_PBUFFER_EXT :: 0x202D;
	WGL_MAX_PBUFFER_PIXELS_EXT :: 0x202E;
	WGL_MAX_PBUFFER_WIDTH_EXT :: 0x202F;
	WGL_MAX_PBUFFER_HEIGHT_EXT :: 0x2030;
	WGL_OPTIMAL_PBUFFER_WIDTH_EXT :: 0x2031;
	WGL_OPTIMAL_PBUFFER_HEIGHT_EXT :: 0x2032;
	WGL_PBUFFER_LARGEST_EXT :: 0x2033;
	WGL_PBUFFER_WIDTH_EXT :: 0x2034;
	WGL_PBUFFER_HEIGHT_EXT :: 0x2035;
	
	// WGL_EXT_pixel_format
	WGL_NUMBER_PIXEL_FORMATS_EXT :: 0x2000;
	WGL_DRAW_TO_WINDOW_EXT :: 0x2001;
	WGL_DRAW_TO_BITMAP_EXT :: 0x2002;
	WGL_ACCELERATION_EXT :: 0x2003;
	WGL_NEED_PALETTE_EXT :: 0x2004;
	WGL_NEED_SYSTEM_PALETTE_EXT :: 0x2005;
	WGL_SWAP_LAYER_BUFFERS_EXT :: 0x2006;
	WGL_SWAP_METHOD_EXT :: 0x2007;
	WGL_NUMBER_OVERLAYS_EXT :: 0x2008;
	WGL_NUMBER_UNDERLAYS_EXT :: 0x2009;
	WGL_TRANSPARENT_EXT :: 0x200A;
	WGL_TRANSPARENT_VALUE_EXT :: 0x200B;
	WGL_SHARE_DEPTH_EXT :: 0x200C;
	WGL_SHARE_STENCIL_EXT :: 0x200D;
	WGL_SHARE_ACCUM_EXT :: 0x200E;
	WGL_SUPPORT_GDI_EXT :: 0x200F;
	WGL_SUPPORT_OPENGL_EXT :: 0x2010;
	WGL_DOUBLE_BUFFER_EXT :: 0x2011;
	WGL_STEREO_EXT :: 0x2012;
	WGL_PIXEL_TYPE_EXT :: 0x2013;
	WGL_COLOR_BITS_EXT :: 0x2014;
	WGL_RED_BITS_EXT :: 0x2015;
	WGL_RED_SHIFT_EXT :: 0x2016;
	WGL_GREEN_BITS_EXT :: 0x2017;
	WGL_GREEN_SHIFT_EXT :: 0x2018;
	WGL_BLUE_BITS_EXT :: 0x2019;
	WGL_BLUE_SHIFT_EXT :: 0x201A;
	WGL_ALPHA_BITS_EXT :: 0x201B;
	WGL_ALPHA_SHIFT_EXT :: 0x201C;
	WGL_ACCUM_BITS_EXT :: 0x201D;
	WGL_ACCUM_RED_BITS_EXT :: 0x201E;
	WGL_ACCUM_GREEN_BITS_EXT :: 0x201F;
	WGL_ACCUM_BLUE_BITS_EXT :: 0x2020;
	WGL_ACCUM_ALPHA_BITS_EXT :: 0x2021;
	WGL_DEPTH_BITS_EXT :: 0x2022;
	WGL_STENCIL_BITS_EXT :: 0x2023;
	WGL_AUX_BUFFERS_EXT :: 0x2024;
	WGL_NO_ACCELERATION_EXT :: 0x2025;
	WGL_GENERIC_ACCELERATION_EXT :: 0x2026;
	WGL_FULL_ACCELERATION_EXT :: 0x2027;
	WGL_SWAP_EXCHANGE_EXT :: 0x2028;
	WGL_SWAP_COPY_EXT :: 0x2029;
	WGL_SWAP_UNDEFINED_EXT :: 0x202A;
	WGL_TYPE_RGBA_EXT :: 0x202B;
	WGL_TYPE_COLORINDEX_EXT :: 0x202C;
	
	// WGL_EXT_pixel_format_packed_float
	WGL_TYPE_RGBA_UNSIGNED_FLOAT_EXT :: 0x20A8;
	
	// WGL_EXT_swap_control
	
	// WGL_EXT_swap_control_tear
	
	// WGL_I3D_digital_video_control
	WGL_DIGITAL_VIDEO_CURSOR_ALPHA_FRAMEBUFFER_I3D :: 0x2050;
	WGL_DIGITAL_VIDEO_CURSOR_ALPHA_VALUE_I3D :: 0x2051;
	WGL_DIGITAL_VIDEO_CURSOR_INCLUDED_I3D :: 0x2052;
	WGL_DIGITAL_VIDEO_GAMMA_CORRECTED_I3D :: 0x2053;
	
	// WGL_I3D_gamma
	WGL_GAMMA_TABLE_SIZE_I3D :: 0x204E;
	WGL_GAMMA_EXCLUDE_DESKTOP_I3D :: 0x204F;
	
	// WGL_I3D_genlock
	WGL_GENLOCK_SOURCE_MULTIVIEW_I3D :: 0x2044;
	WGL_GENLOCK_SOURCE_EXTERNAL_SYNC_I3D :: 0x2045;
	WGL_GENLOCK_SOURCE_EXTERNAL_FIELD_I3D :: 0x2046;
	WGL_GENLOCK_SOURCE_EXTERNAL_TTL_I3D :: 0x2047;
	WGL_GENLOCK_SOURCE_DIGITAL_SYNC_I3D :: 0x2048;
	WGL_GENLOCK_SOURCE_DIGITAL_FIELD_I3D :: 0x2049;
	WGL_GENLOCK_SOURCE_EDGE_FALLING_I3D :: 0x204A;
	WGL_GENLOCK_SOURCE_EDGE_RISING_I3D :: 0x204B;
	WGL_GENLOCK_SOURCE_EDGE_BOTH_I3D :: 0x204C;
	
	// WGL_I3D_image_buffer
	WGL_IMAGE_BUFFER_MIN_ACCESS_I3D :: 0x00000001;
	WGL_IMAGE_BUFFER_LOCK_I3D :: 0x00000002;
	
	// WGL_I3D_swap_frame_lock
	
	// WGL_I3D_swap_frame_usage
	
	// WGL_NV_DX_interop
	WGL_ACCESS_READ_ONLY_NV :: 0x00000000;
	WGL_ACCESS_READ_WRITE_NV :: 0x00000001;
	WGL_ACCESS_WRITE_DISCARD_NV :: 0x00000002;
	
	// WGL_NV_DX_interop2
	
	// WGL_NV_copy_image
	
	// WGL_NV_delay_before_swap
	
	// WGL_NV_float_buffer
	WGL_FLOAT_COMPONENTS_NV :: 0x20B0;
	WGL_BIND_TO_TEXTURE_RECTANGLE_FLOAT_R_NV :: 0x20B1;
	WGL_BIND_TO_TEXTURE_RECTANGLE_FLOAT_RG_NV :: 0x20B2;
	WGL_BIND_TO_TEXTURE_RECTANGLE_FLOAT_RGB_NV :: 0x20B3;
	WGL_BIND_TO_TEXTURE_RECTANGLE_FLOAT_RGBA_NV :: 0x20B4;
	WGL_TEXTURE_FLOAT_R_NV :: 0x20B5;
	WGL_TEXTURE_FLOAT_RG_NV :: 0x20B6;
	WGL_TEXTURE_FLOAT_RGB_NV :: 0x20B7;
	WGL_TEXTURE_FLOAT_RGBA_NV :: 0x20B8;
	
	// WGL_NV_gpu_affinity
	ERROR_INCOMPATIBLE_AFFINITY_MASKS_NV :: 0x20D0;
	ERROR_MISSING_AFFINITY_MASK_NV :: 0x20D1;
	
	// WGL_NV_multisample_coverage
	WGL_COVERAGE_SAMPLES_NV :: 0x2042;
	WGL_COLOR_SAMPLES_NV :: 0x20B9;
	
	// WGL_NV_present_video
	WGL_NUM_VIDEO_SLOTS_NV :: 0x20F0;
	
	// WGL_NV_render_depth_texture
	WGL_BIND_TO_TEXTURE_DEPTH_NV :: 0x20A3;
	WGL_BIND_TO_TEXTURE_RECTANGLE_DEPTH_NV :: 0x20A4;
	WGL_DEPTH_TEXTURE_FORMAT_NV :: 0x20A5;
	WGL_TEXTURE_DEPTH_COMPONENT_NV :: 0x20A6;
	WGL_DEPTH_COMPONENT_NV :: 0x20A7;
	
	// WGL_NV_render_texture_rectangle
	WGL_BIND_TO_TEXTURE_RECTANGLE_RGB_NV :: 0x20A0;
	WGL_BIND_TO_TEXTURE_RECTANGLE_RGBA_NV :: 0x20A1;
	WGL_TEXTURE_RECTANGLE_NV :: 0x20A2;
	
	// WGL_NV_swap_group
	
	// WGL_NV_vertex_array_range
	
	// WGL_NV_video_capture
	WGL_UNIQUE_ID_NV :: 0x20CE;
	WGL_NUM_VIDEO_CAPTURE_SLOTS_NV :: 0x20CF;
	
	// WGL_NV_video_output
	WGL_BIND_TO_VIDEO_RGB_NV :: 0x20C0;
	WGL_BIND_TO_VIDEO_RGBA_NV :: 0x20C1;
	WGL_BIND_TO_VIDEO_RGB_AND_DEPTH_NV :: 0x20C2;
	WGL_VIDEO_OUT_COLOR_NV :: 0x20C3;
	WGL_VIDEO_OUT_ALPHA_NV :: 0x20C4;
	WGL_VIDEO_OUT_DEPTH_NV :: 0x20C5;
	WGL_VIDEO_OUT_COLOR_AND_ALPHA_NV :: 0x20C6;
	WGL_VIDEO_OUT_COLOR_AND_DEPTH_NV :: 0x20C7;
	WGL_VIDEO_OUT_FRAME :: 0x20C8;
	WGL_VIDEO_OUT_FIELD_1 :: 0x20C9;
	WGL_VIDEO_OUT_FIELD_2 :: 0x20CA;
	WGL_VIDEO_OUT_STACKED_FIELDS_1_2 :: 0x20CB;
	WGL_VIDEO_OUT_STACKED_FIELDS_2_1 :: 0x20CC;
	
	// WGL_OML_sync_control
	
	// Extension functions:
	
	// WGL_3DFX_multisample
	
	// WGL_3DL_stereo_control
	wglSetStereoEmitterState3DL : (hDC: win32.HDC, uState: u32) -> win32.BOOL #foreign;
	
	// WGL_AMD_gpu_association
	wglGetGPUIDsAMD : (maxCount: u32, ids: *u32) -> u32 #foreign;
	wglGetGPUInfoAMD : (id: u32, property: s32, dataType: GLenum, size: u32, data: *void) -> s32 #foreign;
	wglGetContextGPUIDAMD : (hglrc: win32.HGLRC) -> u32 #foreign;
	wglCreateAssociatedContextAMD : (id: u32) -> win32.HGLRC #foreign;
	wglCreateAssociatedContextAttribsAMD : (id: u32, hShareContext: win32.HGLRC, attribList: *s32) -> win32.HGLRC #foreign;
	wglDeleteAssociatedContextAMD : (hglrc: win32.HGLRC) -> win32.BOOL #foreign;
	wglMakeAssociatedContextCurrentAMD : (hglrc: win32.HGLRC) -> win32.BOOL #foreign;
	wglGetCurrentAssociatedContextAMD : () -> win32.HGLRC #foreign;
	wglBlitContextFramebufferAMD : (dstCtx: win32.HGLRC, srcX0: GLint, srcY0: GLint, srcX1: GLint, srcY1: GLint, dstX0: GLint, dstY0: GLint, dstX1: GLint, dstY1: GLint, mask: GLbitfield, filter: GLenum) -> void #foreign;
	
	// WGL_ARB_buffer_region
	wglCreateBufferRegionARB : (hDC: win32.HDC, iLayerPlane: s32, uType: u32) -> win32.HANDLE #foreign;
	wglDeleteBufferRegionARB : (hRegion: win32.HANDLE) -> void #foreign;
	wglSaveBufferRegionARB : (hRegion: win32.HANDLE, x: s32, y: s32, width: s32, height: s32) -> win32.BOOL #foreign;
	wglRestoreBufferRegionARB : (hRegion: win32.HANDLE, x: s32, y: s32, width: s32, height: s32, xSrc: s32, ySrc: s32) -> win32.BOOL #foreign;
	
	// WGL_ARB_context_flush_control
	
	// WGL_ARB_create_context
	wglCreateContextAttribsARB : (hDC: win32.HDC, hShareContext: win32.HGLRC, attribList: *s32) -> win32.HGLRC #foreign;
	
	// WGL_ARB_create_context_no_error
	
	// WGL_ARB_create_context_profile
	
	// WGL_ARB_create_context_robustness
	
	// WGL_ARB_extensions_string
	wglGetExtensionsStringARB : (hdc: win32.HDC) -> *u8 #foreign;
	
	// WGL_ARB_framebuffer_sRGB
	
	// WGL_ARB_make_current_read
	wglMakeContextCurrentARB : (hDrawDC: win32.HDC, hReadDC: win32.HDC, hglrc: win32.HGLRC) -> win32.BOOL #foreign;
	wglGetCurrentReadDCARB : () -> win32.HDC #foreign;
	
	// WGL_ARB_multisample
	
	// WGL_ARB_pbuffer
	// wglCreatePbufferARB : (hDC: win32.HDC, iPixelFormat: s32, iWidth: s32, iHeight: s32, piAttribList: *s32) -> HPBUFFERARB #foreign;
	// wglGetPbufferDCARB : (hPbuffer: HPBUFFERARB) -> win32.HDC #foreign;
	// wglReleasePbufferDCARB : (hPbuffer: HPBUFFERARB, hDC: win32.HDC) -> s32 #foreign;
	// wglDestroyPbufferARB : (hPbuffer: HPBUFFERARB) -> win32.BOOL #foreign;
	// wglQueryPbufferARB : (hPbuffer: HPBUFFERARB, iAttribute: s32, piValue: *s32) -> win32.BOOL #foreign;
	
	// WGL_ARB_pixel_format
	wglGetPixelFormatAttribivARB : (hdc: win32.HDC, iPixelFormat: s32, iLayerPlane: s32, nAttributes: u32, piAttributes: *s32, piValues: *s32) -> win32.BOOL #foreign;
	wglGetPixelFormatAttribfvARB : (hdc: win32.HDC, iPixelFormat: s32, iLayerPlane: s32, nAttributes: u32, piAttributes: *s32, pfValues: *float) -> win32.BOOL #foreign;
	wglChoosePixelFormatARB : (hdc: win32.HDC, piAttribIList: *s32, pfAttribFList: *float, nMaxFormats: u32, piFormats: *s32, nNumFormats: *u32) -> win32.BOOL #foreign;
	
	// WGL_ARB_pixel_format_float
	
	// WGL_ARB_render_texture
	// wglBindTexImageARB : (hPbuffer: HPBUFFERARB, iBuffer: s32) -> win32.BOOL #foreign;
	// wglReleaseTexImageARB : (hPbuffer: HPBUFFERARB, iBuffer: s32) -> win32.BOOL #foreign;
	// wglSetPbufferAttribARB : (hPbuffer: HPBUFFERARB, piAttribList: *s32) -> win32.BOOL #foreign;
	
	// WGL_ARB_robustness_application_isolation
	
	// WGL_ARB_robustness_share_group_isolation
	
	// WGL_ATI_pixel_format_float
	
	// WGL_EXT_colorspace
	
	// WGL_EXT_create_context_es2_profile
	
	// WGL_EXT_create_context_es_profile
	
	// WGL_EXT_depth_float
	
	// WGL_EXT_display_color_table
	wglCreateDisplayColorTableEXT : (id: GLushort) -> GLboolean #foreign;
	wglLoadDisplayColorTableEXT : (table: *GLushort, length: GLuint) -> GLboolean #foreign;
	wglBindDisplayColorTableEXT : (id: GLushort) -> GLboolean #foreign;
	wglDestroyDisplayColorTableEXT : (id: GLushort) -> void #foreign;
	
	// WGL_EXT_extensions_string
	wglGetExtensionsStringEXT : () -> *u8 #foreign;
	
	// WGL_EXT_framebuffer_sRGB
	
	// WGL_EXT_make_current_read
	wglMakeContextCurrentEXT : (hDrawDC: win32.HDC, hReadDC: win32.HDC, hglrc: win32.HGLRC) -> win32.BOOL #foreign;
	wglGetCurrentReadDCEXT : () -> win32.HDC #foreign;
	
	// WGL_EXT_multisample
	
	// WGL_EXT_pbuffer
	// wglCreatePbufferEXT : (hDC: win32.HDC, iPixelFormat: s32, iWidth: s32, iHeight: s32, piAttribList: *s32) -> HPBUFFEREXT #foreign;
	// wglGetPbufferDCEXT : (hPbuffer: HPBUFFEREXT) -> win32.HDC #foreign;
	// wglReleasePbufferDCEXT : (hPbuffer: HPBUFFEREXT, hDC: win32.HDC) -> s32 #foreign;
	// wglDestroyPbufferEXT : (hPbuffer: HPBUFFEREXT) -> win32.BOOL #foreign;
	// wglQueryPbufferEXT : (hPbuffer: HPBUFFEREXT, iAttribute: s32, piValue: *s32) -> win32.BOOL #foreign;
	
	// WGL_EXT_pixel_format
	wglGetPixelFormatAttribivEXT : (hdc: win32.HDC, iPixelFormat: s32, iLayerPlane: s32, nAttributes: u32, piAttributes: *s32, piValues: *s32) -> win32.BOOL #foreign;
	wglGetPixelFormatAttribfvEXT : (hdc: win32.HDC, iPixelFormat: s32, iLayerPlane: s32, nAttributes: u32, piAttributes: *s32, pfValues: *float) -> win32.BOOL #foreign;
	wglChoosePixelFormatEXT : (hdc: win32.HDC, piAttribIList: *s32, pfAttribFList: *float, nMaxFormats: u32, piFormats: *s32, nNumFormats: *u32) -> win32.BOOL #foreign;
	
	// WGL_EXT_pixel_format_packed_float
	
	// WGL_EXT_swap_control
	wglSwapIntervalEXT : (interval: s32) -> win32.BOOL #foreign;
	wglGetSwapIntervalEXT : () -> s32 #foreign;
	
	// WGL_EXT_swap_control_tear
	
	// WGL_I3D_digital_video_control
	wglGetDigitalVideoParametersI3D : (hDC: win32.HDC, iAttribute: s32, piValue: *s32) -> win32.BOOL #foreign;
	wglSetDigitalVideoParametersI3D : (hDC: win32.HDC, iAttribute: s32, piValue: *s32) -> win32.BOOL #foreign;
	
	// WGL_I3D_gamma
	wglGetGammaTableParametersI3D : (hDC: win32.HDC, iAttribute: s32, piValue: *s32) -> win32.BOOL #foreign;
	wglSetGammaTableParametersI3D : (hDC: win32.HDC, iAttribute: s32, piValue: *s32) -> win32.BOOL #foreign;
	wglGetGammaTableI3D : (hDC: win32.HDC, iEntries: s32, puRed: *u16, puGreen: *u16, puBlue: *u16) -> win32.BOOL #foreign;
	wglSetGammaTableI3D : (hDC: win32.HDC, iEntries: s32, puRed: *u16, puGreen: *u16, puBlue: *u16) -> win32.BOOL #foreign;
	
	// WGL_I3D_genlock
	wglEnableGenlockI3D : (hDC: win32.HDC) -> win32.BOOL #foreign;
	wglDisableGenlockI3D : (hDC: win32.HDC) -> win32.BOOL #foreign;
	wglIsEnabledGenlockI3D : (hDC: win32.HDC, pFlag: *win32.BOOL) -> win32.BOOL #foreign;
	wglGenlockSourceI3D : (hDC: win32.HDC, uSource: u32) -> win32.BOOL #foreign;
	wglGetGenlockSourceI3D : (hDC: win32.HDC, uSource: *u32) -> win32.BOOL #foreign;
	wglGenlockSourceEdgeI3D : (hDC: win32.HDC, uEdge: u32) -> win32.BOOL #foreign;
	wglGetGenlockSourceEdgeI3D : (hDC: win32.HDC, uEdge: *u32) -> win32.BOOL #foreign;
	wglGenlockSampleRateI3D : (hDC: win32.HDC, uRate: u32) -> win32.BOOL #foreign;
	wglGetGenlockSampleRateI3D : (hDC: win32.HDC, uRate: *u32) -> win32.BOOL #foreign;
	wglGenlockSourceDelayI3D : (hDC: win32.HDC, uDelay: u32) -> win32.BOOL #foreign;
	wglGetGenlockSourceDelayI3D : (hDC: win32.HDC, uDelay: *u32) -> win32.BOOL #foreign;
	wglQueryGenlockMaxSourceDelayI3D : (hDC: win32.HDC, uMaxLineDelay: *u32, uMaxPixelDelay: *u32) -> win32.BOOL #foreign;
	
	// WGL_I3D_image_buffer
	wglCreateImageBufferI3D : (hDC: win32.HDC, dwSize: u32, uFlags: u32) -> *void #foreign;
	wglDestroyImageBufferI3D : (hDC: win32.HDC, pAddress: *void) -> win32.BOOL #foreign;
	wglAssociateImageBufferEventsI3D : (hDC: win32.HDC, pEvent: *win32.HANDLE, pAddress: **void, pSize: *u32, count: u32) -> win32.BOOL #foreign;
	wglReleaseImageBufferEventsI3D : (hDC: win32.HDC, pAddress: **void, count: u32) -> win32.BOOL #foreign;
	
	// WGL_I3D_swap_frame_lock
	wglEnableFrameLockI3D : () -> win32.BOOL #foreign;
	wglDisableFrameLockI3D : () -> win32.BOOL #foreign;
	wglIsEnabledFrameLockI3D : (pFlag: *win32.BOOL) -> win32.BOOL #foreign;
	wglQueryFrameLockMasterI3D : (pFlag: *win32.BOOL) -> win32.BOOL #foreign;
	
	// WGL_I3D_swap_frame_usage
	wglGetFrameUsageI3D : (pUsage: *float) -> win32.BOOL #foreign;
	wglBeginFrameTrackingI3D : () -> win32.BOOL #foreign;
	wglEndFrameTrackingI3D : () -> win32.BOOL #foreign;
	wglQueryFrameTrackingI3D : (pFrameCount: *u32, pMissedFrames: *u32, pLastMissedUsage: *float) -> win32.BOOL #foreign;
	
	// WGL_NV_DX_interop
	wglDXSetResourceShareHandleNV : (dxObject: *void, shareHandle: win32.HANDLE) -> win32.BOOL #foreign;
	wglDXOpenDeviceNV : (dxDevice: *void) -> win32.HANDLE #foreign;
	wglDXCloseDeviceNV : (hDevice: win32.HANDLE) -> win32.BOOL #foreign;
	wglDXRegisterObjectNV : (hDevice: win32.HANDLE, dxObject: *void, name: GLuint, type: GLenum, access: GLenum) -> win32.HANDLE #foreign;
	wglDXUnregisterObjectNV : (hDevice: win32.HANDLE, hObject: win32.HANDLE) -> win32.BOOL #foreign;
	wglDXObjectAccessNV : (hObject: win32.HANDLE, access: GLenum) -> win32.BOOL #foreign;
	wglDXLockObjectsNV : (hDevice: win32.HANDLE, count: GLint, hObjects: *win32.HANDLE) -> win32.BOOL #foreign;
	wglDXUnlockObjectsNV : (hDevice: win32.HANDLE, count: GLint, hObjects: *win32.HANDLE) -> win32.BOOL #foreign;
	
	// WGL_NV_DX_interop2
	
	// WGL_NV_copy_image
	wglCopyImageSubDataNV : (hSrcRC: win32.HGLRC, srcName: GLuint, srcTarget: GLenum, srcLevel: GLint, srcX: GLint, srcY: GLint, srcZ: GLint, hDstRC: win32.HGLRC, dstName: GLuint, dstTarget: GLenum, dstLevel: GLint, dstX: GLint, dstY: GLint, dstZ: GLint, width: GLsizei, height: GLsizei, depth: GLsizei) -> win32.BOOL #foreign;
	
	// WGL_NV_delay_before_swap
	wglDelayBeforeSwapNV : (hDC: win32.HDC, seconds: GLfloat) -> win32.BOOL #foreign;
	
	// WGL_NV_float_buffer
	
	// WGL_NV_gpu_affinity
	// wglEnumGpusNV : (iGpuIndex: u32, phGpu: *HGPUNV) -> win32.BOOL #foreign;
	// wglEnumGpuDevicesNV : (hGpu: HGPUNV, iDeviceIndex: u32, lpGpuDevice: PGPU_DEVICE) -> win32.BOOL #foreign;
	// wglCreateAffinityDCNV : (phGpuList: *HGPUNV) -> win32.HDC #foreign;
	// wglEnumGpusFromAffinityDCNV : (hAffinityDC: win32.HDC, iGpuIndex: u32, hGpu: *HGPUNV) -> win32.BOOL #foreign;
	wglDeleteDCNV : (hdc: win32.HDC) -> win32.BOOL #foreign;
	
	// WGL_NV_multisample_coverage
	
	// WGL_NV_present_video
	// wglEnumerateVideoDevicesNV : (hDC: win32.HDC, phDeviceList: *HVIDEOOUTPUTDEVICENV) -> s32 #foreign;
	// wglBindVideoDeviceNV : (hDC: win32.HDC, uVideoSlot: s32, hVideoDevice: HVIDEOOUTPUTDEVICENV, piAttribList: *s32) -> win32.BOOL #foreign;
	wglQueryCurrentContextNV : (iAttribute: s32, piValue: *s32) -> win32.BOOL #foreign;
	
	// WGL_NV_render_depth_texture
	
	// WGL_NV_render_texture_rectangle
	
	// WGL_NV_swap_group
	wglJoinSwapGroupNV : (hDC: win32.HDC, group: GLuint) -> win32.BOOL #foreign;
	wglBindSwapBarrierNV : (group: GLuint, barrier: GLuint) -> win32.BOOL #foreign;
	wglQuerySwapGroupNV : (hDC: win32.HDC, group: *GLuint, barrier: *GLuint) -> win32.BOOL #foreign;
	wglQueryMaxSwapGroupsNV : (hDC: win32.HDC, maxGroups: *GLuint, maxBarriers: *GLuint) -> win32.BOOL #foreign;
	wglQueryFrameCountNV : (hDC: win32.HDC, count: *GLuint) -> win32.BOOL #foreign;
	wglResetFrameCountNV : (hDC: win32.HDC) -> win32.BOOL #foreign;
	
	// WGL_NV_vertex_array_range
	wglAllocateMemoryNV : (size: GLsizei, readfreq: GLfloat, writefreq: GLfloat, priority: GLfloat) #foreign;
	wglFreeMemoryNV : (pointer: *void) #foreign;
	
	// WGL_NV_video_capture
	// wglBindVideoCaptureDeviceNV : (uVideoSlot: u32, hDevice: HVIDEOINPUTDEVICENV) -> win32.BOOL #foreign;
	// wglEnumerateVideoCaptureDevicesNV : (hDc: win32.HDC, phDeviceList: *HVIDEOINPUTDEVICENV) -> u32 #foreign;
	// wglLockVideoCaptureDeviceNV : (hDc: win32.HDC, hDevice: HVIDEOINPUTDEVICENV) -> win32.BOOL #foreign;
	// wglQueryVideoCaptureDeviceNV : (hDc: win32.HDC, hDevice: HVIDEOINPUTDEVICENV, iAttribute: s32, piValue: *s32) -> win32.BOOL #foreign;
	// wglReleaseVideoCaptureDeviceNV : (hDc: win32.HDC, hDevice: HVIDEOINPUTDEVICENV) -> win32.BOOL #foreign;
	
	// WGL_NV_video_output
	// wglGetVideoDeviceNV : (hDC: win32.HDC, numDevices: s32, hVideoDevice: *HPVIDEODEV) -> win32.BOOL #foreign;
	// wglReleaseVideoDeviceNV : (hVideoDevice: HPVIDEODEV) -> win32.BOOL #foreign;
	// wglBindVideoImageNV : (hVideoDevice: HPVIDEODEV, hPbuffer: HPBUFFERARB, iVideoBuffer: s32) -> win32.BOOL #foreign;
	// wglReleaseVideoImageNV : (hPbuffer: HPBUFFERARB, iVideoBuffer: s32) -> win32.BOOL #foreign;
	// wglSendPbufferToVideoNV : (hPbuffer: HPBUFFERARB, iBufferType: s32, pulCounterPbuffer: *long, bBlock: win32.BOOL) -> win32.BOOL #foreign;
	// wglGetVideoInfoNV : (hpVideoDevice: HPVIDEODEV, pulCounterOutputPbuffer: *long, pulCounterOutputVideo: *long) -> win32.BOOL #foreign;
	
	// WGL_OML_sync_control
	wglGetSyncValuesOML : (hdc: win32.HDC, ust: *s64, msc: *s64, sbc: *s64) -> win32.BOOL #foreign;
	wglGetMscRateOML : (hdc: win32.HDC, numerator: *s32, denominator: *s32) -> win32.BOOL #foreign;
	wglSwapBuffersMscOML : (hdc: win32.HDC, target_msc: s64, divisor: s64, remainder: s64) -> s64 #foreign;
	wglSwapLayerBuffersMscOML : (hdc: win32.HDC, fuPlanes: s32, target_msc: s64, divisor: s64, remainder: s64) -> s64 #foreign;
	wglWaitForMscOML : (hdc: win32.HDC, target_msc: s64, divisor: s64, remainder: s64, ust: *s64, msc: *s64, sbc: *s64) -> win32.BOOL #foreign;
	wglWaitForSbcOML : (hdc: win32.HDC, target_sbc: s64, ust: *s64, msc: *s64, sbc: *s64) -> win32.BOOL #foreign;
}
