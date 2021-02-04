#include "../_mylib_hbt/function.ch"
#include "inkey.ch"

// Разделить строку s на все подстроки, разделенные sep,
// и вернуть массив подстрок между этими разделителями.
// по умолчанию sep - ","
Function Split(s, sep)
  // s - разделяемая строка
  // sep - строка разделитель
  Local i
  local arr := {}

	hb_defaultvalue( sep, ',' )

  for i := 1 to numtoken(s, sep)
    s := alltrim(token(s, sep, i))
    if !empty(s)
      aadd(arr,s)
    endif
  next
  // sDiagnozis := aclone(ar) // заменим строковое представление диагнозов массивом диагнозов

  // if valtype(arr)=="A" .and. len(arr) > 0
  //   for i := 1 to len(arr)
  //     sList += alltrim(arr[i])+","
  //   next
  //   sList := left(sList,len(sList)-1)
  // endif
  return arr
  