using Gee;
namespace Sudoku
{

public class Puzzle : Object
{
	public int magnitude { get; construct set; }
	private bool[] fixed;
	private int[] board;

	public Puzzle ()
	{
		this.with_magnitude (3);
	}

	public Puzzle.with_magnitude (int magnitude)
		requires (magnitude > 0 && magnitude < 7)
	{
		this.magnitude = magnitude;
		this.fixed = new bool[magnitude * magnitude * magnitude * magnitude];
		this.board = new int[magnitude * magnitude * magnitude * magnitude];

		for (size_t i = 0; i < this.board.length; ++i)
		{
			fixed[i] = false;
			board[i] = -1;
		}
	}

	/* (0, 0) is at the top-left, with y increasing downwards, unfortunately */
	public int get_at (int x, int y)
		requires (x >= 0 && y < magnitude * magnitude)
		requires (y >= 0 && y < magnitude * magnitude)
	{
		return board[y * magnitude * magnitude + x];
	}

	public void set_at (int x, int y, int value)
		requires (x >= 0 && x < magnitude * magnitude)
		requires (y >= 0 && y < magnitude * magnitude)
		requires (value >= -1 && value < magnitude * magnitude)
	{
		board[y * magnitude * magnitude + x] = value;
	}

	public bool is_fixed (int x, int y)
		requires (x >= 0 && x < magnitude * magnitude)
		requires (y >= 0 && y < magnitude * magnitude)
	{
		return fixed[y * magnitude * magnitude + x];
	}
}

public class Board
{
	private Cell[] cells;
	private CellList[] rows;
	private CellList[] columns;
	private CellList[] boxes;

	private int magnitude;
	private int sizes;

	public static int states_expanded { get; private set; }

	public Board()
	{
		this.with_magnitude(3);
	}

	public Board.with_grid(int[,] grid)
	{
		int magnitude = 0;
		while ((++magnitude * magnitude) < grid.length[0]);
		this.with_magnitude(magnitude);

		int empty = magnitude <= 3 ? 0 : -1;

		for (int row = 0; row < sizes; row++)
			for (int col = 0; col < sizes; col++)
			{
				int number = grid[row, col];
				Cell cell = cells[row * sizes + col];

				if (number != empty)
				{
					cell.set_only_possibility(number - 1 - empty);
					rule_out_cells(row, col, number - 1 - empty, cell);
				}
			}
	}

	public Board.with_magnitude(int magnitude)
	{
		this.magnitude = magnitude;
		sizes = magnitude * magnitude;
		cells = new Cell[sizes*sizes];
		rows = new CellList[sizes];
		columns = new CellList[sizes];
		boxes = new CellList[sizes];

		for (int i = 0; i < cells.length; i++)
			cells[i] = new Cell(sizes, i / sizes, i % sizes);

		Cell[] row_list = new Cell[sizes];
		Cell[] column_list = new Cell[sizes];
		Cell[] box_list = new Cell[sizes];

		for (int row = 0; row < sizes; row++)
		{
			for (int col = 0; col < sizes; col++)
			{
				row_list[col] = cells[row*sizes + col];
				column_list[col] = cells[col*sizes + row];

				int x = magnitude * (row % magnitude) + (col % magnitude);
				int y = magnitude * (row / magnitude) + (col / magnitude);

				box_list[col] = cells[x + y * sizes];
			}

			rows[row] = new CellList(row_list);
			columns[row] = new CellList(column_list);
			boxes[row] = new CellList(box_list);
		}
	}

	public Board? solveCPS()
	{
		states_expanded = 0;
		return solvedCPS(this);
	}

	public Board? solveFCS()
	{
		states_expanded = 0;
		return solvedFCS(this);
	}

