define temp-table ttRucksack no-undo
  field Compartiment1 as character case-sensitive
  field Compartiment2 as character case-sensitive
  .
  
etime(yes).   
run readFile.
run processData.


procedure readFile:
  define variable vcLijn as character no-undo.
    
  input from value(search("day03\day03_input")).

  repeat 
    on error undo, leave 
    on endkey undo, leave:
       
    import unformatted vcLijn.
  
    create ttRucksack.
    assign
      ttRucksack.Compartiment1 = substring(vcLijn, 1, int(length(vcLijn) / 2))
      ttRucksack.Compartiment2 = substring(vcLijn, int(length(vcLijn) / 2) + 1)
      .
  end.

  input close.
end procedure.

procedure processData:
  define variable viTotalPriority as integer   no-undo.
  define variable viPosition1     as integer   no-undo.
  define variable vcPosition1     as character no-undo case-sensitive.
  define variable vcABCList       as character no-undo case-sensitive initial "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ":u.
  
  for each ttRucksack no-lock :
    do viPosition1 = 1 to length(ttRuckSack.Compartiment1):
      vcPosition1 = substring(ttRuckSack.Compartiment1, viPosition1, 1).
      
      if ttRuckSack.Compartiment2 matches "*" + vcPosition1 + "*":u then 
      do:
        viTotalPriority = viTotalPriority + index(vcABCList, vcPosition1).
        
        viPosition1 = length(ttRuckSack.Compartiment1) + 1. 
      end.
      
    end.      
  end.
  
  message viTotalPriority skip etime / 1000
    view-as alert-box information.
end procedure.

