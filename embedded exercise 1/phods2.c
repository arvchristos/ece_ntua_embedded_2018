/*Parallel Hierarchical One-Dimensional Search for motion estimation*/
/*Initial algorithm - Used for simulation and profiling             */

#include <stdio.h>
#include <stdlib.h>

//Erwthma 1 includes for gettimeofday
#include <time.h>
#include <sys/time.h>

#define N 144     /*Frame dimension for QCIF format*/
#define M 176     /*Frame dimension for QCIF format*/
#define Ba 1      /*Block size*/
#define Bb 22
#define p 7       /*Search space. Restricted in a [-p,p] region around the
                    original location of the block.*/

#define NDIVB (N/Ba)
#define MDIVB (M/Bb)
#define N1 (N-1)
#define M1 (M-1)



#define bar(S) \
                min1 = min_init;\
                min2 = min_init;\
\
                /*For all candidate blocks in X dimension*/\
                for (i = -S; i < S + 1; i += S)\
                {\
                    distx = 0;\
                    disty = 0;\
\
                    /*For all pixels in the block*/\
                    for (k = 0; k < Ba; k++)\
                    {\
                        vectors_x_cur_k_Bx = vectors_x_cur + k + Bx;\
                        vectors_x_cur_k_Bx_i = vectors_x_cur_k_Bx + i;\
                        for (l = 0; l < Bb; l++)\
                        {\
                            p1 = current[k][l];\
                            vectors_y_cur_l_By = vectors_y_cur + l + By;\
                            if (i==0) \
                            {\
                                if ((vectors_x_cur_k_Bx) < 0 ||\
                                        (vectors_x_cur_k_Bx) > (N1) ||\
                                        (vectors_y_cur_l_By) < 0 ||\
                                        (vectors_y_cur_l_By) > (M1))\
                                {\
                                    p2 = 0;\
                                } else {\
                                    p2 = previous[vectors_x_cur_k_Bx][vectors_y_cur_l_By];\
                                }\
\
                                inc = abs(p1 - p2); \
                                distx += inc;\
                                disty += inc;\
                                continue;\
                            }\
                            vectors_y_cur_l_By_i = vectors_y_cur_l_By + i;\
                            if ((vectors_x_cur_k_Bx_i) < 0 ||\
                                    (vectors_x_cur_k_Bx_i) > (N1) ||\
                                    (vectors_y_cur_l_By) < 0 ||\
                                    (vectors_y_cur_l_By) > (M1))\
                            {\
                                p2 = 0;\
                            } else {\
                                p2 = previous[vectors_x_cur_k_Bx_i][vectors_y_cur_l_By];\
                            }\
\
                            distx += abs(p1 - p2);\
                            \
                            if ((vectors_x_cur_k_Bx) < 0 ||\
                                    (vectors_x_cur_k_Bx) > (N1) ||\
                                    (vectors_y_cur_l_By_i) < 0 ||\
                                    (vectors_y_cur_l_By_i) > (M1))\
                            {\
                                q2 = 0;\
                            } else {\
                                q2 = previous[vectors_x_cur_k_Bx][vectors_y_cur_l_By_i];\
                            }\
\
                            disty += abs(p1 - q2);\
                        }\
                    }\
\
                    if (distx < min1)\
                    {\
                        min1 = distx;\
                        bestx = i;\
                    }\
\
                    if (disty < min2)\
                    {\
                        min2 = disty;\
                        besty = i;\
                    }\
                }\
\
                vectors_x_cur += bestx;\
                vectors_y_cur += besty;


void read_sequence(int current[N][M], int previous[N][M])
{
    FILE *picture0, *picture1;
    int i, j;

    if ((picture0 = fopen("akiyo0.y", "rb")) == NULL)
    {
        printf("Previous frame doesn't exist.\n");
        exit(-1);
    }

    if ((picture1 = fopen("akiyo1.y", "rb")) == NULL)
    {
        printf("Current frame doesn't exist.\n");
        exit(-1);
    }

    /*Input for the previous frame*/
    for (i = 0; i < N; i++)
    {
        for (j = 0; j < M; j++)
        {
            previous[i][j] = fgetc(picture0);
        }
    }

    /*Input for the current frame*/
    for (i = 0; i < N; i++)
    {
        for (j = 0; j < M; j++)
        {
            current[i][j] = fgetc(picture1);
        }
    }

    fclose(picture0);
    fclose(picture1);
}


void phods_motion_estimation(int current[N][M], int previous[N][M],
                             int vectors_x[NDIVB][MDIVB], int vectors_y[NDIVB][MDIVB])
{
    int x, y, i, j, k, l, p1, p2, q2, distx, disty, S, min1, min2, bestx, besty;
    int Bx, By, line_fetch_x, line_fetch_y, vectors_y_cur, vectors_x_cur,inc; 
    int block_fetch_x,block_fetch_y;

    distx = 0;
    disty = 0;

    int NB = N/Ba;
    int MB = M/Bb;
    int min_init = (1 << 8)*Ba*Bb;

    int vectors_x_cur_k_Bx,vectors_y_cur_l_By;
    int vectors_x_cur_k_Bx_i,vectors_y_cur_l_By_i;

    /*For all blocks in the current frame*/
    for (x = 0; x < NB; x++)
    {
        Bx = Ba*x;


        for (y = 0; y < MB; y++)
        {
            vectors_x_cur = 0;
            vectors_y_cur = 0;
                   
            By = Bb*y;       

            bar(4);
            
            bar(2);
            
            bar(1);

            //they should be updated before the xy pair is changed for valid code
            vectors_x[x][y] = vectors_x_cur;
            vectors_y[x][y] = vectors_y_cur;
        }

    }
}

int main()
{
    int current[N][M], previous[N][M], motion_vectors_x[N / Ba][M / Bb],
        motion_vectors_y[N / Ba][M / Bb], i, j;

    struct timeval start, end;

    read_sequence(current, previous);
    gettimeofday(&start, NULL);
    phods_motion_estimation(current, previous, motion_vectors_x, motion_vectors_y);
    gettimeofday(&end, NULL);

//usecond precision through 10^6 mult
    printf("%ld\n", ((end.tv_sec * 1000000 + end.tv_usec)
                     - (start.tv_sec * 1000000 + start.tv_usec)));
    return 0;
}
