;VINICIUS PITTIGLIANI PEREGO - CARTÃO: 00242287
;******OBS****:As tabulações utilizadas nos dois relatórios, bem como as das outras telas, seguem o padrão fornecido no enunciado do trabalho.
;int main(){
;iniciaPrograma();
;return 0;
;}	

	.model small
	.stack
		
TB		equ		 9	;tab	
CR		equ		13 ;carriage return
LF		equ		10 ;line feed
		
		.data
centavos db ",00",0
auxGeral dw 0
msg db "Numero:",CR,LF,0
lucro dw 0
index dw 0		
EOFlag db 0 ;flag para o fim do arquivo
lfFlag	db 0 ;flag para LF
stringAux db 10 dup(0)
numeroEng db "Numero de Viagens:",CR,0
StringBuffer db 10 dup(0)
viagens dw 0
neInt dw 0
nc dw 0
neLido dw 0 
primeiro_acesso db 0
BufferTec	db	100 dup (?)
neString db 4 dup(0)
ncString db 4 dup(0) 		
nome_aluno	db		"Vinicius Pittiglini Perego Cartao: 242287",CR,LF,0
ajuda1 db LF,">> Caracteres de comandos:",CR,LF,0
ajuda2 db TB,"[a] solicita novo arquivo de dados",CR,LF,0
ajuda3 db TB,"[g] apresenta o relatorio geral",CR,LF,0
ajuda4 db TB,"[e] apresenta o relatorio de um engenheiro",CR,LF,0
ajuda5 db TB,"[f] encerra o programa",CR,LF,0
ajuda6 db TB,"[?] lista os comandos validos",CR,0
FileName		db		256 dup (?)		; Nome do arquivo a ser lido
FileBuffer		db		10 dup (?)		; Buffer de leitura do arquivo
FileHandle		dw		0				; Handler do arquivo
FileNameBuffer	db		150 dup (?)
msgDados	db  LF,CR,TB,"Arquivo de dados:", CR, LF,0
msgCid		db	TB,TB,"Numero de cidades...... ",0
msgEng	db	LF,TB,TB,"Numero de engenheiros.. ",0
MsgPedeArquivo		db	LF,">> Forneca o nome do arquivo de dados: ", 0
MsgErroOpenFile		db	LF,"Erro na abertura do arquivo.", CR, LF, 0
MsgErroReadFile		db	"Erro na leitura do arquivo.", CR, LF, 0
msg_RE db ">> Forneca o numero do engenheiro: ",0
pedeComando db LF,"Comando> ",0
msgEncerra db LF,"Aplicativo encerrado!",0
msgErroRel db LF,"Numero de engenheiro invalido!",LF,0
msgRelEng3 db LF,"    Cidade",TB," Lucro",TB,"   Prejuizo",0
msgRelEng2 db	LF,"    Numero de visitas: ",0
msgRelEng1 db LF,"    Relatorio do Engenheiro ",0
prejuizoTotalEng db TB,TB,"   ",0
sw_n	dw	0
sw_f	db	0
sw_m	dw	0    
msgGeral db ">> Relatorio Geral",CR,LF,0
linhaGeral db "    Engenheiro ","Visitas",TB,TB,"Lucro",TB,TB,"Prejuizo",0
novaLinha db CR,LF,0
negativeFlag 	dw  0
totalRelEng db LF,"     TOTAL    ",0
tab_space db TB," ",0
tab_spaceRelEng db "    ",0
lucroTAB db TB,"     ",0
lucroRelEng db "     ",0
prejuizoTAB db TB,TB,TB,"       ",0
prejuizoTABEng db TB,TB,"   ",0
negativeFlagLeLinha dw 0
listaLucro dw 999 dup(0) ;lista contendo ponteiros para as listas de engenheiros
listaCidades dw  999 dup(0)	;lista do lucro de cada cidade
listaViagens dw 999	dup(0);lista contendo o numero de viagens de cada engenheiro
listaEngenheiro dw 999 dup (0); lista temporária para armazenar as viagens de 1 engenheiro lido,ou o engenheiro selecionado no menu relatorioEngenheiro
stringTamanho dw 0
totalDinheiro dw 0
totalViagens dw 0
totalGeral db LF,"       TOTAL  ",0
totalGeral2 db "	     ",0
totalPrejuizo db TB,TB,TB,"       ",0
cidadeString db 5 dup(0)


	.code
		;void sprintf_w(char *string->BX, WORD n->AX)
		sprintf_w	proc	near

