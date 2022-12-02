define temp-table ttGame no-undo
  field GameId       as integer
  field OpponentPlay as character
  field MePlay       as character.
  
run readFile.
run processData.


procedure readFile:
  define variable vcLijn as character no-undo.
  define variable viGame as integer   no-undo.
    
  input from value(search("day02\day02_input")).

  repeat 
    on error undo, leave 
    on endkey undo, leave:
       
    import unformatted vcLijn.
  
    create ttGame.
    assign
      viGame              = viGame + 1
      ttGame.GameId       = viGame
      ttGame.OpponentPlay = entry(1, vcLijn, " ":u)
      ttGame.MePlay       = entry(2, vcLijn, " ":u).
  end.

  input close.
end procedure.

procedure processData:
  define variable viTotalScore as integer no-undo.
  define variable viGameScore  as integer no-undo.

  define variable viLose     as integer no-undo initial 0.
  define variable viDraw     as integer no-undo initial 3.
  define variable viWin      as integer no-undo initial 6.
  define variable viRock     as integer no-undo initial 1.
  define variable viPaper    as integer no-undo initial 2.
  define variable viScissors as integer no-undo initial 3.
  
  for each ttGame no-lock by ttGame.GameId:
    viGameScore = 0.  
    
    case ttGame.MePlay:
      when "X":u then 
        do: // Rock
          viGameScore = viGameScore + viRock.
        
          case ttGame.OpponentPlay:
            when "A":u then
              viGameScore = viGameScore + viDraw. 
            when "B":u then
              viGameScore = viGameScore + viLose. 
            when "C":u then
              viGameScore = viGameScore + viWin.
          end case.
        end.
      when "Y":u then 
        do: // Paper
          viGameScore = viGameScore + viPaper.
        
          case ttGame.OpponentPlay:
            when "A":u then
              viGameScore = viGameScore + viWin. 
            when "B":u then
              viGameScore = viGameScore + viDraw. 
            when "C":u then
              viGameScore = viGameScore + viLose.
          end case.
        end.
      when "Z":u then 
        do: // Scissors
          viGameScore = viGameScore + viScissors.
        
          case ttGame.OpponentPlay:
            when "A":u then
              viGameScore = viGameScore + viLose. 
            when "B":u then
              viGameScore = viGameScore + viWin. 
            when "C":u then
              viGameScore = viGameScore + viDraw.
          end case.
        end. 
    end case.
    
    viTotalScore = viTotalScore + viGameScore.  
  end.
  
  /*
  ---------------------------
Information (Press HELP to view stack trace)
---------------------------
13221
---------------------------
OK   Help   
---------------------------
  */
  
  
  message viTotalScore
    view-as alert-box information.
end procedure.

