#! /bin/bash

#sudo pkill -f transmission-cli

echo "SERVIÇO INICIADOOOOOOOOOOOOOOOOOOO"

source ShellBot.sh

bot_token='865837947:AAGC9_tA2YYNAgBwqzZWAVm_Wrez6FsjjS4'

ShellBot.init --token "$bot_token" --return map

assunto=$(cat topico.txt)

local_documento(){
	ShellBot.sendDocument --chat_id -1001363904405 --document @"$1" --caption "hashtag: #$assunto\nlegenda: $legenda"
}

foto() {
	ShellBot.sendPhoto --chat_id -1001363904405 --photo @"$1" --caption "hashtag: #$assunto\nlegenda: $legenda"
}

local_video() {
	ShellBot.sendChatAction --chat_id -1001363904405 --action upload_video
	ShellBot.sendVideo --chat_id -1001363904405 --video @"$1" --caption "hashtag: #$assunto\nlegenda: $legenda"
}

fixarbot(){
	ShellBot.pinChatMessage	--chat_id -1001363904405 --message_id ${return[message_id]}
}

audio(){ 
	let valor=$(($2/3));
	repetir=0
	while [  $repetir -lt $valor ]; do
    	let repetir=repetir+1;
   		ShellBot.sendChatAction --chat_id -1001363904405 --action record_audio
   		sleep 3s
	done
	ShellBot.sendChatAction --chat_id -1001363904405 --action upload_audio
	ShellBot.sendAudio --chat_id -1001363904405 --audio @$1 --caption "#$assunto\n$legenda"
}