;void sprintf_w(char *string, WORD n) {
	mov		sw_n,ax

;	k=5;
	mov		cx,5
	
;	m=10000;
	mov		sw_m,10000
	
;	f=0;
	mov		sw_f,0
	
;	do {
sw_do:

;		quociente = n / m : resto = n % m;	// Usar instrução DIV
	mov		dx,0
	mov		ax,sw_n
	div		sw_m
	
;		if (quociente || f) {
;			*string++ = quociente+'0'
;			f = 1;
;		}
	cmp		al,0
	jne		sw_store
	cmp		sw_f,0
	je		sw_continue
sw_store:
	add		al,'0'
	mov		[bx],al
	inc		bx
	
	mov		sw_f,1
sw_continue:
	
;		n = resto;
	mov		sw_n,dx
	
;		m = m/10;
	mov		dx,0
	mov		ax,sw_m
	mov		bp,10
	div		bp
	mov		sw_m,ax
	
;		--k;
	dec		cx
	
;	} while(k);
	cmp		cx,0
	jnz		sw_do

;	if (!f)
;		*string++ = '0';
	cmp		sw_f,0
	jnz		sw_continua2
	mov		[bx],'0'
	inc		bx
sw_continua2:


;	*string = '\0';
	mov		byte ptr[bx],0
		
;}
	ret
		
sprintf_w	endp



;--------------------------------------------------------------------

fscanf proc near   
;Recebe em BX o ponteiro para uma string destino e escreve nele os caracteres lidos ate encontrar uma virgula ou CR-LF(ja deixando o arquivo na proxima linha)
;fscanf(file *arq,char *destiny){
;	do{
;	FileBuffer=(char) fgetc(arq); //pega um unico caractere do arquivo
;	if(FileBuffer!= ',' && FileBuffer!= LF){
;		destiny=FileBuffer;
;		destiny++;
;	}
;	}while(FileBuffer!= ',');
;	destiny='\0';
;}
		mov lfFlag,0
		cld 
		lacoFscanf:		PUSH di
		mov		bx,FileHandle
		mov		ah,3fh
		mov		cx,1
		lea		dx,FileBuffer
		int		21h
		cmp 	ax,0
		jz 		fimArquivo
		jnc		continuafscanf
		;lea 	bx,MsgErroReadFile
		;call	printf_s
		mov		al,1
		jmp		fimArquivo
continuafscanf:pop di
		cmp FileBuffer,","
		jz endFscanf
		cmp FileBuffer,CR
		jz lacoFscanf
		cmp FileBuffer,LF
		jz endCary
		lea 	si,FileBuffer
		mov		ax,ds						; Ajusta ES=DS para poder usar o MOVSB
		mov		es,ax
		movsb
		jmp lacoFscanf
fimArquivo: pop di
		    mov EOFlag,1
endCary:	mov lfFlag,1
endFscanf:	mov	byte ptr[di],0
		ret

fscanf	endp

mostra_comandos proc near

;void mostra_comandos(){
;	printf_s(ajuda1);
;	printf_s(ajuda2);
;	printf_s(ajuda3);
;	printf_s(ajuda4);
;	printf_s(ajuda5);
;	printf_s(ajuda6);
;}

	lea bx,ajuda1
	call printf_s
	lea bx,ajuda2
	call printf_s
	lea bx,ajuda3
	call printf_s
	lea bx,ajuda4
	call printf_s
	lea bx,ajuda5
	call printf_s
	lea bx,ajuda6
	call printf_s

	ret

mostra_comandos endp

;
;--------------------------------------------------------------------
;Função: Lê um string do teclado
;Entra: (S) -> DS:BX -> Ponteiro para o string
;	    (M) -> CX -> numero maximo de caracteres aceitos
;Algoritmo:
;	Pos = 0
;	while(1) {
;		al = Int21(7)	// Espera pelo teclado
;		if (al==CR) {
;			*S = '\0'
;			return
;		}
;		if (al==BS) {
;			if (Pos==0) continue;
;			Print (BS, SPACE, BS)	// Coloca 3 caracteres na tela
;			--S
;			++M
;			--Pos
;		}
;		if (M==0) continue
;		if (al>=SPACE) {
;			*S = al
;			++S
;			--M
;			++Pos
;			Int21 (s, AL)	// Coloca AL na tela
;		}
;	}
;--------------------------------------------------------------------

