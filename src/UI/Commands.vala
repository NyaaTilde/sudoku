namespace Sudoku.UI
{

class Commands : Gtk.Menu
{
	public Gtk.Application application { get; construct set; }
	public Gtk.Window parent_window { get; construct set; }

	public signal void new_game (int magnitude, string difficulty);
	public signal void solve ();

	public Commands (Gtk.Application application, Gtk.Window parent_window)
	{
		Object
			( application: application
			, parent_window: parent_window
			);
	}

	construct
	{
		Gtk.MenuItem new_game = new Gtk.MenuItem.with_mnemonic ("_New Game");
		Gtk.MenuItem solve_game = new Gtk.MenuItem.with_label ("Solve");
		Gtk.MenuItem about = new Gtk.MenuItem.with_mnemonic ("_About");
		Gtk.MenuItem quit = new Gtk.MenuItem.with_label ("Quit");

		this.add (new_game);
		this.add (solve_game);
		this.add (new Gtk.SeparatorMenuItem ());
		this.add (about);
		this.add (quit);

		this.show_all ();

		new_game.activate.connect (() => {
			NewGameDialog dialog = new NewGameDialog (this.parent_window);
			int response = dialog.run ();
			dialog.destroy ();

			if (response == Gtk.ResponseType.OK)
			{
				this.new_game (dialog.magnitude, dialog.difficulty);
			}
		});

		solve_game.activate.connect (() => {
			this.solve ();
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
