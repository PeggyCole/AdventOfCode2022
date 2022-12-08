define temp-table ttTree no-undo
  field ttColumn         as integer
  field ttRow       as integer
  field ttHeight      as integer
  field ttScenicScore as integer
  index IE1 ttColumn
  index IE2 ttRow .  
  
define variable viMaxColumn    as integer no-undo.
define variable viMaxRow  as integer no-undo.  
  
etime(yes).   
run readFile.
run processData.


procedure readFile:
  define variable vcLijn   as character no-undo.

  define variable viColumn    as integer   no-undo.
  define variable viRow  as integer   no-undo.
  
    
  input from value(search("day08\day08_input")).

  repeat 
    on error undo, leave 
    on endkey undo, leave:
       
    import unformatted vcLijn.
    
    viRow  = viRow  + 1.
  
    do viColumn = 1 to length(vcLijn):
      
      create ttTree.
      assign 
        ttTree.ttColumn    = viColumn
        ttTree.ttRow  = viRow 
        ttTree.ttHeight = int(substring(vcLijn, viColumn, 1))
        .          
    end.     
    
    if viMaxColumn < length(vcLijn) then
      viMaxColumn = length(vcLijn). 
  end.
  
  viMaxRow  = viRow . 

  input close.
  

end procedure.

procedure processData:
  define buffer ttTreeSearch for ttTree.
  
  define variable viMaxScenicScore as integer no-undo.
  
  define variable viScoreLeft      as integer no-undo.
  define variable viScoreRight     as integer no-undo.
  define variable viScoreTop       as integer no-undo.
  define variable viScoreBottom    as integer no-undo.
  define variable viPrev           as integer no-undo.
  
  for each ttTree no-lock:
    // Top
    viScoreTop = 0. 
    for each ttTreeSearch no-lock
      where ttTreeSearch.ttColumn = ttTree.ttColumn
      and ttTreeSearch.ttRow  < ttTree.ttRow 
      by ttTreeSearch.ttRow  desc:
      viScoreTop = viScoreTop + 1. 
      if ttTreeSearch.ttHeight >= ttTree.ttHeight then leave. 
    end.  
      
    // Left Side
    viScoreLeft = 0.
    for each ttTreeSearch no-lock
      where ttTreeSearch.ttColumn < ttTree.ttColumn
      and ttTreeSearch.ttRow  = ttTree.ttRow 
      by ttTreeSearch.ttColumn descending:
      
      viScoreLeft = viScoreLeft + 1.
      if ttTreeSearch.ttHeight >= ttTree.ttHeight then leave.  
    end.
      
    // Bottom
    viScoreBottom = 0.
    for each  ttTreeSearch no-lock
      where ttTreeSearch.ttColumn = ttTree.ttColumn
      and ttTreeSearch.ttRow  > ttTree.ttRow 
      by ttTreeSearch.ttRow  :
      
      viScoreBottom = viScoreBottom + 1.
      if ttTreeSearch.ttHeight >= ttTree.ttHeight then leave. 
    end.

    // Right Side      
    viScoreRight = 0.
    viPrev = 999.
    for each ttTreeSearch no-lock
      where ttTreeSearch.ttColumn > ttTree.ttColumn
      and ttTreeSearch.ttRow  = ttTree.ttRow 
      by ttTreeSearch.ttColumn:
        
      viScoreRight = viScoreRight + 1.   
      if ttTreeSearch.ttHeight >= ttTree.ttHeight then leave. 
    end.
      
    if viMaxScenicScore < (viScoreLeft * viScoreRight * viScoreTop * viScoreBottom) then
      viMaxScenicScore = (viScoreLeft * viScoreRight * viScoreTop * viScoreBottom).
    
  end.  
    
  message viMaxScenicScore skip etime / 1000
    view-as alert-box information.
end procedure.

/*
---------------------------
Information (Press HELP to view stack trace)
---------------------------
331344 
3,98
---------------------------
OK   Help   
---------------------------


*/