enviar() {
	mensagem=${mensagem//+/%2B}
	ShellBot.sendMessage --chat_id -1001363904405 --text "$mensagem" $1
}

descompactarelimpar(){
	#ls | grep "*.zip"
	#[[ "$?" = "0" ]] && {
	(unzip -nj '*.zip')
	[[ "$?" = "1" ]] && {
		entrar=1
		echo "arquivo compactado não detectado"
	}
	#}
	#for i in $(ls | tr " " "#");do filt=$( echo $i | tr -d "][&,"); mv "${i//#/ }" $filt; done
	rm -rf *.txt
	rm -rf *.uri
	rm -rf *.url
	rm -rf *.exe
}

# colocar o bot no diretório dos arquivos baixados

pkill transmission

cd baixado
cd zzanalisar
cd perigo
echo "dentro de analisando: $(ls)"
#entrar=$(ls | head -n1)
#cd "$entrar"

#pasta=$(ls | head -n1)
#[[ $pasta ]] || {
#	echo "sem pasta, criando : zzzzzzzzzzzz"
#	mkdir zzzzzzzzz
#}
#tar -czvf abudabi.zip "$pasta"
#zip -r abudabi.zip "$pasta"

descompactarelimpar

retorno=2
entrar=0
#inicar o ciclo de entrar nas pastas e subpastas, caso houver
for i in $(ls | tr " " "#");do filt=$( echo $i | tr -d "][&,"); mv "${i//#/ }" $filt; done

pasta=$filt

for primeiro in $(ls);do
	[[ "$entrar" = "0" ]] && {
	echo "entrando em: $primeiro"
	cd "$primeiro"
}
	[[ "$?" = "1" ]] && {
		echo "sem pasta, desativando retorno"
		retorno=1
		#mkdir dir
	}

for i in $(ls | tr " " "#");do filt=$( echo $i | tr -d '][&,'); mv "${i//#/ }" $filt; done

	for j in $(ls);do
	[[ "$retorno" = "1" ]] || {
		[[ "$entrar" = "0" ]] && {
			echo "entrando em: $j"
			cd "$j"
			descompactarelimpar
	}
	[[ "$?" = "1" ]] && {
		echo "sem pasta, desativando retorno"
		retorno=1
		#mkdir dir
	}
	}

echo "ANALISANDO E ENVIANDO: "

[[ $(ls | fgrep ".mp4") ]] && {
echo "TEM MP4"
for i in $(ls  | fgrep ".mp4");do

filt=$(echo $i | tr -d "][&,")

#mv "$i" $filt

echo $filt

legenda=$(echo "${filt//#/ }" | cut -d "." -f1)

local_video "$filt"

rm -rf "$i"

done
mensagem="novos conteúdos de $assunto"
enviar
}

[[ $(ls | fgrep ".mkv") ]] && {
echo "TEM MKV"
for i in $(ls  | fgrep ".mkv");do

filt=$(echo $i | tr -d "][&,")

#mv "$i" $filt

echo $filt

legenda=$(echo "${filt//#/ }" | cut -d "." -f1)

local_video "$filt"

rm -rf "$i"

done
mensagem="novos conteúdos de $assunto"
enviar
}

[[ $(ls | fgrep ".mp3") ]] && {
echo "TEM MP3"
for i in $(ls  | fgrep ".mp3");do

filt=$(echo $i | tr -d "][&,")

#mv "$i" $filt

echo $filt

legenda=$(echo "${filt//#/ }" | cut -d "." -f1)

audio "$i"

rm -rf "$i"

done
mensagem="novos conteúdos de $assunto"
enviar
}

[[ $(ls | fgrep ".pdf") ]] && {
echo "TEM PDF"
for i in $(ls  | fgrep ".pdf");do

filt=$(echo $i | tr -d "][&,")

#mv "$i" $filt

echo $filt

legenda=$(echo "${filt//#/ }" | cut -d "." -f1)

local_documento "$filt"

rm -rf "$i"

done
mensagem="novos conteúdos de $assunto"
enviar
}

[[ $(ls | fgrep ".epub") ]] && {
echo "TEM EPUB"
for i in $(ls  | fgrep ".epub");do

filt=$(echo $i | tr -d "][&,")

#mv "$i" $filt

echo $filt

legenda=$(echo "${filt//#/ }" | cut -d "." -f1)

local_documento "$i"

rm -rf "$i"

done
mensagem="novos conteúdos de $assunto"
enviar
}

[[ $(ls | fgrep ".jpg") ]] && {
echo "TEM JPG"
for i in $(ls  | fgrep ".jpg");do

filt=$(echo $i | tr -d "][&,")

#mv "$i" $filt

echo $filt

legenda=$(echo "${filt//#/ }" | cut -d "." -f1)

foto "$filt"
local_documento "$filt"

rm -rf "$i"

done
mensagem="novos conteúdos de $assunto"
enviar
}

[[ $(ls | fgrep ".jpeg") ]] && {
echo "TEM JPEG"
for i in $(ls  | fgrep ".jpeg");do

filt=$(echo $i | tr -d "][&,")

#mv "$i" $filt

echo $filt

legenda=$(echo "${filt//#/ }" | cut -d "." -f1)

foto "$filt"
local_documento "$filt"

rm -rf "$i"

done
mensagem="novos conteúdos de $assunto"
enviar
}

[[ $(ls | fgrep ".png") ]] && {
echo "TEM PNG"
for i in $(ls  | fgrep ".png");do

filt=$(echo $i | tr -d "][&,")

#mv "$i" $filt

echo $filt

legenda=$(echo "${filt//#/ }" | cut -d "." -f1)

foto "$filt"

local_documento "$filt"

rm -rf "$i"

done
mensagem="novos conteúdos de $assunto"
enviar
}

[[ $(ls | fgrep ".pptx") ]] && {
echo "TEM pptx"
for i in $(ls  | fgrep ".pptx");do

filt=$(echo $i | tr -d "][&,")

#mv "$i" $filt

echo $filt

legenda=$(echo "${filt//#/ }" | cut -d "." -f1)

local_documento "$filt"

rm -rf "$i"

done
mensagem="novos conteúdos de $assunto"
enviar
}

[[ $(ls | fgrep ".srt") ]] && {
echo "TEM srt"
for i in $(ls  | fgrep ".srt");do

filt=$(echo $i | tr -d "][&,")

#mv "$i" $filt

echo $filt

legenda="arquivo de legenda: ${filt//#/ }"

local_documento "$filt"

rm -rf "$i"

done
mensagem="novos conteúdos de $assunto"
enviar
}

[[ $(ls | fgrep ".vtt") ]] && {
echo "TEM vtt"
for i in $(ls  | fgrep ".vtt");do

filt=$(echo $i | tr -d "][&,")

#mv "$i" $filt

echo $filt

legenda="arquivo de legenda: ${filt//#/ }"

local_video "$filt"

rm -rf "$i"

done
mensagem="novos conteúdos de $assunto"
enviar
}


#sair das pastas a cada diretório encontrado
	[[ "$retorno" = "2" ]] && {
		echo "retornando uma pasta ..."
		cd ..
		rm -rf "$j"
	} || {
		echo "retorno desativado"
	}
	done
	[[ "$retorno" = "2" ]] && {
		echo "retornando uma pasta ..."
		cd ..
	} || {
		echo "retorno desativado"
	}
done

rm -r "$pasta"

[[ "$?" = "1" ]] && {
	cd ..
	rm -r "$pasta"
}

echo "FIM DA ANALISE"