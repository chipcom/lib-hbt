#include 'hbclass.ch'
#include 'common.ch'
#include 'property.ch'
#include 'function.ch'
#include 'tbox.ch'

// класс описания оконной области
CREATE CLASS TBox

	VISIBLE:
		PROPERTY Top READ getTop WRITE setTop
		PROPERTY Left READ getLeft WRITE setLeft
		PROPERTY Bottom READ getBottom WRITE setBottom
		PROPERTY Right READ getRight WRITE setRight
		PROPERTY Color READ getColor WRITE setColor
		PROPERTY Frame READ getFrame WRITE setFrame
		PROPERTY Shadow READ getShadow WRITE setShadow
		PROPERTY Caption READ getCaption WRITE setCaption
		PROPERTY CaptionColor READ getCaptionColor WRITE setCaptionColor
		PROPERTY Save READ getSave WRITE setSave
		PROPERTY ChangeAttr READ getChangeAttr WRITE setChangeAttr
		PROPERTY MessageLine AS ARRAY WRITE setMessageLine
		PROPERTY HasMessageLine AS LOGICAL READ getHasMessageLine
		PROPERTY Visible AS LOGICAL READ getVisible
		PROPERTY Height AS NUMERIC READ getHeight
		PROPERTY Width AS NUMERIC READ getWidth
		
		METHOD New( nTop, nLeft, nBottom, nRight, lShadow )
		METHOD View()
		METHOD Clear()
	HIDDEN:
		
		DATA FTop			INIT 0
		DATA FLeft			INIT 0
		DATA FBottom		INIT 0
		DATA FRight			INIT 0
		DATA FColor			INIT 'W+/B,W+/R,,,BG+/B'
		DATA FFrame			INIT 2
		DATA FShadow		INIT .f.
		DATA FCaption		INIT ''
		DATA FCaptionColor	INIT 'N/W,GR+/R,,,B/W'
		DATA FSave			INIT .t.
		DATA FMessageLine	INIT {}
		
		DATA FlenMessage	INIT 0
		DATA _saveScreen	INIT ''
		DATA _saveMessage	INIT ''
		DATA _isView		INIT .f.
		DATA _setColor
		DATA aRgnStack		INIT {}
		DATA _nStackPtr		INIT 0
		DATA FChange_Attr	INIT .f.
		
		METHOD getTop
		METHOD setTop( nValue )
		METHOD getLeft
		METHOD setLeft( nValue )
		METHOD getBottom
		METHOD setBottom( nValue )
		METHOD getRight
		METHOD setRight( nValue )
		METHOD getColor
		METHOD setColor( cValue )
		METHOD getFrame
		METHOD setFrame( nValue )
		METHOD getShadow
		METHOD setShadow( lValue )
		METHOD getCaption
		METHOD setCaption( cValue )
		METHOD getCaptionColor
		METHOD setCaptionColor( cValue )
		METHOD setMessageLine( param )
		METHOD getSave
		METHOD setSave( lValue )
		METHOD getChangeAttr
		METHOD setChangeAttr( lValue )
		METHOD getHasMessageLine
		METHOD getVisible
		METHOD getHeight
		METHOD getWidth
		
		METHOD statusBar( cStr, cColor1, cColor2 )
		
		METHOD SavRgn( nTop, nLeft, nBottom, nRight )
		METHOD RstRgn( cScreen, nTop, nLeft )
		METHOD RgnStack( cAction, nTop, nLeft, nBottom, nRight )
		METHOD Change_attr()
		
		DESTRUCTOR  __My_dtor
		
END CLASS

METHOD function getWidth 		 CLASS TBox
return ::FRight - ::FLeft

METHOD function getHeight 		 CLASS TBox
	return ::FBottom - ::FTop + 1

METHOD function getVisible 		 CLASS TBox
	return ::_isView

METHOD PROCEDURE setMessageLine( param ) 		 CLASS TBox

	if ischaracter( param )
		&& ::FMessageLine := param
		aadd( ::FMessageLine, param )
		::FlenMessage := 1
	elseif isarray( param )
		::FMessageLine := param
		::FlenMessage := len( param )
	endif
	return

METHOD function getHasMessageLine 		 CLASS TBox
	return !empty( ::FMessageLine )

METHOD FUNCTION getTop() 		 CLASS TBox
	return ::FTop

METHOD PROCEDURE setTop( nValue ) 		 CLASS TBox
	
	if isnumber( nValue ) .and. nValue >= 0
		::FTop := nValue
	endif
	return

METHOD FUNCTION getLeft() 		 CLASS TBox
	return ::FLeft

METHOD PROCEDURE setLeft( nValue ) 		 CLASS TBox
	
	if isnumber( nValue ) .and. nValue >= 0
		::FLeft := nValue
	endif
	return

