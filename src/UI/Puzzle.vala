namespace Sudoku.UI
{

class Puzzle : Gtk.DrawingArea
{
	private Sudoku.Puzzle puzzle;
	private int dimension;
	private int tile;

	private Gdk.Point active_tile;

	public Puzzle (Sudoku.Puzzle puzzle)
	{
		Object ();

		this.puzzle = puzzle;
		this.tile = 52;

		dimension
			= this.tile * this.puzzle.magnitude * this.puzzle.magnitude
			+ this.puzzle.magnitude * this.puzzle.magnitude + 1;

		this.set_events (Gdk.EventMask.BUTTON_PRESS_MASK);
		this.set_size_request ((int) dimension, (int) dimension);

		this.button_press_event.connect (on_button_press_event);
		this.draw.connect (on_draw);
	}

	private bool on_button_press_event (Gdk.EventButton ev)
	{
		Gdk.Point tile = { };
		tile.x = (int) ev.x / (this.tile + 1);
		tile.y = (int) ev.y / (this.tile + 1);

		this.active_tile = tile;
		this.queue_draw_area (0, 0, this.dimension, this.dimension);

		return true;
	}

	private bool on_draw (Gtk.Widget da, Cairo.Context ctx)
	{
		int num_tiles = this.puzzle.magnitude * this.puzzle.magnitude;

		ctx.set_line_width (1.0);

		ctx.set_source_rgb (1.0, 1.0, 1.0);
		ctx.rectangle (0, 0, this.dimension, this.dimension);
		ctx.fill ();

		for (int i = 0; i < num_tiles + 1; ++i)
		{
			if (i % this.puzzle.magnitude == 0)
			{
				ctx.set_source_rgb (0.0, 0.0, 0.0);
			}
			else
			{
				ctx.set_source_rgb (0.5, 0.5, 0.5);
			}

			ctx.move_to (0, i * (this.tile + 1));
			ctx.line_to (dimension, i * (this.tile + 1));

			ctx.move_to (i * (this.tile + 1), 0);
			ctx.line_to (i * (this.tile + 1), dimension);

			ctx.stroke ();
		}

		for (int i = 0; i < num_tiles; ++i)
		{
			for (int j = 0; j < num_tiles; ++j)
			{
				string num = this.puzzle.get_at (i, j).to_string ();
				Cairo.TextExtents te;

				ctx.save ();
				ctx.translate
					( i * (this.tile + 1)
					, j * (this.tile + 1)
					);

				/* render background */
				if (i == this.active_tile.x && j == this.active_tile.y)
				{
					ctx.set_source_rgb (0.46, 0.61, 0.80);
					ctx.rectangle (1, 1, this.tile - 1, this.tile - 1);
					ctx.fill ();
				}

				/* render text */
				if (num != "-2")
				{
					ctx.set_source_rgb (0.0, 0.0, 0.0);
					ctx.set_font_size (this.tile / 2.0);
					ctx.text_extents (num, out te);
					ctx.move_to
						( 0.5*this.tile + 0.5 - te.x_bearing - te.width / 2
						, 0.5*this.tile + 0.5 - te.y_bearing - te.height / 2
						);
					ctx.show_text (num);
					ctx.fill ();
				}

				ctx.restore ();
			}
		}

		return true;
	}
}

}
