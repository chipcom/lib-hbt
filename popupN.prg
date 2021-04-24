#include 'edit_spr.ch'
#include 'function.ch'
#include 'inkey.ch'

#include 'tbox.ch'

***** ���⨪��쭮� ����
FUNCTION popupN(nTop, nLeft, nBottom, nRight, aArray, nInd, col,;
               fl_shadow, n_func, regim, titul, titul_color, ;
               mfunction, statusLine)
              //  , blk_color)
  // nTop,nLeft,nBottom,nRight - ࠧ���� ����
  // aArray - 2-� ���� ���ᨢ, 1 - ��ப�, 2 - �㫥��, ����� �⬥��� ����� ��� ���
  // nInd - ⥪�騩 �����
  // col - 梥� (��ப� ��� �����)
  // fl_shadow - ���� ⥭� ��� ���
  // n_func - ��� �㭪樨 ���짮��⥫� (����⨥ ������)
  // regim - ०�� ��� popup_edit
  // titul, titul_color - ��������� � ��� 梥�
  // mfunction - �㭪��, ��뢠���� �� ������ 蠣� TBrowse (�ᮢ����)
  // blk_color - 
  LOCAL oBrowse, oColumn, lCont := .t., cStatus, tmp_color := setcolor(),;
      nKey := 256, NSTR := nBottom-nTop-1, COUNT := LEN(aArray), ;
      fl_rbrd := .f., i, j, fl_mouse, x_mouse := 0, y_mouse := 0, km, ;
      color_find, static_find := "", buf_static, len_static, ;
      nsec := seconds(), period := 300
  local oBox
  
  if COUNT == 0
    return 0
  endif

  Private last_k := 2, tmp, mnInd, parr := aArray, lArray := {}
  DEFAULT nInd TO 1, col TO color0, fl_shadow TO .f., ;
    regim TO 0, mfunction TO ''
  default statusLine to ''

  // DEFAULT blk_color TO .f.

  default n_func TO ""
        // default n_func TO 'fmenu_readerN' // n_func TO ""

    nInd := if(nInd <= 0, 1, if(nInd > COUNT, COUNT, nInd))

  if !empty(n_func) .and. "(" $ n_func
    n_func := beforatnum("(",n_func)
  endif
  if !empty(mfunction) .and. !("(" $ mfunction)
    mfunction += "()"
  endif

  // �����⮢�� ������� �뢮��
  oBox := TBox():New(nTop, nLeft, nBottom, nRight)
  oBox:Save()

  if valtype(col) == "C"
    oBox:Color := beforatnum(",",col)
  elseif valtype(col) == "N"
    tmp := "color"+LSTR(col)
    oBox:Color := &tmp
  endif
  oBox:Frame := BORDER_DOUBLE
  if fl_shadow
    oBox:Shadow := .t.
  endif
  if titul != NIL
    DEFAULT titul_color TO setcolor()
    oBox:Caption := alltrim(titul)
    oBox:CaptionColor := titul_color
  endif
  if ! empty(statusLine) .and. ValType(statusLine) == 'C'
    oBox:MessageLine := statusLine
  endif
  oBox:View()

  if NSTR < COUNT .and. NSTR > 4
    fl_rbrd := .t.
    @ nTop+1,nRight    say chr(30)
    @ nBottom-1,nRight say chr(31)
    for i := nTop+2 to nBottom-2
      @ i,nRight say chr(176)
    next
    @ nTop+last_k,nRight say chr(8)
  endif
  SETCURSOR(0)
  oBrowse:= TBrowseNew(nTop+1, nLeft+1, nBottom-1, nRight-1)
  // oBrowse:colorSpec := if(valtype(col) == "C", col, &("color"+LSTR(col)))

  oBrowse:colorSpec := "N/BG,W+/N,B/BG,BG+/B,R/BG,W+/R,N+/BG,W/N,RB/BG,W+/RB"

  oBrowse:goTopBlock := ;
     {|| nInd := 1, right_side(fl_rbrd, nInd, COUNT, nTop, nRight, NSTR) }
  oBrowse:goBottomBlock := ;
     {|| nInd := COUNT, right_side(fl_rbrd, nInd, COUNT, nTop, nRight, NSTR) }
  oBrowse:skipBlock := ;
     { |nSkip, nVar|  nVar := nInd,;
        nInd := IF(nSkip > 0, MIN(COUNT,nInd+nSkip), MAX(1,nInd+nSkip)),;
        right_side(fl_rbrd, nInd, COUNT, nTop, nRight, NSTR), nInd - nVar }
  oColumn := TBColumnNew("", {|| padr(aArray[nInd, 1],nRight-nLeft-3) })
  // if blk_color
    // oColumn:colorBlock := {|| if("*" $ left(aArray[nInd, 1],3), {1,2}, {3,4}) }
  // endif
  oColumn:colorBlock := {|_c| _c:=if(aArray[nInd, 2], 1,4), {{1,2},{3,4},{5,6},{7,8},{9,10}}[_c] }



  oBrowse:addColumn(oColumn)
  if (i := nInd) > COUNT-NSTR
    oBrowse:goBottom()
    for tmp := COUNT-1 TO i STEP -1
      oBrowse:up()
    next
  endif
  color_find := color_find(oBrowse:colorSpec)     // =============
  buf_static := save_box(nTop,nLeft,nTop,nRight)  // =============
  len_static := nRight - nLeft - 3                // =============
  fl_mouse := SETPOSMOUSE()
  DO WHILE lCont
    if nKey != 0
      oBrowse:forcestable()  // �⠡�������
      mnInd := nInd
      if !empty(mfunction) ; tmp := &mfunction ; endif
        FT_MSHOWCRS(fl_mouse)
    endif
    nKey := 0
    /*if fl_mouse
      if (km := FT_MGETPOS()) == 2
        nKey := K_ESC
      elseif km == 1
        x_mouse := FT_MGETX() ; y_mouse := FT_MGETY()
        if between(x_mouse,nLeft+1,nRight-1)
          if between(y_mouse,nTop+1,nBottom-1)
            if y_mouse == (i := nTop + oBrowse:rowPos)
              nKey := K_ENTER
            elseif y_mouse > i
              for j := 1 to y_mouse-i
                keyboard CHR(K_TAB)  //  keysend(CHR(9)+CHR(15),.t.)  // KS_TAB
              next
            else
              for j := 1 to i-y_mouse
                keyboard CHR(K_SH_TAB)  //  keysend(CHR(0)+CHR(15),.t.)  // KS_SH_TAB
              next
            endif
          clear_mouse()
        elseif y_mouse == nTop
          nKey := K_SH_TAB
          elseif y_mouse == nBottom
            nKey := K_TAB
          endif
        elseif fl_rbrd .and. x_mouse == nRight
          if between(y_mouse,nTop+2,nBottom-2)
            if y_mouse < nTop+last_k
              nKey := K_PGUP
            elseif y_mouse > nTop+last_k
              nKey := K_PGDN
            endif
          elseif y_mouse == nTop+1
            nKey := K_SH_TAB
          elseif y_mouse == nBottom-1
            nKey := K_TAB
          endif
          clear_mouse()
        endif
      endif
    endif*/
    if nKey == 0
      nKey := INKEYTRAP()
    endif
    if nKey == 0
      if period > 0 .and. seconds() - nsec > period
        // �᫨ �� �ண��� ���������� [period] ᥪ., � ��� �� �㭪樨
        nKey := K_ESC
      endif
    else
      nsec := seconds()
    endif
    if nKey != 0 .and. ;                                         // =============
      !((len(static_find) > 0 .and. nKey == 32) .or. between(nKey,33,255) ;
                                            .or. nKey == K_BS) // =============
      static_find := "" ; rest_box(buf_static)                   // =============
    endif                                                        // =============
    DO CASE
      CASE nKey == K_UP .or. nKey == K_SH_TAB
        FT_MHIDECRS(fl_mouse) ; oBrowse:up()
      CASE nKey == K_DOWN .or. nKey == K_TAB
        FT_MHIDECRS(fl_mouse) ; oBrowse:down()
      CASE nKey == K_PGUP
        FT_MHIDECRS(fl_mouse) ; oBrowse:pageUp()
      CASE nKey == K_PGDN
        FT_MHIDECRS(fl_mouse) ; oBrowse:pageDown()
      CASE nKey == K_HOME .or. nKey == K_CTRL_PGUP .or. nKey == K_CTRL_HOME
        FT_MHIDECRS(fl_mouse) ; oBrowse:goTop()
      CASE nKey == K_END .or. nKey == K_CTRL_PGDN .or. nKey == K_CTRL_END
        FT_MHIDECRS(fl_mouse) ; oBrowse:goBottom()
      CASE len(static_find) == 0 .and. nKey == 32 .and. ;
                       eq_any(regim,PE_APP_SPACE,PE_SPACE)  // �஡�� == 32
        lCont := .F.
      CASE nKey == K_ENTER
        if regim == PE_EDIT  // �맮� �-�� ��� ।���஢����
          FT_MHIDECRS(fl_mouse)
          tmp := n_func+"("+lstr(nKey)+","+lstr(nInd)+")"
          if (i := &tmp) == 0         // �㭪�� ������ �������� 0 ���
            oBrowse:refreshAll()      // ���������� TBrowse, ���� -1 (��祣�)
          elseif i == 1               // ��� 1 ��� ��室� �� popup
            lCont := .f.
          endif
          nKey := 256
        else  // ���� �롮� �� ����
          lCont := .F.
        endif
      CASE nKey == K_ESC
        lCont := .F.
      CASE ((len(static_find) > 0 .and. nKey == 32) ;
                          .or. between(nKey,33,255) .or. nKey == K_BS) ;
                          .and. !equalany(nKey,43,45) // �� + � -
        FT_MHIDECRS(fl_mouse)
        oBrowse:goTop()
        if nKey == K_BS
          if len(static_find) > 1
            static_find := left(static_find,len(static_find)-1)
          else
            static_find := ""
          endif
        else
          if len(static_find) < len_static
            static_find += Upper(CHR(nKey))
          endif
        endif
        put_static(buf_static,static_find,color_find)
        if !empty(static_find)
          tmp := len(static_find)
          if (i := ascan(aArray, {|x| static_find <= StrForPopupN(x[ 1 ],tmp)} )) > 0
            if i < COUNT-NSTR+1
              oBrowse:goTop()
              nInd := i
              oBrowse:refreshAll()
              right_side(fl_rbrd, nInd, COUNT, nTop, nRight, NSTR)
            else
              oBrowse:goBottom()
              for tmp := COUNT-1 TO i STEP -1
                oBrowse:up()
              next
            endif
          else
            oBrowse:goBottom()
          endif
        endif
      CASE nKey != 0 .and. !empty(n_func)
        FT_MHIDECRS(fl_mouse)
        tmp := n_func+"("+lstr(nKey)+","+lstr(nInd)+")"
        if (i := &tmp) == 0         // �㭪�� ������ �������� 0 ���
          oBrowse:refreshAll()      // ���������� TBrowse, ���� -1 (��祣�)
        elseif i == 1               // ��� 1 ��� ��室� �� popup
          lCont := .f.
        endif
        nKey := 256
    ENDCASE
  ENDDO
  if fl_mouse
    clear_mouse()
    FT_MHIDECRS()
  endif
  setcolor(tmp_color)
  RETURN if(nKey == K_ESC, 0, nInd)

*****
Function fmenu_readerN(nKey,i)
  do case
    case nKey == K_INS .or. nKey == K_SPACE
      if parr[i, 2] //lArray[i]
        parr[i, 1] := stuff(parr[i, 1],2,1,if("*" == substr(parr[i, 1],2,1)," ","*"))
        keyboard chr(K_TAB)
      endif
    case nKey == 43  // "+"
      for i := 1 to len(parr)
        if parr[i, 2] //lArray[i]
          parr[i, 1] := stuff(parr[i, 1],2,1,"*")
        endif
      next
    case nKey == 45  // "-"
      for i := 1 to len(parr)
        if parr[i, 2] //lArray[i]
          parr[i, 1] := stuff(parr[i, 1],2,1," ")
        endif
      next
  endcase
  return 0
  
***** ���� �� ���.�㪢� � POPUP, �������� �஡��� � "*"
Function StrForPopupN(s,k)
  Local i, j, c, ls

  s := upper(s)
  for i := 1 to len(s)
    c := substr(s,i,1)
    if !eq_any(c," ","*")
      j := i ; exit
    endif
  next
  if j == NIL
    j := 1
  endif
  ls := substr(s,j,k)
  return padr(ls,k)
