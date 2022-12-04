define temp-table ttCouple no-undo
  field FromSection1 as integer
  field ToSection1 as integer
  field FromSection2 as integer
  field ToSection2 as integer
  .
  
etime(yes).   
run readFile.
run processData.


procedure readFile:
  define variable vcLijn as character no-undo.
    
  input from value(search("day04\day04_input")).

  repeat 
    on error undo, leave 
    on endkey undo, leave:
       
    import unformatted vcLijn.
  
    create ttCouple.
    assign
      ttCouple.FromSection1 = int(entry(1, entry(1, vcLijn, ",":u), "-"))
      ttCouple.ToSection1 = int(entry(2, entry(1, vcLijn, ",":u), "-"))
      ttCouple.FromSection2 = int(entry(1, entry(2, vcLijn, ",":u), "-"))
      ttCouple.ToSection2 = int(entry(2, entry(2, vcLijn, ",":u), "-"))
      .
  end.

  input close.
end procedure.

procedure processData:
  define variable viTotalCovered as integer   no-undo.
  
  for each ttCouple no-lock :
     if (ttCouple.FromSection1 <= ttCouple.FromSection2
          and ttCouple.ToSection1 >= ttCouple.FromSection2)
        or
        (ttCouple.FromSection1 >= ttCouple.FromSection2
          and ttCouple.FromSection1 <= ttCouple.ToSection2)
        
        or 
     
        (ttCouple.FromSection2 <= ttCouple.FromSection1
         and ttCouple.ToSection2 >= ttCouple.FromSection1)
        
        or
        (ttCouple.FromSection2 >= ttCouple.FromSection1
          and ttCouple.FromSection2 <= ttCouple.ToSection1)
          
        then
        viTotalCovered = viTotalCovered + 1.
                
  end.
  
  message viTotalCovered skip etime / 1000
    view-as alert-box information.
end procedure.

