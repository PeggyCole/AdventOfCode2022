etime(yes).   

define variable vcLijn          as character no-undo.
define variable viRegisterValue as integer   no-undo initial 1.
define variable viCycle         as integer   no-undo.
define variable vcOutput        as character no-undo extent 15000.
define variable vi              as integer   no-undo.

input from value(search("day10\day10_input")).

repeat 
  on error undo, leave 
  on endkey undo, leave:
       
  import unformatted vcLijn.
  
  viCycle = viCycle + 1.
    
  if vcLIjn eq "noop" then 
    run CheckCycles (viCycle, viRegisterValue).
  else 
  do:
    run CheckCycles (viCycle, viRegisterValue).
    viCycle = viCycle + 1.
    run CheckCycles (viCycle, viRegisterValue). 
    
    viRegisterValue = viRegisterValue + int(entry(2, vcLijn, " ")).
  end. 
end.
 
input close.

output to value("c:\temp\output.txt").
do vi = 1 to viCycle:
  if vcOutput[vi] = "" then
    put unformatted ".". 
  else
    put unformatted vcOutput[vi].
    
  if vi mod 40 = 0 then put unformatted skip.
end.
output close.
os-command silent value("c:\temp\output.txt").

message etime / 1000 view-as alert-box information.

procedure CheckCycles:
  define input parameter ipiCycle         as integer     no-undo.
  define input parameter ipiRegisterValue  as integer     no-undo.
  
  define variable viCompareTo as integer no-undo.
  
  viCompareTo = (ipiCycle mod 40) - 1.
  
  if viRegisterValue = viCompareTo 
    or viRegisterValue - 1 = viCompareTo
    or viRegisterValue + 1 = viCompareTo then 
    vcOutput[ipiCycle] = "#". 
  
end procedure.


/*
####.#....###..#....####..##..####.#...#
#....#....#..#.#.......#.#..#....#.#....
###..#....#..#.#......#..#......#..#....
#....#....###..#.....#...#.##..#...#...#
#....#....#....#....#....#..#.#....#....
####.####.#....####.####..###.####.####.

*/
