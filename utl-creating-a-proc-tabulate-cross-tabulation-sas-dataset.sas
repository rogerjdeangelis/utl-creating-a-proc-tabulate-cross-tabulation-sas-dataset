%let pgm=utl-creating-a-proc-tabulate-cross-tabulation-sas-dataset;

%stop_submission;

Creating a proc tabulate cross tabulation sas dataset

Once you have the dataset you can easyly create a fromatted output.

github
https://tinyurl.com/r3s8f5fy
https://github.com/rogerjdeangelis/utl-creating-a-proc-tabulate-cross-tabulation-sas-dataset

SOAPBOX ON
  One of the nice things about proc tabulate is the formatting
  options. It is fairly easy to make pro tabulate look like
  a retangular sas dataset, which can be imported by
  proc import.
SOAPBOX OFF

communities.sas
https://tinyurl.com/3xnm7yyd
https://communities.sas.com/t5/New-SAS-User/Cross-tabulation/m-p/788067#M32353

/**************************************************************************************************************************/
/*                INPUT                | PROCESS               h                      |        OUTPUT                     */
/*                 ====                | =======                                      |        ======                     */
/* SEX YEAR GROUP COND REGION          |STEPS                                         | WORK.WANT                         */
/*                                     | 1 set ods listing file=                      |                                   */
/*  1  2015   1     1  North           | 2 set formchar=','                           |              N   PCT    N   PCT   */
/*  0  2015   2     1  North           |   remove as headings                         | HEADER VAL  2015 2015  2016 2016  */
/*  0  2015   3     1  South           |   tag rts variable wit @                     |                                   */
/*  1  2015   1     1  South           | 3 use title to get colnames                  | sex          0     0     0    0   */
/*  0  2015   2     1  South           | 4 proc import                                |        0     3   50.00   1  33.33 */
/*  1  2015   3     1  East            |   set dmbs=csv                               |        1     3   50.00   2  66.67 */
/*  1  2016   1     1  East            |   datarow=4                                  | Region       0     0     0    0   */
/*  1  2016   2     1  East            |                                              |        East  1   16.67   2  66.67 */
/*  0  2016   3     1  North           | %utlfkil(d:/txt/tab.txt)                     |        North 2   33.33   1  33.33 */
/*                                     |                                              |        South 3   50.00   0   0.00 */
/*                                     |                                              | Group        0     0     0    0   */
/* ----------------------------------- | ods exclude all;                             |        1     2   33.33   1  33.33 */
/* |       |           YEAR          | | ods listing                                  |        2     2   33.33   1  33.33 */
/* |       |-------------------------| |   file="d:/txt/tab.txt";                     |        3     2   33.33   1  33.33 */
/* |       |    2015     |   2016    | |                                              | Cond         0     0     0    0   */
/* |       |------------+------------| | options                                      |        1     6  100.00   3 100.00 */
/* |       |   N |ColPct|  N  |ColPct| |    missing=0                                 |                                   */
/* |-------+-----+------+-----+------| |    formchar=","                              |                                   */
/* |SEX    |     |      |     |      | |    ls=255;                                   |                                   */
/* |-------|     |      |     |      | |                                              |                                   */
/* |0      | 3.00| 50.00| 1.00| 33.33| | proc tabulate                                |                                   */
/* |-------+-----+------+-----+------| |   data=have;                                 |                                   */
/* |1      | 3.00| 50.00| 2.00| 66.67| |   title "Header,Val                          |                                   */
/* |-------+-----+------+-----+------| |         ,n_2015,pct_2015                     |                                   */
/* |REGION |     |      |     |      | |         ,n_2016,pct_2016                     |                                   */
/* |-------|     |      |     |      | |         ,zz2";                               |                                   */
/* |East   | 1.00| 16.67| 2.00| 66.67| |    class Sex                                 |                                   */
/* |-------+-----+------+-----+------| |          Year                                |                                   */
/* |North  | 2.00| 33.33| 1.00| 33.33| |          Region                              |                                   */
/* |-------+-----+------+-----+------| |          Group                               |                                   */
/* |South  | 3.00| 50.00|    0|     0| |          Cond;                               |                                   */
/* |-------+-----+------+-----+------| |    table                                     |                                   */
/* |GROUP  |     |      |     |      | |       Sex="@sex"                             |                                   */
/* |-------|     |      |     |      | |       Region="@Region"                       |                                   */
/* |1      | 2.00| 33.33| 1.00| 33.33| |       Group="@Group"                         |                                   */
/* |-------+-----+------+-----+------| |       Cond="@Cond"                           |                                   */
/* |2      | 2.00| 33.33| 1.00| 33.33| |      ,Year=""*(n="" colpctn="")              |                                   */
/* |-------+-----+------+-----+------| |    /rts=12;                                  |                                   */
/* |3      | 2.00| 33.33| 1.00| 33.33| | run;quit;                                    |                                   */
/* |-------+-----+------+-----+------| |                                              |                                   */
/* |COND   |     |      |     |      | |INTERMEDIATE TEXT FILE                        |                                   */
/* |-------|     |      |     |      | | ======================                       |                                   */
/* |1      | 6.00|100.00| 3.00| 00.00| |                                              |                                   */
/* ----------------------------------- |Header,Val,n_2015,pct_2015,n_2016,pct_2016,z2 |                                   */
/*                                     |                                              |                                   */
/* data have;                          |                                              |                                   */
/* format                              | ,          , 2015 , 2016 ,                   |                                   */
/*    Sex 1.                           |                                              |                                   */
/*    Year 4.                          | ,@sex      , , , , ,                         |                                   */
/*    Group 4.                         |            , , , ,                           |                                   */
/*    Cond 4.                          | ,0         , 3.00, 50.00, 1.00, 33.33,       |                                   */
/*    Region $6.;                      |                                              |                                   */
/* input Sex                           | ,1         , 3.00, 50.00, 2.00, 66.67,       |                                   */
/*    Year                             |                                              |                                   */
/*    Group                            | ,@Region   , , , , ,                         |                                   */
/*    Cond                             |            , , , ,                           |                                   */
/*    Region;                          | ,East      , 1.00, 16.67, 2.00, 66.67,       |                                   */
/* cards4;                             |                                              |                                   */
/* 1 2015 1 1 North                    | ,North     , 2.00, 33.33, 1.00, 33.33,       |                                   */
/* 0 2015 2 1 North                    |                                              |                                   */
/* 0 2015 3 1 South                    | ,South     , 3.00, 50.00, 0, 0,              |                                   */
/* 1 2015 1 1 South                    |                                              |                                   */
/* 0 2015 2 1 South                    | ,@Group    , , , , ,                         |                                   */
/* 1 2015 3 1 East                     |            , , , ,                           |                                   */
/* 1 2016 1 1 East                     | ,1         , 2.00, 33.33, 1.00, 33.33,       |                                   */
/* 1 2016 2 1 East                     |                                              |                                   */
/* 0 2016 3 1 North                    | ,2         , 2.00, 33.33, 1.00, 33.33,       |                                   */
/* ;;;;                                |                                              |                                   */
/* run;quit;                           | ,3         , 2.00, 33.33, 1.00, 33.33,       |                                   */
/*                                     |                                              |                                   */
/*                                     | ,@Cond     , , , , ,                         |                                   */
/*                                     |            , , , ,                           |                                   */
/* ods html close;                     | ,1         , 6.00, 100.00, 3.00, 100.00,     |                                   */
/* ods select all;                     |                                              |                                   */
/* ods listing                         |                                              |                                   */
/*   file="d:/txt/tab.txt";            | ods listing;                                 |                                   */
/*                                     |                                              |                                   */
/* options                             | proc import                                  |                                   */
/*    missing=0                        |  datafile=                                   |                                   */
/*    formchar=","                     |   "d:/txt/tab.txt"                           |                                   */
/*    ls=255;                          |  dbms=csv                                    |                                   */
/*                                     |  out=prewant                                 |                                   */
/* proc tabulate                       |  replace;                                    |                                   */
/*   data=have;                        |  getnames=YES;                               |                                   */
/*   title "Header,Val                 |  datarow=4;                                  |                                   */
/*         ,n_2015,pct_2015            | run;quit;                                    |                                   */
/*         ,n_2016,pct_2016            |                                              |                                   */
/*         ,zz2";                      | PROC IMPORT OUTPUT                           |                                   */
/*    class Sex                        | ==================                           |                                   */
/*          Year                       |                                              |                                   */
/*          Region                     |              N      PCT      N    PCT        |                                   */
/*          Group                      | HDR VAL     2015   2015    2016   2016 ZZ2   |                                   */
/*          Cond;                      |                                              |                                   */
/*    table                            |            2015   2016.00    0     0         |                                   */
/*       Sex="@sex"                    |               0       0      0     0         |                                   */
/*       Region="@Region"              |     @sex      0       0      0     0         |                                   */
/*       Group="@Group"                |               0       0      0     0         |                                   */
/*       Cond="@Cond"                  |     0         3     50.00    1   33.33       |                                   */
/*      ,Year=""*(n="" colpctn="")     |               0       0      0     0         |                                   */
/*    /rts=12;                         |     1         3     50.00    2   66.67       |                                   */
/* run;quit;                           |               0       0      0     0         |                                   */
/*                                     |     @Region   0       0      0     0         |                                   */
/* ods listing;                        |               0       0      0     0         |                                   */
/*                                     |     East      1     16.67    2   66.67       |                                   */
/*-------------------------------------|               0       0      0     0         |                                   */
/*                                     |     North     2     33.33    1   33.33       |                                   */
/* DISPLAY INPUT WITH FULL FORMCHAR    |               0       0      0     0         |                                   */
/*                                     |     South     3     50.00    0    0.00       |                                   */
/* options                             |               0       0      0     0         |                                   */
/*  FORMCHAR='|----|+|---+=|-/\<>*';   |     @Group    0       0      0     0         |                                   */
/* proc tabulate data=have;            |               0       0      0     0         |                                   */
/*   class                             |     1         2     33.33    1   33.33       |                                   */
/*      Sex                            |               0       0      0     0         |                                   */
/*      Year                           |     2         2     33.33    1   33.33       |                                   */
/*      Region                         |               0       0      0     0         |                                   */
/*      Group                          |     3         2     33.33    1   33.33       |                                   */
/*      Cond;                          |               0       0      0     0         |                                   */
/*   table                             |     @Cond     0       0      0     0         |                                   */
/*      Sex                            |               0       0      0     0         |                                   */
/*      Region                         |     1         6    100.00    3  100.00       |                                   */
/*      Group                          |               0       0      0     0         |                                   */
/*      Cond                           |                                              |                                   */
/*     ,Year*(n colpctn)/rts=9;        |     FINAL CLEANUP                            |                                   */
/* run;                                |                                              |                                   */
/*                                     |     data want;                               |                                   */
/*                                     |      length header $12;                      |                                   */
/*                                     |       if left(val) ne "";                    |                                   */
/*                                     |       if left(val)=:"@" then do;             |                                   */
/*                                     |           header=substr(val,2);              |                                   */
/*                                     |           val="";                            |                                   */
/*                                     |                                              |                                   */
/*                                     |       drop zz:;                              |                                   */
/*                                     |     run;quit;                                |                                   */
/*                                     |                                              |                                   */
/*                                     |                  N   PCT    N    PCT         |                                   */
/*                                     |     HEADER VAL  2015 2015  2016  2016        |                                   */
/*                                     |                                              |                                   */
/*                                     |     sex          0     0     0     0         |                                   */
/*                                     |            0     3   50.00   1   33.33       |                                   */
/*                                     |            1     3   50.00   2   66.67       |                                   */
/*                                     |     Region       0     0     0     0         |                                   */
/*                                     |            East  1   16.67   2   66.67       |                                   */
/*                                     |            North 2   33.33   1   33.33       |                                   */
/*                                     |            South 3   50.00   0    0.00       |                                   */
/*                                     |     Group        0     0     0     0         |                                   */
/*                                     |            1     2   33.33   1   33.33       |                                   */
/*                                     |            2     2   33.33   1   33.33       |                                   */
/*                                     |            3     2   33.33   1   33.33       |                                   */
/*                                     |     Cond         0     0     0     0         |                                   */
/*                                     |            1     6  100.00   3  100.00       |                                   */
/*                                     |                                              |                                   */
/*                                     |                                              |                                   */
/*                                     |                                              |                                   */
/*                                     |                                              |                                   */
/*                                     |                                              |                                   */
/*                                     |                                              |                                   */
/*                                     |                                              |                                   */
/*                                     |                                              |                                   */
/*                                     |                                              |                                   */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

