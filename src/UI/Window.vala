namespace Sudoku.UI
{

class Window : Gtk.ApplicationWindow
{
	public Window (Gtk.Application application)
	{
		Object
			( application: application
			);

		Gtk.HeaderBar header_bar = new Gtk.HeaderBar ();
		Gtk.Box box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		Gtk.MenuButton menu_button = new Gtk.MenuButton ();
		Gtk.Image image = new Gtk.Image.from_icon_name ("emblem-system-symbolic", Gtk.IconSize.BUTTON);
		UI.Commands commands = new UI.Commands (this.application, this);
		UI.Puzzle puzzle = new UI.Puzzle (new Sudoku.Puzzle ());

		menu_button.add (image);
		menu_button.set_popup (commands);

		header_bar.title = "Sudoku";
		header_bar.subtitle = "Artificial Intelligence";
		header_bar.show_close_button = true;
		header_bar.pack_end (menu_button);

		box.halign = Gtk.Align.CENTER;
		box.valign = Gtk.Align.CENTER;
		box.add (puzzle);

		this.set_titlebar (header_bar);
		this.add (box);
	}
}

}
