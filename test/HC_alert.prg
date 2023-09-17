/* Copyright 2017-2019 Rafa? Jopek ( rafaljopek at hotmail com ) */

/* Harbour Commander */

#include "box.ch"
#include "directry.ch"
#include "fileio.ch"
#include "hbgtinfo.ch"
#include "inkey.ch"
#include "setcurs.ch"

procedure main( ... )
  local ft
  local i
  local nSize, nFile

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


  HC_Alert( "Error reading:;" )
  IF HC_Alert( "The Harbour Commander", "Do you want to quit the Harbour Commander?", { "Yes", "No!" }, 0x8f ) == 1
    // lContinue := .F.
  ENDIF

  IF ( cNewDrive := HC_Alert( "Drive letter", "Choose left drive:", AllDrives(), 0x8a, 0x0 ) ) != 0

    // hb_CurDrive( AllDrives()[ cNewDrive ] )
    // PanelFetchList( aPanelLeft, hb_cwd() )
    // PanelDisplay( aPanelLeft )

   ENDIF

  return

FUNCTION HC_Alert( cTitle, xMessage, xOptions, nColorNorm, nArg )

    LOCAL nOldCursor := SetCursor( SC_NONE )
 
    // LOCAL nRowPos := Row(), nColPos := Col()
    LOCAL aMessage, aOptions, aPos
    LOCAL nColorHigh
    LOCAL nLenOptions, nLenMessage
    LOCAL nWidth := 0
    LOCAL nLenght := 0
    LOCAL nPos
    LOCAL i
    LOCAL nMaxRow := 0, nMaxCol := 0
    LOCAL nRow, nCol
    LOCAL nKey, nKeyStd
    LOCAL nTop, nLeft, nBottom, nRight
    LOCAL nChoice := 1
    LOCAL nMRow, nMCol
 
    DO CASE
    CASE ValType( cTitle ) == "U"
       cTitle := "OK"
    ENDCASE
 
    DO CASE
    CASE ValType( xMessage ) == "U"
       aMessage := { "" }
    CASE ValType( xMessage ) == "C"
       aMessage := hb_ATokens( xMessage, ";" )
    CASE ValType( xMessage ) == "A"
       aMessage := xMessage
    CASE ValType( xMessage ) == "N"
       aMessage := hb_ATokens( hb_CStr( xMessage ) )
    ENDCASE
 
    DO CASE
    CASE ValType( xOptions ) == "U"
       aOptions := { "OK" }
    CASE ValType( xOptions ) == "C"
       aOptions := hb_ATokens( xOptions, ";" )
    CASE ValType( xOptions ) == "A"
       aOptions := xOptions
    ENDCASE
 
    DO CASE
    CASE ValType( nColorNorm ) == "U"
       nColorNorm := 0x4f
       nColorHigh := 0x1f
    CASE ValType( nColorNorm ) == "N"
       nColorNorm := hb_bitAnd( nColorNorm, 0xff )
       nColorHigh := hb_bitAnd( hb_bitOr( hb_bitShift( nColorNorm, - 4 ), hb_bitShift( nColorNorm, 4 ) ), 0x77 )
    ENDCASE
 
    nLenOptions := Len( aOptions )
    FOR i := 1 TO nLenOptions
       nWidth += Len( aOptions[ i ] ) + 2
       nLenght += Len( aOptions[ i ] ) + 2
    NEXT
 
    /* w p?tli przechodz? przez nWidth, wybieram co jest wi?ksze */
    nLenMessage := Len( aMessage )
    FOR i := 1 TO nLenMessage
       nWidth := Max( nWidth, Len( aMessage[ i ] ) )
    NEXT
 
    DO WHILE .T.
 
       DispBegin()
 
       /* zachowanie drugiego ustawienia ! */
       IF nMaxRow != MaxRow( .T. ) .OR. nMaxCol != iif( nArg == NIL, MaxCol( .T. ), iif( nArg == 0x0, Int( MaxCol( .T. ) / 2 ), MaxCol( .T. ) + Int( MaxCol( .T. ) / 2 ) ) )
 
          WSelect( 0 )
 
          nMaxRow := MaxRow( .T. )
          /* ostatni parametr ustawia okienko dialogowe: NIL ?rodek, 0x0 po lewo i 0x1 po prawo */
          nMaxCol := iif( nArg == NIL, MaxCol( .T. ), iif( nArg == 0x0, Int( MaxCol( .T. ) / 2 ), MaxCol( .T. ) + Int( MaxCol( .T. ) / 2 ) ) )
 
          nTop    := Int( nMaxRow / 3 ) - 3
          nLeft   := Int( ( nMaxCol - nWidth ) / 2 ) - 2
          nBottom := nTop + 4 + nLenMessage
          nRight  := Int( ( nMaxCol + nWidth ) / 2 ) - 1 + 2
 
          WClose( 1 )
          WSetShadow( 0x8 )
          WOpen( nTop, nLeft, nBottom, nRight, .T. )
 
          hb_DispBox( 0, 0, nMaxRow, nMaxCol, hb_UTF8ToStrBox( " Û       " ), nColorNorm )
          hb_DispOutAt( 0, 0, Center( cTitle ), hb_bitShift( nColorNorm, 4 ) )
 
          FOR nPos := 1 TO Len( aMessage )
             hb_DispOutAt( 1 + nPos, 0, Center( aMessage[ nPos ] ), nColorNorm )
          NEXT
 
       ENDIF
 
       /* zapisuje wsp??rz?dne przycisk?w aOptions */
       aPos := {}
       nRow := nPos + 2
       nCol := Int( ( MaxCol() + 1 - nLenght - nLenOptions + 1 ) / 2 )
 
       FOR i := 1 TO nLenOptions
          AAdd( aPos, nCol )
          hb_DispOutAt( nRow, nCol, " " + aOptions[ i ] + " ", iif( i == nChoice, nColorHigh, nColorNorm ) )
          nCol += Len( aOptions[ i ] ) + 3
       NEXT
 
       DispEnd()
 
       nKey := Inkey( 0 )
       nKeyStd := hb_keyStd( nKey )
 
       DO CASE
       CASE nKeyStd == K_ESC
          nChoice := 0
          EXIT
 
       CASE nKeyStd == K_ENTER .OR. nKeyStd == K_SPACE
          EXIT
 
       CASE nKeyStd == K_MOUSEMOVE
 
          FOR i := 1 TO nLenOptions
             IF MRow() == nPos + 2 .AND. MCol() >= aPos[ i ] .AND. MCol() <= aPos[ i ] + Len( aOptions[ i ] ) + 1
                nChoice := i
             ENDIF
          NEXT
 
       CASE nKeyStd == K_LBUTTONDOWN
 
          nMCol := MCol()
          nMRow := MRow()
 
          IF MRow() == 0 .AND. MCol() >= 0 .AND. MCol() <= MaxCol()
 
             DO WHILE MLeftDown()
                WMove( WRow() + MRow() - nMRow, WCol() + MCol() - nMCol )
             ENDDO
 
          ENDIF
 
          FOR i := 1 TO nLenOptions
             IF MRow() == nPos + 2 .AND. MCol() >= aPos[ i ] .AND. MCol() <= aPos[ i ] + Len( aOptions[ i ] ) + 1
                nChoice := i
                EXIT
             ENDIF
          NEXT
 
          IF nChoice == i
             EXIT
          ENDIF
 
       CASE ( nKeyStd == K_LEFT .OR. nKeyStd == K_SH_TAB ) .AND. nLenOptions > 1
 
          nChoice--
          IF nChoice == 0
             nChoice := nLenOptions
          ENDIF
 
       CASE ( nKeyStd == K_RIGHT .OR. nKeyStd == K_TAB ) .AND. nLenOptions > 1
 
          nChoice++
          IF nChoice > nLenOptions
             nChoice := 1
          ENDIF
 
       CASE nKeyStd == K_CTRL_UP
          WMove( WRow() - 1, WCol() )
 
       CASE nKeyStd == K_CTRL_DOWN
          WMove( WRow() + 1, WCol() )
 
       CASE nKeyStd == K_CTRL_LEFT
          WMove( WRow(), WCol() - 1 )
 
       CASE nKeyStd == K_CTRL_RIGHT
          WMove( WRow(), WCol() + 1 )
 
       CASE nKeyStd == HB_K_RESIZE
 
          WClose( 1 )
 
          AutoSize()
 
          // PanelDisplay( aPanelLeft )
          // PanelDisplay( aPanelRight )
          // ComdLineDisplay( aPanelSelect )
 
          // BottomBar()
 
       ENDCASE
 
    ENDDO
 
    WClose( 1 )
    SetCursor( nOldCursor )
    // SetPos( nRowPos, nColPos )
 
    RETURN iif( nKey == 0, 0, nChoice )

