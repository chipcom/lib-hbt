
***** проверяет попадает ли date1 (диапазон date1-date2) в диапазон _begin_date-_end_date
Function dateInRange( _begin_date, _end_date, date1, date2 )
  // _begin_date - начало действия
  // _end_date   - окончание действия
  // date1 - проверяемая дата
  // date2 - вторая дата диапазона (если = NIL, то проверяем только по date1)
  Local fl := .f., fl2

  hb_default( @date1, date() )  // по умолчанию проверяем на текущую дату

  // DEFAULT date1 TO sys_date  // по умолчанию проверяем на сегодняшний момент
  if empty(_begin_date)
    _begin_date := stod( '19930101' )  // если начало действия = пусто, то 01.01.1993
  endif
  // проверка даты date1 на попадание в диапазон
  if (fl := (date1 >= _begin_date)) .and. !empty(_end_date)
    fl := (date1 <= _end_date)
  endif
  // проверка диапазона date1-date2 на пересечение с диапазоном
  if valtype(date2) == 'D'
    if (fl2 := (date2 >= _begin_date)) .and. !empty(_end_date)
      fl2 := (date2 <= _end_date)
    endif
    fl := (fl .or. fl2)
  endif
  return fl
