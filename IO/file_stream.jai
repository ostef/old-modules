File_Open_Flags :: os.File_Open_Flags;

make_stream :: inline (file : os.File) -> Stream #must
{
	result : Stream;
	result.data = file;
	result.close = close_file;
	result.write = write_file;
	result.read  = read_file;
	result.flush = flush_file;
	result.seek  = seek_file;
	result.size  = get_file_size;
	return result;
}

open_file :: inline (filename : string, flags : File_Open_Flags) -> Stream #must, os.Error
{
	file, err := os.open (filename, flags);
	return make_stream (file), err;
}

close_file :: inline (using stream : *Stream) -> Error
{
	return error_from_os (os.close (data));
}

write_file :: inline (stream : *Stream, data : *void, size : s64) -> written : s64, Error
{
	written, err := os.write (stream.data, data, size);
	return written, error_from_os (err);
}

read_file :: inline (stream : *Stream, data : *void, size : s64) -> read : s64, Error
{
	read, err := os.read (stream.data, data, size);
	return read, error_from_os (err);
}

flush_file :: inline (using stream : *Stream) -> Error
{
	return error_from_os (os.flush (data));
}

seek_file :: inline (using stream : *Stream, offset : s64, from : Seek_From) -> new_offset : s64, Error
{
	new_offset, err := os.seek (data, offset, from);
	return new_offset, error_from_os (err);
}

get_file_size :: inline (stream : *Stream) -> s64, Error
{
	size, err := os.get_file_size (stream.data);
	return size, error_from_os (err);
}