PROCEDURE AutoSize()

  Resize( aPanelLeft, 0, 0, MaxRow() - 2, MaxCol() / 2 )
  Resize( aPanelRight, 0, MaxCol() / 2 + 1, MaxRow() - 2, MaxCol() )
   
  RETURN

PROCEDURE Resize( aPanel, nTop, nLeft, nBottom, nRight )

  aPanel[ _nTop    ] := nTop
  aPanel[ _nLeft   ] := nLeft
  aPanel[ _nBottom ] := nBottom
  aPanel[ _nRight  ] := nRight
 
  RETURN

PROCEDURE BottomBar()

  LOCAL nRow := MaxRow()
  LOCAL cSpaces
  LOCAL nCol := Int( MaxCol() / 10 ) + 1
 
  cSpaces := Space( nCol - 8 )
 
  hb_DispOutAt( nRow, 0,        " 1", 0x7 )
  hb_DispOutAt( nRow, 2,            "Help  " + cSpaces, 0x30 )
  hb_DispOutAt( nRow, nCol,     " 2", 0x7 )
  hb_DispOutAt( nRow, nCol + 2,     "Menu  " + cSpaces, 0x30 )
  hb_DispOutAt( nRow, nCol * 2, " 3", 0x7 )
  hb_DispOutAt( nRow, nCol * 2 + 2, "View  " + cSpaces, 0x30 )
  hb_DispOutAt( nRow, nCol * 3, " 4", 0x7 )
  hb_DispOutAt( nRow, nCol * 3 + 2, "Edit  " + cSpaces, 0x30 )
  hb_DispOutAt( nRow, nCol * 4, " 5", 0x7 )
  hb_DispOutAt( nRow, nCol * 4 + 2, "Copy  " + cSpaces, 0x30 )
  hb_DispOutAt( nRow, nCol * 5, " 6", 0x7 )
  hb_DispOutAt( nRow, nCol * 5 + 2, "RenMov" + cSpaces, 0x30 )
  hb_DispOutAt( nRow, nCol * 6, " 7", 0x7 )
  hb_DispOutAt( nRow, nCol * 6 + 2, "MkDir " + cSpaces, 0x30 )
  hb_DispOutAt( nRow, nCol * 7, " 8", 0x7 )
  hb_DispOutAt( nRow, nCol * 7 + 2, "Delete" + cSpaces, 0x30 )
  hb_DispOutAt( nRow, nCol * 8, " 9", 0x7 )
  hb_DispOutAt( nRow, nCol * 8 + 2, "PullDn" + cSpaces, 0x30 )
  hb_DispOutAt( nRow, nCol * 9, "10", 0x7 )
  hb_DispOutAt( nRow, nCol * 9 + 2, "Quit  " + cSpaces, 0x30 )
 
  RETURN

PROCEDURE ComdLineDisplay( aPanel )

  LOCAL nMaxRow := MaxRow(), nMaxCol := MaxCol()
 
  DispBegin()
 
  hb_DispOutAt( nMaxRow - 1, 0, ;
      PadR( aPanel[ _cCurrentDir ] + SubStr( aPanel[ _cComdLine ], 1 + aPanel[ _nComdColNo ], nMaxCol + aPanel[ _nComdColNo ] ), nMaxCol ), 0x7 )
 
  SetPos( nMaxRow - 1, aPanel[ _nComdCol ] + Len( aPanel[ _cCurrentDir ] ) )
 
  DispEnd()
 
  RETURN
 
FUNCTION AllDrives()

  LOCAL i
  LOCAL aArrayDrives := {}
 
  FOR i := 1 TO 26
    IF DiskChange( Chr( i + 64 ) )
      AAdd( aArrayDrives, Chr( i + 64 ) )
    ENDIF
  NEXT
 
  RETURN aArrayDrives
 