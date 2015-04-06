namespace Sudoku.UI
{

class Application : Gtk.Application
{
	public Application ()
	{
		Object
			( application_id: "is.system.sudoku"
			, flags:          ApplicationFlags.FLAGS_NONE
			);
	}

	protected override void activate ()
	{
		Window window = new Window (this);
		window.show_all ();
	}
}

}
