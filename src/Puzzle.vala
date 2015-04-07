using Gee;

namespace Sudoku
{

public class Puzzle : Object
{
	public int magnitude { get; construct set; }
	public string difficulty { get; construct set; }
	private bool[] conflicts;
	private bool[] fixed;
	private Board board;

	public signal void changed ();

	public Puzzle ()
	{
		this.with_magnitude (3);
	}

	public Puzzle.with_magnitude (int magnitude)
	{
		this.with_magnitude_and_difficulty (magnitude, "normal");
	}

	public Puzzle.with_magnitude_and_difficulty (int magnitude, string difficulty)
		requires (magnitude > 0 && magnitude < 7)
	{
		this.magnitude = magnitude;
		this.difficulty = difficulty;
		this.conflicts = new bool[magnitude * magnitude * magnitude * magnitude];
		this.fixed = new bool[magnitude * magnitude * magnitude * magnitude];
		this.board = new Board.with_magnitude (magnitude);

		for (size_t i = 0; i < this.conflicts.length; ++i)
		{
			conflicts[i] = false;
			fixed[i] = false;
		}

		Board board = Board.create_unfinished
			( this.magnitude
			, (int) new Rand ().next_int ()
			, num_to_remove (this.difficulty)
			);

		for (int i = 0; i < magnitude * magnitude; ++i)
		{
			for (int j = 0; j < magnitude * magnitude; ++j)
			{
				unowned Cell c = board.get_cell_at (i, j);

				if (c.number != -1)
				{
					this.set_at (i, j, c.number);
					fixed[i * magnitude * magnitude + j] = true;
				}
			}
		}
	}

	/* (0, 0) is at the top-left, with y increasing downwards, unfortunately */
	public int get_at (int x, int y)
		requires (x >= 0 && y < magnitude * magnitude)
		requires (y >= 0 && y < magnitude * magnitude)
	{
		return this.board.get_cell_at (y, x).number;
	}

	public void set_at (int x, int y, int value)
		requires (x >= 0 && x < magnitude * magnitude)
		requires (y >= 0 && y < magnitude * magnitude)
		requires (value >= -1 && value < magnitude * magnitude)
	{
		this.board.get_cell_at (y, x).set_only_possibility (value);
		this.check_conflicts ();
		this.changed ();
	}

	public bool is_conflicted (int x, int y)
		requires (x >= 0 && x < magnitude * magnitude)
		requires (y >= 0 && y < magnitude * magnitude)
	{
		return conflicts[x * magnitude * magnitude + y];
	}

	public bool is_fixed (int x, int y)
		requires (x >= 0 && x < magnitude * magnitude)
		requires (y >= 0 && y < magnitude * magnitude)
	{
		return fixed[x * magnitude * magnitude + y];
	}

	public void clear ()
	{
		int num_tiles = this.magnitude * this.magnitude;

		for (int x = 0; x < num_tiles; ++x)
		{
			for (int y = 0; y < num_tiles; ++y)
			{
				if ( ! this.is_fixed (x, y))
				{
					this.set_at (x, y, -1);
				}
			}
		}
	}

	public bool solve ()
	{
		if (check_conflicts ())
			return false;

		SolveResult? solution = this.board.solveCPS (2);

		if
			(  solution == null
			|| solution.first_result == null
			|| solution.results != 1
			)
			return false;

		this.board = solution.first_result;
		this.changed ();

		return true;
	}

	private int num_to_remove (string difficulty)
	{
		switch (this.magnitude)
		{
			case 3:
				switch (difficulty)
				{
					case "easy":
						return 35;
					case "normal":
						return 40;
					case "hard":
						return 48;
					case "very-hard":
						return 53;
				}
				break;
			case 4:
				switch (difficulty)
				{
					case "easy":
						return 90;
					case "normal":
						return 99;
					case "hard":
						return 111;
					case "very-hard":
						return 130;
				}
				break;
			case 5:
				switch (difficulty)
				{
					case "easy":
						return 200;
					case "normal":
						return 220;
					case "hard":
						return 260;
					case "very-hard":
						return 290;
				}
				break;
		}

		return 0;
	}

	private bool check_conflicts ()
	{
		bool conflict = false;
		ArrayList<unowned Cell> cells = this.board.check_conflicts ();

		for (size_t i = 0; i < this.conflicts.length; ++i)
		{
			conflicts[i] = false;
		}

		foreach (unowned Cell cell in cells)
		{
			conflict = true;
			set_conflict (cell.col, cell.row);
		}

		return conflict;
	}

	private void set_conflict (int x, int y)
	{
		conflicts[x * magnitude * magnitude + y] = true;
	}
}

}
