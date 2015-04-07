namespace Sudoku.UI
{

class Puzzle : Gtk.DrawingArea
{
	private Sudoku.Puzzle puzzle;
	private Gdk.Point active_tile;

	private string[] alphabet =
		{ ""
		, "1"
		, "1234"
		, "123456789"
		, "0123456789ABCDEF"
		, "0123456789ABCDEFGHIJKLMNO"
		, "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		};

	public Puzzle (Sudoku.Puzzle puzzle)
	{
		Object ();

		this.puzzle = puzzle;
		this.active_tile = { -1, -1 };

		this.set_events
			( Gdk.EventMask.BUTTON_PRESS_MASK
			| Gdk.EventMask.KEY_PRESS_MASK
			);

		this.can_focus = true;
		this.set_size_request (600, 600);

		this.button_press_event.connect (on_button_press_event);
		this.key_press_event.connect (on_key_press_event);
		this.draw.connect (on_draw);
	}

	private void redraw ()
	{
		this.queue_draw_area (0, 0, this.get_drawing_size (), this.get_drawing_size ());
	}

	private string get_character (int num)
	{
		return this.alphabet[this.puzzle.magnitude][num].to_string ();
	}

	private int get_drawing_size ()
	{
		return int.min
			( this.get_allocated_width ()
			, this.get_allocated_height ()
			);
	}

	private int get_number (char character)
	{
		string alpha = this.alphabet[this.puzzle.magnitude];

		for (int i = 0; i < alpha.length; ++i)
		{
			if (alpha[i] == character)
				return i;
		}

		return -1;
	}

	private bool on_button_press_event (Gdk.EventButton ev)
	{
		this.grab_focus ();

		int num_tiles = this.puzzle.magnitude * this.puzzle.magnitude;
		Gdk.Point tile = { };

		tile.x = (int) ev.x * num_tiles / this.get_drawing_size ();
		tile.y = (int) ev.y * num_tiles / this.get_drawing_size ();

		if
			(  tile.x >= num_tiles
			|| tile.y >= num_tiles
			)
			return true;

		if (this.puzzle.is_fixed (tile.x, tile.y))
			return true;

		this.active_tile = tile;
		this.redraw ();

		return true;
	}

	private bool on_key_press_event (Gdk.EventKey ev)
	{
		if (this.active_tile.x == -1 || this.active_tile.y == -1)
			return true;

		switch (ev.keyval)
		{
			case Gdk.Key.BackSpace:
			case Gdk.Key.Delete:
				this.puzzle.set_at (this.active_tile.x, this.active_tile.y, -1);
				this.active_tile = { -1, -1 };
				this.redraw ();
				break;
			default:
				if (ev.keyval >= 0x80)
					return true;

				char chr = ((char) ev.keyval).toupper ();
				int num = get_number (chr);

				if (num == -1)
					return true;

				this.puzzle.set_at (this.active_tile.x, this.active_tile.y, num);
				this.active_tile = { -1, -1 };
				this.redraw ();
				break;
		}

		return true;
	}

	private bool on_draw (Gtk.Widget da, Cairo.Context ctx)
	{
		int num_tiles = this.puzzle.magnitude * this.puzzle.magnitude;

		ctx.scale (this.get_drawing_size (), this.get_drawing_size ());
		ctx.scale (1.0 / num_tiles, 1.0 / num_tiles);
		ctx.set_line_width (1.5 * (double) num_tiles / this.get_drawing_size ());

		ctx.set_source_rgb (1.0, 1.0, 1.0);
		ctx.rectangle (0, 0, num_tiles, num_tiles);
		ctx.fill ();

		for (int i = 0; i < num_tiles; ++i)
		{
			for (int j = 0; j < num_tiles; ++j)
			{
				Cairo.TextExtents te;

				ctx.save ();
				ctx.translate (i, j);

				/* render active background */
				if (i == this.active_tile.x && j == this.active_tile.y)
				{
					ctx.set_source_rgb (0.46, 0.61, 0.80);
					ctx.rectangle (0, 0, 1, 1);
					ctx.fill ();
				}

				/* render fixed background */
				if (this.puzzle.is_fixed (i, j))
				{
					ctx.set_source_rgb (0.8, 0.8, 0.8);
					ctx.rectangle (0, 0, 1, 1);
					ctx.fill ();
				}

				/* render text */
				int num = this.puzzle.get_at (i, j);

				if (num != -1)
				{
					string str = this.get_character (num);

					ctx.set_source_rgb (0.0, 0.0, 0.0);
					ctx.set_font_size (0.5);
					ctx.text_extents (str, out te);
					ctx.move_to
						( 0.5 - te.x_bearing - te.width / 2
						, 0.5 - te.y_bearing - te.height / 2
						);
					ctx.show_text (str);
					ctx.fill ();
				}

				ctx.restore ();
			}
		}

		/* render thin lines */
		for (int i = 0; i <= num_tiles; ++i)
		{
			if (i % this.puzzle.magnitude == 0)
				continue;

			ctx.set_source_rgb (0.5, 0.5, 0.5);

			ctx.move_to (0, i);
			ctx.line_to (num_tiles, i);

			ctx.move_to (i, 0);
			ctx.line_to (i, num_tiles);
		}

		ctx.stroke ();

		/* render thick lines */
		for (int i = 0; i <= num_tiles; i += this.puzzle.magnitude)
		{
			ctx.set_source_rgb (0.0, 0.0, 0.0);

			ctx.move_to (0, i);
			ctx.line_to (num_tiles, i);

			ctx.move_to (i, 0);
			ctx.line_to (i, num_tiles);
		}

		ctx.stroke ();

		return true;
	}
}

}
