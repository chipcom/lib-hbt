function main()
  local str1 := 'О сколько нам открытий чудных'
  local str2 := 'раз, два, три'
  local str3 := 'раз, два. три'
  local arr, arr1, arr2, arr3
  local aTokens

  REQUEST HB_CODEPAGE_RU866
  HB_CDPSELECT("RU866")
  REQUEST HB_LANG_RU866
  HB_LANGSELECT("RU866")
  
  // arr := Split(str1)
  // arr1 := Split(str2, ',')
  // arr2 := Split(str2)
  // arr3 := Split(str2, '.')

  // alertx(arr, str1)
  // alertx(arr1, str2)
  // alertx(arr2, str2)
  // alertx(arr3, str3)
  ? str1
  aTokens := Split(str1)
  AEval( aTokens, {| token, n | QOut( hb_ntos(n), token ) } )

  ? str2
  aTokens := Split(str2, ',')
  AEval( aTokens, {| token, n | QOut( hb_ntos(n), token ) } )

  ? str2
  aTokens := Split(str2)
  AEval( aTokens, {| token, n | QOut( hb_ntos(n), token ) } )

  ? str3
  aTokens := Split(str3, ',')
  AEval( aTokens, {| token, n | QOut( hb_ntos(n), token ) } )
  Inkey(0)
return nil