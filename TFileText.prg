#include 'hbclass.ch'
#include 'common.ch'
#include 'property.ch'
#include 'fileio.ch'
#include 'tfile.ch'

#translate MAX( <a>, <b>, <c>, <d>, <e> ) => MAX( MAX( MAX( MAX( <a>, <b> ), <c> ), <d> ), <e> )

// класс описания текстового файла для вывода
CREATE CLASS TFileText
  VISIBLE:
    PROPERTY NameFile READ getNameFile
    PROPERTY Heigh READ getHeigh WRITE setHeigh
    PROPERTY Width READ getWidth WRITE setWidth
    PROPERTY EnablePageBreak READ getPageBreak WRITE setPageBreak
    PROPERTY TableHeader WRITE setTableHeader
    PROPERTY EnableTableHeader READ getEnableTableHeader WRITE setEnableTableHeader
    PROPERTY VerticalSeparator READ getVerticalSeparator WRITE setVerticalSeparator
    PROPERTY TableFooterEnable WRITE setTableFooterEnable

    METHOD New( NameFile, width, page_break, high, num_page ) CONSTRUCTOR
    METHOD Close()
    METHOD add_string( str, align, cFill )
    METHOD Add_Column( title, width, align, cFill, wrap )
    METHOD Add_Row( aRow )
    METHOD End_Table()
    METHOD PageBreak()
    METHOD PrintTableHeader()
    METHOD Size()

  HIDDEN:
    DATA fp
    DATA FName
    DATA F_sh INIT 80
    DATA F_HH INIT 60
    DATA F_count_page INIT 1
    DATA F_current_line INIT 0
    DATA F_page_break INIT .f.
    DATA F_num_page INIT .f.
    DATA F_align INIT FILE_LEFT
    DATA F_enable_table_header INIT .f.
    DATA F_table_header INIT {}
    DATA F_table_footer INIT ''
    DATA F_table_enable_footer INIT .f.
    DATA F_table_column INIT {}
    DATA F_column_wrap INIT .f.
    DATA F_first_column INIT .t.
    DATA F_symbol INIT { '─', '│', '┬', '┴' }
    DATA F_vertical_separator INIT chr( 32 )

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
    METHOD getVerticalSeparator() INLINE ::F_vertical_separator
    METHOD setVerticalSeparator( lVal )   INLINE ::F_vertical_separator := lVal
    METHOD setTableFooterEnable( lVal )   INLINE ::F_table_enable_footer := lVal
      
    METHOD control_page_break()
    METHOD word_wrap( str, n, symb )
            
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
  ::F_current_line := 0
  ::F_count_page := 1
  ::F_page_break := page_break
  ::F_num_page := num_page
  return self

METHOD procedure Add_Row( aRow ) CLASS TFileText

  local i, str
  local j, aTemp, max_capacity := 0, arr := {}
  local arrTemp

  hb_default( @aRow, {} )
  aTemp := {}
  for i := 1 to len( aRow )
    arrTemp := { ::word_wrap( aRow[ i ], ::F_table_column[ i, 1 ] ) }
    if ( ! ::F_table_column[ i, 5 ] ) .and. ( len( arrTemp[ 1 ] ) > 1 )
      asize( arrTemp[ 1 ], 1 )
    endif
    AAdd( aTemp, arrTemp )
    max_capacity := iif( len( arrTemp[ 1 ] ) > max_capacity, len( arrTemp[ 1 ] ), max_capacity )

//    AAdd( aTemp, { ::word_wrap( aRow[ i ], ::F_table_column[ i, 1 ] ) } )
//    max_capacity := iif( len( aTemp[ i, 1 ] ) > max_capacity, len( aTemp[ i, 1 ] ), max_capacity )

  next
  for j := 1 to max_capacity
    str := ''
    for i := 1 to len( aRow )
      if ( len( aTemp[ i, 1 ] ) >= j  .and. ( ::F_table_column[ i, 5 ] ) ) .or. ;
          ( ( ! ::F_table_column[ i, 5 ] ) .and. ( j == 1 ) )
        if ::F_table_column[ i, 2 ] == FILE_LEFT
          str += PadRight( alltrim( aTemp[ i, 1, j ] ), ::F_table_column[ i, 1 ], ::F_table_column[ i, 4 ] )
        elseif ::F_table_column[ i, 2 ] == FILE_RIGHT
          str += PadLeft( alltrim( aTemp[ i, 1, j ] ), ::F_table_column[ i, 1 ], ::F_table_column[ i, 4 ] )
        elseif ::F_table_column[ i, 2 ] == FILE_CENTER
          str += Center( alltrim( aTemp[ i, 1, j ] ), ::F_table_column[ i, 1 ], ::F_table_column[ i, 4 ], .t. )
        endif
      else
        str += space( ::F_table_column[ i, 1 ] )
      endif
      
      str += ::F_vertical_separator   // chr( 32 )  // ::F_symbol[ 2 ]
    next i
    ::add_string( str )
  next
  return