METHOD FUNCTION getBottom() 		 CLASS TBox
	return ::FBottom

METHOD PROCEDURE setBottom( nValue ) 		 CLASS TBox
	
	if isnumber( nValue ) .and. nValue >= 0
		::FBottom := nValue
	endif
	return

METHOD FUNCTION getRight() 		 CLASS TBox
	return ::FRight

METHOD PROCEDURE setRight( nValue ) 		 CLASS TBox
	
	if isnumber( nValue ) .and. nValue >= 0
		::FRight := nValue
	endif
	return

METHOD FUNCTION getColor() 		 CLASS TBox
	return ::FColor

METHOD PROCEDURE setColor( cValue ) 		 CLASS TBox
	
	if ischaracter( cValue )
		::FColor := cValue
	endif
	return

METHOD FUNCTION getFrame() 		 CLASS TBox
	return ::FFrame

METHOD PROCEDURE setFrame( nValue ) 		 CLASS TBox
	
	if isnumber( nValue ) .and. nValue >= 0 .and. nValue <= 4
		::FFrame := nValue
	endif
	return

METHOD FUNCTION getShadow() 		 CLASS TBox
	return ::FShadow

METHOD PROCEDURE setShadow( lValue ) 		 CLASS TBox
	
	if islogical( lValue )
		::FShadow := lValue
	endif
	return

METHOD FUNCTION getSave() 		 CLASS TBox
	return ::FSave

METHOD PROCEDURE setSave( lValue ) 		 CLASS TBox
	
	if islogical( lValue )
		::FSave := lValue
	endif
	return

METHOD FUNCTION getChangeAttr() 		 CLASS TBox
	return ::FChange_Attr

METHOD PROCEDURE setChangeAttr( lValue ) 		 CLASS TBox
	
	if islogical( lValue )
		::FChange_Attr := lValue
	endif
	return

METHOD FUNCTION getCaption() 		 CLASS TBox
	return ::FCaption

METHOD PROCEDURE setCaption( cValue ) 		 CLASS TBox

	if ischaracter( cValue )
		::FCaption := cValue
	endif
	return

METHOD FUNCTION getCaptionColor() 		 CLASS TBox
	return ::FCaptionColor

METHOD PROCEDURE setCaptionColor( cValue ) 		 CLASS TBox
	
	if ischaracter( cValue )
		::FCaptionColor := cValue
	endif
	return

METHOD New( nTop, nLeft, nBottom, nRight, lShadow )  CLASS TBox

	hb_default( @nTop, 0 )
	hb_default( @nLeft, 0 )
	hb_default( @nBottom, 0 )
	hb_default( @nRight, 0 )
	hb_default( @lShadow, .f. )
	
	::FTop		:= if( valtype( nTop ) == 'N', nTop, 0 )
	::FLeft		:= if( valtype( nLeft ) == 'N', nLeft, 0 )
	::FBottom	:= if( valtype( nBottom ) == 'N', nBottom, 0 )
	::FRight	:= if( valtype( nRight ) == 'N', nRight, 0 )
	::FShadow	:= if( valtype( lShadow ) == 'L', lShadow, .f. )
	return self

METHOD procedure Clear() CLASS TBox

	@ ::FTop, ::FLeft clear to ::FBottom, ::FRight
	return

METHOD PROCEDURE View()  CLASS TBox
	local tmp
	local i, length

	if ::FChange_Attr
		::RgnStack( 'push', 0,  0, maxrow(), maxcol() )
		::Change_attr()
	else
		if ::FSave
			if ! empty( ::FMessageLine )
				for i := ::FlenMessage to 1 step -1
					::RgnStack( 'push', maxrow() - i + 1,  0, maxrow() - i + 1, maxcol() )
				next
			endif
			::RgnStack( 'push', ::FTop, ::FLeft, ::FBottom + 1, ::FRight + 2 )
		endif
	endif
	
	if ::FShadow	// отрисовка тени внизу и справа от прямоугольника
		colorwin( ::FBottom + 1, ::FLeft + 2, ::FBottom + 1, ::FRight + 2, 'W/N' )
		colorwin( ::FTop + 1, ::FRight + 1, ::FBottom + 1, ::FRight + 2, 'W/N' )
	endif
	if ! empty( ::FColor )
		::_setColor := setcolor( ::FColor )
	endif
	@ ::FTop, ::FLeft clear to ::FBottom, ::FRight
	
	do case
		case ::FFrame == BORDER_NONE 	// без рамки
		case ::FFrame == BORDER_SINGLE  // одинарная рамка по краю
			@ ::FTop, ::FLeft TO ::FBottom, ::FRight
		case ::FFrame == BORDER_DOUBLE  // двойная рамка по краю
			@ ::FTop, ::FLeft TO ::FBottom, ::FRight double
		case ::FFrame == BORDER_SINGLE_SHIFT  // одинарная рамка со сдвигом
			@ ::FTop, ::FLeft + 1 TO ::FBottom, ::FRight - 1
		case ::FFrame == BORDER_DOUBLE_SHIFT  // двойная рамка со сдвигом
			@ ::FTop, ::FLeft + 1 TO ::FBottom, ::FRight - 1 double
	endcase
	if ::FCaption != ''
		tmp := ' ' + left( alltrim( ::FCaption ), ::FRight - ::FLeft - 3 ) + ' '
		@ ::FTop, ::FLeft + 1 + ( ::FRight - ::FLeft - len( tmp ) ) / 2 SAY tmp color hb_defaultValue( ::FCaptionColor, setcolor() )
	endif
	if ! empty( ::FMessageLine )
		for i := ::FlenMessage to 1 step -1
			::statusBar( maxrow() - i + 1, ::FMessageLine[ ::FlenMessage - i + 1 ] )
		next
	endif
	::_isView := .t.
	return

