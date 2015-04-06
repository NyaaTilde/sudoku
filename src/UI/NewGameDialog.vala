namespace Sudoku.UI
{

class NewGameDialog : Gtk.Dialog
{
	private Gtk.Grid grid;
	private int options;

	public NewGameDialog (Gtk.Window parent)
	{
		Object
			( modal: true
			, transient_for: parent
			, use_header_bar: (int) true
			, modal: true
			);
	}

	construct
	{
		Gtk.Container content_area = this.get_content_area ();
		this.grid = new Gtk.Grid ();

		this.grid.expand = true;
		this.grid.column_spacing = 8;
		this.grid.row_spacing = 8;

		this.add_button ("New Game", Gtk.ResponseType.OK);
		this.add_button ("Cancel", Gtk.ResponseType.CANCEL);

		add_option
			( "Magnitude"
			, new Gtk.SpinButton (new Gtk.Adjustment (3, 3, 6, 1, 0, 0), 1, 0)
			);

		content_area.margin = 4;
		content_area.add (grid);
		content_area.show_all ();
	}

	private void add_option (string str, Gtk.Widget widget)
	{
		Gtk.Label label = new Gtk.Label (str);
		int y = this.options++;

		label.halign = Gtk.Align.END;
		label.expand = true;
		widget.expand = true;

		this.grid.attach (label, 0, y, 1, 1);
		this.grid.attach (widget, 1, y, 1, 1);
	}
}

}
