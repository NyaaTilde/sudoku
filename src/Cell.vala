namespace Sudoku
{

[Compact]
public class Cell
{
	public int possibilities;
	public uint64 options;

	public Cell (int possibilities, int row, int col)
	{
		this.possibilities = possibilities;
		this.options = (1 << possibilities) - 1;
		this.row = row;
		this.col = col;
		this.number = -1;
	}

	public bool get_possibility (int index)
	{
		return (options & (1 << index)) > 0;
	}

	public bool set_possibility (int index, bool value)
	{
		options &= ~(1 << index);

		if (value)
			options |= 1 << index;

		return options > 0;
	}

	public void set_only_possibility (int index)
	{
		options = 0;

		for (int i = 0; i < this.possibilities; ++i)
			options |= (uint64) ((i == index) || (index == -1)) << i;

		this.number = index;
	}

	public void set_state (Cell cell)
	{
		number = cell.number;
		row = cell.row;
		col = cell.col;

		possibilities = cell.possibilities;
		options = cell.options;
	}

	public bool is_constrained ()
	{
		if (number != -1)
			return false;

		/* is only one bit set */
		return (options != 0) && ((options & (~options + 1)) == options);
	}

	public int get_constrained_value ()
	{
		uint64 opts = options;
		int i = 0;

		while (opts > 0)
		{
			if ((opts & 1) == 1)
				return i;

			opts >>= 1;
			++i;
		}

		return -1;
	}

	public CELL_SEARCH_ENUM has_multiple_options ()
	{
		if (number != -1)
			return CELL_SEARCH_ENUM.FINISHED;

		if (options > 0)
			return CELL_SEARCH_ENUM.UNASSIGNED;

		return CELL_SEARCH_ENUM.FAILURE;
	}

	public CELL_SEARCH_ENUM get_options (out int opts)
	{
		uint64 o = options;
		opts = 0;

		if (number != -1)
			return CELL_SEARCH_ENUM.FINISHED;

		while (o > 0)
		{
			opts += (int) (o & 1);
			o >>= 1;
		}

		if (opts > 0)
			return CELL_SEARCH_ENUM.UNASSIGNED;

		return CELL_SEARCH_ENUM.FAILURE;
	}

	public bool[] get_all_options ()
	{
		bool[] opts = new bool[possibilities];

		for (int i = 0; i < possibilities; ++i)
		{
			opts[i] = (options & (1 << i)) > 0;
		}

		return opts;
	}

	public string to_string ()
	{
		string n = (number+1).to_string();

		for (int i = n.length; i < 3; i++)
			n = " " + n;

		return n;
	}

	public int number;
	public int row;
	public int col;
}

}
