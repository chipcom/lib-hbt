

procedure main( ... )
  local ft
  local i

  REQUEST HB_CODEPAGE_RU866
  HB_CDPSELECT("RU866")
  REQUEST HB_LANG_RU866
  HB_LANGSELECT("RU866")

  //SET(_SET_EVENTMASK,INKEY_KEYBOARD)
  SET SCOREBOARD OFF
  SET EXACT ON
  SET DATE GERMAN
  SET WRAP ON
  SET CENTURY ON
  SET EXCLUSIVE ON
  SET DELETED ON


  ft := TFileText():New('test.txt', , .t., , .t.)
  for i := 1 to 100
    ft:add_string('test ' + alltrim(str(i,3)))
  next

  return
