define temp-table ttTree no-undo
  field ttColumn     as integer
  field ttRow  as integer
  field ttHeight  as integer
  index IE1 ttColumn
  index IE2 ttRow.  
  
define variable viMaxColumn    as integer no-undo.
define variable viMaxRow as integer no-undo.  
  
etime(yes).   
run readFile.
run processData.


procedure readFile:
  define variable vcLijn   as character no-undo.

  define variable viColumn    as integer   no-undo.
  define variable viRow as integer   no-undo.
  
    
  input from value(search("day08\day08_input")).

  repeat 
    on error undo, leave 
    on endkey undo, leave:
       
    import unformatted vcLijn.
    
    viRow = viRow + 1.
  
    do viColumn = 1 to length(vcLijn):
      
      create ttTree.
      assign 
        ttTree.ttColumn    = viColumn
        ttTree.ttRow = viRow
        ttTree.ttHeight = int(substring(vcLijn, viColumn, 1))
        .          
    end.     
    
    if viMaxColumn < length(vcLijn) then
      viMaxColumn = length(vcLijn). 
  end.
  
  viMaxRow = viRow. 

  input close.
  

end procedure.

procedure processData:
  define buffer ttTreeSearch for ttTree.
  
  define variable viVisible  as integer no-undo.
  define variable vlVisible  as logical no-undo.
  
  for each ttTree no-lock:
    
    vlVisible = no.
    
    if ttTree.ttColumn = 1 
      or ttTree.ttRow = 1 
      or ttTree.ttColumn = viMaxColumn
      or ttTree.ttRow = viMaxRow
      then 
    do:
      vlVisible = true.  
    end.  
    else 
    do:
      // Top
      find first ttTreeSearch no-lock
        where ttTreeSearch.ttColumn = ttTree.ttColumn
        and ttTreeSearch.ttRow < ttTree.ttRow
        and ttTreeSearch.ttHeight >= ttTree.ttHeight
        no-error.
      if not available ttTreeSearch then vlVisible = true. 
      
      
      if not vlVisible then 
      do:
      // Left side
        find first ttTreeSearch no-lock
          where ttTreeSearch.ttColumn < ttTree.ttColumn
          and ttTreeSearch.ttRow = ttTree.ttRow
          and ttTreeSearch.ttHeight >= ttTree.ttHeight
          no-error.
        if not available ttTreeSearch then vlVisible = true. 
      end.
      
      if not vlVisible then 
      do:
      // Bottom
        find first ttTreeSearch no-lock
          where ttTreeSearch.ttColumn = ttTree.ttColumn
          and ttTreeSearch.ttRow > ttTree.ttRow
          and ttTreeSearch.ttHeight >= ttTree.ttHeight
          no-error.
        if not available ttTreeSearch then vlVisible = true. 
      end.
 
      if not vlVisible then 
      do:
      // Right side
        find first ttTreeSearch no-lock
          where ttTreeSearch.ttColumn > ttTree.ttColumn
          and ttTreeSearch.ttRow = ttTree.ttRow
          and ttTreeSearch.ttHeight >= ttTree.ttHeight
          no-error.
        if not available ttTreeSearch then vlVisible = true.
      end.
      
    end.
    
    if vlVisible then 
      viVisible = viVisible + 1.
  
  end.  
  
    
  message viVisible skip etime / 1000
    view-as alert-box information.
end procedure.

/*


*/