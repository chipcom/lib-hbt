#include "../_mylib_hbt/function.ch"
#include "inkey.ch"

// ��������� ��ப� s �� �� �����ப�, ࠧ������� sep,
// � ������ ���ᨢ �����ப ����� �⨬� ࠧ����⥫ﬨ.
// �� 㬮�砭�� sep - "�஡��"
Function Split(s, sep)
  // s - ࠧ���塞�� ��ப�
  // sep - ��ப� ࠧ����⥫�
  return hb_ATokens( s, sep )
  