METHOD procedure __My_dtor CLASS TBox

	setcolor( ::_setColor )
	
	if (::FSave .and. ::_isView) .or. (::FChange_Attr .and. ::_isView)
		::RgnStack( 'pop all' )
	endif
	return

METHOD function statusBar( pos, cStr, cColor1, cColor2 ) CLASS TBox
	local out_str := '', out_arr := {}, i, j := 2, s
	
	default cColor1 to 'W+/R,,,,B/W', cColor2 to 'GR+/R,,,,B/W'
	cStr := ' ' + cStr
	for i := 1 to numtoken( cStr, '^' )
		s := token( cStr, '^', i )
		if j == 1
			out_str += s
			aadd( out_arr, s )
			j := 2
		else
			out_str += s
			j := 1
		endif
	next
	out_str := padc( alltrim( out_str ), maxcol() + 1 )
	@ pos, 0 say out_str color cColor1
	for i := 1 to len( out_arr )
		if ( j := at( out_arr[ i ], out_str ) ) > 0
			@ pos, j - 1 say out_arr[ i ] color cColor2
		endif
	next
	return nil

METHOD function SavRgn( nTop, nLeft, nBottom, nRight ) CLASS TBox
	RETURN hb_BChar( nTop ) + hb_BChar( nLeft ) + hb_BChar( nBottom ) + hb_BChar( nRight ) + ;
		savescreen( nTop, nLeft, nBottom, nRight )

METHOD function RstRgn( cScreen, nTop, nLeft ) CLASS TBox

	if PCount() == 3
		RestScreen( nTop, nLeft, ;
			( nTop  - hb_BCode( hb_BSubStr( cScreen, 1, 1 ) ) ) + hb_BCode( hb_BSubStr( cScreen, 3, 1 ) ), ;
			( nLeft - hb_BCode( hb_BSubStr( cScreen, 2, 1 ) ) ) + hb_BCode( hb_BSubStr( cScreen, 4, 1 ) ), ;
			hb_BSubStr( cScreen, 5 ) )
	else
		RestScreen( ;
			hb_BCode( hb_BSubStr( cScreen, 1, 1 ) ), ;
			hb_BCode( hb_BSubStr( cScreen, 2, 1 ) ), ;
			hb_BCode( hb_BSubStr( cScreen, 3, 1 ) ), ;
			hb_BCode( hb_BSubStr( cScreen, 4, 1 ) ), ;
			hb_BSubStr( cScreen, 5 ) )
	endif
	return nil

METHOD function RgnStack( cAction, nTop, nLeft, nBottom, nRight ) CLASS TBox
	local nPopTop
	
	cAction := lower( cAction )
	if cAction == 'push'
		ASize( ::aRgnStack, ++::_nStackPtr )[ ::_nStackPtr ] := ;
			::SavRgn( nTop, nLeft, nBottom, nRight )
	elseif cAction == 'pop' .or. cAction == 'pop all'
			nPopTop := iif( 'all' $ cAction, 0, ::_nStackPtr - 1 )
		do while ::_nStackPtr > nPopTop
			::RstRgn( ::aRgnStack[ ::_nStackPtr-- ] )
		enddo
		asize( ::aRgnStack, ::_nStackPtr )
	endif
	return nil

// сделать область экрана "бледной"
METHOD function Change_attr() CLASS TBox
	LOCAL sTmpScr,  ch := CHR(255) + CHR(247)
	local r1 := 0, c1 := 0, r2 := maxrow(), c2 := maxcol()

	sTmpScr := SAVESCREEN(r1, c1, r2, c2)
	CHARAND(@sTmpScr, ch)
	RESTSCREEN(r1, c1, r2, c2, sTmpScr)
	colorwin(r1, c1, r2, c2, 'N+/BG', 'N/BG')
	colorwin(r1, c1, r2, c2, 'N+/W', 'N/W')
	return nil