data have;
format
   Sex 1.
   Year 4.
   Group 4.
   Cond 4.
   Region $6.;
input Sex
   Year
   Group
   Cond
   Region;
cards4;
1 2015 1 1 North
0 2015 2 1 North
0 2015 3 1 South
1 2015 1 1 South
0 2015 2 1 South
1 2015 3 1 East
1 2016 1 1 East
1 2016 2 1 East
0 2016 3 1 North
;;;;
run;quit;

/**************************************************************************************************************************/
/* SEX YEAR GROUP COND REGION                                                                                             */
/*                                                                                                                        */
/*  1  2015   1     1  North                                                                                              */
/*  0  2015   2     1  North                                                                                              */
/*  0  2015   3     1  South                                                                                              */
/*  1  2015   1     1  South                                                                                              */
/*  0  2015   2     1  South                                                                                              */
/*  1  2015   3     1  East                                                                                               */
/*  1  2016   1     1  East                                                                                               */
/*  1  2016   2     1  East                                                                                               */
/*  0  2016   3     1  North                                                                                              */
/**************************************************************************************************************************/

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

/*---- tabulate output to a file ----*/

ods html close;
ods listing
  file="d:/txt/tab.txt";

options
   missing=0
   formchar=","
   ls=255;

proc tabulate
  data=have;
  title "Header,Val
        ,n_2015,pct_2015
        ,n_2016,pct_2016
        ,zz2";
   class Sex
         Year
         Region
         Group
         Cond;
   table
      Sex="@sex"
      Region="@Region"
      Group="@Group"
      Cond="@Cond"
     ,Year=""*(n="" colpctn="")
   /rts=12;
