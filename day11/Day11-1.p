define temp-table ttMonkey no-undo
  field MonkeyId          as integer 
  field Inspections       as integer
  field Items             as character 
  field OperationFormula  as character
  field TestDivisible     as integer
  field TestTrueMonkeyId  as integer
  field TestFalseMonkeyId as integer
  index PK as primary unique MonkeyId.
  
define variable vdResult as decimal    no-undo.
define temp-table tt no-undo /*dummy TEMP-TABLE*/
  field field1 as integer.

define query vhqueryTT for tt. /* dummy QUERY */
function GetDecimal returns logical
  (input vdValue as decimal).
  vdResult = vdValue.
  return true.
end function.  /* GetDecimal*/  
      
etime(yes).
   
run readFile.

run processData.

procedure readFile:
  define variable vcLijn          as character no-undo.
  define variable viCurrentMonkey as integer   no-undo.
  
  input from value("day11\Day11_input").
  
  repeat 
    on error undo, leave 
    on endkey undo, leave:
       
    import unformatted vcLijn.
  
    if trim(vcLijn) begins "Monkey " then 
    do:
      create ttMonkey.
      assign 
        ttMonkey.MonkeyId = viCurrentMonkey
        viCurrentMonkey   = viCurrentMonkey + 1. 
    end.
    
    if trim(vcLijn) begins "StartIng items: " then 
      ttMonkey.Items = replace(substring(trim(vcLijn), 17), " ":u, "").
      
    if trim(vcLijn) begins "Operation: " then 
      ttMonkey.OperationFormula = substring(trim(vcLijn), 17). 
    
    if trim(vcLijn) begins "Test: " then
      ttMonkey.TestDivisible = int(entry(num-entries(trim(vcLijn), " "), trim(vcLijn), " ")).
      
    if trim(vcLijn) begins "If true: " then
      ttMonkey.TestTrueMonkeyId = int(entry(num-entries(trim(vcLijn), " "), trim(vcLijn), " ")).
      
    if trim(vcLijn) begins "If false: " then
      ttMonkey.TestFalseMonkeyId = int(entry(num-entries(trim(vcLijn), " "), trim(vcLijn), " ")).
  end.
  
  input close.
end procedure.

procedure processData:
 
  define variable viRound as integer no-undo.
  define variable viItem as integer no-undo.
  define variable vcFormule as character no-undo.
  
  define buffer bttMonkey for ttMonkey.  
  
 // debugger:initiate().
 // debugger:set-break().
  
  do viRound = 1 to 20:
    for each ttMonkey by MonkeyId: 
      do viItem = 1 to num-entries(ttMonkey.Items, ","):
        ttMonkey.Inspections = ttMonkey.Inspections + 1.
        vcFormule = replace(ttMonkey.OperationFormula, "old", entry(viItem, ttMonkey.Items, ",":u)).
        
        query vhqueryTT:query-prepare("for each tt where dynamic-function( 'GetDecimal', " + vcFormule + ") = true").
        query vhqueryTT:query-open().
        query vhqueryTT:query-close.
        vdResult = trunc(vdResult / 3, 0).
                
        if vdResult mod ttMonkey.TestDivisible = 0 then 
          find bttMonkey no-lock 
            where bttMonkey.MonkeyId = ttMonkey.TestTrueMonkeyId 
            no-error.
        else
          find bttMonkey no-lock 
            where bttMonkey.MonkeyId = ttMonkey.TestFalseMonkeyId 
            no-error.
                 
        if available bttMonkey then 
          bttMonkey.Items = trim(bttMonkey.Items + "," + string(vdResult), ",").
            
      end.
      
      ttMonkey.Items = "".
    end. 
  end.
  
  
  define variable viMax1 as integer no-undo.
  define variable viMax2 as integer no-undo.
  
  for each ttMonkey no-lock by inspections desc: 
    if viMax1 = 0 then 
      viMax1 = ttMonkey.Inspections.
    else
      if viMax2 = 0 then 
        viMax2 = ttMonkey.Inspections.
      else 
        leave.
  end.      
  
   message viMax1 * viMax2 skip etime / 1000
   view-as alert-box information.
     
/*
    
---------------------------
Information (Press HELP to view stack trace)
---------------------------
61005
---------------------------
OK   Help   
---------------------------
    
*/
    
 
end procedure.






