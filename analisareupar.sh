#! /bin/bash

> dir.txt
> dir2.txt

[[ $(printf "%s\n" baixado/*/*/*/*) = 'baixado/*/*/*/*' ]] || {
	echo "passou pelo 1"
	nop=1 
	printf "%s\n" baixado/*/*/*/* | while read diretorio;do
	[[ "${diretorio##*/}" = *".zip"* ]] && {
		(unzip -nj "$diretorio" -d baixado/descompactado)
	}
	done

	printf "%s\n" baixado/*/*/*/* | while read diretorio;do
		echo "$diretorio" >> dir.txt
		#varredura
		#categorizar_upar "${diretorio%$arquivo}$filt"
	done
}

[[ $nop = 1 ]] || {
	echo "testando 2"
[[ $(printf "%s\n" baixado/*/*/*) = 'baixado/*/*/*' ]] || {
	echo "passou pelo 2"
	nop=1
	printf "%s\n" baixado/*/*/* | while read diretorio;do
	[[ "${diretorio##*/}" = *".zip"* ]] && {
		(unzip -nj "$diretorio" -d baixado/descompactado)
	}
	done

	printf "%s\n" baixado/*/*/* | while read diretorio;do
		echo "$diretorio" >> dir.txt
		#varredura
		#categorizar_upar "${diretorio%$arquivo}$filt"
	done
}
}

[[ $nop = 1 ]] || {
	echo "testando 3"
[[ $(printf "%s\n" baixado/*/*) = 'baixado/*/*' ]] || {
	echo "passou pelo 3"
	nop=1
	printf "%s\n" baixado/*/* | while read diretorio;do
		[[ "${diretorio##*/}" = *".zip"* ]] && {
			(unzip -nj "$diretorio" -d baixado/descompactado)
		}
	done

	ls -d baixado/*/* | while read diretorio;do
		echo "$diretorio" >> dir.txt
		#varredura
		#categorizar_upar "${diretorio%$arquivo}$filt"
	done
}
}

[[ $nop = 1 ]] || {
	echo "testando 4"
[[ $(printf "%s\n" baixado/*) = 'baixado/*' ]] || {
	echo "passou pelo 4"
	nop=1
	printf "%s\n" baixado/* | while read diretorio;do
	[[ "${diretorio##*/}" = *".zip"* ]] && {
		(unzip -nj "$diretorio" -d baixado/descompactado)
	}
	done

	printf "%s\n" baixado/* | while read diretorio;do
		echo "$diretorio" >> dir.txt
		#varredura
		#categorizar_upar "${diretorio%$arquivo}$filt"
	done
}
}

#echo "antes do shellbot:"
#printf "%s\n" baixado/*/*

source ShellBot.sh

#find -type f -exec echo baixado{} \;

#echo "após o shellbot:"
#printf "%s\n" baixado/*/*

bot_token='865837947:AAGC9_tA2YYNAgBwqzZWAVm_Wrez6FsjjS4'

ShellBot.init --token "$bot_token" --return map

local_documento(){
	taguear
	(ShellBot.sendDocument --chat_id -1001363904405 --document @"$1" --caption "hashtag: $assunto\nlegenda: $legenda")
}

foto() {
	taguear
	(ShellBot.sendPhoto --chat_id -1001363904405 --photo @"$1" --caption "hashtag: $assunto\nlegenda: $legenda")
}

local_video() {
	taguear
	ShellBot.sendChatAction --chat_id -1001363904405 --action upload_video
(	ShellBot.sendVideo --chat_id -1001363904405 --video @"$1" --caption "hashtag: $assunto\nlegenda: $legenda")
}

fixarbot(){
	taguear
	(ShellBot.pinChatMessage	--chat_id -1001363904405 --message_id ${return[message_id]})
}

audio(){ 
	taguear
	let valor=$(($2/3));
	repetir=0
	while [  $repetir -lt $valor ]; do
    	let repetir=repetir+1;
   		ShellBot.sendChatAction --chat_id -1001363904405 --action record_audio
   		sleep 3s
	done
	ShellBot.sendChatAction --chat_id -1001363904405 --action upload_audio
	(ShellBot.sendAudio --chat_id -1001363904405 --audio @$1 --caption "$assunto\n$legenda")
}

