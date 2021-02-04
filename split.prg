#include "../_mylib_hbt/function.ch"
#include "inkey.ch"

// ��������� ��ப� s �� �� �����ப�, ࠧ������� sep,
// � ������ ���ᨢ �����ப ����� �⨬� ࠧ����⥫ﬨ.
// �� 㬮�砭�� sep - ","
Function Split(s, sep)
  // s - ࠧ���塞�� ��ப�
  // sep - ��ப� ࠧ����⥫�
  Local i
  local arr := {}

	hb_defaultvalue( sep, ',' )

  for i := 1 to numtoken(s, sep)
    s := alltrim(token(s, sep, i))
    if !empty(s)
      aadd(arr,s)
    endif
  next
  // sDiagnozis := aclone(ar) // ������� ��ப���� �।�⠢����� ��������� ���ᨢ�� ���������

  // if valtype(arr)=="A" .and. len(arr) > 0
  //   for i := 1 to len(arr)
  //     sList += alltrim(arr[i])+","
  //   next
  //   sList := left(sList,len(sList)-1)
  // endif
  return arr
  