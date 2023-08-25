#include 'hbclass.ch'
#include 'common.ch'
#include 'property.ch'
#include 'fileio.ch'
#include 'tfile.ch'

// ����� ���ᠭ�� ⥪�⮢��� 䠩�� ��� �뢮��
CREATE CLASS TFileText
  VISIBLE:
    PROPERTY NameFile READ getNameFile
    PROPERTY Heigh READ getHeigh WRITE setHeigh
    PROPERTY Width READ getWidth WRITE setWidth
    PROPERTY EnablePageBreak READ getPageBreak WRITE setPageBreak
    PROPERTY TableHeader WRITE setTableHeader
    PROPERTY EnableTableHeader READ getEnableTableHeader WRITE setEnableTableHeader

    METHOD New( NameFile, width, page_break, high, num_page ) CONSTRUCTOR
    METHOD Close()
    METHOD add_string( str, align, cFill )
    METHOD PageBreak()
    METHOD PrintTableHeader()
    METHOD Size()

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
    DATA F_enable_table_header INIT .f.
    DATA F_table_header INIT {}

    METHOD getNameFile()          INLINE ::FName
    METHOD getHeigh()             INLINE ::F_HH
    METHOD setHeigh( nVal )       INLINE ::F_HH := nVal
    METHOD getWidth()             INLINE ::F_sh
    METHOD setWidth( nVal )       INLINE ::F_sh := nVal
    METHOD getPageBreak()         INLINE ::F_page_break
    METHOD setPageBreak( lVal )   INLINE ::F_page_break := lVal
    METHOD setTableHeader( aHeader )
    METHOD getEnableTableHeader() INLINE ::F_enable_table_header
    METHOD setEnableTableHeader( lVal )   INLINE ::F_enable_table_header := lVal
    METHOD control_page_break()
            
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

  if (::fp := HB_VFOPEN( ::FName, FO_CREAT + FO_TRUNC + FO_WRITE + FO_EXCLUSIVE )) == nil
    return nil
  endif

  ::F_HH := high
  ::F_sh := width
  ::F_current_lina := 0
  ::F_count_page := 1
  ::F_page_break := page_break
  ::F_num_page := num_page
  return self

METHOD function Size()  CLASS TFileText
	if !isnil(::fp)
		return HB_VFSIZE(::fp)
	endif
	return 0
		

METHOD procedure setTableHeader( aHeader )  CLASS TFileText

  hb_default( @aHeader, {})
  ::F_table_header := aHeader
  return

METHOD procedure PrintTableHeader()  CLASS TFileText
  local i, aLen := len(::F_table_header)

  if aLen > 0
    for i := 1 to aLen
      ::add_string( ::F_table_header[i] )
    next
  endif
  return

METHOD procedure add_string( str, align, cFill )  CLASS TFileText

	hb_default( @align, FILE_LEFT )
	hb_default( @cFill, ' ' )
	hb_default( @str, '' )
  ::control_page_break()
  if align == FILE_LEFT
    str := padr(str, ::F_sh, cFill)
  elseif align == FILE_RIGHT
    str := padl(str, ::F_sh, cFill)
  elseif align == FILE_CENTER
    str := padc(str, ::F_sh, cFill)
  endif
  HB_VFWRITE(::fp, str + hb_eol())
  return

METHOD function control_page_break()  CLASS TFileText
  local strPage, strWrite

  ::F_current_lina ++
  if ::F_page_break
    if ::F_current_lina > ::F_HH
      HB_VFWRITE(::fp, chr(12))
      ::F_count_page ++
      if ::F_num_page
        strPage := '���� ' + alltrim(Str(::F_count_page))
        // strWrite := PadLeft( strPage, ::F_sh - len(strPage) ) + hb_eol()
        strWrite := padl(strPage, ::F_sh) + hb_eol()
        HB_VFWRITE(::fp, strWrite )//, [<cChar|nChar>] ) ? cString
        ::F_current_lina := 2
      else
        ::F_current_lina := 1
      endif
      if ::F_enable_table_header
        ::printTableHeader()
      endif
    endif
  endif
  return .f.

METHOD procedure PageBreak()  CLASS TFileText
  local strPage, strWrite
  
  HB_VFWRITE(::fp, chr(12))
  ::F_count_page ++
  if ::F_num_page
    strPage := '���� ' + alltrim(Str(::F_count_page))
    strWrite := padl(strPage, ::F_sh) + hb_eol()
    HB_VFWRITE(::fp, strWrite )
    ::F_current_lina := 2
  else
    ::F_current_lina := 1
  endif
  return
  
METHOD procedure Close CLASS TFileText
    
  if ::fp != nil
    HB_VFCLOSE(::fp)
  endif
  return

METHOD procedure __My_dtor CLASS TFileText
    
  if ::fp != nil
    HB_VFCLOSE(::fp)
  endif
  return
  