namespace Sudoku
{

public class Puzzle
{
	private uint magnitude;
	private int[] board;

	public Puzzle ()
	{
		this.with_magnitude (3);
	}

	public Puzzle.with_magnitude (uint magnitude)
		requires (magnitude > 0)
	{
		this.magnitude = magnitude;
		this.board = new int[magnitude * magnitude * magnitude * magnitude];

		for (size_t i = 0; i < this.board.length; ++i)
		{
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
}

public class Board
{
	private Cell[] cells;
	private CellList[] rows;
	private CellList[] columns;
	private CellList[] boxes;
	private int magnitude;
	
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
				
				if (number != empty)
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
	
	public CellList get_box_at(int x, int y)
	{
		x /= magnitude;
		y /= magnitude;
		
		return boxes[x + y * magnitude];
	}
	public Cell get_cell_at(int x, int y)
	{
		return cells[x+y*(sizes)];
	}
	public void set_cell_at(int x, int y, int number)
	{
		cells[x+y*(sizes)].number = number;
	}
	public int sizes { get; private set; }
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
	
	public int number { get; set; }
	public int x { get; private set; }
	public int y { get; private set; }
}

}
