define temp-table ttCalories no-undo
  field ttElveId        as integer
  field ttTotalCalories as integer.
  
run readFile.
run processData.

procedure readFile:
  define variable viElveId as integer   no-undo initial 1.  
  define variable vcLijn   as character no-undo.
  
  input from value(search("day01\day01_input")).

  repeat on error undo, leave 
    on endkey undo, leave:
       
    import unformatted vcLijn.
  
    if vcLijn = "" then
      viElveId = viElveId + 1.
    else 
    do:  
      find ttCalories exclusive-lock
        where ttCalories.ttElveId = viElveId 
        no-error.
      if not avail ttCalories then
      do:
        create ttCalories.
        assign
          ttCalories.ttElveId = viElveId.
      end.
    
      if avail ttCalories then
        ttCalories.ttTotalCalories = ttCalories.ttTotalCalories + int(vcLijn).  
    end.
  end.

  input close.
end procedure.

procedure processData:
  define variable viTop3   as integer no-undo.
  define variable viTeller as integer no-undo.

  for each ttCalories by ttTotalCalories desc:
    viTeller = viTeller + 1.
  
    if viTeller > 3 then
    do:
      message viTop3
        view-as alert-box info.   
      leave.
    end.

    viTop3 = viTop3 + ttCalories.ttTotalCalories.
  end.
end procedure.
