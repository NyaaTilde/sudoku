namespace Sudoku.UI
{

class Window : Gtk.ApplicationWindow
{
	private Gtk.Box box;

	public Sudoku.Puzzle active_puzzle { get; set; }

	public Window (Gtk.Application application, Sudoku.Puzzle puzzle)
	{
		Object
			( application: application
			);

		Gtk.HeaderBar header_bar = new Gtk.HeaderBar ();
		Gtk.MenuButton menu_button = new Gtk.MenuButton ();
		Gtk.Image image = new Gtk.Image.from_icon_name ("emblem-system-symbolic", Gtk.IconSize.BUTTON);
		UI.Commands commands = new UI.Commands (this.application, this);

		this.box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		this.notify.connect (this.on_notify);
		this.active_puzzle = puzzle;

		menu_button.add (image);
		menu_button.set_popup (commands);

		header_bar.title = "Sudoku";
		header_bar.subtitle = "Artificial Intelligence";
		header_bar.show_close_button = true;
		header_bar.pack_end (menu_button);

		this.box.halign = Gtk.Align.CENTER;
		this.box.valign = Gtk.Align.CENTER;

		this.set_titlebar (header_bar);
		this.add (box);
	}

	private void on_notify (ParamSpec ps)
	{
		switch (ps.name)
		{
			case "active-puzzle":
				this.box.@foreach ((widget) => {
					this.box.remove (widget);
				});

				this.box.add (new UI.Puzzle (this.active_puzzle));
				break;
		}
	}
}

}
