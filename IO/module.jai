#scope_module

#import "Runtime";
fs :: #import "File_System";

#scope_export

#load "file_stream.jai";

Stream :: struct
{
	// @Note (stefan): We don't have an Open_Proc because this is
	// a procedure that is not called on a general Stream. You'd
	// instead call an open_file procedure that can take any
	// arguments for example.
	Close_Proc :: #type (*Stream) -> Error;
	Write_Proc :: #type (*Stream, *void, s64) -> s64, Error;
	Read_Proc  :: #type (*Stream, *void, s64) -> s64, Error;
	Flush_Proc :: #type (*Stream) -> Error;
	Seek_Proc  :: #type (*Stream, s64, Seek_From) -> s64, Error;
	Size_Proc  :: #type (*Stream) -> s64, Error;

	Procs :: struct
	{
		close : Close_Proc;
		write : Write_Proc;
		read  : Read_Proc;
		flush : Flush_Proc;
		seek  : Seek_Proc;
		size  : Size_Proc;
	}

	using procs : Procs;
	data : *void;
}

Seek_From :: enum
{
	BEGIN   :: 0;
	CURRENT :: 1;
	END     :: 2;
}

Error :: enum
{
	OK :: 0;

	EOI :: 1;
	EOF :: EOI;

	NOT_IMPLEMENTED;
	UNKNOWN :: 1001;
}

to_error :: inline (err : fs.Error) -> Error #must
{
	if err ==
	{
	case .OK;
		return .OK;
	}
	return .UNKNOWN;
}

close :: inline (s : *Stream) -> Error
{
	if s.close
		return s.close (s);
	return .NOT_IMPLEMENTED;
}

write :: inline (s : *Stream, buff : *void, size : s64) -> bytes_written : s64, Error
{
	if s.write
	{
		bytes_written, err := s.write (s, buff, size);
		return bytes_written, err;
	}
	return 0, .NOT_IMPLEMENTED;
}

read :: inline (s : *Stream, buff : *void, size : s64) -> bytes_read : s64, Error
{
	if s.read
	{
		bytes_read, err := s.read (s, buff, size);
		return bytes_read, err;
	}
	return 0, .NOT_IMPLEMENTED;
}

flush :: inline (s : *Stream) -> Error
{
	if s.flush
		return s.flush (s);
	return .NOT_IMPLEMENTED;
}

seek :: inline (s : *Stream, offset : s64, from : Seek_From) -> new_offset : s64, Error
{
	if s.seek
	{
		res, err := s.seek (s, offset, from);
		return res, err;
	}
	return 0, .NOT_IMPLEMENTED;
}

size :: inline (s : *Stream) -> s64, Error
{
	if s.size
	{
		res, err := s.size (s);
		return res, err;
	}
	return 0, .NOT_IMPLEMENTED;
}

get_cursor :: inline (s : *Stream) -> s64, Error
{
	cursor, err := seek (s, 0, .CURRENT);
	return cursor, err;
}
