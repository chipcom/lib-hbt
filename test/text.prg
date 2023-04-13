#include 'tfile.ch'


procedure main( ... )
  local ft
  local i

  local arr_title := {;
    "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ", ;
    " ˜¨äà ””Œ‘        ³ ˜¨äà Œ ³  ¨¬¥­®¢ ­¨¥ ãá«ã£¨                                   ", ;
    "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"}
    
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

  public cDataCScr, help_code
  public cColorStMsg, cColorSt1Msg, cColorSt2Msg, cColorWait
  
  cDataCScr   := "W+/B,B/BG"              // 1
  help_code := 0
  cColorStMsg := "W+/R,,,,B/W"                  //    Stat_msg
  cColorSt1Msg:= "W+/R,,,,B/W"                //    Stat_msg
  cColorSt2Msg:= "GR+/R,,,,B/W"                //    Stat_msg
  cColorWait  := "W+/R*,,,,B/W"                 //    †¤¨â¥
  
  ft := TFileText():New('test.txt', , .t., , .t.)
  ft:TableHeader := arr_title
  ft:EnableTableHeader := .t.
  ft:printTableHeader()
  for i := 1 to 200
    if i == 100
      ft:add_string('test ' + alltrim(str(i,3)), FILE_CENTER, '=')
    elseif i == 110
      ft:add_string('test ' + alltrim(str(i,3)), FILE_RIGHT, '+')
      ft:EnableTableHeader := .f.
    else
      ft:add_string('test ' + alltrim(str(i,3)))
    endif
    if i == 61
      ft:Heigh := 10
    endif
    if i == 170
      ft:EnablePageBreak := .f.
    endif
    if i == 190
      ft:PageBreak()
    endif
  next

  ft:Close()

  viewtext(ft:NameFile, , , , .t., , , 5)

  return
