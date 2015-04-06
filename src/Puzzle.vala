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

		for (int i = 0; i < sizes; i++)
			for (int j = 0; j < sizes; j++)
			{
				int number = grid[i, j];
				Cell cell = cells[i * sizes + j];

				cell.set_only_possibility(number - 1 - empty);
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
			cells[i] = new Cell(sizes, i % sizes, i / sizes);

		Cell[] row_list = new Cell[sizes];
		Cell[] column_list = new Cell[sizes];
		Cell[] box_list = new Cell[sizes];

		for (int i = 0; i < sizes; i++)
		{
			for (int j = 0; j < sizes; j++)
			{
				row_list[j] = cells[i*sizes + j];
				column_list[j] = cells[j*sizes + i];

				int x = magnitude * (i % magnitude) + (j % magnitude);
				int y = magnitude * (i / magnitude) + (j / magnitude);

				box_list[j] = cells[x + y * sizes];
			}

			rows[i] = new CellList(row_list);
			columns[i] = new CellList(column_list);
			boxes[i] = new CellList(box_list);
		}
	}
	
	public void solve()
	{
		solved();
	}

	private CellList get_box_at(int x, int y)
	{
		x /= magnitude;
		y /= magnitude;

		return boxes[x + y * magnitude];
	}

	private Cell get_cell_at(int x, int y)
	{
		return cells[x+y*(sizes)];
	}

	private void set_cell_at(int x, int y, int number)
	{
		cells[x+y*(sizes)].number = number;
	}
	
	private bool solved()
	{
	    int row, col;
	    if(!find_unassigned (out row, out col))
            return true;
        for (int i = 0; i < sizes; i++)
        {
            if(is_safe(row,col,i))
            {
                set_cell_at(col,row,i);
                if(solved())
                    return true;
                set_cell_at(col, row, -1);
            }
        }
        return false;
	}

	private bool find_unassigned(out int row, out int col)
	{
	    for(row = 0; row < sizes; row++)
            for(col= 0; col < sizes; col++)
                if(get_cell_at(col,row).number == -1)
                    return true;
        row = 0;
        col = 0;
        return false;
	}

	private bool is_safe(int row, int col, int num)
	{
	    if (!rows[row].is_used(num))
            if (!columns[col].is_used(num))
                if (!get_box_at(col,row).is_used(num))
                    return true;
        return false;

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
}

public class CellList
{
	private Cell[] cells;

	public CellList(Cell[] cells)
	{
		this.cells = cells;
	}

	public void rule_out(int index)
	{
		foreach (Cell c in cells)
			c.set_possibility(index, false);
	}
	
	public bool is_used(int number)
	{
	    foreach (Cell c in cells)
            if (number == c.number)
                return true;
        return false;
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

	public Cell(int possibilities, int x, int y)
	{
		options = new bool[possibilities];
		this.x = x;
		this.y = y;
	}

	public bool get_possibility(int index)
	{
		return options[index];
	}

	public void set_possibility(int index, bool value)
	{
		options[index] = value;
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
		x = cell.x;
		y = cell.y;
		
		if (options.length != cell.options.length)
			options = new bool[cell.options.length];
		for (int i = 0; i < options.length; i++)
			options[i] = cell.options[i];
	}
	
	public string to_string()
	{
		string n = (number+1).to_string();
		
		for (int i = n.length; i < 3; i++)
			n = " " + n;
		
		return n;
	}

	public int number { get; set; }
	public int x { get; private set; }
	public int y { get; private set; }
}

}
