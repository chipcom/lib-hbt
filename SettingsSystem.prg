
#include 'inkey.ch'
#include 'setcurs.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

function settingsSystem()
	static mm_da_net := { { '�� ', 1 }, { '���', 2 } }
	static cgreen := 'G+/B'											// 梥� ��� ��⮪
	local oBox
	local oIniSystem := TSettingSystem():New( dir_server + 'system' ) 
	
	&& private mtest := '��ࠢ��', m1test
	private mSSL, m1SSL

	m1SSL := iif( oIniSystem:SSL, 1, 2 )
	mSSL := inieditspr( A__MENUVERT, mm_da_net, m1SSL )
	
	// ��ᬮ�� � ।���஢���� ����஥� ᮮ�饭��
	oBox := TBox():New( 1, 0, 22, 78, .t. )
	&& oBox:Caption := ''
	&& oBox:CaptionColor := 'B+/B'
	oBox:Color := cDataCGet
	oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<PgDn>^ - ���⢥ত���� �����'
	oBox:View()

	ix := 2
	// @ ix, 2 SAY '���⥬� ������ ᮮ�饭�ﬨ:' color cgreen
	// @ ++ix, 2 say '����� ���� UDP ��� ������ ᮮ�饭�ﬨ' get oIniSystem:PortUDP picture '99999'
	// @ ++ix, 2 say '�६� ����প� ��ࠢ�� �ப����⥫��� ����⮢ WHO � ���.' get oIniSystem:TimeDelay picture '99'
	
	&& ++ix
	@ ++ix, 2 SAY '�����஭��� ����:' color cgreen
	@ ++ix, 2 say 'E-mail' get oIniSystem:EMail picture 'XXXXXXXXXXXXXXXXXXXX'
	@ ++ix, 2 say '��ࢥ� �室�饩 ����� (POP3)' get oIniSystem:ServerPOP3 picture 'XXXXXXXXXXXXXXXXXXXX'
	@ ++ix, 2 say '��ࢥ� ��室�饩 ����� (SMTP)' get oIniSystem:ServerSMTP picture 'XXXXXXXXXXXXXXXXXXXX'
	@ ++ix, 2 say '��� ���짮��⥫� E-mail' get oIniSystem:Login picture 'XXXXXXXXXXXXXXXXXXXX'
	@ ++ix, 2 say '��஫� ���짮��⥫� E-mail' get oIniSystem:EMailPassword picture 'XXXXXXXXXXXXXXXXXXXX'
	@ ++ix, 2 say '�ᯮ�짮���� ��⮪�� SSL' get mSSL ;
		reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , ,.f. ) }
	
	// @ ++ix, 2 say '�஢�ઠ ����� ...' get mtest ;
		// reader { | x | menu_reader( x, { { || SendFile() } }, A__FUNCTION, , , .f. ) }
	
	myread()
	if f_Esc_Enter( 1 )
		oIniSystem:SSL := iif( m1SSL == 2, .f., .t. )
		oIniSystem:Save()
	endif
	return nil
	
&& function SendFile()
	&& local ret := .f.
	&& local nameZipFile := cur_dir + "error.zip"
	&& local serverSMTP, body, subject
	&& local lSSL
	&& local oIniSystem := TSettingSystem():New( dir_server + 'system' ) 

	&& if ! tip_SSL()
		&& hb_Alert( 'No SSL' )
		&& return nil
	&& endif

	&& cPassword := oIniSystem:EMailPassword
	&& cFrom := oIniSystem:Email
	&& cTo := 'vbaykin@mail.ru'
	
	&& serverSMTP := oIniSystem:ServerSMTP
	&& body := "���� �訡��: " + glob_mo[ _MO_FULL_NAME ]
	&& subject := "��०�����: " + glob_mo[ _MO_KOD_TFOMS ]
	
	&& nameZipFile := dir_server + 'error.txt'
	&& ret := hb_SendMail( ;
		&& serverSMTP, ;
		&& Val( if( lSSL, '465', '25' ) ), ;
		&& cFrom, ;
		&& cTo, ;
		&& nil /* CC */, ;
		&& {} /* BCC */, ;
		&& body, ;
		&& subject, ;
		&& { nameZipFile } /* attachment */, ;
		&& cFrom, ;
		&& cPassword, ;
		&& '', ;
		&& nil /* nPriority */, ;
		&& nil /* lRead */, ;
		&& .f. /* lTrace */, ;
		&& .f., ;
		&& nil /* lNoAuth */, ;
		&& nil /* nTimeOut */, ;
		&& nil /* cReplyTo */, ;
		&& lSSL /* lSSL */, ;
		&& , ;
		&& 'CP866' )
	&& if ret
		&& hb_Alert( '��ࠢ�� ��諠 �ᯥ譮' )
	&& else
		&& hb_Alert( '��ࠢ�� �����訫��� ��㤠筮' )
	&& endif
	&& return nil