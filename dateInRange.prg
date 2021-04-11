
***** �஢���� �������� �� date1 (�������� date1-date2) � �������� _begin_date-_end_date
Function dateInRange( _begin_date, _end_date, date1, date2 )
  // _begin_date - ��砫� ����⢨�
  // _end_date   - ����砭�� ����⢨�
  // date1 - �஢��塞�� ���
  // date2 - ���� ��� ��������� (�᫨ = NIL, � �஢��塞 ⮫쪮 �� date1)
  Local fl := .f., fl2

  hb_default( @date1, date() )  // �� 㬮�砭�� �஢��塞 �� ⥪���� ����

  // DEFAULT date1 TO sys_date  // �� 㬮�砭�� �஢��塞 �� ᥣ����譨� ������
  if empty(_begin_date)
    _begin_date := stod( '19930101' )  // �᫨ ��砫� ����⢨� = ����, � 01.01.1993
  endif
  // �஢�ઠ ���� date1 �� ��������� � ��������
  if (fl := (date1 >= _begin_date)) .and. !empty(_end_date)
    fl := (date1 <= _end_date)
  endif
  // �஢�ઠ ��������� date1-date2 �� ����祭�� � ����������
  if valtype(date2) == 'D'
    if (fl2 := (date2 >= _begin_date)) .and. !empty(_end_date)
      fl2 := (date2 <= _end_date)
    endif
    fl := (fl .or. fl2)
  endif
  return fl
