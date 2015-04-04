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
		Gtk.MenuButton menu_button = new Gtk.MenuButton ();
		Gtk.Image image = new Gtk.Image.from_icon_name ("emblem-system-symbolic", Gtk.IconSize.BUTTON);
		Gtk.Menu menu = new Gtk.Menu ();
		Gtk.MenuItem menu_item_about = new Gtk.MenuItem.with_mnemonic ("_About");
		Gtk.MenuItem menu_item_quit = new Gtk.MenuItem.with_label ("Quit");

		menu_item_quit.activate.connect (() => {
			this.quit ();
		});

		menu_item_about.activate.connect (() => {
			AboutDialog dialog = new AboutDialog (this.window);
			dialog.present ();
		});

		menu.add (menu_item_about);
		menu.add (new Gtk.SeparatorMenuItem ());
		menu.add (menu_item_quit);
		menu.show_all ();

		menu_button.add (image);
		menu_button.set_popup (menu);

		header_bar.title = "Sudoku";
		header_bar.subtitle = "Artificial Intelligence";
		header_bar.show_close_button = true;
		header_bar.pack_end (menu_button);

		this.window.set_default_size (800, 600);
		this.window.set_titlebar (header_bar);
		this.window.add (box);

		this.window.show_all ();
	}
}

}
