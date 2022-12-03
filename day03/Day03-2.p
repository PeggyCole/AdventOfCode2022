define temp-table ttGroup no-undo
  field Elve1 as character case-sensitive
  field Elve2 as character case-sensitive
  field Elve3 as character case-sensitive
  .
  
etime(yes).  
run readFile.
run processData.


procedure readFile:
  input from value(search("day03\day03_input")).

  repeat 
    on error undo, leave 
    on endkey undo, leave:
       
    create ttGroup.
    
    import unformatted ttGroup.Elve1.  
    import unformatted ttGroup.Elve2.
    import unformatted ttGroup.Elve3.
    
  end.

  input close.
end procedure.

procedure processData:
  define variable viTotalPriority as integer   no-undo.
  define variable viPosition1     as integer   no-undo.
  define variable vcPosition1     as character no-undo case-sensitive.
  define variable vcABCList       as character no-undo case-sensitive initial "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ":u.
  
  for each ttGroup no-lock :
    do viPosition1 = 1 to length(ttGroup.Elve1):
      vcPosition1 = substring(ttGroup.Elve1, viPosition1, 1).
      
      if ttGroup.Elve2 matches "*" + vcPosition1 + "*":u 
        and ttGroup.Elve3 matches "*" + vcPosition1 + "*":u
        then 
      do:
        viTotalPriority = viTotalPriority + index(vcABCList, vcPosition1).
        
        viPosition1 = length(ttGroup.Elve1) + 1. 
      end.
    end.      
  end.
  
  message viTotalPriority skip etime / 1000
    view-as alert-box information.
end procedure.