	public Board? solveBTS()
	{
		states_expanded = 0;
		Board b = copy();
		b.solvedBTS();
		return b;
	}
    public ArrayList<Cell> check_conflicts()
    {
        var list = new ArrayList<Cell>();
        foreach (CellList cl in rows)
            list.add_all(cl.get_conflicts());
        foreach (CellList cl in columns)
            list.add_all(cl.get_conflicts());
        foreach (CellList cl in boxes)
            list.add_all(cl.get_conflicts());
        return list;
    }
	private CellList get_box_at(int row, int col)
	{
		row /= magnitude;
		col /= magnitude;

		return boxes[col + row * magnitude];
	}

	private Cell get_cell_at(int row, int col)
	{
		return cells[col + row * sizes];
	}

	private void set_cell_at(int row, int col, int number)
	{
		cells[col + row * sizes].number = number;
	}

	private static Board? solvedCPS(Board board)
	{
		int row, col, val;
		switch (board.most_constrained_option(out row, out col, out val))
		{
		case CELL_SEARCH_ENUM.FINISHED:
			return board;
		case CELL_SEARCH_ENUM.FAILURE:
			return null;
		}

		for (int i = 0; i < board.sizes; i++)
		{
			if (board.has_option(row, col, i))
			{
				states_expanded++;
				Board b = board.copy();
				if (!b.propagate(row, col, i))
					continue;
				if ((b = solvedCPS(b)) != null)
					return b;
			}
		}

		return null;
	}

	private static Board? solvedFCS(Board board)
	{
		int row, col;
		switch(board.find_option (out row, out col))
		{
			case CELL_SEARCH_ENUM.FINISHED:
				return board;
			case CELL_SEARCH_ENUM.FAILURE:
				return null;
		}
		for (int i = 0; i < board.sizes; i++)
		{
			if (board.has_option(row, col, i))
			{
				states_expanded++;
				Board b = board.copy();
				Cell c = b.get_cell_at(row, col);
				c.set_only_possibility(i);
				if (!b.rule_out_cells(row, col, i, c))
					continue;
				if ((b = solvedFCS(b)) != null)
					return b;
			}
		}
		return null;
	}

	public bool solvedBTS()
	{
		int row, col;
		if(!find_unassigned(out row, out col))
			return true;
		for(int i = 0; i < sizes; i++)
		{
			if(is_safe(row,col,i))
			{
				states_expanded++;
				set_cell_at(row, col, i);
				if(solvedBTS())
					return true;
				set_cell_at(row, col, -1);
			}
		}
		return false;

	}

    private CELL_SEARCH_ENUM most_constrained_option(out int row, out int col, out int val)
	{
        row = -1;
        col = -1;
        val = -1;
        int minvalue = sizes+1;
        for (int r = 0; r < sizes; r++)
            for (int c = 0; c < sizes; c++)
            {
                int tmp = 0;
                Cell tmpcell = get_cell_at(r,c);
                switch (tmpcell.get_options(out tmp))
                {
                    case CELL_SEARCH_ENUM.UNASSIGNED:
                        if(tmp < minvalue)
                        {
                            minvalue = tmp;
                            row = r;
                            col = c;
                            if ((val = rows[row].get_only_possible_cell(tmpcell)) == -1)
                                if((val = columns[col].get_only_possible_cell(tmpcell)) == -1)
                                    if((val = get_box_at(row, col).get_only_possible_cell(tmpcell)) == -1)
                                        val = tmpcell.get_constrained_value();
                            /*if(minvalue == 2)
                                return CELL_SEARCH_ENUM.UNASSIGNED;*/
                        }
                        break;
                    case CELL_SEARCH_ENUM.FAILURE:
                        return CELL_SEARCH_ENUM.FAILURE;
                }
            }
        if (row != -1 && col != -1)
            return CELL_SEARCH_ENUM.UNASSIGNED;
        row = 0;
        col = 0;
        return CELL_SEARCH_ENUM.FINISHED;
	}

