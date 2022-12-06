
define variable vlcInput    as longchar no-undo.
define variable viInput     as integer  no-undo.
define variable vlFoundSame as logical  no-undo.

copy-lob file search("day06\day06_input") to vlcInput.

do viInput = 1 to length(vlcInput):
  vlFoundSame = false.
  run CheckDiffs (substring(vlcInput, viInput, 14), 1, input-output vlFoundSame).
  if not vlFoundSame then do: 
    message "Marker: " viInput + 13 view-as alert-box info.
    
    leave. 
  end.
end.  

procedure CheckDiffs:
  define input        parameter ipcToCheck as character   no-undo.
  define input        parameter ipiStart   as integer     no-undo.
  define input-output       parameter ioplFoundSame as logical     no-undo.
  
  if ioplFoundSame = true then return.
  
  define variable viMain as integer no-undo.
  define variable viSub  as integer no-undo.
  
  do viMain = ipiStart to length(ipcToCheck):
    do viSub = viMain + 1 to length(ipcToCheck):
      if substring(ipcToCheck, viMain, 1) = substring(ipcToCheck, viSub, 1) then do:
        assign
          ioplFoundSame = true
          viSub         = length(ipcToCheck) + 1
          viMain        = length(ipcToCheck) + 1.
      end.
    end.
    
    if not ioplFoundSame and viMain + 1 < length(ipcToCheck) then 
    do:
      run CheckDiffs (ipcToCheck, viMain + 1, input-output ioplFoundSame).
    end.  
  end.   
  

end procedure.