namespace Sudoku
{

public class SolveResult
{
	public SolveResult (int num)
	{
		first_result = null;
		results = 0;
		finished = false;
		states_expanded = 0;
		find_count = num;
	}
	
	public Board? first_result { get; set; }
	public int results { get; set; }
	public bool finished { get; set; }
	public int states_expanded { get; set; }
	public int find_count { get; set; }
}

}
