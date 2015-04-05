namespace Sudoku.UI
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
		Gtk.MenuButton menu_button = new Gtk.MenuButton ();
		Gtk.Image image = new Gtk.Image.from_icon_name ("emblem-system-symbolic", Gtk.IconSize.BUTTON);
		UI.Commands commands = new UI.Commands (this, this.window);
		UI.Puzzle puzzle = new UI.Puzzle (new Sudoku.Puzzle ());

		menu_button.add (image);
		menu_button.set_popup (commands);

		header_bar.title = "Sudoku";
		header_bar.subtitle = "Artificial Intelligence";
		header_bar.show_close_button = true;
		header_bar.pack_end (menu_button);

		box.halign = Gtk.Align.CENTER;
		box.valign = Gtk.Align.CENTER;
		box.expand = true;
		box.add (puzzle);

		this.window.set_default_size (800, 600);
		this.window.set_titlebar (header_bar);
		this.window.add (box);

		this.window.show_all ();
	}
}

}
