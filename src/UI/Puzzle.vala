namespace Sudoku.UI
{

class Puzzle : Gtk.Grid
{
	private Sudoku.Puzzle puzzle;

	public Puzzle (Sudoku.Puzzle puzzle)
	{
		Object
			( column_spacing: 8
			, row_spacing: 8
			);

		this.puzzle = puzzle;

		/* for each box row */
		for (int i = 0; i < this.puzzle.magnitude; ++i)
		{
			for (int j = 0; j < this.puzzle.magnitude; ++j)
			{
				Gtk.Grid subgrid = new Gtk.Grid ();

				subgrid.column_spacing = 4;
				subgrid.row_spacing = 4;

				/* for each row in box */
				for (int k = 0; k < this.puzzle.magnitude; ++k)
				{
					/* for each column in box */
					for (int l = 0; l < this.puzzle.magnitude; ++l)
					{
						subgrid.attach (new Tile (), k, l, 1, 1);
					}
				}

				this.attach (subgrid, i, j, 1, 1);
			}
		}
	}
}

}