ReadString	proc	near
		;mov bx,0
		;Pos = 0
		mov		dx,0

RDSTR_1:
		;while(1) {
		;	al = Int21(7)		// Espera pelo teclado
		mov		ah,7
		int		21H

		;	if (al==CR) {
		cmp		al,0DH
		jne		RDSTR_A

		;		*S = '\0'
		mov		byte ptr[bx],0
		;		return
		ret
		;	}

RDSTR_A:
		;	if (al==BS) {
		cmp		al,08H
		jne		RDSTR_B

		;		if (Pos==0) continue;
		cmp		dx,0
		jz		RDSTR_1

		;		Print (BS, SPACE, BS)
		push	dx
		
		mov		dl,08H
		mov		ah,2
		int		21H
		
		mov		dl,' '
		mov		ah,2
		int		21H
		
		mov		dl,08H
		mov		ah,2
		int		21H
		
		pop		dx

		;		--s
		dec		bx
		;		++M
		inc		cx
		;		--Pos
		dec		dx
		
		;	}
		jmp		RDSTR_1

RDSTR_B:
		;	if (M==0) continue
		cmp		cx,0
		je		RDSTR_1

		;	if (al>=SPACE) {
		cmp		al,' '
		jl		RDSTR_1

		;		*S = al
		mov		[bx],al

		;		++S
		inc		bx
		;		--M
		dec		cx
		;		++Pos
		inc		dx

		;		Int21 (s, AL)
		push	dx
		mov		dl,al
		mov		ah,2
		int		21H
		pop		dx

		;	}
		;}
		jmp		RDSTR_1

ReadString	endp


;--------------------------------------------------------------------

;strpad(char *Alterada){
;	int tamString=0;
;	char * apontaAlterada=&Alterada;
;	while(Alterada!= '\0'){
;		Alterada++;
;		tamString++;
;	}
;	tamString=5-tamString;
;	while(tamString!=0){
;		printf(" ");
;	tamString--;
;	}
;	printf_s(Alterada);
;}
;DI->PONTEIRO P/ STRING
;Verifica o tamanho de uma String de ate no maximo 5 caracteres, imprimindo espaco para cada caractere vazio.No final, imprime a String.
		strpad  proc near
		mov cx,0
		PUSH di
tamStrpad:	CMP [di],0
		JZ contStrpad
		INC cx
		INC di
		JMP tamStrpad
contStrpad:		
		POP di
		MOV stringTamanho,5
		sub stringTamanho,cx
lacoStrPad:
		cmp stringTamanho,00
		jz endPad
		mov dl,32
		mov	ah,2
		int	21H
		dec stringTamanho
		jmp lacoStrPad 
endPad:	mov bx,di
		call printf_s
		ret

strpad endp
;--------------------------------------------------------------------	
printf_s	proc	near
			
 		;	While (*s!='\0') {
		mov		dl,[bx]
		cmp		dl,0
		je		ps_1
	
	 ;		putchar(*s)
		push	bx
		mov		ah,2
		int		21H
		pop		bx

		;		++s;
		inc		bx
		
		;	}
		jmp		printf_s
		
		ps_1:

		ret
		
printf_s	endp
;--------------------------------------------------------------------
limpaString proc near
;cx->tamanho da Sitnrg
;bx->entrada da String
		lacoLimpa:
		cmp cx,0
		jz endLimpa
		mov [bx],0
		inc bx
		dec cx
		jmp lacoLimpa
endLimpa: 	
		ret
limpaString endp
;--------------------------------------------------------------------	
GetFileName	proc	near

	;	printf_s("Nome do arquivo: ");