enviar() {
	taguear
	mensagem=${mensagem//+/%2B}
	ShellBot.sendMessage --chat_id -1001363904405 --text "$mensagem" $1
}

taguear(){
	minusc=$(echo ${legenda,,} | tr "#" " ")
	assunto=""
	[[ "$minusc" = *"java"* ]] && assunto+="#java "
	[[ "$minusc" = *"python"* ]] && assunto+="#python "
	[[ "$minusc" = *"mysql"* ]] && assunto+="#mysql "
	[[ "$minusc" = *"shell"* || "$minusc" = *"shellscript"* ]] && assunto+="#shellscript"
	[[ "$minusc" = *"php"* ]] && assunto+="#php "
	[[ "$minusc" = *"linux"* ]] && assunto+="#linux "
	[[ "$minusc" = *"windows"* ]] && assunto+="#windows "
	[[ "$minusc" = "c" ]] && assunto+="#c "
	[[ "$minusc" = *"c#"* ]] && assunto+="#c# "
	[[ "$minusc" = *"c++"* ]] && assunto+="#c++ "
	[[ "$minusc" = *"lua"* ]] && assunto+="#lua "
	[[ "$minusc" = *"ruby"* ]] && assunto+="#ruby "
	[[ "$minusc" = *"design"* ]] && assunto+="#design "
	[[ "$minusc" = *"design-patterns"* ]] && assunto+="#design_patterns "
	[[ "$minusc" = *"pattern"* ]] && assunto+="#pattern "
	[[ "$minusc" = *"exploit"* ]] && assunto+="#exploit "
	[[ "$minusc" = *"exploitation"* ]] && assunto+="#exploitation "
	[[ "$minusc" = *"pentest"* ]] && assunto+="#pentest "
	[[ "$minusc" = *"hacking"* ]] && assunto+="#hacking "
	[[ "$minusc" = *"hack"* ]] && assunto+="#hack "
	[[ "$minusc" = *"begginers"* ]] && assunto+="#begginers "
	[[ "$minusc" = *"wifi"* ]] && assunto+="#wifi "
	[[ "$minusc" = *"deep larning"* ]] && assunto+="#deep_larning "
	[[ "$minusc" = *"inteligência artificial"* ]] && assunto+="#inteligência_artificial "
	[[ "$minusc" = *"artificial inteligence"* ]] && assunto+="#artificial_inteligence "
	[[ "$minusc" = *"visual"* ]] && assunto+="#visual "
	[[ "$minusc" = *"ti"* ]] && assunto+="#ti "
	[[ "$minusc" = *"clean code"* || "$minusc" = *"clean-code"* ]] && assunto+="#clean-code "
	[[ "$minusc" = *"metasploit"* ]] && assunto+="#metasploit "
	[[ "$minusc" = *"metaxploit"* ]] && assunto+="#metaxploit "
	[[ "$minusc" = *"attack"* ]] && assunto+="#attack "
	[[ "$minusc" = *"attacking"* ]] && assunto+="#attacking "
	[[ "$minusc" = *"fonrense"* ]] && assunto+="#forense "
	[[ "$minusc" = *"sniffers"* || "$minusc" = *"sniffer"* ]] && assunto+="#sniffers "
	[[ "$minusc" = *"vulnerabilidades"* ]] && assunto+="#vulnerabilidades "
	[[ "$minusc" = *"vulnerabilities"* ]] && assunto+="#vulnerabilities "
	[[ "$minusc" = *"ddos"* ]] && assunto+="#ddos "
	[[ "$minusc" = *"bypass"* ]] && assunto+="#bypass "
	[[ "$minusc" = *"bypassing"* ]] && assunto+="#bypassing "
	[[ "$minusc" = *"buffer"* ]] && assunto+="#buffer "
	[[ "$minusc" = *"botnet"* ]] && assunto+="#botnet "
	[[ "$minusc" = *"segurança"* ]] && assunto+="#segurança "
	[[ "$minusc" = *"secuity"* ]] && assunto+="#secuity "
	[[ "$minusc" = *"redes"* ]] && assunto+="#redes "
	[[ "$minusc" = *"network"* ]] && assunto+="#network "
	[[ "$minusc" = *"internet"* ]] && assunto+="#internet "
	[[ "$minusc" = *"apostila"* || "$minusc" = *"apost"* ]] && assunto+="#apostila "
	[[ "$minusc" = *"iptables"* ]] && assunto+="#iptables "
	[[ "$minusc" = *"anonimato"* ]] && assunto+="#anonimato "
	[[ "$minusc" = *"keylogger"* ]] && assunto+="#keyloger "
	[[ "$minusc" = *"xss"* ]] && assunto+="#xss "
	[[ "$minusc" = *"html"* ]] && assunto+="#html "
	[[ "$minusc" = *"html5"* ]] && assunto+="#html5 "
	[[ "$minusc" = *"css"* ]] && assunto+="#css "
	[[ "$minusc" = *"css3"* ]] && assunto+="#css3 "
	[[ "$minusc" = *"fbi"* ]] && assunto+="#fbi "
	[[ "$minusc" = *"nsa"* ]] && assunto+="#nsa "
	[[ "$minusc" = *"nasa"* ]] && assunto+="#nasa "
	[[ "$minusc" = *"firewall"* ]] && assunto+="#firewall "
	[[ "$minusc" = *"bash"* ]] && assunto+="#bash "
	[[ "$minusc" = *"nexus"* ]] && assunto+="#nexus "
	[[ "$minusc" = *"zsh"* ]] && assunto+="#zsh "
	[[ "$minusc" = *"monads"* ]] && assunto+="#monads "
	[[ "$minusc" = *"monoids"* ]] && assunto+="#monoids "
	[[ "$minusc" = *"json"* ]] && assunto+="#json "
	[[ "$minusc" = *"web"* ]] && assunto+="#web "
	[[ "$minusc" = *"photoshop"* ]] && assunto+="#photoshop "
	[[ "$minusc" = *"gimp"* ]] && assunto+="#gimp "
	[[ "$minusc" = *"iphone"* ]] && assunto+="#iphone "
	[[ "$minusc" = *"rust"* ]] && assunto+="#rust "
	[[ "$minusc" = *"bootstrap"* ]] && assunto+="#bootstrap "
	[[ "$minusc" = *"engineering"* ]] && assunto+="#engineering "
	[[ "$minusc" = *"reverse"* ]] && assunto+="#reverse "
	[[ "$minusc" = *"assembly"* ]] && assunto+="#assembly "
	[[ "$minusc" = *"raspberry"* ]] && assunto+="#raspberry pi "
	[[ "$minusc" = *"algorithms"* ]] && assunto+="#algorithms "
	[[ "$minusc" = *"scrath"* ]] && assunto+="#scrath "
	[[ "$minusc" = *"sql"* ]] && assunto+="#sql "
	[[ "$minusc" = *"nutrition"* ]] && assunto+="#nutrition "
	[[ "$minusc" = *"nfc"* ]] && assunto+="#nfc "
	[[ "$minusc" = *"manual"* ]] && assunto+="#manual "
	[[ "$minusc" = *"git"* ]] && assunto+="#git "
	[[ "$minusc" = *"github"* ]] && assunto+="#github "
	[[ "$minusc" = *"black hat"* ]] && assunto+="#black_hat "
	[[ "$minusc" = *"comandos"* ]] && assunto+="#comandos "
	[[ "$minusc" = *"commands"* ]] && assunto+="#commands "
	[[ "$minusc" = *"certificação"* ]] && assunto+="#certificacao "
	[[ "$minusc" = *"certificate"* ]] && assunto+="#certificate "
	[[ "$minusc" = *"redes"* ]] && assunto+="#redes "
	[[ "$minusc" = *"expressoes"* ]] && assunto+="#expressoes "
	[[ "$minusc" = *"regulares"* ]] && assunto+="#regulares "
	[[ "$minusc" = *"laravel"* ]] && assunto+="#laravel "
	[[ "$minusc" = *"tor"* ]] && assunto+="#tor "
	[[ "$minusc" = *"dark"* ]] && assunto+="#dark "
	[[ "$minusc" = *"art"* ]] && assunto+="#art "
	[[ "$minusc" = *"anonymity"* ]] && assunto+="#anonymity "
	[[ "$minusc" = *"deep web"* ]] && assunto+="#deep_web "
	[[ "$minusc" = *"kali linux"* ]] && assunto+="#kali_linux "
	[[ "$minusc" = *"arduino"* ]] && assunto+="#arduino "
	[[ "$minusc" = *"flutter"* ]] && assunto+="#flutter "
	[[ "$minusc" = *"dommies"* ]] && assunto+="#dommies "
	[[ "$minusc" = *"manual"* ]] && assunto+="#manual "
	[[ "$minusc" = *"excel"* ]] && assunto+="#excel "
	[[ "$minusc" = *"vba"* ]] && assunto+="#vba "
	[[ "$minusc" = *"data science"* ]] && assunto+="#data_science "
	[[ "$minusc" = *"scraping"* ]] && assunto+="#web_scraping "
	[[ "$minusc" = *"django"* ]] && assunto+="#django "
	[[ "$minusc" = *"dummies"* ]] && assunto+="#dummies "
	[[ "$minusc" = *"neuro"* ]] && assunto+="#neuro "
	[[ $assunto ]] || assunto="não identificado"
	echo "TAGS: $assunto"
}

categorizar_upar(){

arquivo=${1##*/}

legenda=${arquivo%.*}
legenda=${legenda//#/ }

[[ "$arquivo" = *".mp4"* || "$arquivo" = *".mkv"* || "$arquivo" = *".webm"* ]] && {
	echo "TEM MP4, mkv, ou webm"	
	local_video "$1"
	rm -rf "$1"
}

[[ "$arquivo" = *".mp3"* || "$arquivo" = *".wav"* ]] && {
	echo "TEM MP3 ou WAV"
	audio "$1"
	rm -rf "$1"
}

[[ "$arquivo" = *".pdf"* || "$arquivo" = *".epub"* ]] && {
	echo "TEM PDF ou EPUB"
	local_documento "$1"
	rm -rf "$1"
}

[[ "$arquivo" = *".jpg"* || "$arquivo" = *".jpeg"* || "$arquivo" = *".png"* ]] && {
	echo "TEM JPG ,JPEG ou PNG"
	foto "$1"
	local_documento "$1"
	rm -rf "$1"
}

[[ "$arquivo" = *".pptx"* ]] && {
	echo "TEM pptx"
	local_documento "$1"
	rm -rf "$1"
}

[[ "$arquivo" = *".srt"* ]] && {
	echo "TEM srt"
	local_documento "$1"
	rm -rf "$1"
}

[[ "$arquivo" = *".vtt"* ]] && {
	echo "TEM vtt"
	local_documento "$1"
	rm -rf "$1"
}
}

varredura(){
	filt=$(echo ${diretorio##*/} | tr ' ' '#' | tr -d '][&,')
	arquivo=${diretorio##*/}
	modificado="${diretorio%$arquivo*}$filt"
	mv "${diretorio}" "$modificado"
	echo "$modificado" >> dir2.txt
}

pkill transmission

nop=0

while read diretorio;do
	filt=$(echo ${diretorio##*/} | tr ' ' '#' | tr -d '][&,')
	arquivo=${diretorio##*/}
	modificado="${diretorio%$arquivo*}$filt"
	mv "${diretorio}" "$modificado"
	echo "$modificado" >> dir2.txt
done < dir.txt

while read diretorio;do
	categorizar_upar "$diretorio"
	rm -f "$diretorio"
done < dir2.txt

> dir.txt
> dir2.txt

mensagem="conteúdo solicitado sobre: $(< atual.txt)"
enviar

echo "FIM DA ANALISE"