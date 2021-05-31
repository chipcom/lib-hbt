*** 31.05.21
*** функция нахождения максимальной длины строки в массиве строк
function maxLenStringInArray(arr)
  local max := 0, i

  for i := 1 to len(arr)
    if max < len(arr[i])
      max := len(arr[i])
    endif
  next
  return max
