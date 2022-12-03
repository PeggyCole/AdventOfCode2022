define temp-table ttGame no-undo
  field GameId          as integer
  field OpponentPlay    as character
  field MePlay          as character.
  
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
  
  for each ttGame no-lock by ttGame.GameId:
    viGameScore = 0.  
    
    case ttGame.OpponentPlay:
      when "A":u then 
        do: // Rock
          case ttGame.MePlay:
            when "X":u then // I lose 
              assign
                viGameScore = viGameScore + 0 // I have to lose
                viGameScore = viGameScore + 3. // I lose so I am scissors
            when "Y":u then // Draw
              assign
                viGameScore = viGameScore + 3 // Draw
                viGameScore = viGameScore + 1. // Draw so I am rock
            when "Z":u then // I win
              assign
                viGameScore = viGameScore + 6 // I have to win
                viGameScore = viGameScore + 2. // I win so I am paper
          end case.
        end.
      when "B":u then 
        do: // Paper
          case ttGame.MePlay:
            when "X":u then // I lose 
              assign
                viGameScore = viGameScore + 0 // I have to lose
                viGameScore = viGameScore + 1. // I lose so I am rock
            when "Y":u then // Draw
              assign
                viGameScore = viGameScore + 3 // Draw
                viGameScore = viGameScore + 2. // Draw so I am paper
            when "Z":u then // I win
              assign
                viGameScore = viGameScore + 6 // I have to win
                viGameScore = viGameScore + 3. // I win so I am scissors
          end case.
        end.
      when "C":u then 
        do: // Scissors
          case ttGame.MePlay:
            when "X":u then // I lose 
              assign
                viGameScore = viGameScore + 0 // I have to lose
                viGameScore = viGameScore + 2. // I lose so I am paper
            when "Y":u then // Draw
              assign
                viGameScore = viGameScore + 3 // Draw
                viGameScore = viGameScore + 3. // Draw so I am scissors
            when "Z":u then // I win
              assign
                viGameScore = viGameScore + 6 // I have to win
                viGameScore = viGameScore + 1. // I win so I am rock
          end case.
        end. 
    end case.
    
    viTotalScore = viTotalScore + viGameScore.  
  end.
  
  
  
  message viTotalScore
    view-as alert-box information.
end procedure.