namespace Sudoku.UI
{

class Window : Gtk.ApplicationWindow
{
	private Gtk.AspectFrame frame;
	private Gtk.HeaderBar header_bar;

	public Sudoku.Puzzle active_puzzle { get; set; }

	public Window (Gtk.Application application, Sudoku.Puzzle puzzle)
	{
		Object
			( application: application
			);

		Gtk.MenuButton menu_button = new Gtk.MenuButton ();
		Gtk.Image image = new Gtk.Image.from_icon_name ("emblem-system-symbolic", Gtk.IconSize.BUTTON);
		Gtk.Box box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		UI.Commands commands = new UI.Commands (this.application, this);

		commands.new_game.connect (on_new_game);
		commands.solve.connect (on_solve);
		commands.clear.connect (on_clear);

		this.header_bar = new Gtk.HeaderBar ();
		this.frame = new Gtk.AspectFrame (null, 0.5f, 0.5f, 1.0f, false);
		this.frame.expand = true;
		this.notify.connect (this.on_notify);
		this.active_puzzle = puzzle;

		menu_button.add (image);
		menu_button.set_popup (commands);

		header_bar.title = "Sudoku";
		header_bar.show_close_button = true;
		header_bar.pack_end (menu_button);

		box.add (this.frame);

		this.set_titlebar (header_bar);
		this.add (box);
	}

	private string friendly_difficulty (string difficulty)
	{
		switch (difficulty)
		{
			case "easy":
				return "Easy Difficulty";
			case "normal":
				return "Normal Difficulty";
			case "hard":
				return "Hard Difficulty";
			case "very-hard":
				return "Very Hard Difficulty";
		}

		return "";
	}

	private void on_new_game (int magnitude, string difficulty)
	{
		this.active_puzzle = new Sudoku.Puzzle.with_magnitude_and_difficulty (magnitude, difficulty);
	}

	private void on_solve ()
	{
		bool solution = this.active_puzzle.solve ();

		if ( ! solution)
		{
			Gtk.Dialog dialog = new Gtk.MessageDialog
				( this
				, Gtk.DialogFlags.DESTROY_WITH_PARENT
				, Gtk.MessageType.ERROR
				, Gtk.ButtonsType.CLOSE
				, "No valid solution."
				);

			dialog.run ();
			dialog.destroy ();
		}
	}

	private void on_clear ()
	{
		this.active_puzzle.clear ();
	}

	private void on_notify (ParamSpec ps)
	{
		switch (ps.name)
		{
			case "active-puzzle":
				this.frame.@foreach ((widget) => {
					this.frame.remove (widget);
				});

				this.frame.add (new UI.Puzzle (this.active_puzzle));
				this.frame.show_all ();

				this.header_bar.subtitle = friendly_difficulty (this.active_puzzle.difficulty);

				break;
		}
	}
}

}
