namespace Sudoku.UI
{

class Tile : Gtk.Box
{
	public int value { get; set; }

	public Tile ()
	{
		this.with_value (-1);
	}

	public Tile.with_value (int value)
	{
		Object
			( orientation: Gtk.Orientation.VERTICAL
			);

		this.value = value;
	}

	construct
	{
		Gtk.Entry entry = new Gtk.Entry ();

		entry.input_purpose = Gtk.InputPurpose.DIGITS;
		entry.max_length = 1;
		entry.width_chars = 1;

		entry.set_size_request (48, 48);

		this.add (entry);
	}
}

}
