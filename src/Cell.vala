namespace Sudoku
{

[Compact]
public class Cell
{
	public bool[] options;

	public Cell(int possibilities, int row, int col)
	{
		options = new bool[possibilities];
		this.row = row;
		this.col = col;

		number = -1;
		int length = options.length;
		for (int i = 0; i < length; i++)
			options[i] = true;
	}

	public bool get_possibility(int index)
	{
		return options[index];
	}

	public bool set_possibility(int index, bool value)
	{
		options[index] = value;
		int length = options.length;
		for (int i = 0; i < length; i++)
			if (options[i])
				return true;
		return false;
	}

	public void set_only_possibility(int index)
	{
		int length = options.length;
		for (int i = 0; i < length; i++)
			options[i] = i == index || index == -1;
		number = index;
	}

	public void set_state(Cell cell)
	{
		number = cell.number;
		row = cell.row;
		col = cell.col;

		if (options.length != cell.options.length)
			options = new bool[cell.options.length];
		int length = options.length;
		for (int i = 0; i < length; i++)
			options[i] = cell.options[i];
	}

	public bool is_constrained()
	{
		if (number != -1)
			return false;

		int opts = 0;
		for (int i = 0; i < options.length; i++)
			if (options[i])
				opts++;

		return opts == 1;
	}

	public int get_constrained_value()
	{
		for (int i = 0; i < options.length; i++)
			if (options[i])
				return i;
		return -1;
	}

	public CELL_SEARCH_ENUM has_multiple_options()
	{
		if (number != -1)
			return CELL_SEARCH_ENUM.FINISHED;
		for (int i = 0; i < options.length; i++)
			if (options[i])
				return CELL_SEARCH_ENUM.UNASSIGNED;

		return CELL_SEARCH_ENUM.FAILURE;
	}
	public CELL_SEARCH_ENUM get_options(out int opts)
	{
		opts = 0;
		if (number != -1)
			return CELL_SEARCH_ENUM.FINISHED;
		int length = options.length;
		for(int i = 0; i < length; i++)
			if (options[i])
				opts++;
		if(opts > 0)
			return CELL_SEARCH_ENUM.UNASSIGNED;
		return CELL_SEARCH_ENUM.FAILURE;
	}

	public bool[] get_all_options()
	{
		return options;
	}

	public string to_string()
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
