namespace Sudoku
{

class Application : Gtk.Application
{
	private Gtk.ApplicationWindow window;

	public Application ()
	{
		Object
			( application_id: "is.system.sudoku"
			, flags:          ApplicationFlags.FLAGS_NONE
			);
	}

	protected override void activate ()
	{
		this.window = new Gtk.ApplicationWindow (this);

		Gtk.HeaderBar header_bar = new Gtk.HeaderBar ();
		Gtk.Box box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

		header_bar.title = "Sudoku";
		header_bar.subtitle = "Artificial Intelligence";
		header_bar.show_close_button = true;

		this.window.set_default_size (800, 600);
		this.window.set_titlebar (header_bar);
		this.window.add (box);

		this.window.show_all ();
	}
}

}
