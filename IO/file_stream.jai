make_stream :: inline (file : fs.File) -> Stream #must
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

open_file :: inline (filename : string, flags : fs.File_Open_Flags) -> Stream #must, fs.Error
{
	file, err := fs.open (filename, flags);
	return make_stream (file), err;
}

close_file :: inline (using stream : *Stream) -> Error
{
	return to_error (fs.close (data));
}

write_file :: inline (stream : *Stream, data : *void, size : s64) -> written : s64, Error
{
	written, err := fs.write (stream.data, data, size);
	return written, to_error (err);
}

read_file :: inline (stream : *Stream, data : *void, size : s64) -> read : s64, Error
{
	read, err := fs.read (stream.data, data, size);
	return read, to_error (err);
}

flush_file :: inline (using stream : *Stream) -> Error
{
	return to_error (fs.flush (data));
}

seek_file :: inline (using stream : *Stream, offset : s64, from : Seek_From) -> new_offset : s64, Error
{
	new_offset, err := fs.seek (data, offset, from);
	return new_offset, to_error (err);
}

get_file_size :: inline (stream : *Stream) -> s64, Error
{
	size, err := fs.get_file_size (stream.data);
	return size, to_error (err);
}
