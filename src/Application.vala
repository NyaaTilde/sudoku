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

		this.window.show_all ();
	}
}

}
