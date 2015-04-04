const int N = 4;
const int smallest = 0;
static int count = 0;
int main()
{
	// 0 means unassigned cells
	int[,] grid =
	{{8,-1,-1,-1,-1,-1,-1,-1,-1},
	{-1,-1,3,6,-1,-1,-1,-1,-1},
	{-1,7,-1,-1,9,-1,2,-1,-1},
	{-1,5,-1,-1,-1,7,-1,-1,-1},
	{-1,-1,-1,-1,4,5,7,-1,-1},
	{-1,-1,-1,1,-1,-1,-1,3,-1},
	{-1,-1,1,-1,-1,-1,-1,6,8},
	{-1,-1,8,5,-1,-1,-1,1,-1},
	{-1,9,-1,-1,-1,-1,4,-1,-1}};
/*{{-1,-1,-1,-1,-1,-1,-1,12,-1,2,-1,13,-1,4,-1,-1},
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
	{-1,13,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1}};*/

/*{{0,0,0,0,0,0,0,0,0},
	 {0,0,0,0,0,0,0,0,0},
	 {0,0,0,0,0,0,0,0,0},
	 {0,0,0,0,0,0,0,0,0},
	 {0,0,0,0,0,0,0,0,0},
	 {0,0,0,0,0,0,0,0,0},
	 {0,0,0,0,0,0,0,0,0},
	 {0,0,0,0,0,0,0,0,0},
	 {0,0,0,0,0,0,0,0,0}};*/
	//print(grid.length[0].to_string());
	/*bool[,,] fc = new bool[N*N,N*N,N*N];
	for(int i = 0; i < grid.length[0]; i++)
	{
		for(int j = 0; j < grid.length[1]; j++)
		{
			if(grid[i,j] == -1)
			{
				for(int k = 0; k < fc.length[2]; k++)
				{
					fc[i,j,k] = true;
				}
			}
			else
			{
				fc[i,j,k] = false;
			}
		}
	}*/
	Timer timer = new Timer();
	if (solved(grid))
		print_grid(grid);
	else
		print("No solution exists");
	timer.stop();
	ulong time;
	timer.elapsed(out time);
	
	print("Solving time: " + (time / 1000).to_string() + "ms\n");
	print("Count: " + count.to_string() + "\n");
	
	return 0;
}

bool solved(int[,] grid, bool[,,] fc) 
{
	int row, col;
	if (!find_unassigned (grid, out row, out col))
		return true;

	for (int i = smallest; i < grid.length[0] + smallest; i++)
	{
		if (is_safe(grid, row, col, i))
		{
			grid[row, col] = i;
			count++;
			if(count % 100000000 == 0)
				print("Count: " + count.to_string() + "\n");
			if(solved(grid))
				return true;
			grid[row, col] = -1;
		}
	}

	return false;
}

bool find_unassigned(int[,] grid, out int row, out int col)
{
	for (row = 0; row < grid.length[0]; row++)
		for (col = 0; col < grid.length[1]; col++)
			if (grid[row, col] == -1)
				return true;
	row = 0;
	col = 0;
	return false;
}

bool is_safe(int[,] grid, int row, int col, int num) 
{
	if (!used_row(grid, row, num))
		if (!used_col(grid, col, num))
			if (!used_box(grid, row - row%N, col-col%N, num))
				return true;
	return false;
}

bool used_row(int[,] grid, int row, int num)
{
	for (int col = 0; col < grid.length[1]; col++)
		if (grid[row, col] == num)
			return true;
	return false;
}

bool used_col(int[,] grid, int col, int num)
{
	for (int row = 0; row < grid.length[0]; row++)
		if (grid[row, col] == num)
			return true;
	return false;
}

bool used_box(int[,] grid, int row, int col, int num)
{
	for (int i = 0; i < N; i++)
		for (int j = 0; j < N; j++)
			if (grid[row+i, j+col] == num)
				return true;
	return false;
}

void fc_row(bool[,,] fc, int row, int num)
{

}
void fc_col(bool[,,] fc, int col, int num)
{

}
void fc_box(bool[,,] fc, int row, int col, int num)
{

}

void print_grid(int[,] grid)
{
	for (int row = 0; row < grid.length[0]; row++)
	{
		for (int col = 0; col < grid.length[1]; col++)
			print("%d ", grid[row, col]);
		print("\n");
	}
}