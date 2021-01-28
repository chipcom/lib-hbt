#require 'xhb'
#require 'hbmisc'

#include 'hbdll.ch'

IMPORT static DebugMessageBox( hWnd, cMsg, cText, nFlags ) FROM user32.dll EXPORTED AS MessageBoxA

// Function to convert any type to string.
//  Правила перевода:
// строка - без изменения
// число  - строка
// дата   - строка
// объект - 'объект'
// NIL    - 'пусто!'
// блок кода - строка от результата
// массив    - слияние строк от элементов
// мемо      - значение
// логическое- 'истина' или ' ложь '
function xtoc( parm, len, dec )
	local t := '', ln := 0, i := 0, p := .f., ret
    ret := ''
    t = valtype( parm )
    do case
        case t = 'A'
            ln = len( parm )
            for i = 1 to ln
                ret := ret + xtoc( parm[ i ] )
            next
        case t = 'B'
            ret := xtoc( eval( parm ) )
        case t = 'C'
            ret := parm
        case t = 'D'
            ret := dtoc( parm )
        case t = 'L'
            ret := if( parm, 'TRUE ', 'FALSE' )
        case t = 'M'
            ret := parm
        case t = 'N'
            if !empty( len ) .and. !empty( dec )
               ret := str( parm, len, dec )
			elseif !empty( len )
//               ret:=str(parm,len)
                if len( alltrim( STR( parm ) ) ) > len
					ret := replicate( '*', len )
				else
					ret := padl( str( parm ), len )
				endif
			else
				ret := str( parm )
            endif
            p := .t.
        case t = 'O'
            ret := 'object'
        case t = 'U'
            ret := 'empty!'
        otherwise
            ret := '.?.'
   endcase
return ret

/*
    AsString
*/
function AsString( xVal, descript )

   LOCAL result
   local tmp

   switch ValType( xVal )
   case 'C'
      if ! empty(descript)
         return descript + " (Char): " + xVal
      else
         return xVal
      endif
   case 'D'
      if empty( xVal )
         tmp := '  /   /    '
      else
         tmp := str( day( xVal ), 2 ) + '/' + left( cmonth( xVal ), 3 ) + '/' + str( year( xVal ), 4 )
      endif
      if ! empty(descript)
         return descript + " (Date): " + tmp
      else
         return tmp
      endif
   case 'B'
      tmp := '{|| ... }'
      if ! empty(descript)
         return descript + " (BlockCode): " + tmp
      else
         return tmp
      endif
   case 'L'
      tmp := iif( xVal, '.T.', '.F.' )
      if ! empty(descript)
         return descript + " (Logical): " + tmp
      else
         return tmp
      endif
   case 'N'
      tmp := ltrim( str( xVal ) )
      if ! empty(descript)
         return descript + " (Numeric): " + tmp
      else
         return tmp
      endif
   case 'O'
      BEGIN SEQUENCE WITH {| oErr| break( oErr ) }
         if xVal:IsDerivedFrom( 'TTime' )
            tmp := xVal:AsString
         else
            tmp := '<Object>: ' + xVal:ClassName
         endif
      RECOVER
         tmp := '<Object Not Valid>'
      END SEQUENCE
      if ! empty(descript)
         return descript + " (Object): " + tmp
      else
         return tmp
      endif
   case 'A'
      tmp := '<Array>: ' + LTrim( Str( Len( xVal ) ) )
      if ! empty(descript)
         return descript + " (Array): " + tmp
      else
         return tmp
      endif
   case 'T'
      tmp := hb_tToC( xVal )
      if ! empty(descript)
         return descript + " (Numeric): " + tmp
      else
         return tmp
      endif
   endswitch
   return ''

function AlertX( param, descript )
	
	HB_Default( @descript, "" ) 
	// HB_Default( @dec, 0 ) 
	alert( AsString( param, descript ) )
	return nil

function AlertXList( param )
	local item
	
	for each item in param
		alertx(item)
	next
	return nil

function win_AlertX( param )
	
	HB_Default( @param, '' ) 
	hb_threadDetach( hb_threadStart( @DebugMessageBox(),  0, AsString( param ), win_OEMToAnsi( 'Отладка' ) ) )
	return nil