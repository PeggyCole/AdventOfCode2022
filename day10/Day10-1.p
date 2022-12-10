etime(yes).   


define variable vcLijn             as character no-undo.
define variable viRegisterValue    as integer   no-undo initial 1.
define variable viCycle           as integer   no-undo.

define variable viCalculateOnCycle as integer   no-undo initial 20.

define variable viTotalRegisterValue    as integer   no-undo.

input from value(search("day10\day10_input")).

repeat 
  on error undo, leave 
  on endkey undo, leave:
       
  import unformatted vcLijn.

  viCycle = viCycle + 1.
    
  if vcLIjn eq "noop" then 
    run CheckCycles (viCycle, input-output viCalculateOnCycle, input viRegisterValue).
  else 
  do:
    run CheckCycles (viCycle, input-output viCalculateOnCycle, input viRegisterValue).
    viCycle = viCycle + 1.
    run CheckCycles (viCycle, input-output viCalculateOnCycle, input viRegisterValue). 
    viRegisterValue = viRegisterValue + int(entry(2, vcLijn, " ")).
  end. 
end.
 
input close.

message viTotalRegisterValue skip etime / 1000 view-as alert-box information.

procedure CheckCycles:
  define input        parameter ipiCycle            as integer     no-undo.
  define input-output parameter iopiCalculateOnCycle as integer     no-undo.
  define input        parameter ipiRegisterValue     as integer     no-undo.
  

  if ipiCycle = iopiCalculateOnCycle then 
    assign
      viTotalRegisterValue = viTotalRegisterValue + (viRegisterValue * iopiCalculateOnCycle)
      iopiCalculateOnCycle = iopiCalculateOnCycle + 40.
  
  
end procedure.

/*
---------------------------
Information (Press HELP to view stack trace)
---------------------------
14780 
,001
---------------------------
OK   Help   
---------------------------

*/