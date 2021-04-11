#include 'function.ch'

***** функция разрезания строки на массив строк длиной не более указанного размера с учетом слов
function splitStrToArray(s,n,symb)
  // s    - строка, которая будет разрезаться
  // n    - количество символов в обрезках строк
  // symb - подмножество симоволов из ' ,;-+/' (разделители для переноса)
  Local i := 0, i1, i2, i3, i4, i5, i6, j, fl, s1
  local mas := {}

  DEFAULT symb TO ' ,;-'
  if empty(s := RTRIM(s))
    // if len(mas) == 0
    //   asize(mas, 1)
    // endif
    // AAdd(mas, space(n))
    return mas
  endif
  DO WHILE .T.
    IF LEN(s) <= n
      AAdd(mas, padr(s,n))
      EXIT
    ELSEIF SUBSTR(s,n+1,1) == ' ' // если после отрезания сразу идет пробел
      AAdd(mas, SUBSTR(s,1,n))
      s := LTRIM(SUBSTR(s,n+1))
    ELSE
      s1 := SUBSTR(s,1,n)
      i1 := if(' ' $ symb, RAT(' ',s1), 0)
      i2 := if(',' $ symb, RAT(',',s1), 0)
      i3 := if(';' $ symb, RAT(';',s1), 0)
      i4 := if('-' $ symb, RAT('-',s1), 0)
      i5 := if('+' $ symb, RAT('+',s1), 0)
      i6 := if('/' $ symb, RAT('/',s1), 0)
      j := MAX(i2,i3,i4,i5,i6)
      fl := (i1 > j)
      j := MAX(j,i1)
      IF j > 0
        AAdd(mas, padr(SUBSTR(s1,1,IF(fl,j-1,j)),n))
        s := LTRIM(SUBSTR(s,j+1))
      ELSE
        AAdd(mas, SUBSTR(s,1,n))
        s := LTRIM(SUBSTR(s,n+1))
      ENDIF
    ENDIF
  ENDDO
  RETURN mas       //  вернуть массив получившихся строк
