#include 'hbclass.ch'
#include 'common.ch'
#include 'property.ch'
#include 'function.ch'

// класс описания текстового файла для вывода
CREATE CLASS TFileText
  VISIBLE:
    METHOD New( NameFile )
    METHOD add_string( str )
    METHOD next_list(n)
    METHOD verify_FF(h, f_next_list, width, blk)

  HIDDEN:
    DATA fp
    DATA FName
    DATA F_sh INIT 80
    DATA F_HH INIT 60
    DATA F_n_list INIT 1
    DATA F_tek_stroke INIT 0
    DATA F_verify_FF INIT .f.

		DESTRUCTOR  __My_dtor
END CLASS

METHOD New( NameFile )  CLASS TFileText

  if NameFile == nil .or. empty(NameFile)
    return nil
  endif

  ::FName := NameFile
  ::fp := fcreate( ::FName )

  return self

METHOD procedure add_string( str )  CLASS TFileText

  DEFAULT stroke TO ""
  Inc(::F_tek_stroke)
  fwrite(::fp, str + chr(13) + chr(10))
  return

METHOD procedure next_list(n)  CLASS TFileText
  DEFAULT n TO 80
  if ::F_n_list > 1
    add_string(padl('Лист ' + lstr(::F_n_list), n))
    add_string('')
  endif
  return
    
METHOD function verify_FF(h, f_next_list, width, blk)  CLASS TFileText
  // проверить и, если необходимо, поставить символ перевода формата
  // h           - кол-во строк на листе
  // f_next_list - флаг, указывающий на необходимость вызова ф-ии next_list()
  // width       - параметр для ф-ии next_list()
  if ::F_tek_stroke > h
    DEFAULT f_next_list TO .f.
    VALDEFAULT blk, 'B' TO {|| .t. }
    eval(blk)
    add_string(chr(12))
    ::F_tek_stroke := 0
    Inc(::F_n_list)
    if f_next_list
      next_list(width)
    endif
    return .t.
  endif
  return .f.
    
METHOD procedure __My_dtor CLASS TFileText
    
  if ::fp != nil
    FClose(::fp)
  endif
  return
  