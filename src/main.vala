using Sudoku;

int main (string[] args)
{
	//Sudoku.UI.Application app = new Sudoku.UI.Application ();

	//return app.run (args);

    Timer timer = new Timer();
	int[,] grid =
    {
		{8,0,0,0,0,0,0,0,0},
		{0,0,3,6,0,0,0,0,0},
		{0,7,0,0,9,0,2,0,0},
		{0,5,0,0,0,7,0,0,0},
		{0,0,0,0,4,5,7,0,0},
		{0,0,0,1,0,0,0,3,0},
		{0,0,1,0,0,0,0,6,8},
		{0,0,8,5,0,0,0,1,0},
		{0,9,0,0,0,0,4,0,0}
	};

	Board board = new Board./*with_magnitude(3);//*/with_grid(grid);
	board = board.solve();

	print("Forward checing:\n");
	print("Solving time: " + (timer.elapsed() * 1000).to_string() + "ms\n");
	print("States expanded: " + Board.states_expanded.to_string() + "\n");
	print(board.to_string() + "\n");

	timer.start();
	board = new Board.with_grid(grid);
	board = board.solveBTS();

	print("Back tracking:\n");
	print("Solving time: " + (timer.elapsed() * 1000).to_string() + "ms\n");
	print("States expanded: " + Board.states_expanded.to_string() + "\n");
	print(board.to_string() + "\n");

	return 0;
}