beginGFN:	lea		bx,MsgPedeArquivo
		call	printf_s

		;	// Lê uma linha do teclado
		;	FileNameBuffer[0]=100;
		;	gets(ah=0x0A, dx=&FileNameBuffer)
		mov		ah,0ah
		lea		dx,FileNameBuffer
		mov		byte ptr FileNameBuffer,100
		int		21h

		;	// Copia do buffer de teclado para o FileName
		;	for (char *s=FileNameBuffer+2, char *d=FileName, cx=FileNameBuffer[1]; cx!=0; s++,d++,cx--)
		;		*d = *s;		
		lea	 	si,FileNameBuffer+2
		lea		di,FileName
		mov		cl,FileNameBuffer+1
		mov		ch,0
		mov		ax,ds						; Ajusta ES=DS para poder usar o MOVSB
		mov		es,ax
		rep 	movsb

		;	// Coloca o '\0' no final do string
		;	*d = '\0';
		mov		byte ptr es:[di],0

		mov		al,0
		lea		dx,FileName
		mov		ah,3dh
		int		21h
		jnc		endGetName
	
		lea		bx,MsgErroOpenFile
		call	printf_s
		.exit
endGetName: mov	FileHandle,ax	;salva fileHandle
	
			ret
GetFileName	endp
;--------------------------------------------------------------------
;Entra: (S) -> DS:BX -> Ponteiro para o string de origem
;Sai:	(A) -> AX -> Valor "Hex" resultante
;Algoritmo:
;	A = 0;
;	while (*S!='\0') {
;		A = 10 * A + (*S - '0')
;		++S;
;	}
;	return
;--------------------------------------------------------------------
atoi proc near
		mov negativeFlag,0
		mov ax,0
		; A = 0;
	
		cmp		byte ptr[bx], "-"
		jne		atoi_2
		mov     negativeFlag,1
		inc 	bx
		mov		ax,0
atoi_2:
		; while (*S!='\0') {
		cmp		byte ptr[bx], 0
		jz		atoi_1

		; 	A = 10 * A
		mov		cx,10
		mul		cx

		; 	A = A + *S
		mov		ch,0
		mov		cl,[bx]
		add		ax,cx

		; 	A = A - '0'
		sub		ax,'0'

		; 	++S
		inc		bx
		
		;}
		jmp		atoi_2

atoi_1:	cmp negativeFlag,1
		jnz here
		neg ax
	;	dec ax
		;add ax,-1
		; return
here:
		ret

atoi	endp
;fgets:le uma linha inteira do arquivo,encerrando o laco ao encontrar lf ou EOF
;void fgets(FILE *arq,word lista[]){
;	int aux=0;
;	char stringBuffer[10];
;	do{
;		fscanf(arq,stringBuffer);	
;		lista[aux]=atoi(stringBuffer);
;		
;   }while(StringBuffer!= LF && StringBuffer!=EOF)
;}	
fgets proc near
;le uma linha do arquivo até encontrar LF
loopLeLinha:
		push bx
		lea di,StringBuffer
		call fscanf
		lea bx,StringBuffer
		call atoi
		pop bx
		mov [bx],ax
		add	bx,2
		cmp lfFlag,1
		jz terminaLeLinha
		jmp loopLeLinha
terminaLeLinha:	ret
fgets endp

		.startup
;============================================================		
;	void iniciaPrograma(){
;		printf_s(nome_aluno);
;		le_arquivo();
;}
		lea	bx,nome_aluno
		call	printf_s
		
;============================================================	

;============================================================	
;void le_arquivo(){
;	char * FileName;
;	readString(nome_arquivo,100);
;	FileName=getFileName();
;	fscanf(fileHandle,neString);salva NC
;	fscanf(fileHandle,ncString);/salva NC
;	int lucro,auxCidade,auxLucro=0,viagens,AuxEngenheiro;
;	do{
;		fgets(arquivo,listaEngenheiro);
;		listaViagens[auxViagens]=listaEngenheiro[0];
;		viagens=listaEngenheiro[0];
;		auxEngenheiro=0;
;		listaViagens+=2;
;		lucro=0;
;		while(viagens){
;			auxCidade=listaEngenheiro[auxEngenheiro];
;			lucro+=	listaCidades[auxCidade];
;			auxEngenheiro+=2;
;			viagens--;	
;		}
;		listaLucro[auxLucro]=lucro;
;		auxLucro+=2;
;	  }	
;	while(feof(arquivo));
;	fclose(arquivo);
;	menu_acoes();
;}
	le_arquivo:
		call getFileName
		lea  di,neString
		call fscanf
		lea  di,ncString
		call fscanf
		lea bx,listaCidades
		call fgets
		lea bx,listaLucro
		push bx
		mov di,0
		push di
