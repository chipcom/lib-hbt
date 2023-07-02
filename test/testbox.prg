#include 'tbox.ch'

procedure main( ... )
  local tb
  local mGender := 'мужской'
    
  REQUEST HB_CODEPAGE_RU866
  HB_CDPSELECT('RU866')
  REQUEST HB_LANG_RU866
  HB_LANGSELECT('RU866')

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
  
  cDataCScr   := 'W+/B,B/BG'              // 1
  help_code := 0
  cColorStMsg := 'W+/R,,,,B/W'                  //    Stat_msg
  cColorSt1Msg:= 'W+/R,,,,B/W'                //    Stat_msg
  cColorSt2Msg:= 'GR+/R,,,,B/W'                //    Stat_msg
  cColorWait  := 'W+/R*,,,,B/W'                 //    Ждите
  

  tb := TBox():new(10, 10, 20, 70)
  tb:Caption := 'Выберите регион'
  tb:Frame := BORDER_SINGLE
  tb:View()
  @ 8, 5 TBOX tb say 'Пол:' GET mGender
  // @ Row(), Col() + 1 GET mGender

  read
  return
