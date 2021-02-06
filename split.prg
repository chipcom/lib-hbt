#include "../_mylib_hbt/function.ch"
#include "inkey.ch"

// Разделить строку s на все подстроки, разделенные sep,
// и вернуть массив подстрок между этими разделителями.
// по умолчанию sep - "пробел"
Function Split(s, sep)
  // s - разделяемая строка
  // sep - строка разделитель
  return hb_ATokens( s, sep )
  