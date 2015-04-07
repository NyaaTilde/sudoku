using Gee;

namespace Sudoku
{

public enum CELL_SEARCH_ENUM
{
	UNASSIGNED,
	FINISHED,
	FAILURE
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

		int empty = -1;//magnitude <= 3 ? 0 : -1;

		for (int row = 0; row < sizes; row++)
			for (int col = 0; col < sizes; col++)
			{
				int number = grid[row, col];
				unowned Cell cell = cells[row * sizes + col];

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

		(unowned Cell)[] row_list = new Cell[sizes];
		(unowned Cell)[] column_list = new Cell[sizes];
		(unowned Cell)[] box_list = new Cell[sizes];

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
	
	public static Board create_unfinished(int magnitude, int seed, int difficulty)
	{
		Rand rnd = new Rand.with_seed(seed);
		
		while (true)
		{
			Board board = create_random(magnitude, rnd);
			Board b = delete_random(board, rnd, difficulty);
		
			int[,] numbers = new int[b.sizes, b.sizes];
			
			for (int row = 0; row < b.sizes; row++)
				for (int col = 0; col < b.sizes; col++)
					numbers[col, row] = b.get_cell_at(row, col).number;
			
			Board solve = new Board.with_grid(numbers);
			
			if (magnitude > 3)
				return solve;
			
			SolveResult r = new SolveResult(2);
 			r = solvedCPS(solve, r);
			if (r.results != 1)
				continue;
			
			return b;
		}
	}
	
	private static Board delete_random(Board board, Rand rnd, int amount)
	{
		Board b = board.copy();
		
		for (int i = 0; i < amount; i++)
		{
			while (true)
			{
				int r = rnd.int_range(0, b.cells.length);
				unowned Cell c = b.cells[r];
				
				if (c.number != -1)
				{
					c.number = -1;
					break;
				}
			}
		}
		
		return b;
	}
	
	public static Board create_random(int magnitude, Rand rnd)
	{
		Board board = new Board.with_magnitude(magnitude);
		
		unowned CellList list = board.rows[0];
		int[] numbers = new int[board.sizes];
		
		for (int i = 0; i < numbers.length; i++)
			numbers[i] = i;
		shuffle(numbers, rnd);
		
		unowned Cell[] cells = list.cells;
		for (int i = 0; i < cells.length; i++)
			cells[i].set_only_possibility(numbers[i]);
		
		SolveResult r = new SolveResult(1);
		r = solvedCPS(board, r);
		
		return r.first_result;
	}

	public SolveResult? solveCPS (int num)
	{
		Board board = this.copy ();

		for (int i = 0; i < this.cells.length; ++i)
		{
			unowned Cell c = this.cells[i];

			if (c.number != -1)
			{
				board.propagate (c.row, c.col, c.number);
			}
		}

		states_expanded = 0;
		SolveResult result = new SolveResult (num);
		return solvedCPS(board, result);
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
		var list = new ArrayList<unowned Cell>();
		foreach (unowned CellList cl in rows)
			list.add_all(cl.get_conflicts());
		foreach (unowned CellList cl in columns)
			list.add_all(cl.get_conflicts());
		foreach (unowned CellList cl in boxes)
			list.add_all(cl.get_conflicts());
		return list;
	}

	private unowned CellList get_box_at(int row, int col)
	{
		row /= magnitude;
		col /= magnitude;

		return boxes[col + row * magnitude];
	}

	public unowned Cell get_cell_at(int row, int col)
	{
		return cells[col + row * sizes];
	}

	private void set_cell_at(int row, int col, int number)
	{
		cells[col + row * sizes].number = number;
	}

	private static SolveResult? solvedCPS(Board board, SolveResult result)
	{
		while (true)
		{
			int row, col, val;
			switch (board.most_constrained_option(out row, out col, out val))
			{
				case CELL_SEARCH_ENUM.FINISHED:
					if (result.first_result == null)
						result.first_result = board;
					result.results++;
					
					if (result.results >= result.find_count && result.find_count != -1)
						result.finished = true;
					return result;
				case CELL_SEARCH_ENUM.FAILURE:
					return result;
			}

			result.states_expanded++;
			Board b = board.copy();
			/*if (result.states_expanded % 1000 == 0)
			{
				print("States: " + result.states_expanded.to_string() + "\n");
				print("Solutions: " + result.results.to_string() + "\n");
				print(board.to_string() + "\n------------------------------------\n");
			}*/
			
			SolveResult r = null;
			if (!b.propagate(row, col, val) || (!((r = solvedCPS(b, result)).finished)))
			{
				board.get_cell_at(row, col).set_possibility(val, false);
				continue;
			}
			
			return result;
		}
	}

	private static Board? solvedFCS(Board board)
	{
		int row, col, val;
		switch(board.find_option(out row, out col, out val))
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
				unowned Cell c = b.get_cell_at(row, col);
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
				unowned Cell tmpcell = get_cell_at(r,c);
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

	private CELL_SEARCH_ENUM find_option(out int row, out int col, out int val)
	{
		row = -1;
		col = -1;
		val = -1;
		for (int r = 0; r < sizes; r++)
			for (int c = 0; c < sizes; c++)
			{
				unowned Cell cell = get_cell_at(r, c);
				
				switch (cell.has_multiple_options())
				{
				case CELL_SEARCH_ENUM.UNASSIGNED:
					if (row == -1)
					{
						row = r;
						col = c;
						val = cell.get_constrained_value();
					}
					break;
				case CELL_SEARCH_ENUM.FAILURE:
					return CELL_SEARCH_ENUM.FAILURE;
                }
			}

		if (row != -1)
			return CELL_SEARCH_ENUM.UNASSIGNED;

		row = 0;
		col = 0;
		val = 0;
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
		unowned Cell c = get_cell_at(row, col);
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
			unowned Cell? c = list.get_constrained_cell();
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
	
	private static void shuffle(int[] numbers, Rand r)
	{
		for (int i = 0; i < numbers.length; i++)
		{
			int rnd = numbers[r.int_range(0, numbers.length)];
			int n = numbers[rnd];
			numbers[rnd] = numbers[i];
			numbers[i] = n;
		}
	}
}

}
