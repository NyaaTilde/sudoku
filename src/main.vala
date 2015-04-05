int main (string[] args)
{
	Sudoku.UI.Application app = new Sudoku.UI.Application ();

	return app.run (args);

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
	
	Sudoku.Board board = new Sudoku.Board.with_grid(grid);
	board.solve();
	
	print(board.to_string() + "\n");
	
	return 0;
}