METHOD procedure Add_Column( title, width, align, cFill, wrap, align_header ) CLASS TFileText

  hb_default( @title, '' )
  hb_default( @width, 0 )
  hb_default( @align, FILE_LEFT )
	hb_default( @cFill, chr( 32 ) )
	hb_default( @wrap, .f. )
	hb_default( @align_header, align )
  AAdd( ::F_table_column, { width, align, title, cFill, wrap } )
  if len( ::F_table_header ) == 0
    AAdd( ::F_table_header, '' )
    AAdd( ::F_table_header, '' )
    AAdd( ::F_table_header, '' )
  endif
  if wrap
    ::F_column_wrap := .t.
  endif
  if ! ::F_first_column
    ::F_table_header[ 1 ] += ::F_symbol[ 3 ]
    ::F_table_header[ 2 ] += ::F_symbol[ 2 ]
    ::F_table_header[ 3 ] += ::F_symbol[ 4 ]
    ::F_table_footer += ::F_symbol[ 4 ]
  endif
  ::F_table_header[ 1 ] += Replicate( ::F_symbol[ 1 ], width )
  ::F_table_header[ 3 ] += Replicate( ::F_symbol[ 1 ], width )
  ::F_table_footer += Replicate( ::F_symbol[ 1 ], width )
  if align_header == FILE_LEFT
    ::F_table_header[ 2 ] += PadRight( title, width, cFill )
  elseif align_header == FILE_RIGHT
    ::F_table_header[ 2 ] += PadLeft( title, width, cFill )
  elseif align_header == FILE_CENTER
    ::F_table_header[ 2 ] += Center( title, width, cFill, .t. )
  endif
  ::F_first_column := .f.
  return

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
  
  local i, aLen := len( ::F_table_header )

  if aLen > 0
    for i := 1 to aLen
      ::add_string( ::F_table_header[ i ] )
    next
  endif
  return

METHOD procedure add_string( str, align, cFill )  CLASS TFileText

	hb_default( @align, FILE_LEFT )
	hb_default( @cFill, chr( 32 ) )
	hb_default( @str, '' )
  ::control_page_break()
  if align == FILE_LEFT
    str := padr( str, ::F_sh, cFill )
  elseif align == FILE_RIGHT
    str := padl( str, ::F_sh, cFill )
  elseif align == FILE_CENTER
    str := padc( str, ::F_sh, cFill )
  endif
  HB_VFWRITE( ::fp, str + hb_eol() )
  return

METHOD procedure End_Table()  CLASS TFileText

  if ::F_table_enable_footer
  ::add_string( ::F_table_footer + hb_eol() )
  ::F_table_enable_footer := .f.
  endif
  return

METHOD function control_page_break()  CLASS TFileText
  
  local strPage, strWrite

  ::F_current_line ++
  if ::F_page_break
    if ::F_current_line == ::F_HH .and. ::F_table_enable_footer
      strWrite := ::F_table_footer + hb_eol()
      HB_VFWRITE( ::fp, strWrite )
      ::F_current_line ++
    endif
    if ::F_current_line > ::F_HH
      ::PageBreak()
      if ::F_enable_table_header
        ::printTableHeader()
      endif
    endif
  endif
  return .f.

METHOD procedure PageBreak()  CLASS TFileText
  
  local strPage, strWrite
  
  HB_VFWRITE( ::fp, chr( 12 ) )
  ::F_count_page ++
  if ::F_num_page
    strPage := 'Лист ' + alltrim( Str( ::F_count_page ) )
    strWrite := padl( strPage, ::F_sh ) + hb_eol()
    HB_VFWRITE( ::fp, strWrite )
    ::F_current_line := 2
  else
    ::F_current_line := 1
  endif
  return
  
METHOD procedure Close CLASS TFileText
    
  if ::fp != nil
    HB_VFCLOSE( ::fp )
  endif
  return

METHOD procedure __My_dtor CLASS TFileText
    
  if ::fp != nil
    HB_VFCLOSE( ::fp )
  endif
  return
  
METHOD function word_wrap( str, n, symb ) CLASS TFileText
  // str    - строка, которая будет разрезаться
  // n    - количество символов в обрезках строк
  // symb - подмножество симоволов из " ,;-+/" (разделители для переноса)
  
  Local i := 0, i1, i2, i3, i4, i5, i6, j, fl, s1
  local aStr
  
  DEFAULT symb TO ' ,;-'
  aStr := {}
  if empty( str := RTRIM( str ) )
    if len( aStr ) == 0
      asize( aStr, 1 )
    endif
    aStr[ 1 ] := space( n )
    return aStr
  endif
  DO WHILE .T.
    IF LEN( str ) <= n
      if ++i > len( aStr )
        asize( aStr, i )
      endif
      aStr[ i ] := padr( str, n )
      EXIT
    ELSEIF SUBSTR( str, n + 1, 1 ) == ' ' // если после отрезания сразу идет пробел
      if ++i > len( aStr )
        asize( aStr, i )
      endif
      aStr[ i ] := SUBSTR( str, 1, n )
      str := LTRIM( SUBSTR( str, n + 1 ) )
    ELSE
      s1 := SUBSTR( str, 1, n )
      i1 := if( ' ' $ symb, RAT( ' ', s1 ), 0 )
      i2 := if( ',' $ symb, RAT( ',', s1 ), 0 )
      i3 := if( ';' $ symb, RAT( ';', s1 ), 0 )
      i4 := if( '-' $ symb, RAT( '-', s1 ), 0 )
      i5 := if( '+' $ symb, RAT( '+', s1 ), 0 )
      i6 := if( '/' $ symb, RAT( '/', s1 ), 0 )
      j := MAX( i2, i3, i4, i5, i6 )
      fl := ( i1 > j )
      j := MAX( j, i1 )
      if ++i > len( aStr )
        asize( aStr, i )
      endif
      IF j > 0
        aStr[ i ] := padr( SUBSTR( s1, 1, IF( fl, j - 1, j ) ), n )
        str := LTRIM( SUBSTR( str, j + 1 ) )
      ELSE
        aStr[ i ] := SUBSTR( str, 1, n )
        str := LTRIM( SUBSTR( str, n + 1 ) )
      ENDIF
    ENDIF
  ENDDO
  RETURN aStr       //  вернуть массив получившихся строк
