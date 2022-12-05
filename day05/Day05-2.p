define temp-table ttMove no-undo
  field NumberToMove as integer
  field FromStack    as integer
  field ToStack      as integer
  .
  
define temp-table ttStack no-undo
  field StackId    as integer
  field SequenceId as integer
  field CrateId    as character
  .  
  
etime(yes).   
run readFile.
run processData.


procedure readFile:
  define variable vcLijn        as character no-undo.
  define variable vlMoves       as logical   no-undo.
  define variable viStack       as integer   no-undo.
  
  define buffer bttStack for ttStack.
    
  input from value(search("day05\day05_input")).

  repeat 
    on error undo, leave 
    on endkey undo, leave:
       
    import unformatted vcLijn.
  
    if trim(vcLijn) begins "1" then 
    do:
      vlMoves = true.
      import unformatted vcLijn.
      import unformatted vcLijn.
    end.
   
    if vlMoves then 
    do:
      create ttMove.
      assign 
        ttMove.NumberToMove = int(entry(2, vcLijn, " ":u))
        ttMove.FromStack    = int(entry(4, vcLijn, " ":u))
        ttMove.ToStack      = int(entry(6, vcLijn, " ":u))
        .     
    end.
    else 
    do:
      vcLijn = vcLijn + " ".
      do viStack = 1 to length(vcLijn) by 4:
        if substring(vcLijn, viStack, 3) matches "[*]" then 
        do:
          create ttStack.
          assign
            ttStack.StackId = (if viStack = 1 then 1 else ((viStack - 1) / 4) + 1)
            ttStack.CrateId = substring(trim(substring(vcLijn, viStack, 3)), 2, 1).
          
          for each bttstack no-lock
            where bttStack.StackId = ttStack.Stackid
            and bttStack.SequenceId <> 0 
            by bttStack.SequenceId descending:   
            ttStack.SequenceId = bttStack.SequenceId + 1.
            
            leave.
          end. 
          if ttStack.SequenceId = 0 then ttStack.SequenceId = 1.  
        end.
      end.   
    end. 
     
  end.

  input close.

end procedure.

procedure processData:
  define buffer ttStackFrom for ttStack.
  define buffer ttStackTo   for ttStack.
  
  define variable viToMove as integer   no-undo.
  define variable vcResult as character no-undo.
  
  for each ttMove no-lock :
    for each ttStackTo exclusive-lock
      where ttStackTo.StackId = ttMove.TOStack:
      ttStackTo.SequenceId = ttStackTo.SequenceId + ttMove.NumberToMove.     
    end.
  
    do viToMOve = 1 to ttMove.NumberToMove:
      for each ttStackFrom exclusive-lock
        where ttStackFrom.StackId = ttMove.FromStack
        by ttStackFrom.SequenceId:
 
        assign
          ttStackFrom.StackId    = ttMove.ToStack
          ttStackFrom.SequenceId = viToMOve. 
        leave.
      end.      
    end.
    
    for each ttStackFrom exclusive-lock
      where ttStackFrom.StackId = ttMove.FromStack:
      ttStackFrom.SequenceId = ttStackFrom.SequenceId - ttMove.NumberToMove.     
    end.
  end.
  
  for each ttStack no-lock
    where ttStack.Sequenceid = 1
    by ttStack.StackId :
    vcResult = vcResult + ttStack.CrateId.   
  end.      
  message vcResult skip etime / 1000
    view-as alert-box information.
end procedure.

/*
---------------------------
Information (Press HELP to view stack trace)
---------------------------
LCTQFBVZV 
,179
---------------------------
OK   Help   
---------------------------

*/