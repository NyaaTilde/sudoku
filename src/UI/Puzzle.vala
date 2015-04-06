namespace Sudoku.UI
{

class Puzzle : Gtk.DrawingArea
{
	private Sudoku.Puzzle puzzle;
	private int dimension;
	private int tile;

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
		print ("%f, %f\n", ev.x, ev.y);

		return true;
	}

	private bool on_draw (Gtk.Widget da, Cairo.Context ctx)
	{
		ctx.set_line_width (1.0);

		ctx.set_source_rgb (1.0, 1.0, 1.0);
		ctx.rectangle (0, 0, this.dimension, this.dimension);
		ctx.fill ();

		for
			( int i = 0
			; i < this.puzzle.magnitude * this.puzzle.magnitude + 1
			; ++i
			)
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

		return true;
	}
}

}
