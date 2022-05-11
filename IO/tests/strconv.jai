#import "Runtime";
fmt :: #import "Fmt";
fs  :: #import "File_System";
io  :: #import "IO";

main :: ()
{
	s, err := io.open_file ("data/strconv.txt", .ACCESS_READ);
	assert (err == .OK, "Could not open file: %", fs.get_last_error_string ());
	{
		f, n, conv_err, stream_err := io.parse_f64 (*s);
		assert (n > 0, "Could not parse f64: %, %.", conv_err, stream_err);
		fmt.println (f);
	}
	io.seek (*s, 1, .CURRENT);
	{
		b, n, conv_err, stream_err := io.parse_bool (*s);
		assert (n > 0, "Could not parse bool: %, %.", conv_err, stream_err);
		fmt.println (b);
	}
	io.seek (*s, 1, .CURRENT);
	{
		b, n, conv_err, stream_err := io.parse_bool (*s);
		assert (n > 0, "Could not parse bool: %, %.", conv_err, stream_err);
		fmt.println (b);
	}
	io.seek (*s, 1, .CURRENT);
	{
		val, n, conv_err, stream_err := io.parse_s64 (*s);
		assert (n > 0, "Could not parse s64: %, %.", conv_err, stream_err);
		fmt.println (val);
	}
}
