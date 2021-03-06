namespace Sudoku.UI
{

class NewGameDialog : Gtk.Dialog
{
	private Gtk.Grid grid;
	private int options;

	public int magnitude { get; private set; }
	public string difficulty { get; private set; }

	public NewGameDialog (Gtk.Window parent)
	{
		Object
			( modal: true
			, transient_for: parent
			, use_header_bar: (int) true
			, modal: true
			);

		this.magnitude = 3;
		this.difficulty = "normal";

		Gtk.Adjustment magnitude_adjustment = new Gtk.Adjustment
			( this.magnitude
			, 3
			, 5
			, 1
			, 0
			, 0
			);
		Gtk.ComboBoxText difficulty_combobox = new Gtk.ComboBoxText ();
		Gtk.Container content_area = this.get_content_area ();
		Gtk.SpinButton magnitude_spinbutton = new Gtk.SpinButton (magnitude_adjustment, 1, 0);

		difficulty_combobox.append ("easy", "Easy");
		difficulty_combobox.append ("normal", "Normal");
		difficulty_combobox.append ("hard", "Hard");
		difficulty_combobox.append ("very-hard", "Very Hard");
		difficulty_combobox.active_id = this.difficulty;

		this.grid = new Gtk.Grid ();

		this.grid.expand = true;
		this.grid.column_spacing = 8;
		this.grid.row_spacing = 8;

		this.add_button ("New Game", Gtk.ResponseType.OK);
		this.add_button ("Cancel", Gtk.ResponseType.CANCEL);

		add_option ("Magnitude", magnitude_spinbutton);
		add_option ("Difficulty", difficulty_combobox);

		content_area.margin = 4;
		content_area.add (grid);
		content_area.show_all ();

		magnitude_spinbutton.value_changed.connect (() => {
			this.magnitude = (int) magnitude_adjustment.value;
		});

		difficulty_combobox.changed.connect (() => {
			this.difficulty = difficulty_combobox.active_id;
		});
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
