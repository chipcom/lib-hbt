function main()
  local str1 := '� ᪮�쪮 ��� ����⨩ �㤭��'
  local str2 := 'ࠧ, ���, ��'
  local arr, arr1, arr2

  REQUEST HB_CODEPAGE_RU866
  HB_CDPSELECT("RU866")
  REQUEST HB_LANG_RU866
  HB_LANGSELECT("RU866")
  
  arr := Split(str1)
  arr1 := Split(str2, ',')
  arr2 := Split(str2)

  alertx(arr, str1)
  alertx(arr1, str2)
  alertx(arr2, str2)

return nil