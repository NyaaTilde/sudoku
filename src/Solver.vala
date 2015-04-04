namespace Sudoku{

    public class Solver
    {
        private int N;
        private int smallest;
        private int count;
        private Board board;
        public Solver.with_size(int size)
        {
            N = size;
            smallest = -1;
            count = 0;
        }
        public Solver()
        {
            N = 3;
            smallest = 0;
            count = 0;
        }

        private void init()
        {
            int[,] grid =
            {{8,0,0,0,0,0,0,0,0},
            {0,0,3,6,0,0,0,0,0},
            {0,7,0,0,9,0,2,0,0},
            {0,5,0,0,0,7,0,0,0},
            {0,0,0,0,4,5,7,0,0},
            {0,0,0,1,0,0,0,3,0},
            {0,0,1,0,0,0,0,6,8},
            {0,0,8,5,0,0,0,1,0},
            {0,9,0,0,0,0,4,0,0}};

            Timer timer = new Timer();
            board = new Board.with_grid(grid);

            if (solved(board))
			{
                //print_grid(board);
			}
            else
			{
                //print("No solution exists");
            }
			timer.stop();
            ulong time;
            timer.elapsed(out time);

            print("Solving time: " + (time / 1000).to_string() + "ms\n");
            print("Count: " + count.to_string() + "\n");
                    // -1 means unassigned cells 16x16, 0 9x9
        }

        private bool solved(Board board)
        {
            int row, col;
            if (!find_unassigned (board, out row, out col))
                return true;

            for (int i = smallest; i < board.sizes + smallest; i++)
            {
                if (is_safe(board, row, col, i))
                {
                    board.set_cell_at(col,row,i);
                    count++;
                    if(solved(board))
                        return true;
                    board.set_cell_at(row,col, smallest);
                }
            }

            return false;
        }

        private bool find_unassigned(Board board, out int row, out int col)
        {
            for (row = 0; row < board.sizes; row++)
                for (col = 0; col < board.sizes; col++)
                    if (board.get_cell_at(col, row).number == smallest)
                        return true;
            row = 0;
            col = 0;
            return false;
        }

        private bool is_safe(Board board, int row, int col, int num)
        {
            if (!used_row(board, row, num))
                if (!used_col(board, col, num))
                    if (!used_box(board, row - row%N, col-col%N, num))
                        return true;
            return false;
        }

        private bool used_row(Board board, int row, int num)
        {
            for (int col = 0; col < board.sizes; col++)
                if (board.get_cell_at(col, row).number == num)
                    return true;
            return false;
        }

        private bool used_col(Board board, int col, int num)
        {
            for (int row = 0; row < board.sizes; row++)
                if (board.get_cell_at(col, row).number == num)
                    return true;
            return false;
        }

        private bool used_box(Board Board, int row, int col, int num)
        {
            for (int i = 0; i < N; i++)
                for (int j = 0; j < N; j++)
                    if (board.get_cell_at(col+j, row+i).number == num)
                        return true;
            return false;
        }

    }
}
