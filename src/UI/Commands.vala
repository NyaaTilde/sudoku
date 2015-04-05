namespace Sudoku.UI
{

class Commands : Gtk.Menu
{
	public Gtk.Application application { get; construct set; }
	public Gtk.Window parent_window { get; construct set; }

	public Commands (Gtk.Application application, Gtk.Window parent_window)
	{
		Object
			( application: application
			, parent_window: parent_window
			);
	}

	construct
	{
		Gtk.MenuItem new_game = new Gtk.MenuItem.with_mnemonic ("_New");
		Gtk.MenuItem about = new Gtk.MenuItem.with_mnemonic ("_About");
		Gtk.MenuItem quit = new Gtk.MenuItem.with_label ("Quit");

		this.add (new_game);
		this.add (about);
		this.add (new Gtk.SeparatorMenuItem ());
		this.add (quit);

		this.show_all ();

		new_game.activate.connect (() => {
			NewGameDialog dialog = new NewGameDialog (this.parent_window);
			dialog.run ();
			dialog.destroy ();
		});

		about.activate.connect (() => {
			AboutDialog dialog = new AboutDialog (this.parent_window);
			dialog.run ();
			dialog.destroy ();
		});

		quit.activate.connect (() => {
			this.application.quit ();
		});
	}
}

}