trocaLinha:	
		lea bx,listaEngenheiro
		call fgets
		pop di
		pop bx
		lea si,listaEngenheiro
		mov ax,[listaEngenheiro]
		add si,2 ;aponta para primeira posicão de cálculo
		mov [di+listaViagens],ax
		mov viagens,ax
		add di,2
		mov ax,0
calculaLucro:
		cmp viagens,0
		jz mudaEngenheiro
		mov bp,[si]
		shl bp,1
		add ax,[bp+listaCidades]
		add si,2
		dec viagens
		jmp calculaLucro
mudaEngenheiro:
		mov [bx],ax
		add bx,2
		push bx
		push di
		cmp EOFlag,1
		jz exits
		jmp trocaLinha
	
exits:	
	lea	 bx,msgDados 
		call printf_s
		lea  bx,msgCid
		call printf_s
		lea  bx,ncString
		call printf_s
		
		lea  bx,msgEng
		call printf_s
		lea  bx,neString
		call printf_s
		
		;;transf as Strings NE e NC em numeros:
		lea		bx,neString
		call	atoi
		mov 	neInt,ax
		lea		bx,ncString
		call	atoi			
		mov 	nc,ax
		mov ah,3eh
		mov bx,FileHandle
		int 21h
		cmp primeiro_acesso,0
		jne chama_acoes
solicita_comando:		call mostra_comandos
		inc primeiro_acesso
		jmp chama_acoes
;============================================================

