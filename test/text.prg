#include 'tfile.ch'


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
  for i := 1 to 200
    if i == 100
      ft:add_string('test ' + alltrim(str(i,3)), FILE_CENTER, '=')
    elseif i == 110
      ft:add_string('test ' + alltrim(str(i,3)), FILE_RIGHT, '+')
    else
      ft:add_string('test ' + alltrim(str(i,3)))
    endif
    if i == 61
      ft:Heigh := 10
    endif
    if i == 91
      ft:PageBreak := .f.
    endif
  next

  return
