namespace Sudoku.UI
{

class AboutDialog : Gtk.AboutDialog
{
	public AboutDialog (Gtk.Window parent)
	{
		Object
			( modal: true
			, transient_for: parent
			);
	}

	construct
	{
		const string[] authors =
			{ "Gabríel Arthúr Pétursson <gabriel@system.is>"
			, "Ingibergur Sindri Stefnisson <ingibergur13@ru.is>"
			, "Kristján Árni Gerhardsson <fluffy@fluffy.is>"
			, null
			};

		this.authors = authors;
		this.program_name = "Sudoku";
		this.copyright = "Copyright © 2015 Gabríel, Kristján, Ingibergur";
		this.license_type = Gtk.License.GPL_3_0;
	}
}

}
