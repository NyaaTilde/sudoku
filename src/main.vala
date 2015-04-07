using Sudoku;

int main (string[] args)
{
	Sudoku.UI.Application app = new Sudoku.UI.Application ();

	return app.run (args);

    Timer timer = new Timer();
	int[,] grid =
	{
		{-1,-1,-1,-1,-1,-1,11,-1,3,-1,2,-1,-1,14,-1,-1},
		{6,-1,-1,0,-1,-1,5,15,7,11,-1,4,13,-1,10,-1},
		{-1,-1,-1,7,-1,1,-1,-1,-1,6,-1,-1,-1,15,-1,-1},
		{2,4,9,-1,-1,-1,0,-1,-1,12,-1,-1,-1,-1,-1,-1},
		{-1,6,-1,-1,8,-1,-1,-1,-1,2,12,-1,5,-1,-1,14},
		{-1,3,15,9,-1,0,-1,5,6,4,-1,11,-1,8,-1,-1},
		{0,-1,5,-1,-1,-1,-1,-1,-1,-1,13,1,15,2,-1,-1},
		{-1,10,-1,-1,6,-1,-1,-1,-1,-1,-1,8,-1,0,7,12},
		{-1,9,6,8,1,15,-1,-1,12,-1,-1,-1,0,-1,-1,4},
		{-1,-1,-1,-1,3,-1,10,-1,-1,-1,-1,-1,-1,12,13,-1},
		{10,13,-1,-1,-1,5,-1,8,-1,7,1,-1,-1,-1,-1,-1},
		{1,-1,7,-1,0,-1,14,-1,5,-1,-1,-1,2,-1,-1,-1},
		{-1,0,1,15,-1,-1,6,-1,2,-1,4,-1,-1,-1,-1,-1},
		{4,-1,-1,-1,-1,14,13,-1,-1,10,-1,3,-1,-1,12,-1},
		{-1,-1,-1,-1,-1,-1,-1,-1,14,15,-1,13,-1,4,-1,5},
		{5,-1,3,-1,9,10,7,-1,-1,8,-1,-1,1,-1,-1,-1}
};

	/*Board board = new Board./*with_magnitude(3);//* /with_grid(grid);
	board = board.solveFCS();

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
	Board board = new Board./*with_magnitude(5);//*/with_grid(grid, true);
	board = board.solveCPS();

	print("Constraint propagation:\n");
	print("Solving time: " + (timer.elapsed() * 1000).to_string() + "ms\n");
	print("States expanded: " + Board.states_expanded.to_string() + "\n");
	print(board.to_string() + "\n");

	return 0;
}
