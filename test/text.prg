#include 'tfile.ch'


procedure main( ... )
  local ft
  local i
  local nSize, nFile
  local aRow

  local arr_title := {;
    "컴컴컴컴컴컴컴컴컴컫컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�", ;
    " 삩菴 뵒럩�        � 삩菴 뙉 � 뜝º���쥯��� 信ャ（                                   ", ;
    "컴컴컴컴컴컴컴컴컴컨컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"}
    
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
  cColorWait  := "W+/R*,,,,B/W"                 //    넠ⓥ�

  ft := TFileText():New('test.txt', , .t., , .t.)
  ft:Add_Column( '삩菴 뵒럩�', 15, FILE_LEFT )
  ft:Add_Column( '삩菴 뙉', 12, FILE_CENTER )
  ft:Add_Column( '뜝º���쥯��� 信ャ（', 30, FILE_LEFT, , .t. )
  ft:Add_Column( '삩菴 뮅럩�', 15, FILE_RIGHT, , .t. )
//  ft:TableHeader := arr_title
  ft:EnableTableHeader := .t.
  ft:VerticalSeparator := '�'
  ft:TableFooterEnable := .t.
  ft:printTableHeader()
  for i := 1 to 200
    aRow := {}  // �葉飡º 쵟遜Ð
    AAdd( aRow, 'test' )
    AAdd( aRow, alltrim( str( i, 3 ) ) )
    AAdd( aRow, 'М� ㅿㅿ �젹音 曄飡�音 ��젪Œ, ぎ＄� �� � 嵬洙� 쭬��М�' )
    AAdd( aRow, 'ゃ-ゃ�-丞丞-ゃゃゃ' )
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
