#include 'hbclass.ch'
#include 'common.ch'
#include 'property.ch'
#include 'fileio.ch'
#include 'tfile.ch'

// класс описания текстового файла для вывода
CREATE CLASS TFileText
  VISIBLE:
    PROPERTY Heigh READ getHeigh WRITE setHeigh
    PROPERTY Width READ getWidth WRITE setWidth
    PROPERTY PageBreak READ getPageBreak WRITE setPageBreak

    METHOD New( NameFile, width, page_break, high, num_page ) CONSTRUCTOR
    METHOD add_string( str )

  HIDDEN:
    DATA fp
    DATA FName
    DATA F_sh INIT 80
    DATA F_HH INIT 60
    DATA F_count_page INIT 1
    DATA F_current_lina INIT 0
    DATA F_page_break INIT .f.
    DATA F_num_page INIT .f.
    DATA F_align INIT FILE_LEFT

    METHOD page_break()
    METHOD getHeigh()             INLINE ::F_HH
    METHOD setHeigh( nVal )       INLINE ::F_HH := nVal
    METHOD getWidth()             INLINE ::F_sh
    METHOD setWidth( nVal )       INLINE ::F_sh := nVal
    METHOD getPageBreak()         INLINE ::F_page_break
    METHOD setPageBreak( lVal )   INLINE ::F_page_break := lVal
        
		DESTRUCTOR  __My_dtor
END CLASS

METHOD New( NameFile, width, page_break, high, num_page )  CLASS TFileText

	hb_default( @width, 80 )
	hb_default( @page_break, .f. )
	hb_default( @high, 60 )
	hb_default( @num_page, .f. )

  if NameFile == nil .or. empty(NameFile)
    return nil
  endif

  ::FName := NameFile

  if (::fp := fcreate( ::FName )) == F_ERROR
    return nil
  endif

  ::F_HH := high
  ::F_sh := width
  ::F_current_lina := 0
  ::F_count_page := 1
  ::F_page_break := page_break
  ::F_num_page := num_page
  return self

METHOD procedure add_string( str, align, cFill )  CLASS TFileText

	hb_default( @align, FILE_LEFT )
	hb_default( @cFill, ' ' )
	hb_default( @str, '' )
  ::page_break()
  if align == FILE_LEFT
    str := padr(str, ::F_sh, cFill)
  elseif align == FILE_RIGHT
    str := padl(str, ::F_sh, cFill)
  elseif align == FILE_CENTER
    str := padc(str, ::F_sh, cFill)
  endif
  fwrite(::fp, str + hb_eol())
  return

METHOD function page_break()  CLASS TFileText
  local strPage, strWrite

  ::F_current_lina ++
  if ::F_page_break
    if ::F_current_lina > ::F_HH
      fwrite(::fp, chr(12))
      ::F_count_page ++
      if ::F_num_page
        strPage := 'Лист ' + alltrim(Str(::F_count_page))
        // strWrite := PadLeft( strPage, ::F_sh - len(strPage) ) + hb_eol()
        strWrite := padl(strPage, ::F_sh) + hb_eol()
        fwrite(::fp, strWrite )//, [<cChar|nChar>] ) ? cString
        ::F_current_lina := 2
      else
        ::F_current_lina := 1
      endif
    endif
  endif
  return .f.
    
METHOD procedure __My_dtor CLASS TFileText
    
  if ::fp != nil
    FClose(::fp)
  endif
  return
  