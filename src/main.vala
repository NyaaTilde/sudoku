using Sudoku;

int main (string[] args)
{
	Sudoku.UI.Application app = new Sudoku.UI.Application ();

	return app.run (args);

    Timer timer = new Timer();
	int[,] grid =
	{
		{-1,-1,-1,-1,-1,-1,-1,12,-1,2,-1,13,-1,4,-1,-1},
		{-1,4,-1,8,-1,-1,3,-1,-1,15,-1,-1,11,12,-1,0},
		{11,-1,-1,-1,5,1,9,15,7,-1,-1,-1,3,-1,-1,-1},
		{-1,-1,2,-1,-1,14,-1,11,9,-1,0,-1,-1,-1,-1,-1},
		{-1,-1,7,-1,-1,9,-1,3,-1,-1,2,11,12,-1,-1,-1},
		{-1,-1,5,-1,-1,-1,12,4,-1,-1,-1,15,0,13,10,-1},
		{-1,-1,13,-1,1,-1,-1,-1,-1,-1,-1,6,-1,-1,-1,-1},
		{2,15,-1,3,-1,-1,-1,-1,13,-1,-1,1,5,8,-1,7},
		{15,12,0,11,-1,2,-1,-1,-1,-1,-1,-1,-1,-1,-1,5},
		{-1,-1,3,-1,12,-1,6,9,-1,-1,15,-1,8,-1,-1,-1},
		{4,-1,-1,2,-1,-1,11,8,10,14,-1,-1,-1,-1,6,-1},
		{-1,9,-1,-1,0,-1,-1,-1,2,-1,-1,-1,-1,14,-1,-1},
		{-1,-1,10,9,3,8,-1,7,-1,-1,-1,-1,15,-1,-1,6},
		{1,-1,15,4,-1,6,-1,-1,-1,3,-1,2,-1,0,7,-1},
		{-1,3,8,-1,10,-1,-1,-1,12,0,-1,-1,4,-1,11,-1},
		{-1,13,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1}
	};

	Board board = new Board./*with_magnitude(3);//*/with_grid(grid);
	/*board = board.solveFCS();

	print("Forward checking with most constrained heuristic:\n");
	print("Solving time: " + (timer.elapsed() * 1000).to_string() + "ms\n");
	print("States expanded: " + Board.states_expanded.to_string() + "\n");
	print(board.to_string() + "\n");

	/*timer.start();
	board = new Board.with_grid(grid);
	board = board.solveBTS();

	print("Back tracking:\n");
	print("Solving time: " + (timer.elapsed() * 1000).to_string() + "ms\n");
	print("States expanded: " + Board.states_expanded.to_string() + "\n");
	print(board.to_string() + "\n");*/

	timer.start();
	board = new Board./*with_magnitude(5);//*/with_grid(grid);
	board = board.solveBTS();

	print("Constraint propagation:\n");
	print("Solving time: " + (timer.elapsed() * 1000).to_string() + "ms\n");
	print("States expanded: " + Board.states_expanded.to_string() + "\n");
	print(board.to_string() + "\n");

	return 0;
}
