#include 'hbclass.ch'
#include 'property.ch'
#include 'common.ch'

// класс TProgressBar 
CREATE CLASS TProgressBar
	VISIBLE:
		PROPERTY Row WRITE setRow INIT 0
		PROPERTY ColumnMin WRITE setColumnMin INIT 0
		PROPERTY ColumnMax WRITE setColumnMax INIT 0
		PROPERTY ValueMin WRITE setValueMin INIT 0
		PROPERTY ValueMax WRITE setValueMax INIT 0
		PROPERTY Symbol WRITE setSymbol // INIT chr( 176 )
		PROPERTY Color WRITE setColor

		METHOD new( nRow, nColumnMin, nColumnMax, nValueMin, nValueMax )
    METHOD Update( nStep )
    METHOD Display()
    METHOD Destroy()

	PROTECTED:
		DATA FDisplay 		INIT .f.
		DATA FRow  		    INIT 0
		DATA FColumnMin	  INIT 0
		DATA FColumnMax 	INIT 0
		DATA FValueMin	  INIT 0
		DATA FValueMax   	INIT 0
    DATA FStep        INIT 0
    DATA FCurrent     INIT 0
    DATA FScreen
    DATA FSymbol      INIT chr( 176 )
    DATA FColor       INIT 'N/BG, W+/N'
    DATA FBuf

    METHOD setRow( nValue )             INLINE ::FRow := nValue
    METHOD setColumnMin( nValue )       INLINE ::FColumnMIN := nValue
    METHOD setColumnMax( nValue )       INLINE ::FColumnMax := nValue
    METHOD setValueMin( nValue )        INLINE ::FValueMin := nValue
    METHOD setValueMax( nValue )        INLINE ::FValueMax := nValue
    METHOD setSymbol( cValue )          INLINE ::Fsymbol := cValue
    METHOD setColor( cColor )           INLINE ::FColor := cColor
		
ENDCLASS

METHOD TProgressBar:New( nRow, nColumnMin, nColumnMax, nValueMin, nValueMax )

	::FRow      			:= hb_DefaultValue( nRow, 0 )
	::FColumnMin			:= hb_DefaultValue( nColumnMin, 0 )
	::FColumnMax			:= hb_DefaultValue( nColumnMax, 80 ) - 1 
	::FValueMin			  := hb_DefaultValue( nValueMin, 0 )
	::FValueMax			  := hb_DefaultValue( nValueMax, 0 )
  ::FStep           := int( ( nValueMax - nValueMin ) / ( nColumnMax - nColumnMin - 2 ) )
  ::FCurrent        := nColumnMin + 1
  ::FBuf            := SaveScreen( ::FRow, ::FColumnMin, ::FRow, ::FColumnMax )
	return self

METHOD PROCEDURE TProgressBar:Display( )

  ::FScreen := save_box( ::FRow, ::FColumnMin, ::FRow, ::FColumnMax )
//  ::FScreen := .t.
  @ ::FRow, ::FColumnMin SAY '[' Color ::FColor
  @ ::FRow, ::FColumnMax SAY ']' Color ::FColor
  return

METHOD PROCEDURE TProgressBar:Update( nStep )

  If nStep % ::FStep == 0
    @ ::FRow, ::FCurrent++ SAY ::FSymbol Color ::FColor
  endif
  return

METHOD PROCEDURE TProgressBar:Destroy()

  rest_box( ::FScreen )
  return
