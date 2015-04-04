int main (string[] args)
{

    int[,] =
    {{8,0,0,0,0,0,0,0,0},
    {0,0,3,6,0,0,0,0,0},
    {0,7,0,0,9,0,2,0,0},
    {0,5,0,0,0,7,0,0,0},
    {0,0,0,0,4,5,7,0,0},
    {0,0,0,1,0,0,0,3,0},
    {0,0,1,0,0,0,0,6,8},
    {0,0,8,5,0,0,0,1,0},
    {0,9,0,0,0,0,4,0,0}};
    Board = new Board.with_grid(grid);
	Sudoku.Application app = new Sudoku.Application ();

	return app.run (args);
}
