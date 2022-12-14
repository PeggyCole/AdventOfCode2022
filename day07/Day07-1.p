define temp-table ttFileStructure no-undo
  field DirectoryId as integer
  field LevelId     as integer 
  field FileName    as character
  field FileSize    as int64.  
  
define temp-table ttDirStructure no-undo 
  field ParentDirectoryId as integer
  field DirectoryId       as integer
  field DirectoryName     as character
  field DirectorySize     as int64.
      
etime(yes).
   
run readFile.
run processData.

procedure readFile:
  define variable vcLijn               as character no-undo.
  define variable viCurrentLevel       as integer   no-undo.
  define variable vcNumbers            as character no-undo initial "0,1,2,3,4,5,6,7,8,9".
  define variable viDirectoryId        as integer   no-undo.
  define variable viParentDirectoryId  as integer   no-undo.
  define variable viCurrentDirectoryId as integer   no-undo.
  define variable vcDirectoryTree      as character no-undo.
  
  input from value(search("day07\day07_input")).
  
  create ttDirStructure.
  assign
    ttDirStructure.DirectoryId       = 0
    ttDirStructure.DirectoryName     = "/"
    ttDirStructure.ParentDirectoryId = 0.

  repeat 
    on error undo, leave 
    on endkey undo, leave:
       
    import unformatted vcLijn.
  
    if vcLijn = "$ cd /" then 
      assign 
        viCurrentLevel       = 0
        viParentDirectoryId  = 0
        viCurrentDirectoryId = 0.
    else 
    do:
      if vcLijn = "$ cd .." then 
      do:
        
        vcDirectoryTree = substring(vcDirectoryTree, 1, r-index(vcDirectoryTree, ",") - 1).  
      
        if vcDirectoryTree = "" then 
          viCurrentDirectoryId = 0.
        else
          viCurrentDirectoryId = int(entry(num-entries(vcDirectoryTree, ","), vcDirectoryTree, ",")).
          
        viCurrentLevel = viCurrentLevel - 1.
      end.
    
      else 
      do:
        if vcLijn begins "$ cd " then 
        do:
          create ttDirStructure.
          assign
            viParentDirectoryId              = viCurrentDirectoryId    
            viCurrentLevel                   = viCurrentLevel + 1      
            viDirectoryId                    = viDirectoryId + 1      
            ttDirStructure.DirectoryId       = viDirectoryId
            ttDirStructure.DirectoryName     = entry(3, vcLijn, " ")
            ttDirStructure.ParentDirectoryId = viParentDirectoryId           
            viCurrentDirectoryId             = viDirectoryId
            vcDirectoryTree                  = vcDirectoryTree + "," + string(viDirectoryId).  
        end.      
      end.
    end.
    
    if num-entries(vcLijn, " ":u) = 2 and lookup(substring(vcLijn, 1, 1), vcNumbers, ",") > 0 then 
    do:
      create ttFileStructure.
      assign
        ttFileStructure.LevelId     = viCurrentLevel
        ttFileStructure.DirectoryId = viCurrentDirectoryId
        ttFileStructure.FileName    = entry(2, vcLijn, " ")
        ttFileStructure.FileSize    = int64(entry(1, vcLijn, " "))        
        .
    end.
    
    //if vcLijn = "$ ls" then . // do nothing 
    //if vcLijn begins "dir " then . // do nothing
     
    
  end.
  input close.

end procedure.

procedure processData:
  define buffer ttDirStructure for ttDirStructure.
  
  define variable viSum as integer no-undo.
  
  find ttDirStructure no-lock 
    where ttDirStructure.ParentDirectoryId = 0
    and ttDirStructure.DirectoryId = 0 no-error.
  run getDirSize (input ttDirStructure.DirectoryId, output ttDirStructure.DirectorySize).
  
  for each ttDirStructure no-lock
    where ttDirStructure.DirectorySize <= 100000: 
    viSum = viSum + ttDirStructure.DirectorySize. 
  end.
  
  message viSum skip etime / 1000
    view-as alert-box information.
    
/*
    
---------------------------
Information (Press HELP to view stack trace)
---------------------------
1642503
---------------------------
OK   Help   
---------------------------
    
*/
    
 
end procedure.

procedure getDirSize:
  define input parameter ipiDirectoryId as integer no-undo.
  define output parameter opiDirectorySize as int64 no-undo.
  
  define buffer ttDirStructure  for ttDirStructure.
  define buffer ttFileStructure for ttFileStructure.
  
  for each ttFileStructure no-lock 
    where ttFileStructure.DirectoryId = ipiDirectoryId:
    opiDirectorySize = opiDirectorySize + ttFileStructure.FileSize . 
  end.  
  
  for each ttDirStructure no-lock
    where ttDirStructure.ParentDirectoryId = ipiDirectoryId
    and ttDirStructure.DirectoryId <> ipiDirectoryId:
    run getDirSize (input ttDirStructure.DirectoryId, output ttDirStructure.DirectorySize).
    
    opiDirectorySize = opiDirectorySize + ttDirStructure.DirectorySize.
  end.
  
end procedure.