;void menu_acoes(){
;	mostra_comandos();
;	readString(entrada,1);
;	switch(entrada){
;		case "?": mostra_comandos();
;		case "g": relatorio_geral();
;		case "f": encerra();
;		case "a": le_arquivo();
;		case "e": relatorio_engenheiro();
;
;		}

limpa_tela:	
		mov ax,7  ;;chamada de sistema para limpar a tela
		int 10h
		
chama_acoes:
		
		; Chamada da rotina (para teste)

		lea bx,pedeComando
		call printf_s
		;ReadString(bx=BufferTec, cx=10)	// limita em 10 caracteres
		mov	cx,1
		lea	bx,BufferTec
		call ReadString
		cmp BufferTec,"?";OBS: em teclados padrão ABNT-2,o DOSBOX só aceita ? com Alt+W
		jz vai_comandos
		cmp BufferTec,"a"
		jz vai_arquivo
		cmp BufferTec,"g"
		jz relatorioGeral
		cmp BufferTec,"f"
		jz encerra_programa
		cmp BufferTec,"e"
		jz vai_relatorio_engenheiro
		jmp chama_acoes
		
	vai_comandos:		mov ax,7  ;;chamada de sistema para limpar a tela
		int 10h
		call mostra_comandos
		jmp chama_acoes
	vai_arquivo:mov ax,7  ;;chamada de sistema para limpar a tela
		int 10h
		jmp le_arquivo
	vai_relatorio_engenheiro:
		mov ax,7  ;;chamada de sistema para limpar a tela
		int 10h
		
;============================================================
;void relatorio_engenheiro(){
;	int auxcidade=0;
;	int auxEng=2;//aponta o auxiliar p/ percorrer o vetor de engenheiros na posicao do primeiro vaor
;	do{
;	printf_s(msg_RE);
;	readString(BufferTec);
;	if(BufferTec==0)
;		chama_acoes();
;	int neLido=atoi(BufferTec);
;	int auxLeitura=neLido+2;
;	if(neLido>neInt){
;		fopen(arquivo);
;		while(auxLeitura){			//abre o arquivo e lê até chegar na linha do engenheiro selecionado,armazenando no vetor listaEngenheiro
;		fgets(listaEngenheiro);
;		auxLeitura--;
;		}
;		printf_s(msgRelEng1);
;		printf_s(msgRelEng2);
;		printf_s(msgRelEng3);
;		auxLeitura=0;
;		while(auxLeitura<listaEngenheiro[0]){
;			sprintf_w(auxLeitura,stringBuffer);
;			printf_s(stringBuffer);
;			sprintf_w(listaEngenheiro[auxEngenheiro],stringBuffer);
;			printf_s(stringBuffer);
;			auxCidade=listaEngenheiro[auxEngenheiro];
;			if(listaCidades[auxCidade] > 0){
;				sprintf_w(listaCidades[auxCidade],stringBuffer);
;				strpad(stringBuffer);
;				printf_s(centavos);
;			}else{
;				printf_s("\t \t ");
;				sprintf_w(listaCidades[auxCidade],stringBuffer);
;				strpad(stringBuffer);
;				printf_s(centavos);
;			}
;	
;		}
;		fclose(arquivo);
;	    chama_acoes();		
;	 }
;		else{
;		printf_s("Numero de engenheiro invalido");	
;		}
;	}while(BufferTec);
;			
;}
;
;============================================================
relatorio_engenheiro:
		lea bx,msg_RE
		call printf_s
		mov	cx,3
		lea	bx,BufferTec
		call ReadString
		cmp BufferTec,0
		jz chama_acoes
		lea	bx,BufferTec
		call atoi
		mov neLido,ax
		mov ax,neInt
		cmp ax,neLido
		jg eng_valido
		lea bx,msgErroRel
		call printf_s
		jmp relatorio_engenheiro

eng_valido: 
		mov	al,0
		lea	dx,FileName
		mov	ah,3dh
		int	21h
		mov ax,neLido
		add ax,4
lacoRelEng:	
		cmp ax,0
		jz mostraRelatorio
		dec ax
		push ax
		jz mostraRelatorio
		lea bx,listaEngenheiro
		call fgets
		pop ax
		jmp lacoRelEng

		
mostraRelatorio:	
		lea bx,msgRelEng1
		call printf_s
		lea bx,BufferTec
		call printf_s
		lea bx,msgRelEng2
		call printf_s
		lea bx,stringAux
		mov ax,[listaEngenheiro]
		call sprintf_w
		lea bx,stringAux
		call printf_s
		lea bx,msgRelEng3
		call printf_s
		lea di,listaEngenheiro
		add di,2
		push di
		mov cx,[listaEngenheiro]
		inc cx
linhaRelEng:
		cmp cx,0
		dec cx
		push cx
		jz endRelEng
		lea bx,novaLinha
		call printf_s
		lea bx,tab_spaceRelEng
		call printf_s
		pop cx
		pop di
		mov ax,[di]
		lea bx,cidadeString
		push di
		push cx
		call sprintf_w
		lea di,cidadeString
		call strpad
		lea bx,cidadeString
		mov cx,5
		call limpaString
		pop cx
		pop di
		mov bp,[di]
		add di,2
		push di
		push cx
		shl bp,1
		mov ax,[bp+listaCidades]
		cmp ax,0
		jl prejuizoEng
		push ax
		lea bx,lucroRelEng
		call printf_s		
		pop ax
		lea bx,stringAux
		mov cx,10
		call limpaString
		lea bx,stringAux
		call sprintf_w
		lea di,stringAux
		call strpad
		lea bx,centavos
		call printf_s
		pop cx
		jmp linhaRelEng
prejuizoEng:
		neg ax
		push ax
		lea bx,prejuizoTABEng
		call printf_s		
		pop ax
		lea bx,stringAux
		mov cx,10
		call limpaString
		lea bx,stringAux
		call sprintf_w
		lea di,stringAux
		call strpad
		lea bx,centavos
		call printf_s
		pop cx
		jmp linhaRelEng
endRelEng:
		lea bx,totalRelEng
		call printf_s
		lea bx,stringAux ;limpaString para imprimir o lucro
		mov ax,10
		call limpaString
		mov bp,neLido
		shl bp,1
		mov ax,[bp+listaLucro]
		cmp ax,0
		jl prejuizoRelEng
		lea bx,stringAux
		call sprintf_w
		lea di,stringAux
		call strpad
		lea bx,centavos
		call printf_s
		jmp fechaRelEng
prejuizoRelEng:
		neg ax
		push ax
		lea bx,prejuizoTotalEng
		call printf_s
		pop ax
		lea bx,stringAux
		call sprintf_w
		lea di,stringAux
		call strpad
		lea bx,centavos
		call printf_s
fechaRelEng:		
		mov ah,3eh
		mov bx,FileHandle
		int 21h
		jmp chama_acoes	
	
;============================================================
;void relatorioGeral(){
;	system("cls");
;	printf_s(">> Relatorio Geral: \n");
;	printf_s("\t \t Engenheiro Visitas \t \t Lucro \t \t Prejuizo");
;	int auxGeral=0;
;		
;	while(auxGeral< ne){
;	{
;		printf_s("\t \t");
;		sprintf_w(stringBuffer,auxGeral); //converte o numero do atual engenheiro para String
;		strpad(stringBuffer);// posiciona a String corretamente na tela de acordo com seu tamanho para imprimi-la
;		sprintf_w(stringBuffer,listaCidades[auxGeral]); //converte o numero de visitas do atual engenheiro para String
;		strpad(stringBuffer);
;		if(listaLucro[auxGeral]>0){
;			printf_s(lucroTAB);
;			sprintf_w(stringBuffer,listaLucro[auxGeral]);
;			strpad(stringBuffer);
;		}
;		else{
;			listaLucro[auxGeral]=-listaLucro[auxGeral];
;			sprintf_w(stringBuffer,listaLucro[auxGeral]);
;			strpad(stringBuffer);		
;		}
;		auxGeral+=2;
;	}
;	chama_acoes();	
;}
relatorioGeral:	
		mov totalDinheiro,0
		mov totalViagens,0
		mov ax,7  
		int 10h	;;chamada de sistema para limpar a tela
		lea bx,msgGeral
		call printf_s
		lea bx,linhaGeral
		call printf_s
		lea bx,listaViagens
		lea di,listaLucro
		mov ax,0
newLinha:
		cmp neInt,ax
		jz endGeral
		push ax
		push di
		push bx
		lea bx,novaLinha
		call printf_s
		lea bx,tab_space
		call printf_s
		pop bx
		pop di
		pop ax
		push ax;coloca o numero de engenheiro da pilha em ax e novamente retorna na pilha as informações dos registradores
		push di
		push bx
		cmp ax,9
		jg decimal
		push ax
		mov	bx," "
		mov	ah,2
		int	21H
		pop ax
decimal:	
		lea bx,stringBuffer
		call sprintf_w
		lea bx,stringBuffer
		call printf_s
		lea bx,tab_space
		call printf_s
		pop bx
		mov ax,[bx]
		add totalViagens,ax
		add bx,2
		push bx
		cmp ax,9
		jg decimal2
		push ax
		mov	bx," "
		mov	ah,2
		int	21H
		pop ax
decimal2:
		lea bx,stringBuffer
		call sprintf_w
		lea bx,stringBuffer
		call printf_s
		pop bx
		pop di
		cmp [di],0
		jl prejuizo
		push di
		push bx
		lea bx,lucroTAB
		call printf_s
		pop bx
		pop di
		mov ax,[di]
		add totalDinheiro,ax
		add di,2
		push di
		push bx
		lea bx,stringBuffer
		call sprintf_w
		lea di,stringBuffer
		call strpad
		lea bx,centavos
		call printf_s
		pop bx
		pop di  
		pop ax
		inc ax
		jmp newLinha
prejuizo:	
		push di
		push bx
		lea bx,prejuizoTAB
		call printf_s
		pop bx
		pop di
		mov ax,[di]
		add totalDinheiro,ax
		neg ax
		add di,2
		push di
		push bx
		lea bx,stringBuffer
		call sprintf_w
		lea di,stringBuffer
		call strpad
		lea bx,centavos
		call printf_s
		pop bx
		pop di 
		pop ax
		inc ax
		jmp newLinha
endGeral:lea bx,totalGeral
		call printf_s
		mov ax,totalViagens
		lea bx,StringBuffer
		call sprintf_w
		lea di,StringBuffer
		call strpad
		mov ax,totalDinheiro
		cmp ax,0
		jg ehPositivo
		LEA BX,totalPrejuizo
		call printf_s
		mov ax,totalDinheiro
		neg ax
		lea bx,StringBuffer
		call sprintf_w
		lea di,StringBuffer
		call strpad
		lea bx,centavos
		call printf_s
		jmp chama_acoes
ehPositivo:
		lea bx,totalGeral2
		call printf_s
		lea bx,StringBuffer
		call sprintf_w
		lea di,StringBuffer
		call strpad
		lea bx,centavos
		call printf_s
		jmp chama_acoes
	
;============================================================
;void encerra_programa(){
;	printf_s(msgEncerra);
;	system(exit);
;}
encerra_programa:
	lea bx,msgEncerra
	call printf_s
	.exit
;============================================================

;--------------------------------------------------------------------
		end