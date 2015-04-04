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

}
