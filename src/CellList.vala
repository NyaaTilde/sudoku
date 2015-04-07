using Gee;

namespace Sudoku
{

public class CellList
{
	private Cell[] cells;

	public CellList(Cell[] cells)
	{
		this.cells = cells;
	}

	public bool rule_out(Cell cell, int index)
	{
		foreach (Cell c in cells)
		{
			if(cell != c)
				if (!c.set_possibility(index, false))
					return false;
		}

		return true;
	}

	public ArrayList<Cell> get_conflicts()
	{
		var list = new ArrayList<Cell>();
		int[] numbers = new int[cells.length];
		foreach (Cell c in cells)
			if(c.number != -1)
			{
				numbers[c.number]++;
				if(numbers[c.number]>1)
					list.add(c);
			}
		foreach (Cell c in list)
			foreach (Cell c2 in cells)
				if(c.number == c2.number && c != c2)
					list.add(c2);
		return list;

	}

	public Cell? get_constrained_cell()
	{
		foreach (Cell c in cells)
			if (c.is_constrained())
				return c;
		return null;
	}
	public int get_only_possible_cell(Cell cell)
	{
		bool[] opts = cell.get_all_options();
		foreach (Cell c in cells)
		{
			if (cell != c)
			{
				for (int i = 0; i < opts.length; i++)
				{
						if(opts[i] == c.get_possibility(i))
							opts[i] = false;
				}
			}
		}
		for(int i = 0; i < opts.length; i++)
		{
			if(opts[i])
				return i;
		}
		return -1;
	}

	public bool is_used(int number)
	{
		foreach (Cell c in cells)
			if (number == c.number)
				return true;
		return false;
	}

	public bool has_option(int number)
	{
		foreach (Cell c in cells)
			if (!c.get_possibility(number))
				return false;
		return true;
	}

	public string to_string()
	{
		string str = "";

		for (int i = 0; i < cells.length; i++)
		{
			str += cells[i].to_string();
			if (i != cells.length -1)
				str += " ";
		}

		return str;
	}
}

}