	private CELL_SEARCH_ENUM find_option(out int row, out int col)
	{
		row = -1;
		col = -1;
		for (int r = 0; r < sizes; r++)
			for (int c = 0; c < sizes; c++)
				switch (get_cell_at(r, c).has_multiple_options())
				{
				case CELL_SEARCH_ENUM.UNASSIGNED:
					if (row == -1 && col == -1)
					{
						row = r;
						col = c;
					}
					break;
				case CELL_SEARCH_ENUM.FAILURE:
					return CELL_SEARCH_ENUM.FAILURE;
                }

		if (row != -1 && col != -1)
			return CELL_SEARCH_ENUM.UNASSIGNED;

		row = 0;
		col = 0;
		return CELL_SEARCH_ENUM.FINISHED;
	}

	private bool find_unassigned(out int row, out int col)
	{
		for(row = 0; row < sizes; row++)
			for(col= 0; col < sizes; col++)
				if(get_cell_at(row, col).number == -1)
					return true;
		row = 0;
		col = 0;
        return false;
	}

	private bool is_safe(int row, int col, int num)
	{
	    if (!rows[row].is_used(num))
            if (!columns[col].is_used(num))
                if (!get_box_at(row, col).is_used(num))
                    return true;
        return false;
	}

	private bool has_option(int row, int col, int num)
	{
		return get_cell_at(row, col).get_possibility(num);
	}

	private bool propagate(int row, int col, int value)
	{
		Cell c = get_cell_at(row, col);
		c.set_only_possibility(value);
		if (!rule_out_cells(row, col, value, c))
			return false;

		if (propagate_list(rows[row]) &&
			propagate_list(columns[col]) &&
			propagate_list(get_box_at(row, col)))
			return true;

		return false;
	}

	private bool propagate_list(CellList list)
	{
		while (true)
		{
			Cell? c = list.get_constrained_cell();
			if (c == null)
				return true;

			if (!propagate(c.row, c.col, c.get_constrained_value()))
				return false;
		}
	}

	public string to_string()
	{
		string str = "";

		for (int i = 0; i < sizes; i++)
		{
			str += rows[i].to_string();
			if (i != rows.length -1)
				str += "\n";
		}

		return str;
	}

	public Board copy()
	{
		Board b = new Board.with_magnitude(magnitude);
		for (int i = 0; i < cells.length; i++)
			b.cells[i].set_state(cells[i]);

		return b;
	}

	public bool rule_out_cells(int row, int col, int num, Cell cell)
	{
		if (rows[row].rule_out(cell, num) &&
	    		columns[col].rule_out(cell, num) &&
			get_box_at(row, col).rule_out(cell, num))
			return true;
		return false;
	}
}

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
                if(c.number == c2.number && c.row != c2.row && c.col != c2.col)
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

public class Cell
{
	private bool[] options;

	public Cell(int possibilities, int row, int col)
	{
		options = new bool[possibilities];
		this.row = row;
		this.col = col;

		number = -1;
		for (int i = 0; i < options.length; i++)
			options[i] = true;
	}

	public bool get_possibility(int index)
	{
		return options[index];
	}

	public bool set_possibility(int index, bool value)
	{
		options[index] = value;
		for (int i = 0; i < options.length; i++)
			if (options[i])
				return true;
		return false;
	}

	public void set_only_possibility(int index)
	{
		for (int i = 0; i < options.length; i++)
			options[i] = i == index;
		number = index;
	}

	public void set_state(Cell cell)
	{
		number = cell.number;
		row = cell.row;
		col = cell.col;

		if (options.length != cell.options.length)
			options = new bool[cell.options.length];
		for (int i = 0; i < options.length; i++)
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
        for(int i = 0; i < options.length; i++)
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

	public int number { get; set; }
	public int row { get; private set; }
	public int col { get; private set; }
}

public enum CELL_SEARCH_ENUM
{
    UNASSIGNED,
    FINISHED,
    FAILURE
}

}
