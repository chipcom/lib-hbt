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
		PROPERTY Symbol WRITE setSymbol INIT chr( 176 )

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
//		DATA FDeleted	INIT .f.

    METHOD setRow( nValue )
    METHOD setColumnMin( nValue )
    METHOD setColumnMax( nValue )
    METHOD setValueMin( nValue )
    METHOD setValueMax( nValue )
    METHOD setSymbol( nValue )
		
ENDCLASS

METHOD New( nRow, nColumnMin, nColumnMax, nValueMin, nValueMax )	CLASS TProgressBar

	::FRow      			:= hb_DefaultValue( nRow, 0 )
	::FColumnMin			:= hb_DefaultValue( nColumnMin, 0 )
	::FColumnMax			:= hb_DefaultValue( nColumnMax, 80 ) - 1 
	::FValueMin			  := hb_DefaultValue( nValueMin, 0 )
	::FValueMax			  := hb_DefaultValue( nValueMax, 0 )
  ::FStep           := int( ( nValueMax - nValueMin ) / ( nColumnMax - nColumnMin - 2 ) )
  ::FCurrent        := nColumnMin + 1
	return self

METHOD PROCEDURE Display( )	CLASS TProgressBar

  ::FScreen := save_box( ::FRow, ::FColumnMin, ::FRow, ::FColumnMax )
  ::FScreen := .t.
  @ ::FRow, ::FColumnMin SAY '['
  @ ::FRow, ::FColumnMax SAY ']'
  return

METHOD PROCEDURE TProgressBar:Update( nStep )

  If nStep % ::FStep == 0
    @ ::FRow, ::FCurrent++ SAY ::FSymbol  //'='
  endif
  return

METHOD PROCEDURE TProgressBar:Destroy()

  rest_box( ::FScreen )
  return

METHOD PROCEDURE TProgressBar:setRow( nValue )
	
  ::FRow := nValue
	return

METHOD PROCEDURE TProgressBar:setColumnMin( nValue )
	
  ::FColumnMin := nValue
	return

METHOD PROCEDURE TProgressBar:setColumnMax( nValue )
	
  ::FColumnMax := nValue
	return

METHOD PROCEDURE TProgressBar:setValueMin( nValue )
	
  ::FValueMin := nValue
	return

METHOD PROCEDURE TProgressBar:setValueMax( nValue )
	
  ::FValueMax := nValue
	return

METHOD PROCEDURE TProgressBar:setSymbol( nValue )
	
  ::FSymbol := nValue
	return

