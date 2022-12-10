etime(yes).   

define temp-table ttVisitedByTail no-undo
  field PositionX as integer 
  field PositionY as integer
  index PK as primary unique PositionX PositionY.
  
define temp-table ttKnot no-undo
  field KnotId    as integer
  field PositionX as integer 
  field PositionY as integer
  index PK as primary unique KnotId.
  

define variable vcLijn          as character no-undo.
define variable viStep          as integer   no-undo.
define variable viKnot          as integer   no-undo.
define variable viVisitedByTail as integer   no-undo.

define variable viPrevKnotX     as integer   no-undo.
define variable viPrevKnotY     as integer   no-undo.

define variable viNumKnots      as integer   no-undo initial 10.

do viKnot = 1 to viNumKnots:
  create ttKnot.
  assign
    ttKnot.KnotId    = viKnot
    ttKnot.PositionX = 1
    ttKnot.PositionY = 1. 
end.

create ttVisitedByTail.
assign
  ttVisitedByTail.PositionX = 1
  ttVisitedByTail.PositionY = 1.
  
input from value(search("day09\day09_input")).

repeat 
  on error undo, leave 
  on endkey undo, leave:
       
  import unformatted vcLijn.
  
  do viStep = 1 to int(entry(2, vcLIjn, " ":u)):
    
    find ttKnot exclusive-lock
      where ttKnot.KnotId = 1
      no-error.
       
    case entry(1, vcLijn, " "):
      when "R" then 
        ttKnot.PositionX = ttKnot.PositionX + 1.        
      when "U" then 
        ttKnot.PositionY = ttKnot.PositionY - 1.
      when "L" then 
        ttKnot.PositionX = ttKnot.PositionX - 1. 
      when "D" then 
        ttKnot.PositionY = ttKnot.PositionY + 1. 
    end case.
    
    assign
      viPrevKnotX = ttKnot.PositionX
      viPrevKnotY = ttKnot.PositionY.
    
    for each ttKnot exclusive-lock 
      where ttKnot.KnotId > 1 
      by ttKnot.KnotId:
        
      if viPrevKnotY = ttKnot.PositionY and abs(viPrevKnotX - ttKnot.PositionX) = 2 then 
      do:
        if viPrevKnotX > ttKnot.PositionX then 
          ttKnot.PositionX = ttKnot.PositionX + 1.
        else
          ttKnot.PositionX = ttKnot.PositionX - 1.
      end.
      
      if viPrevKnotX = ttKnot.PositionX and abs(viPrevKnotY - ttKnot.PositionY) = 2 then 
      do:
        if viPrevKnotY > ttKnot.PositionY then 
          ttKnot.PositionY = ttKnot.PositionY + 1.
        else
          ttKnot.PositionY = ttKnot.PositionY - 1.
      end.
      
      
      if (abs(viPrevKnotX - ttKnot.PositionX) = 1 and abs(viPrevKnotY - ttKnot.PositionY) = 2)
        or (abs(viPrevKnotX - ttKnot.PositionX) = 2 and abs(viPrevKnotY - ttKnot.PositionY) = 1)
        or (abs(viPrevKnotX - ttKnot.PositionX) = 2 and abs(viPrevKnotY - ttKnot.PositionY) = 2)
        then 
      do:
        if viPrevKnotY > ttKnot.PositionY then 
          ttKnot.PositionY = ttKnot.PositionY + 1.
        else
          ttKnot.PositionY = ttKnot.PositionY - 1.
        
        if viPrevKnotX > ttKnot.PositionX then 
          ttKnot.PositionX = ttKnot.PositionX + 1.
        else
          ttKnot.PositionX = ttKnot.PositionX - 1.  
      end.
      
      assign
        viPrevKnotX = ttKnot.PositionX
        viPrevKnotY = ttKnot.PositionY.
        
      if ttKnot.KnotId = viNumKnots then 
      do:
        find ttVisitedByTail exclusive-lock
          where ttVisitedbyTail.PositionX = ttKnot.PositionX
          and ttVisitedbyTail.PositionY = ttKnot.PositionY
          no-error.
        if not available ttVisitedbyTail then 
        do:
          create ttVisitedbyTail.
          assign 
            ttVisitedbyTail.PositionX = ttKnot.PositionX
            ttVisitedbyTail.PositionY = ttKnot.PositionY.
        end.
      end.
    end. 
  end.
end.
 
input close.

for each ttVisitedByTail no-lock:
  viVisitedByTail = viVisitedByTail + 1.
end.

message viVisitedByTail skip etime / 1000 view-as alert-box information.

/*
---------------------------
Information (Press HELP to view stack trace)
---------------------------
2455
---------------------------
OK   Help   
---------------------------

*/