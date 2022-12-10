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
  
  if vcLIjn eq "noop" then 
  do:
    viCycle = viCycle + 1.
    
    run CheckCycles (viCycle, input-output viCalculateOnCycle, input-output viRegisterValue, 0).
  end.
  else 
  do:
    viCycle = viCycle + 1.
    run CheckCycles (viCycle, input-output viCalculateOnCycle, input-output viRegisterValue, 0).
    
    viCycle = viCycle + 1.
    run CheckCycles (viCycle, input-output viCalculateOnCycle, input-output viRegisterValue, int(entry(2, vcLijn, " "))). 
  end. 
end.
 
input close.

message viTotalRegisterValue skip etime / 1000 view-as alert-box information.

procedure CheckCycles:
  define input        parameter ipiCycles            as integer     no-undo.
  define input-output parameter iopiCalculateOnCycle as integer     no-undo.
  define input-output parameter iopiRegisterValue    as integer     no-undo.
  define input        parameter ipiValueToAdd        as integer     no-undo.

  if ipiCycles = iopiCalculateOnCycle then 
  do:
    assign
      viTotalRegisterValue    = viTotalRegisterValue + (iopiRegisterValue * iopiCalculateOnCycle)
      iopiCalculateOnCycle = iopiCalculateOnCycle + 40.
  end.
  
  iopiRegisterValue    = iopiRegisterValue + ipiValueToAdd.
end procedure.

