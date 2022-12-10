etime(yes).   

define temp-table ttVisitedByTail no-undo
  field PositionX as integer 
  field PositionY as integer
  index PK as primary unique PositionX PositionY.

define variable vcLijn          as character no-undo.
define variable viHeadX         as integer   no-undo initial 1.
define variable viHeadY         as integer   no-undo initial 1.
define variable viTailX         as integer   no-undo initial 1.
define variable viTailY         as integer   no-undo initial 1.
define variable viStep          as integer   no-undo.
define variable viVisitedByTail as integer   no-undo.


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
    case entry(1, vcLijn, " "):
      when "R" then 
        viHeadX = viHeadX + 1.        
      when "U" then 
        viHeadY = viHeadY - 1.
      when "L" then 
        viHeadX = viHeadX - 1. 
      when "D" then 
        viHeadY = viHeadY + 1. 
    end case.
    
    if viHeadY = viTailY and abs(viHeadX - viTailX) = 2 then 
    do:
      if viHeadX > viTailX then 
        viTailX = viTailX + 1.
      else
        viTailX = viTailX - 1.
    end.
    
    if viHeadX = viTailX and abs(viHeadY - viTailY) = 2 then 
    do:
      if viHeadY > viTailY then 
        viTailY = viTailY + 1.
      else
        viTailY = viTailY - 1.
    end.
    
    if (abs(viHeadX - viTailX) = 1 and abs(viHeadY - viTailY) = 2)
      or (abs(viHeadX - viTailX) = 2 and abs(viHeadY - viTailY) = 1)
      then 
    do:
      if viHeadY > viTailY then 
        viTailY = viTailY + 1.
      else
        viTailY = viTailY - 1.
        
      if viHeadX > viTailX then 
        viTailX = viTailX + 1.
      else
        viTailX = viTailX - 1.  
    end.
    
    find ttVisitedByTail exclusive-lock
      where ttVisitedbyTail.PositionX = viTailX
      and ttVisitedbyTail.PositionY = viTailY
      no-error.
    if not available ttVisitedbyTail then 
    do:
      create ttVisitedbyTail.
      assign 
        ttVisitedbyTail.PositionX = viTailX
        ttVisitedbyTail.PositionY = viTailY.
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
6337
---------------------------
OK   Help   
---------------------------
*/