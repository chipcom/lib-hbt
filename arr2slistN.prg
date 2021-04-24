#include 'function.ch'
#include 'inkey.ch'

Function arr2SlistN(arr)
  Local i, sList := ""
  if valtype(arr)=="A" .and. len(arr) > 0
    for i := 1 to len(arr)
      sList += alltrim(arr[i])+","
    next
    sList := left(sList,len(sList)-1)
  endif
  return sList
  