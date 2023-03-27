#include 'hbclass.ch'
#include 'common.ch'
#include 'property.ch'
#include 'fileio.ch'

// класс описания текстового файла для вывода
CREATE CLASS TFileText
  VISIBLE:
    METHOD New( NameFile, width, verify_FF, high, num_page )
    METHOD add_string( str )

  HIDDEN:
    DATA fp
    DATA FName
    DATA F_sh INIT 80
    DATA F_HH INIT 60
    DATA F_n_list INIT 1
    DATA F_tek_stroke INIT 0
    DATA F_verify_FF INIT .f.
    DATA F_num_page INIT .f.
    DATA F_nFileOutput

    METHOD verify_FF()

		DESTRUCTOR  __My_dtor
END CLASS

METHOD New( NameFile, width, verify_FF, high, num_page )  CLASS TFileText

	hb_default( @width, 80 )
	hb_default( @verify_FF, .f. )
	hb_default( @high, 60 )
	hb_default( @num_page, .f. )

  if NameFile == nil .or. empty(NameFile)
    return nil
  endif

  ::FName := NameFile
  // ::fp := fcreate( ::FName )
  ::F_HH := high
  ::F_sh := width
  ::F_tek_stroke := 0
  ::F_n_list := 1
  ::F_verify_FF := verify_FF
  ::F_num_page := num_page
  IF ( ::fp := hb_vfOpen( ::FName, FO_CREAT + FO_TRUNC + FO_WRITE ) ) == nil
    return nil
  endif
  ::F_nFileOutput := hb_vfHandle( ::fp )

  return self

METHOD procedure add_string( str )  CLASS TFileText

	hb_default( @str, '' )
  ::verify_FF()
  fwrite(::F_nFileOutput, str + hb_eol())
  return

METHOD function verify_FF()  CLASS TFileText
  local strPage, strWrite

  ::F_tek_stroke ++
  if ::F_verify_FF
    if ::F_tek_stroke > ::F_HH
      fwrite(::F_nFileOutput, chr(12))
      fwrite(::F_nFileOutput, hb_eol())
      if ::F_num_page
        strPage := 'Лист ' + alltrim(hb_ValToStr(::F_n_list))
        strWrite := PadLeft( strPage, ::F_sh - len(strPage) )
        fwrite(::F_nFileOutput, strWrite )//, [<cChar|nChar>] ) ? cString
        fwrite(::F_nFileOutput, '')
        ::F_n_list ++
        ::F_tek_stroke := 2
      else
        ::F_tek_stroke := 1
      endif
    endif
  endif
  return .f.
    
METHOD procedure __My_dtor CLASS TFileText
    
  if ::fp != nil
    hb_vfClose(::fp)
  endif
  return
  