run;quit;

/*---- create sas dataset ----*/

ods listing;

proc import
 datafile=
  "d:/txt/tab.txt"
 dbms=csv
 out=prewant
 replace;
 getnames=YES;
 datarow=4;
run;quit;

/*---- minor cleanup ----*/

data want;
 length header $12;
 set prewant;
  if left(val) ne "";
  if left(val)=:"@" then do;
      header=substr(val,2);
      val="";
  end;
  drop zz:;
run;quit;

/**************************************************************************************************************************/
/*   TABULATE OUTPUT                                                                                                      */
/*   ==============                                                                                                       */
/*                                                                                                                        */
/*   d:/txt/tab.txt                                                                                                       */
/*                                                                                                                        */
/*   Header,Val        ,n_2015,pct_2015        ,n_2016,pct_2016        ,zz2                                               */
/*                                                                                                                        */
/*                                                                                                                        */
/*   ,          ,          2015           ,          2016           ,                                                     */
/*                                                                                                                        */
/*   ,@sex      ,            ,            ,            ,            ,                                                     */
/*                           ,            ,            ,            ,                                                     */
/*   ,0         ,        3.00,       50.00,        1.00,       33.33,                                                     */
/*                                                                                                                        */
/*   ,1         ,        3.00,       50.00,        2.00,       66.67,                                                     */
/*                                                                                                                        */
/*   ,@Region   ,            ,            ,            ,            ,                                                     */
/*                           ,            ,            ,            ,                                                     */
/*   ,East      ,        1.00,       16.67,        2.00,       66.67,                                                     */
/*                                                                                                                        */
/*   ,North     ,        2.00,       33.33,        1.00,       33.33,                                                     */
/*                                                                                                                        */
/*   ,South     ,        3.00,       50.00,           0,           0,                                                     */
/*                                                                                                                        */
/*   ,@Group    ,            ,            ,            ,            ,                                                     */
/*                           ,            ,            ,            ,                                                     */
/*   ,1         ,        2.00,       33.33,        1.00,       33.33,                                                     */
/*                                                                                                                        */
/*   ,2         ,        2.00,       33.33,        1.00,       33.33,                                                     */
/*                                                                                                                        */
/*   ,3         ,        2.00,       33.33,        1.00,       33.33,                                                     */
/*                                                                                                                        */
/*   ,@Cond     ,            ,            ,            ,            ,                                                     */
/*                           ,            ,            ,            ,                                                     */
/*   ,1         ,        6.00,      100.00,        3.00,      100.00,                                                     */
/*                                                                                                                        */
/*------------------------------------------------------------------------------------------------------------------------*/
/*                                                                                                                        */
/*   PROC IMPORT OUTPUT WORK.PREWANT                                                                                      */
/*   ===============================                                                                                      */
/*                                                                                                                        */
/*   WORK.PREWANT obs=28                                                                                                  */
/*                                                                                                                        */
/*   Obs    HEADER    VAL        N_2015    PCT_2015    N_2016    PCT_2016    ZZ2                                          */
/*                                                                                                                        */
/*     1                          2015      2016.00       0          0                                                    */
/*     2                             0          0         0          0                                                    */
/*     3              @sex           0          0         0          0                                                    */
/*     4                             0          0         0          0                                                    */
/*     5              0              3        50.00       1        33.33                                                  */
/*     6                             0          0         0          0                                                    */
/*     7              1              3        50.00       2        66.67                                                  */
/*     8                             0          0         0          0                                                    */
/*     9              @Region        0          0         0          0                                                    */
/*    10                             0          0         0          0                                                    */
/*    11              East           1        16.67       2        66.67                                                  */
/*    12                             0          0         0          0                                                    */
/*    13              North          2        33.33       1        33.33                                                  */
/*    14                             0          0         0          0                                                    */
/*    15              South          3        50.00       0         0.00                                                  */
/*    16                             0          0         0          0                                                    */
/*    17              @Group         0          0         0          0                                                    */
/*    18                             0          0         0          0                                                    */
/*    19              1              2        33.33       1        33.33                                                  */
/*    20                             0          0         0          0                                                    */
/*    21              2              2        33.33       1        33.33                                                  */
/*    22                             0          0         0          0                                                    */
/*    23              3              2        33.33       1        33.33                                                  */
/*    24                             0          0         0          0                                                    */
/*    25              @Cond          0          0         0          0                                                    */
/*    26                             0          0         0          0                                                    */
/*    27              1              6       100.00       3       100.00                                                  */
/*    28                             0          0         0          0                                                    */
/*                                                                                                                        */
/*------------------------------------------------------------------------------------------------------------------------*/
/*                                                                                                                        */
/*   FINAL OUTPUT                                                                                                         */
/*   ============                                                                                                         */
/*                                                                                                                        */
/*    WORK.WANT total obs=13                                                                                              */
/*                                                                                                                        */
/*    Obs    HEADER    VAL      N_2015    PCT_2015    N_2016    PCT_2016                                                  */
/*                                                                                                                        */
/*      1    sex                   0          0          0          0                                                     */
/*      2              0           3        50.00        1        33.33                                                   */
/*      3              1           3        50.00        2        66.67                                                   */
/*      4    Region                0          0          0          0                                                     */
/*      5              East        1        16.67        2        66.67                                                   */
/*      6              North       2        33.33        1        33.33                                                   */
/*      7              South       3        50.00        0         0.00                                                   */
/*      8    Group                 0          0          0          0                                                     */
/*      9              1           2        33.33        1        33.33                                                   */
/*     10              2           2        33.33        1        33.33                                                   */
/*     11              3           2        33.33        1        33.33                                                   */
/*     12    Cond                  0          0          0          0                                                     */
/*     13              1           6       100.00        3       100.00                                                   */
/**************************************************************************************************************************/

 /*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
