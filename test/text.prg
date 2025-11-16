#include 'tfile.ch'

// 16.11.25
procedure main( ... )
  local ft
  local i
  local nSize, nFile
  local aRow, textStr

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

  textStr := 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'

  ft := TFileText():New('test.txt', , .t., , .t.)
  ft:add_string( '' )
  ft:add_string( textStr, , , .t. )
  ft:add_string( '' )
  ft:Add_Column( '˜¨äà ””Œ‘', 15, FILE_LEFT )
  ft:Add_Column( '˜¨äà Œ', 12, FILE_CENTER )
  ft:Add_Column( ' ¨¬¥­®¢ ­¨¥ ãá«ã£¨', 30, FILE_LEFT, , .t. )
  ft:Add_Column( '˜¨äà ’”Œ‘', 15, FILE_RIGHT, , .t. )
//  ft:TableHeader := arr_title
  ft:EnableTableHeader := .t.
  ft:VerticalSeparator := '³'
  ft:TableFooterEnable := .t.
  ft:printTableHeader()
  for i := 1 to 200
    aRow := {}  // ®ç¨áâ¨¬ ¬ áá¨¢
    AAdd( aRow, 'test' )
    AAdd( aRow, alltrim( str( i, 3 ) ) )
    AAdd( aRow, '¬®© ¤ï¤ï á ¬ëå ç¥áâ­ëå ¯à ¢¨«, ª®£¤  ­¥ ¢ èãâªã § ­¥¬®£' )
    AAdd( aRow, 'ªã-ªãª-ãªãª-ªãªãªã' )
    ft:Add_Row( aRow )
    if i == 100
      ft:End_Table()
    endif
    if i == 120
      ft:Heigh := 10
    endif
    if i == 170
      ft:EnablePageBreak := .f.
    endif
    if i == 190
      ft:PageBreak()
    endif
  next

  nsize := ft:Size()
  nFile := ft:NameFile
  // ft:Close()

  ft := nil

  viewtext(nFile, , , , .t., , , 5)

  return
