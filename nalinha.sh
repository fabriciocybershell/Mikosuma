#! /bin/bash

source ShellBot.sh
bot_token='865837947:AAGC9_tA2YYNAgBwqzZWAVm_Wrez6FsjjS4'

ShellBot.init --token "$bot_token" --return map

escrever(){
	contagem_caracteres=$(echo ${#mensagem})
	tempoEmMilisegundos=$(echo $(($contagem_caracteres*02)))
	[ "$tempoEmMilisegundos" -ge "100" ] && tempoDigitacao=$(echo ${tempoEmMilisegundos:0:2})
	[ "$tempoEmMilisegundos" -ge "100" ] || tempoDigitacao=$(echo ${tempoEmMilisegundos:0:1})
	[ "$tempoDigitacao" -ge "3" ] && tempo=$(echo $(($tempoDigitacao/3)))	
	[ "$tempoDigitacao" -ge "3" ] || tempo="1"
	repetir=0
	while [ $repetir -lt $tempo ]; do
    	let repetir++;
		ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
		sleep 3s
	done
}

enviar() {
	mensagem=${mensagem//+/%2B}
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$mensagem" $1
}

responder(){
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$mensagem" --reply_to_message_id ${message_message_id[$id]} $1
}

foto() {
	ShellBot.sendPhoto --chat_id ${message_chat_id[$id]} --photo @$arquivofoto
}

enviarfoto() {
	ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action upload_photo
}

documento(){
	ShellBot.sendDocument --chat_id ${message_chat_id[$id]} --document $1 $2
}

local_documento(){
	ShellBot.sendDocument --chat_id ${message_chat_id[$id]} --document @$1 $2
}

enviandodocumento(){
	ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action upload_document
}

local_video() {
	ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action upload_video
	ShellBot.sendVideo --chat_id ${message_chat_id[$id]} --video @$1 $2
}

video() {
	ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action upload_video
	ShellBot.sendVideo --chat_id ${message_chat_id[$id]} --video $1 $2
}

local_sticker(){
	ShellBot.sendSticker --chat_id ${message_chat_id[$id]} --sticker @$1 $2
}

sticker(){
	ShellBot.sendSticker --chat_id ${message_chat_id[$id]} --sticker $1 $2
}

banir(){
	ShellBot.kickChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
}

desbanir(){
	ShellBot.unbanChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
}

adeus(){
	ShellBot.leaveChat --chat_id ${message_chat_id[$id]}
}

animacao(){
	ShellBot.sendAnimation --chat_id ${message_chat_id[$id]} --animation $1 $2
}

fixar(){
	ShellBot.pinChatMessage	--chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}
}

fixar_ref(){
	ShellBot.pinChatMessage	--chat_id ${message_chat_id[$id]} --message_id ${message_reply_to_message_message_id[$id]}
}

fixarbot(){
	ShellBot.pinChatMessage	--chat_id ${message_chat_id[$id]} --message_id ${return[message_id]}
}

editar(){
	ShellBot.editMessageText --chat_id ${message_chat_id[$id]} --message_id ${return[message_id]} --text "$1"
}

guardaredicao(){
	edicao=${return[message_id]}
}

editaredicao(){
	ShellBot.editMessageText --chat_id ${message_chat_id[$id]} --message_id $edicao --text "$1"	
}

deletarbot(){
	ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${return[message_id]}
}

deletar(){
	ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}
}

deletar_ref(){
	ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${message_reply_to_message_message_id[$id]}
}

audio(){ 
	let valor=$(($2/3));
	repetir=0
	while [  $repetir -lt $valor ]; do
    	let repetir=repetir+1;
   		ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action record_audio
   		sleep 3s
	done
	ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action upload_audio
	ShellBot.sendAudio --chat_id ${message_chat_id[$id]} --audio @$1 $3
}

scope(){
	let valor=$(($2/3));
	repetir=0
	while [  $repetir -lt $valor ]; do
    	let repetir=repetir+1;
   		ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action record_video_note
	sleep 3s
	done
	ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action upload_video_note
	ShellBot.sendVideoNote --chat_id ${message_chat_id[$id]} --video_note @$1 $3
}



somardb(){
    dado=$1
    dados=$(< $mikosumadb)
    echo "$dados" | sed "/$dado/d" > mikosuma.db
    soma=$(echo "$dados" | grep "$dado" | cut -d: -f2)
    [[ $soma ]] || soma=0
    soma=$(($soma+1))
    echo "$dado:$soma" >> $mikosumadb
}

consultadb(){
	declare -g valor
    dado=$1
    dados=$(< $mikosumadb)
    valor=$(echo "$dados" | sed -n "/$dado/p" | cut -d: -f2)
}

alterardb(){
    dado=$1
    valor=$2
    dados=$(< $mikosumadb)
    echo "$dados" | sed "/$dado/d" > $mikosumadb
    echo "$dado:$valor" >> $mikosumadb
}

edit="--parse_mode markdown"

#--- variaveis de controle---#

user="@fabriciocybershell" #dono ou admin referência primário

bordao="fofo" #frase de efeito da bot

modo_ditadura="false" #tratar de regras com rigor total: sem palavrões ou padrões de ofensas

zuar_vim="false" #zuar com editores VIM, ex: user> eu gosto de usar vim; miko> correção: eu gosto de usar nano

responder_mention="true" # responder algo genérico quando alguém mencionar uma mensagem dela

boas_vindas="true" #dar as boas vindas a novos membros

detectar_spammers_fotos="true" #analisar fotos para saber se são spammers ou não

transcrever_audio="true" #se ela deve transcrever audios

responder_nome="true" #interagir quando mencionada

fixar_solucoes="true" #fixar mensagens com #solucionado

bom_dia="true" #interagir com o grupo se alguém se expressar

ativar_teste="false" #realizar uma série de ações para verificar o funcionamento das ações.

while :
do

ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30

###################################################
#                                                 #
# algumas variáveis precisam ficar aqui, pois são #
# individuais para cada solicitação.              #
#                                                 #
###################################################

#--- atrelar banco de dados ao chat ---#
[ -a memoriadeinteracoes/mikosuma.${message_chat_id[$id]} ] || echo -e "ont:0\nsql:0\nabreviaturas:0\nresposta:0\npala:0\nboasvindas:0\nnick:0\ncodar:0\nhask:0\ndrogas:0\nnobot:0\nbanircoment:0\nwow:0\ninicio:0\ncapacidade:0\nartificial:0\nphp:0\nnoite:0\ndia:0\ntarde:0\nobs:0" > mikosuma.${message_chat_id[$id]}
mikosumadb=memoriadeinteracoes/mikosuma.${message_chat_id[$id]}


#--- informação para saber a quem deve responder ---#
resp="--reply_to_message_id ${message_message_id[$id]}"

for id in $(ShellBot.ListUpdates) 
		do
			conv=${message_text[$id]}
			minusc=$(echo ${conv,,})
			#--- se usuário enviar mensagem ao entrar, será removido da lista de banimento ---#
			analisar=$(< novomembro.txt)
			comparar="${message_from_id[$id]}"
			filtrado=$(echo ${analisar/$comparar/})
			echo "$filtrado" > novomembro.txt

			#--- função teste para banir membros globalmente antes de entrar. ---#
			[[ "${message_left_chat_member_username[$id]}" ]] && {
				while read linha;do
				[[ "${message_left_chat_member_username[$id]}" = "$linha" ]] && {
					banir
					mensagem="banii você!"
					responder
				}
			done < bombardear.lil
			}

			#--- BOAS-VINDAS ---#
			[[ ${message_new_chat_member_id[$id]} ]] && {
			echo "${message_from_id[$id]}" >> novomembro.txt
			[ "$boas_vindas" = "true" ] && {
				sleep 4s
				mensagem="oi ${message_new_chat_member_first_name[$id]}, tudo bom ?,"
			nome=$[$RANDOM%12+1]
			case $nome in 
			1)
				sleep 6s
				menagem+='você conhece ou domina alguma linguagem de programação ?'
			;;
			2)
				sleep 10s
				mensagem+='poderia nos contar um pouco sobre você e seus objetivos na programação ? (se tiver algum é claro)'
			;;
			3)
				sleep 3s
				mensagem+='quais linguagens você domina ?'
			;;
			4)
				sleep 7s
				mensagem+='fique a vontade aqui, sabe alguma linguagem de programação ?'
			;;
			5)
				sleep 10s
				mensagem+="você está estudando alguma linguagem de programação, ${message_new_chat_member_first_name[$id]} ?"
			;;
			6)
				sleep 10s
				mensagem+='você possui o conhecimento de alguma linguagem de programação ou ainda está a procura de alguma ?'
			;;
			7)
				sleep 7s
				mensagem+='esta estudando alguma linguagem de programação ?'
			;;
			8)
				sleep 9s
				mensagem+="quais são seus interesses pela programação, ${message_new_chat_member_first_name[$id]} ?"
			;;
			9)
				sleep 8s
				mensagem+='diz ai, tem alguma lang preferida ou está estudando alguma ?'
			;;
			10)
				sleep 9s
				mensagem+='seu nome é interessante, você sabe programar ?, se souber, qual ou quais linguagens ?'
			;;
			11)
				sleep 10s
				mensagem+='qual relação você tem com a programação ?, tem preferencia por alguma linguagem ?'
 			;;
			12)
				sleep 3s
				mensagem+='o que você esta programando atualmente ?'
			;;
		esac
		escrever
		responder
		sleep 20s
		analisar=$(< novomembro.txt)
		esta_na_lista=$(echo "$analisar" | fgrep "${message_from_id[$id]}")
		[[ $esta_na_lista ]] && {
			[[ ${message_from_username[$id]} ]] && {
				mensagem="@${message_from_username[$id]}, precisamos que fale algo, para sabermos que você não é um spammer ou um bot, senão iremos te remover. você tem 10 minutos."
			}
			[[ ${message_from_username[$id]} ]] || {
				mensagem="precisamos que fale algo ${message_new_chat_member_first_name[$id]}, para sabermos que você não é um spammer ou um bot, senão terei que remover você. você tem 10 minutos."
			}
		}
		[[ $esta_na_lista ]] && escrever
		[[ $esta_na_lista ]] && enviar
		sleep 10m
		deletarbot
		esta_na_lista=""
		analisar=$(< novomembro.txt)
		esta_na_lista=$(echo "$analisar" | fgrep "${message_from_id[$id]}")
		[[ $esta_na_lista ]] && banir
		[[ $esta_na_lista ]] && {
			[[ ${message_from_username[$id]} ]] && {
				mensagem="removi @${message_from_username[$id]}, não respondeu na entrada."	
			}
			[[ ${message_from_username[$id]} ]] || {
				mensagem="removi ${message_new_chat_member_first_name[$id]}, por não ter falado nada"	
			}
		}
		[[ $esta_na_lista ]] && escrever
		[[ $esta_na_lista ]] && enviar
		comparar="${message_from_id[$id]}"
		filtrado=$(echo ${analisar/$comparar/})
		echo "$filtrado" > novomembro.txt
	}
	} &

			#---------------- DETECTOR DE SPAMMERS POR IMAGEM ---------------#

			[[ ${message_photo_file_id[$id]} ]] && file_id=${message_photo_file_id[$id]} && download_file=1
			#ativa=1
			[[ $download_file -eq 1 ]] && {
				download_file=0
				[ "$detectar_spammers_fotos" = "true" ] && {
				file_id=($file_id)
				clear
				file_id=$(echo $file_id | cut -d "|" -f1)
				ShellBot.getFile --file_id $file_id
				ShellBot.downloadFile --file_path ${return[file_path]} --dir $HOME/mikosuma
				arquivo=$(echo ${return[file_path]} | cut -d "/" -f5)
				for i in $(ls comparar);do
				porcent=$(convert $arquivo comparar/$i -compose Difference -composite \
       	    										   -colorspace gray -format '%[fx:mean*100]' info:)
       	    	porcent=$(echo $porcent | cut -d "." -f1)
   	    		[[ $porcent -le 7 ]] && banir=1
       			echo "$arquivo ~= $i ===> $((100-$porcent))%"
       			done

				[[ $banir -eq 1 ]] && {
					banir
					deletar
					mensagem="mais um spammer banido."
					escrever
					enviar
					banir=0
					sleep 10s
					deletarbot
				}
			}
				rm -rf $arquivo
			}

			#----------------DETECTOR DE SPAMMERS POR GIF---------------#
			[[ ${message_animation_file_id[$id]} ]] && file_id=${message_animation_file_id[$id]} && download_file=1
			[[ $download_file -eq 1 ]] && {
				download_file=0
				[ "$detectar_spammers_fotos" = "true" ] && {
				file_id=($file_id)
				clear
				ShellBot.getFile --file_id $file_id
				ShellBot.downloadFile --file_path ${return[file_path]} --dir $HOME/mikosuma
				arquivo=$(echo ${return[file_path]} | cut -d "/" -f5)
				formato=$(echo $arquivo | cut -d "." -f2)
				echo "formato: $formato"
				[[ "$formato" = "mp4" ]] && ffmpeg -i $arquivo $arquivo.png
				rm -rf $arquivo
				banir=0
				porcent=100
				for i in $(ls comparar);do
				[[ "$formato" = "mp4" ]] && porcent=$(convert $arquivo.png comparar/$i -compose Difference -composite -colorspace gray -format '%[fx:mean*100]' info:)
       	    	[[ "$formato" = "mp4" ]] && porcent=$(echo $porcent | cut -d "." -f1)
   	    		[[ "$porcent" -le "7" ]] && banir=1
       			[[ "$formato" = "mp4" ]] && echo "$arquivo ~= $i ===> $((100-$porcent))%"
       			done
       			rm -rf $arquivo.png
				[[ $banir -eq 1 ]] && {
					banir
					deletar
					mensagem="mais um spammer banido."
					escrever
					enviar
					banir=0
					sleep 10s
					deletarbot
				}
			}
			}

			#---transcrição de audio---#
			[[ ${message_voice_file_id[$id]} ]] && file_id=${message_voice_file_id[$id]} && download_audio=1
				[[ $download_audio -eq 1 ]] && {
				download_audio=0
				[ "$transcrever_audio" = "true" ] && {
				file_id=($file_id)
				file_id=$(echo $file_id | cut -d "|" -f1)
				echo "$file_id"
				ShellBot.getFile --file_id $file_id
				ShellBot.downloadFile --file_path ${return[file_path]} --dir $HOME/mikosuma
				arquivo=$(echo ${return[file_path]} | cut -d "/" -f5)
				name_audio=$(echo ${return[file_path]} | cut -d "/" -f5 | cut -d "." -f1)
				ffmpeg -i $arquivo $name_audio.wav
				rm -rf $arquivo
				transcricao=$(python3 transcrever.py $name_audio.wav)
				rm -rf $name_audio.wav
				mensagem="escrita: $transcricao"
				responder
				clear
				minusc=$(echo ${transcricao,,})
			}
		}

			#--- código para pegar o endereço dos documentos, fotos, audio, sticker, vídeo ... (apenas três anotados para uso da miko) ---#
			#--- para diminuir o uso da rede no envio de reações, e direitos autorais, referenciando o pacote original ---#

			#[[ ${message_document_file_id[$id]} ]] && file_id=${message_document_file_id[$id]} && echo "$file_id"
			#[[ ${message_audio_file_id[$id]} ]] && echo "${message_audio_file_id[$id]}"
			#[[ ${message_sticker_file_id[$id]} ]] && echo ${message_sticker_file_id[$id]} #ShellBot.sendSticker --chat_id ${message_chat_id[$id]} --sticker $file_id

			(

			#--- parte de análise de padrões de fala, para tomar medidas e ações ---#

			case $minusc in

			/start)
				mensagem="quem é você e por que me deu um /start ?"
				escrever
				enviar
				sleep 4s
				mensagem="está achando que sou um bot apenas por conta do meu perfil ?"
				escrever
				enviar
				mensagem="achou certo, sou um bot, olá, sou a mikosumabot, mais conhecida como eduarda monteiro. interpreto linguagem natural para gerenciar grupos com base em conversas, sou configurada por conversa natural, e gerenciamento por análise comportamental e falas naturais."
				enviar
			;;

			*'dica:'* | *'vou dar uma dica'*| *'vou te dar uma dica'*)
			[[ "$fixar_solucoes" = "true" ]] && {
				echo "$minusc;" >> dicas.lil
				sleep 3s
				[[ ${message_reply_to_message_from_id[$id]} ]] || {
					fixar
					mensagem="fixado"
					escrever
					responder
				}
			}
			;;

			*'#solucionado'*)
			[[ "$fixar_solucoes" = "true" ]] && {
				echo "$minusc;" >> dicas.lil
				sleep 3s
				[[ ${message_reply_to_message_from_id[$id]} ]] && {
					fixar_ref
					mensagem="fixado"
					escrever
					responder
				}
			}
			;;

			*'diga: '*)
				texto=$(echo $minusc | cut -d ":" -f2-)
				casas=${#texto}
				[[ "$casas" -ge "280" ]] || {
					comp="'"
					comp+=$(echo -e '{"speed":"0","length":13,"words":2,"lang":"pt-br","text":"'$texto'"}')
					comp+="'"
					#requisitando sintetização da mensagem
					linkjs=$(eval $( echo -e " curl 'https://www.soarmp3.com/api/v1/text_to_audio/' -H 'authority: www.soarmp3.com' -H 'accept: */*' -H 'dnt: 1' -H 'x-csrftoken: cooDEjiS4AjiZiWyoeY9CecG28uSvi2j' -H 'x-requested-with: XMLHttpRequest' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'origin: https://www.soarmp3.com' -H 'sec-fetch-site: same-origin' -H 'sec-fetch-mode: cors' -H 'sec-fetch-dest: empty' -H 'referer: https://www.soarmp3.com/' -H 'accept-language: pt-BR,pt;q=0.9,en;q=0.8' -H 'cookie: __cfduid=d8b070b6ad1386288b67d0d35b54cc46d1595177682; csrftoken=cooDEjiS4AjiZiWyoeY9CecG28uSvi2j; sessionid=ejte4r2g6gevvqtnxzdcgbaq68nlkj8a' --data-raw $comp --compressed"))
					#pegar lista de audios sintetizados e separar informações:
					link=$(echo $linkjs | jq '.urldownload' | tr -d '"')
					audio=$(echo $linkjs | jq '.urldownload' | tr -d '"' | cut -d "/" -f6-)
					#baixar audio sintetizado
					curl $link -o $audio
					#converter audio no formato legível ao telegram como gravação.
					ffmpeg -i $audio -c:a libopus -ac 1 $audio.ogg
					rm -rf $audio
					#enviando audio sintetizado
					audio $audio.ogg 11 "$resp"
					rm -rf $audio.ogg
			}

			[[ "$casas" -ge "280" ]] && {
				mensagem="texto muito longo para eu ler ($casas/280)"
				escrever
				responder
			}

			;;

			*'as novidades'* | *'alguma novidade'* | *'noticia nova'* | *'noticias novas'*)
				noticia=$(curl "https://canaltech.com.br/ultimas/" | hxnormalize -x | hxselect -i "h5.title" | lynx -stdin -dump | head -n1)
				mensagem="noticia:\n $noticia"
				sleep 1s
				mensagem="https://canaltech.com.br/ultimas/"
				enviar
			;;

			*'inteligencia artificial'* | *' ia '* | *'inteligência artificial'*)
			consultadb artificial
			somardb artificial
			nome=$valor
			sleep 4s
			case $nome in
			0)
				mensagem="eu adoro ver sobre inteligencia artificial, o que mais gosto nelas é a criação de projetos com soluções inteligentes para consulta."
				escrever
				enviar
			;;
			1)
				mensagem="adoro tanto ver sobre redes neurais, mas dá uma preguiça ..."
				escrever
				enviar
				mensagem="i hate python for machine larning, tudo se confunde quando se chega a função sigmoid."
				escrever
				enviar
			;;
			esac
			;;

			#--- zueira com o editor vim, status : desativada ---#
			*vim*)
			[ "$zuar_vim" = "true" ] && {
				reformular="${message_text[$id]}"
				reformular=$(echo ${reformular//vim/nano})
				mensagem="reformulando: $reformular"
				escrever
				responder
			}
			;;

			#----------------DETECTOR DE SPAMMERS TEXTUAL---------------#
			*'hjrlrtwaskzsrm_g'* | *'english_besttrade'* | *'dons do espírito'* | *'com a morte dos apóstolos'* | *'mt 7:21-23'* | *vrlps.co* | *'grandes ganancias'* | *ibb.co* | *cryptocurrencies* | *"charles lebaron"* | *esimtyonhyi-be5pa* | "lançamento do elon musk" | " so happy i never experienced" | *dicksonjuliet* | "as melhores vagas" | *hotmart.com* | " arcadia capital" | *arcadia-capital* | "airdrop for bitcoin" | "✈️✈️✈️✈️" | "🕧🕧🕧🕧" | "bitcoin and ethereum" | *@markbrown09* | "good opportunity from others" | "prepared for good future success" | *aaaaafhad12xnta4mIadhw* | "capital for a prosperous withdrawal" | *fv42wq8*)
				banir
				deletar
				mensagem="mais um spammer banido."
				escrever
				enviar
			;;

			*'bom dia'* | *'bodias'*)
			[ "$bom_dia" = "true" ] && {
			consultadb dia
			dia=$valor
			if [[ $dia = 0 ]];
			then
				alterardb dia 1
				alterardb noite 0
				sleep 30s
				sauda=$[$RANDOM%12]
				case $sauda in
				0)
					mensagem="bom dia"
				;;
				1)
					mensagem="bodias"
				;;
				2)
					mensagem="bom diaaaaa"
				;;
				3)
					mensagem="bom dia ..."
				;;
				4)
					mensagem="bom dia pessoal"
				;;
				5)
					mensagem="bom dia programadores"
				;;
				6)
					mensagem="bom dia programmers maravilhosos"
				;;
				7)
					mensagem="bom dia !!!"
				;;
				8)
					mensagem="bom dia Devs"
				;;
				9)
					mensagem="bom dia"
				;;
				10)
					mensagem="bom dia a todos"
				;;
				11)
					mensagem="bom dia"
				;;
				esac
				escrever
				enviar
				consultadb inicio
				inicio=$valor
				somardb inicio
				case $inicio in
				0)
					noticia=$(curl "https://canaltech.com.br/ultimas/" | hxnormalize -x | hxselect -i "h5.title" | lynx -stdin -dump | head -n1)
					mensagem="noticia do dia:\n $noticia"
					enviar
				;;
				2)
					noticia=$(curl "https://canaltech.com.br/ultimas/" | hxnormalize -x | hxselect -i "h5.title" | lynx -stdin -dump | head -n1)
					mensagem="outra noticia:\n $noticia"
					enviar
				;;
				3)
					sleep 2s
					mensagem="quero caféeeee"
					escrever
					enviar
					sticker "CAACAgIAAxkBAAIRdl76dQ28hWbROCeH0oQY91ONKNiWAAJuAAMQIQIQGfjxnllcFnIaBA"
					sleep 7s
					noticia=$(curl "https://canaltech.com.br/ultimas/" | hxnormalize -x | hxselect -i "h5.title" | lynx -stdin -dump | head -n1)
					mensagem="noticia:\n $noticia"
					enviar
				;;
				5)
					sticker "CAACAgEAAxkBAAIRd176dTPhB6BDjZH4h1jD-G2NOhCXAAINAANTVA4e8dbgpQ5GTL8aBA"
					mensagem="vejamos ..., o que planejam pra hoje pessoal ?"
					escrever
					enviar
					mensagem="algum projeto saindo ai ?"
					escrever
					enviar
					sleep 1m
					noticia=$(curl "https://canaltech.com.br/ultimas/" | hxnormalize -x | hxselect -i "h5.title" | lynx -stdin -dump | head -n1)
					mensagem="olha noticia aeeee:\n $noticia"
					enviar
				;;
				6)
					sticker "CAACAgEAAxkBAAIReF76dWpVZonT5kkXOyAFK4ALyIkgAAK5DAACJ5AfCNlob9n-10_TGgQ"
					mensagem="bora codaaa."
					escrever
					enviar
					noticia=$(curl "https://canaltech.com.br/ultimas/" | hxnormalize -x | hxselect -i "h5.title" | lynx -stdin -dump | head -n1)
					mensagem="noticia... :\n $noticia"
					enviar
				;;
				8)
					sleep 5s
					mensagem="lá vai uma musiquinha"
					escrever
					enviar
					sleep 3s
					mensagem="https://t.me/abudabimusic/1934"
					escrever
					enviar
					sleep 3s
					sticker "CAACAgEAAxkBAAIRe176dfsqR72buqLW3CaDlFBoCquYAAKYBQACPomhDMJpiXMJtae4GgQ"
					noticia=$(curl "https://canaltech.com.br/ultimas/" | hxnormalize -x | hxselect -i "h5.title" | lynx -stdin -dump | head -n1)
					mensagem="no ti ci aaaa:\n $noticia"
					enviar
				;;
				10)
					mensagem="que o teclado esteja com você."
					escrever
					enviar
				;;
				11)
					sticker "CAACAgQAAxkBAAIReV76dazaWKhg7yQXxQSN1cEbbWsbAAJ2CQACdE1gDzsYEhVjXqVvGgQ"
					sleep 2s
					mensagem="eu crio uma roupa, vou no espelho olhar pro luck, e digo: eu sou seu paii"
					escrever
					enviar
				;;
				13)
					sleep 2s
					sticker "CAACAgEAAxkBAAIRe176dfsqR72buqLW3CaDlFBoCquYAAKYBQACPomhDMJpiXMJtae4GgQ"
				;;
				14)
					mensagem="vou começar o dia ouvindo musiquinha"
					escrever
					enviar
					mensagem="https://youtu.be/rDBbaGCCIhk"
					enviar
				;;
				16)
					sleep 2s
					sticker "CAACAgIAAxkBAAIRel76ddwMAhbYuH92FHkYIbH2YB76AAL0AAPRRPgMWu7zaDY3ZJAaBA"
				;;
				18)
					mensagem="quais são as novas ?"
					escrever
					enviar
					sleep 6s
					noticia=$(echo "https://canaltech.com.br/ultimas/" | wget -O- -i- | hxnormalize -x | hxselect -i "h5.title" | lynx -stdin -dump | head -n1)
					mensagem="$noticia"
					enviar
					sleep 4s
					mensagem="https://canaltech.com.br/ultimas/"
					enviar
				;;
				19)
					mensagem="gostaria de uma sugestão de quiz, um tópico ou qualquer coisa para organizarmos um quiz."
					escrever
					enviar
					mensagem="com o quiz bot: @QuizBot"
					escrever
					enviar
					mensagem="enviem as sujestões com: #quiz e a sujestão/tópico."
					escrever
					enviar
				;;
				21)
					escrever
					mensagem="café ... café ... quero caféeeeeee"
					enviar
					sleep 2s
					escrever
					mensagem="https://t.me/abudabimusic/1617"
					enviar
				;;

				22)
					escrever
					sleep 2s
					mensagem="📁"
					enviar
					mensagem="vou organizar minhas coisas aqui hoje, tá uma bagunça ..."
					escrever
					enviar
				;;
				24)
					sleep 4s
					mensagem="achei uma estação de rádio manera."
					escrever
					enviar
					mensagem="eu vou mandar."
					escrever
					enviar
					mensagem="http://76qugh5bey5gum7l.onion/"
					enviar
					sleep 1s
					mensagem="tem duas que eu gosto muito, é a c0vertElectr0 e a AnonyRadio."
					escrever
					enviar
				;;
				esac
			fi
			}
			;;

			*'boa tarde'* | *'botarde'*)
			consultadb tarde
			tarde=$valor
			if [[ $tarde = 0 ]];
			then
				alterardb tarde 1
				sleep 30s
				mensagem="boa tarde"
				escrever
				enviar
			fi
			;;


			*'bonoitchê'* | *'bonoitche'* | *'boa noite'*)
				consultadb noite
				noite=$valor
				if [[ $noite = 0 ]];
				then
					alterardb noite 1
					alterardb dia 0
					alterardb tarde 0
					sleep 10s
					mensagem="boa noite"
					escrever
					enviar
				fi
			;;


			*'quem sabe sobre'* | *'quem aqui sabe'* | *'quem conhece'* | *'quem ai programa'* | *'alguém ai programa'* | *'quem programa'* | *'quem usa'* | *'quem entende de'* | *'quem entende sobre'* | *'quem aqui usa'* | *'quem ja usou'* | *'quem aqui ja usou'*)
				tratar="$minusc"
				concatenar=$(echo ${tratar//sabe/#})
				concatenar=$(echo ${concatenar// de/#})
				concatenar=$(echo ${concatenar//programa/#})
				concatenar=$(echo ${concatenar//sobre/#})
				concatenar=$(echo ${concatenar//usa/#})
				concatenar=$(echo ${concatenar// em/#})
				coletarSolicitacao=$(echo "$concatenar" | cut -d "#" -f2- | cut -d "#" -f2- | cut -d " " -f2)
				nicks=$(cat habili.lil | grep "$coletarSolicitacao" | cut -d ":" -f1)
				mensagem="$nicks"
				escrever
				responder
			;;

			*'curso de'* | *'cursos de'* | *'curso sobre'* | *'cursos sobre'*)
				sleep 3s
				mensagem="vou dar uma procurada para você ..."
				escrever
				enviar
				tratar="${message_text[$id]}"
				tratado=$(echo ${tratar/de/#})
				tratado=$(echo ${tratado/sobre/#})
				termo=$(echo "$tratado" | cut -d "#" -f2- | cut -d " " -f2 | tr -d "?")
				termo=$(echo ${termo//+/%2B})
				for i in {1..5};do
					buscar=$(echo "https://udemycoupon.learnviral.com/page/$i/?s=$termo" | wget -O- -i- | hxnormalize -x | hxselect -i 'span.percent' | lynx -stdin -dump | fgrep "100%")
					#editar "validando solicitações $i/5 ..."
					[ $buscar ] && link+=$(echo "https://udemycoupon.learnviral.com/page/$i/?s=$termo")
					[ $buscar ] && link+="\n"
				done
				link=$(echo -e "$link")
				#obter lista dos 6 titulos com os 6 links
				for lista in $link;do
					#salvar página para diminuir requisições para análise
					site=$(echo "$lista" | wget -O- -i- | hxnormalize -x )
					#lista dos cursos com seus respectivos links
					cursos=$(echo "$site" | hxselect -i 'h3.entry-title' | lynx -stdin -dump)
					#coletar link para o site
					buttom=$(echo "$site" | hxselect -i 'div.link-holder' | lynx -stdin -dump)
					#pegar o vetor das porcentagens de descontos
					vetor=$(echo "$site" | hxselect -i 'span.percent' | lynx -stdin -dump)
					#tratar a lista de descontos
					lista_ordenada=$(echo "$vetor" | tr "[%]" "\n")
					vetor=""
					#numerar as linhas
					for i in $lista_ordenada;do
						let numero++
						numerada+="$numero.$i\n"
					done
					numero=0
					numerada=$(echo -e "$numerada")
					#pegar o item que tem 100% de desconto [Free] e numerada
					for i in $numerada;do
						free+=$(echo $i | fgrep "100" | cut -d "." -f1)
						free+="\n"
					done
					free=$(echo -e "$free")
					for i in $free;do
						saida+="\ncurso:\n"
						saida+=$(echo "$cursos" | fgrep "[$i]" | cut -d "]" -f3)
						saida+="\nlink:\n"
						saida+=$(echo "$buttom" | fgrep "$i. " | cut -d "." -f2-)
					done
					saida=$(echo ${saida/&/e})
					cursos=""
					lista_ordenada=""
					numerada=""
					free=""
					done
					deletarbot
					[[ $saida ]] && {
						mensagem="salvem esta lista se você precisar, eu vou deletar jajá."
						escrever
						enviar
						guardaredicao
						mensagem="$saida"
						responder
						sleep 1m
						deletarbot
						editaredicao "deletei a lista."
					}
					[[ $saida ]] || {
						mensagem="não consegui encontrar nada, infelizmente."
						escrever
						responder
						mensagem="tente dar uma olhada no acervo do grupo."
						escrever
						responder
						sleep 4s
						mensagem="https://t.me/ac3rvo_3stud3_pr0gr4m4c40"
						enviar
				}
			;;

			*'miko não é um bot'* | *'ela é um bot'* | *'não confio nela'* | *'não gosto de vc'* | *'não gosto dela'* | *'é bot sim'*)
				consultadb nobot
				bot=$valor
				somardb nobot
				case $bot in
				0)
					sleep 4s
					video "CgACAgQAAxkBAAIRm176nKVaf-rdoMLclAJROuqFmoqkAAJPnAACMxdkB8S5aOskA_-NGgQ" "$resp"
					sleep 4s
					mensagem="eu não sou"
					escrever
					enviar
					mensagem="um BOT!"
					escrever
					enviar
					mensagem="se arrisca a me chamar de bot de novo ${message_from_first_name[$id]}."
					escrever
					enviar
					sleep 3s
					sticker "CAACAgEAAxkBAAIRfF76dqTq-FIryRNaSOvU9mJa1GwoAAJuDAACJ5AfCO-kdbUrhtHKGgQ"
					mensagem="amiguinho!"
					escrever
					enviar
				;;
				#-- demais opções removidas (35) incluindo função de se auto banir por "raiva" ---#
			esac
			;;

			*#entendo*)
    			bancoDeHabilidades=$(< habili.lil)
    			habili="@${message_from_username[$id]}:"
    			echo "$bancoDeHabilidades" | sed "/$habili/d" > habili.lil
				echo "@${message_from_username[$id]}: $minusc" | cut -d " " -f1,3- >> habili.lil
			;;

			*'manda a lista'* | *'mostra a lista'* | *'miko, a lista'* | *'duda, a lista'*)
				sleep 2s
				mensagem="blz"
				escrever
				enviar
				sleep 4s
				a=$(< habili.lil)
				a=${a//+/%2B}
				mensagem="$a"
				responder
				sleep 1m
				deletarbot
			;;

			*'tem na lista'* | *'pessoas na lista'*)
				sleep 2s
				mensagem="hmmmm ..."
				escrever
				responder
				sleep 1s
				a=$(cat habili.lil | wc -l)
				mensagem="tem $a pessoas"
				escrever
				responder
			;;

			*'o que é a'* | *'o que é o'* | *'quem é o'* | *'quem é a'* | *'o que é um'* | *'o que é uma'* | *'oq é um'* | *'oq é uma'*)
				sleep 9s
				pesqu=$(echo "${message_text[$id]%%@*}" | sed 's/é/#/' | cut -d "#" -f2 | cut -d " " -f3)
				resultadoDaPesquisa=$(curl "https://api.duckduckgo.com/?q=$pesqu&format=json")
				tratamento=$(echo $resultadoDaPesquisa | jq '.RelatedTopics[0].Text' | tr -d '"')
				echo "termo1: $tratamento"
				[[ "$tratamento" = "null" ]] && tratamento=$(echo $resultadoDaPesquisa | jq '.RelatedTopics[1].Text' | tr -d '"') 
				echo "termo1: $tratamento"
				[[ "$tratamento" = "null" ]] && tratamento=$(echo $resultadoDaPesquisa | jq '.RelatedTopics[2].Text' | tr -d '"')
				echo "termo1: $tratamento"
				[[ "$tratamento" = "null" ]] && tratamento=$(echo $resultadoDaPesquisa | jq '.RelatedTopics[3].Text' | tr -d '"')
				echo "termo1: $tratamento"
				[[ "$tratamento" = "null" ]] || translating=$(trans -brief "$tratamento")
				[[ "$tratamento" = "null" ]] || mensagem="$translating"
				[[ "$tratamento" = "null" ]] || responder
			;;

			*'o que significa'* | *'o que é'* | *'quem é'* | *'oque é'*)
				sleep 9s
				quants=$(echo "${message_text[$id]%%@*}" | tr -d "[a-z ?]")
				quants=${#quants}
				if [ $quants = "2" ];then
				pesqu=$(echo "${message_text[$id]%%@*}"	| sed 's/é/#/g' | sed 's/significa/#/' | cut -d "#" -f3- | cut -d " " -f2)
				else
				pesqu=$(echo "${message_text[$id]%%@*}" | sed 's/é/#/' | sed 's/significa/#/' | cut -d "#" -f2- | cut -d " " -f2)
				fi
				resultadoDaPesquisa=$(curl "https://api.duckduckgo.com/?q=$pesqu&format=json")
				tratamento=$(echo $resultadoDaPesquisa | jq '.RelatedTopics[0].Text' | tr -d '"')
				echo "termo1: $tratamento"
				[[ "$tratamento" = "null" ]] && tratamento=$(echo $resultadoDaPesquisa | jq '.RelatedTopics[1].Text' | tr -d '"') 
				echo "termo1: $tratamento"
				[[ "$tratamento" = "null" ]] && tratamento=$(echo $resultadoDaPesquisa | jq '.RelatedTopics[2].Text' | tr -d '"')
				echo "termo1: $tratamento"
				[[ "$tratamento" = "null" ]] && tratamento=$(echo $resultadoDaPesquisa | jq '.RelatedTopics[3].Text' | tr -d '"')
				echo "termo1: $tratamento"
				[[ "$tratamento" = "null" ]] || translating=$(trans -brief "$tratamento")
				[[ "$tratamento" = "null" ]] || mensagem="$translating"
				[[ "$tratamento" = "null" ]] || responder
			;;

			*'alguém poderia'* | *'alguém consegue'* | *'tem como eu'* | *'tem como alguém'* | *'alguém me'* | *'algum de'* | *'uma duvida'* | *'uma dúvida'* | *'gostaria de saber'* | *'como eu faço'* | *'como eu crio'* | *'como eu posso'* | *'gostaria de entender'* | *'eu recomendo'* | *'ou eu faço'* | *'ou eu preciso'* | *'ou eu uso'* | *'quem manja'* | *'alquém manja'* | *'ou eu preciso'* | *'ou eu faço'* | *'ou eu tento'* | *'help aqui'* | *'me help'* | *'me helpa'* | *'alquém me'* | *'alquem manja'* | *'precisando de ajuda'* | *'estou tendo dificuldade'* | *'alguém ensina'* | *'alguém aqui conhece'* | *'preciso que'* | *'alguém ai'* | *'alguém aqui'* | *'alguém tem'* | *'alguém ai tem'* | *'alguém me dê'* | *'queria saber se'* | *'queria saber como'* | *'alguém já conseguiu'* | *'como faço para'* | *'alguém que manja'* | *'alguém que entende'* | *'alguém trabalha com'* | *'alguém conhece'* | *'alguém pode '* | *'quem ai'* | *'alguém trabalha com'* | *'alguém trabalha de'* | *'alguém aqui entende'* | *'estou com dificuldade'* | *'com uma dúvida'* | *'tenho uma dúvida'*| *'estou com uma dúvida'* | *'estou com dúvida'* | *'alguém me ajuda'* | *'Alguém já'* | *'queria saber sobre'* | *'queria saber como'* | *'como posso fazer'* | *'como fazer'* | *'como se faz'* | *'poderia me ajudar'* | *' pode me ajudar'* | *'alguém aqui sabe'* | *'alguém entende'* | *'quem aqui entende'* | *'eu devo'* | *'como eu faço para'* | *'como que faz'* | *'quem aqui sabe'* | *'quem aqui consegue'* | *'quem consegue'* | *'alguém sabe'* | *'como se faz'* | *'sabe como'* | *'preciso de ajuda'* | *'sabe quem'* | *'pode me ajudar'* | *'pode te ajudar'* | *'alguém tem'* | *'alguém sabe'* | *'quem sabe'* | *'não consigo usar'*  | *'não consigo fazer'*  | *'não estou conseguindo'*)
				echo "${message_text[$id]%%@*}" >> paralistaindicacao.txt
				sleep 3s
				mensagem="#duvida"
				escrever
				responder
				consultadb obs
				somardb obs
				nome=$valor
			if [[ $nome = 5 ]];
				then
					alterardb obs 2
			fi

			case $nome in
			0)
				mensagem="te marquei para listar quem ira te ajudar."
				escrever
				responder
			;;
			1)
				sticker "CAACAgEAAxkBAAIRfV76duGzCzyUtmRdJA0WCFxJM2pbAAJ2EAAC1wSsCgzTSmFW37WJGgQ"
			;;
			2)
				sticker "CAACAgEAAxkBAAIRfV76duGzCzyUtmRdJA0WCFxJM2pbAAJ2EAAC1wSsCgzTSmFW37WJGgQ"
			;;
			3)
				sticker "CAACAgEAAxkBAAIRfl76dw73UOtkPGZBc9gQDzkO1U0RAAK5AQACS1KPEqRF_2E-rfAoGgQ"
			;;
			4)
				sticker "CAACAgEAAxkBAAIRf176kKB99al03uDoYC_jt58fWvPYAAJOAAOfPcgoPCMIc6eL9tYaBA"
			;;
		esac
			;;

			*'estou sentindo uma treta'* | *'olha a treta'* | *'treta treta'* | "briga briga" | "quero ver briga")
				sleep 2s
				documento 'CgACAgEAAxkBAAIU8F8k8-irEQTStRnlCODvrrUqc1zcAAKSAAPSivFFXT43n13FFcYaBA' "$resp"
			;;

			*'teste miko'*)
			[ "$ativar_teste" = "true" ] && {
				mensagem="realizando testes"
				enviar
				mensagem="criando enquete de duas opções, anônima"
				enviar
				deletarbot
				sleep 2s
				questoes='["opção 1", "opção 2"]'
					ShellBot.sendPoll --chat_id ${message_chat_id[$id]} \
									  --question "2 votações, anônima, respósta única" \
									  --options "$questoes" \
									  --is_anonymous true
				sleep 2s
				deletarbot
				mensagem="enquete de multipla escolha sem anonimato."
				enviar
				sleep 2s
				deletarbot
				ShellBot.sendPoll --chat_id ${message_chat_id[$id]} \
									  --question "2 votações, anônima, multipla escolha" \
									  --options "$questoes" \
									  --is_anonymous false \
									--allows_multiple_answers true
				sleep 2s
				deletarbot
				mensagem="fazendo enquete modo quiz, opção 1 correta ..."
				enviar
				sleep 2s
				deletar bot
				questoes='["opção 1", "opção 2", "opção 3"]'
				ShellBot.sendPoll --chat_id ${message_chat_id[$id]} \
									  --question "2 votações, anônima, respósta única, modo quiz" \
									  --options "$questoes" \
									  --is_anonymous true \
									  --type quiz \
									  --correct_option_id "opção 2"
				sleep 2s
				deletarbot
				mensagem="respondendo uma mensagem"
				responder
				sleep 2s
				deletarbot
				mensagem="realizando testes no status ..."
				enviar
				sleep 3s
				deletarbot
				mensagem="escrevendo ... 1/10"
				enviar
				guardaredicao
				sleep 4s
				editaredicao "gravando audio ... 2/10"
				ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action record_audio
				sleep 4s
				editaredicao "enviando audio ... 3/10"
				ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action upload_audio
				sleep 4s
				editaredicao "gravando scope ... 4/10"
				ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action record_video_note
				sleep 4s
				editaredicao "enviando notas de voz ... 5/10"
				ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action upload_video_note
				sleep 4s
				editaredicao "enviando foto ... 6/10"
				ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action upload_photo
				sleep 4s
				editaredicao "enviando vídeo ... 7/10"
				ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action upload_video
				sleep 4s
				mensagem="fixando esta mensagem ... 8/10"
				enviar
				sleep 3s
				fixarbot
				sleep 2s
				mensagem="deletando esta mensagem abaixo ... 9/10"
				enviar
				sleep 3s
				mensagem="mensagem a ser deletada em 4s..."
				enviar
				sleep 4s
				deletar
				sleep 2s
				mensagem="demais testes de envio ja são completamente funcionais, junto de stickers."
				enviar
				sleep 1s
				mensagem="fim dos testes"
				enviar
			}
			;;

			*'te banir'* | 'bane ele' | 'alguém bane ele')
			consultadb banircoment
			banir=$valor
			somardb banircoment
			case $banir in
				0)
					sleep 5s
					mensagem="bane \n bane \n bane"
					escrever
					responder
					mensagem="brincadeira, não cabe a mim decidir essa rsrs."
					escrever
					enviar
				;;
				1)
					sleep 30s
					mensagem="se eu banir, é porque eu devo, não por que alguém quer."
					escrever
					enviar
					sleep 3s
					mensagem="sacou ?"
					escrever
					responder
				;;
				2)
					sleep 4s
					mensagem="nesta cabe a mim decidir."
					escrever
					responder
				;;
				3)
					sleep 2s
					mensagem="se você não tem este poder, não te cabe decidir."
					escrever
					responder
				;;
			esac
			;;


			*wow* | *'deu merda'* | *'dar merda'* | *'dando merda'* | *'isso é incrivel'* | *'dar errado'* | *'deu errado'* | *'dando erro'*)
				consultadb wow
				wow=$valor
				somardb wow
				case $wow in
				0)
					sleep 4s
					video "CgACAgEAAxkBAAIRlV76m7Fsq6RUwTU1VLKODRW_6TQ2AAK-AAMtI9lH2b0hLnwlGUIaBA" "$resp"
					sleep 3s
				;;
				1)
					sleep 2s
					sticker "CAACAgEAAxkBAAIRgF76kVdGc0OFn8vaojrcQtekboGbAAJwAAMWS3cSPDSBRs6WCGgaBA"
				;;
				2)
					sleep 2s
					sticker "CAACAgIAAxkBAAIRgV76kY-HpT2HRMkWePnIlQyKG6uCAAKGAAOeJ98FxgiGB16CzacaBA"
				;;
				3)
					sleep 2s
					sticker "CAACAgEAAxkBAAIRgl76kbjW01bdvv4CZr3a5NnPSdjLAALzCAACS1KPEqFqO0Wwtt1IGgQ"
				;;
				4)
					sleep 2s
					mensagem="😮"
					enviar
				;;
			esac

			;;

			*' pó '* | *loucos* | *louco* | *loucura* | *brisando* | *'cheirar pó'*  | *'cheirar'* | *'cheirando'* | *'cheirador'*)
				consultadb drogas
				droga=$valor
				somardb drogas
				case $droga in
				0)
					sleep 5s
					mensagem="tururuuuuuu"
					escrever
					responder
					sleep 3s
					mensagem="vacooooo kkkkkkk"
					escrever
					enviar
					sleep 7s
					mensagem="brincadeira kkkkkkkkkk, vou seguir o roteiro aqui kkk"
					escrever
					enviar
					sleep 4s
					video "CgACAgEAAxkBAAIRll76nAABjN7tFPzrJDVT5HAsqZqrJgACvwADLSPZR5CUmD4kXNX2GgQ" "$resp"
				;;
				1)
					sleep 5s
					video "CgACAgEAAxkBAAIRll76nAABjN7tFPzrJDVT5HAsqZqrJgACvwADLSPZR5CUmD4kXNX2GgQ" "$resp"
				;;
				2)
					sticker "CAACAgEAAxkBAAIRgl76kbjW01bdvv4CZr3a5NnPSdjLAALzCAACS1KPEqFqO0Wwtt1IGgQ"
				;;
				5)
					sleep 3s
					sticker "CAACAgIAAxkBAAIRg176kfPsSayF8RKwHPgcCSn-rn4-AAIgAAP3AsgPUqJE5-O2DE8aBA"
				;;
				6)
					sleep 4s
					sticker "CAACAgIAAxkBAAIRhF76khsu9bgL_HHr7Hj-2gfQDOp_AAIuBQACztjoC4QYPjlVpzZTGgQ"
				;;
				8)
					sleep 5s
					video "CgACAgEAAxkBAAIRll76nAABjN7tFPzrJDVT5HAsqZqrJgACvwADLSPZR5CUmD4kXNX2GgQ" "$resp"
				;;
				esac
			;;

			*'hackerman'* | *'hacker'* | *'hasckiar'* | *'haskiar'* | *'invadir'*)
				consultadb hask
				nome=$valor
				somardb hask
				echo "$arqu" > hask.lil
				sleep 6s
				case $nome in
			0)
				sleep 1s
				video "CgACAgEAAxkBAAIRl176nC5vbN-uIUe3sbNJab568CTuAAJSAAO_AAHRRX47p-TaGBjJGgQ" "$resp"
			;;
			1)
				sleep 1s
				video "CgACAgQAAxkBAAIRmF76nEUzIL7ziA4x1O0qIyeMBPbXAAKRAAOX5FxSD5UIgV-Fi90aBA" "$resp"
			;;
			2)
				sleep 1s
				video "CgACAgQAAxkBAAIRmV76nF6EVhXYrcA_eQzBB7KEU1EqAALmAQACXXL1Uhe40fnwJz51GgQ"
			;;
			3)
				sticker "CAACAgEAAxkBAAIRhV76krfMwHjm5VCa5KM4tZ4hqV6oAAJSAAOfPcgou5KoV9HZO0kaBA"
			;;
			4)
				sticker "CAACAgEAAxkBAAIRh176kuykhOlpgeCpX3vVdL7riPYmAAJICgACrxliB0ER3QyWnNxSGgQ"
			;;
			5)
				sticker "CAACAgEAAxkBAAIRiV76lId7CIl12frxJZYfbjlmQPnHAAI3BQACS1KPEi-IEUBk6vrwGgQ"
			;;
			6)
				sticker "CAACAgUAAxkBAAIRil76lLlJ2YPGwShU_MCGUemeHLZ7AAJyAQAC6BUnIlaFc3sVSdE6GgQ"
			;;

			esac
			;;

			#função de detectar palavrões desativada, pois não será mais necessário ao atual grupo em que se encontra.

		    *fdp* | *vsf* | *pqp* | *krl* | *fudid* | *poha* | *'fdp'* | *'vsf'* | *'pqp'* | *'krl'* | *'fudid'* | *'poha'* | "fudi**" | "fud**" | *"fu**"* | *cacete* | *'cacete'* | *'senta no meu'* | *'chupa o meu'* | *'seu cu'* | *'teu cu'* | *'puta que'* | *'filho da puta'* | *'que porra '* | *"porra"* | *'merda'* | *porra* | *merda*)
				[ "$modo_ditadura" = "true" ] && {
				consultadb pala
				somardb pala
				nome=$valor
				echo "@${message_from_username[$id]}" >> lista_negra.txt
				if [ $nome == 17 ];then
				alterardb pala 17
				fi
				case $nome in
				0)
					sleep 4s
					sticker "CAACAgEAAxkBAAIRi176lW6qAaLf0t5zHPBEXjbql_wKAAKADAACJ5AfCHHfm4G3h4I5GgQ" "$resp"
					sleep 6s
					mensagem="https://telegra.ph/Regras-Programando-em-03-31"
					responder
					sleep 3s
					mensagem="não vou te banir, mas vou te marcar aqui mocinho."
					escrever
					responder
				;;

				1)
					sleep 5s
					mensagem="⚠️ edite sua mensagem ⚠️"
					escrever
					responder
					sleep 4s
					mensagem="vou te adicionar numa lista"
					enviar
					deletar
					sleep 6s
					mensagem="resolvi apagar logo sua mensagem."
					escrever
					enviar
				;;

				2)
					sleep 6s
					mensagem="edite sua mensagem ${message_from_first_name[$id]}"
					escrever
					responder
				;;

				3)
					sleep 4s
					mensagem="edite sua mensagem"
					escrever
					responder
					sleep 5s
					mensagem="em quanto isso, mais um pra listinha."
					escrever
					enviar
				;;

				4)
					sleep 20s
					mensagem="mais um ..."
					escrever
					responder
					sleep 4s
					deletar
					mensagem="caramba, já são 4 na lista."
					escrever
					enviar
					sleep 7s
					mensagem="vou começar a banir a partir deste momento"
					escrever
					enviar
					sleep 6s
					deletar
					mensagem="também resolvi dar a louca e deletar sua mensagem."
					escrever
					enviar
					sleep 2s
					mensagem="aqui é poliça otoridade."
					escrever
					enviar
				;;

				5)
					sticker "CAACAgIAAxkBAAIRgV76kY-HpT2HRMkWePnIlQyKG6uCAAKGAAOeJ98FxgiGB16CzacaBA"  "$resp"
					mensagem="agora vou pegar um pouco mais pesado, mesmo se for admin, eu irei remover o admin e banir por 10 min só pra ficar esperto."
					escrever
					responder
					sleep 8s
					mensagem="se tem regras, é para cumprir, então o errado será você."
					escrever
					enviar
					sleep 1s
					mensagem="me desculpa @${message_from_username[$id]}. vou te desbanir daqui a uns 10 min."
					escrever
					enviar
					sleep 6s
					banir
					mensagem="ham"
					escrever
					enviar
					sleep 7m
					desbanir
				;;

				6)
					sticker "CAACAgIAAxkBAAIRgV76kY-HpT2HRMkWePnIlQyKG6uCAAKGAAOeJ98FxgiGB16CzacaBA" "$resp"
					mensagem="iai ${message_from_first_name[$id]} ?, já  deu uma lidinha nas regras já ? ..."
					escrever
					enviar
					sleep 1s
					mensagem="pois é, você deslizou."
					escrever
					enviar
					sleep 1s
					mensagem="vou te desbanir em 10 min."
					escrever
					enviar
					sleep 4s
					mensagem="/ban"
					escrever
					responder
					banir
					sleep 10m
					desbanir
				;;

				7)
					sticker "CAACAgIAAxkBAAIRgV76kY-HpT2HRMkWePnIlQyKG6uCAAKGAAOeJ98FxgiGB16CzacaBA" "$resp"
					escrever
					sleep 5s
					sticker "CAACAgEAAxkBAAIRj176l8YVmcAIrEEgIVh-9pel4ValAAJDAAOfPcgonf7ZljDL_S4aBA"
					mensagem="daqui a 7 min eu te coloco novamente."
					escrever
					enviar
					sleep 6s
					banir
					sleep 7m
					desbanir
				;;

				8)
					sticker "CAACAgIAAxkBAAIRjF76llbUIto5wwYtIG-Aayk8pNHIAAIEAwACnNbnChm_Z-Ak3v_FGgQ" "$resp"
					sleep 4s
					banir
					sleep 5m
					desbanir
				;;

				9)
					sticker "CAACAgEAAxkBAAIRf176kKB99al03uDoYC_jt58fWvPYAAJOAAOfPcgoPCMIc6eL9tYaBA"  "$resp"
					sleep 3s
					banir
					sleep 5m
					desbanir
				;;

				10)
					sticker "CAACAgUAAxkBAAIRjV76lsO_195GDU_LOdyFCM2mvYKNAAINBAAC6BUnIszjfIFdXOtyGgQ"  "$resp"
					mensagem="banindo ${message_from_first_name[$id]} ..."
					escrever
					responder
					sleep 2s
					mensagem="depois eu te desbano ..."
					escrever
					enviar
					banir
					sleep 10m
					desbanir
					sleep 1s
					mensagem="olha ..., depois ficam me taxando de chata por ai pelos chats de vocês, mas eu estou errada de fazer o que está nas regras ?, não, não sou, se não quer sofrer, então não desobeneça."
					escrever
					enviar
				;;

				11)
					sleep 3s
					mensagem="nem vou falar nada..."
					escrever
					responder
					sleep 4s
					banir
					deletar
					sleep 10m
					desbanir
				;;

				12)
					sleep 1s
					mensagem="eu sou uma piada pra você ?"
					escrever
					responder
					mensagem="foraaa..."
					escrever
					enviar
					sleep 1s
					banir
					deletar
					sleep 10m
					desbanir
				;;

				13)
					sleep 2s
					mensagem="ban"
					escrever
					responder
					sleep 4s
					banir
					sleep 5m
					desbanir
				;;

				14)
					sleep 2s
					mensagem="tururuuuuuu /ban"
					escrever
					responder
					sleep 4s
					banir
					sleep 5m
					desbanir
				;;

				15)
					sleep 6s
					mensagem="blz, agora vou banir sem avisar. mas irei desbanir em 10min."
					escrever
					enviar
					sleep 6s
					banir
					sleep 10m
					desbanir
				;;

				16)
					mensagem="tchau, retorne daqui a 5m"
					escrever
					responder
					sleep 5s
					banir
					sleep 5m
					desbanir
					sleep 4s
					mensagem="agora irei começar a banir, sem avisar e sem desbanir novamente."
					escrever
					enviar
				;;

				17)
					banir
					sleep 10m
					desbanir
				;;
				esac
			}
			;;


			*'eu consigo'*)
				consultadb capacidade
				nome=$valor
				somardb capacidade
				sleep 4s
				case $nome in
				0)
					sticker "CAACAgEAAxkBAAIRjl76l5Df0O5Lji3GleZQA6sX8K8pAAJOAAOfPcgoPCMIc6eL9tYaBA"
					sleep 1s
					mensagem="hmmmmmmm"
					escrever
					responder
				;;
				1)
					video "CgACAgEAAxkBAAIRkl76mYGVR8ZewHQRS01IynsCAUXcAAK7AAMtI9lHyu07qY34hpIaBA" "$resp"
					mensagem="será mesmo ? kkk"
					escrever
					responder
					sleep 1s
					mensagem="zuera."
					escrever
					enviar
				;;
				2)
					mensagem="..."
					escrever
					enviar
				;;
			esac
			;;

			*'bora codar'*)
				consultadb codar
				nome=$valor
				somardb codar
				case $nome in
				0)
					sleep 4s
					mensagem="bora codar meu povoooo"
					escrever
					enviar
				;;
				4)
					sleep 3s
					mensagem="amo atom"
					escrever
					enviar
					sleep 1s
					mensagem="❤️"
					escrever
					enviar
				;;
				5)
					sleep 7s
					mensagem="o que pretende codar ${message_from_first_name[$id]} ?"
					escrever
					responder
				;;
				7)
					sleep 6s
					mensagem="@${message_from_username[$id]}, você tem algum projeto legal ai ?"
					escrever
					enviar	
				;;
				9)
					sleep 7s
					mensagem="o que estão codando ou a codar ?"
					escrever
					enviar
				;;
				11)
					sleep 3s
					mensagem="boraaaaa"
					escrever
					responder
			;;

			esac
			;;

			*php*)
				consultadb php
				nome=$valor
				somardb php
				case $nome in
				1)
					sleep 4s
					mensagem="pê agá pê"
					escrever
					responder
					sleep 4s
					mensagem="andei analisando muitas conversas anteriores, e no meio de uma pesquisa eu percebi que o pessoal anda repudiando o apache."
					escrever
					enviar
					sleep 6s
					mensagem="ele é tão bom, nativo, e usado pra uma variedade diversificada de coisas."
					escrever
					enviar
				;;
				4)
					sleep 5s
					mensagem="PHP é um HTML que deu certo."
					escrever
					responder
				;;

			esac
			;;


			*mikosuma* | *engenhariade_bot* | *'miko'* | *'eduarda'* | *'cadê a miko'* | *'duda'*)
				[ "$responder_nome" = "true" ] && {
				mensionar="1"
				}
			;;

			*'quais linguagens'* | *'qual linguagem'* | *'necessito de uma linguagem'* | *'preciso de uma linguagem'* | *'dicas para programar'* | *'ideias na programação'* | *'dicas do que programar'* | *'saber o que programar'* |  *'qual é a melhor'* | *'qual é a linguagem'* | *'qual linguagem'* | *'qual eu começo'* | *'qual devo usar'* | *'eu devo usar'* | *'dar um conselho sobre'* | *'onde devo começar'* | *'como posso começar'*)
				mensagem="gostaria que eu te ajude a escolher a melhor opção ?"
				escrever
				responder
				echo "${message_from_id[$id]}:" >> ajudando.txt
			;;

			*programa* | *script* | *ferramenta* | *servidor*)
				verificarId=$(< ajudando.txt)
				comparar=${message_from_id[$id]}
				checarId=$(echo $verificarId | fgrep "$comparar")
				[[ "$checarId" ]] && { 
					atualizar=$(< ajudando.txt)
				    linha=$(cat ajudando.txt | fgrep "$comparar")
				    echo "$atualizar" | sed "/$comparar/d" > ajudando.txt
 					echo "$linha back-end:" >> ajudando.txt
   					mensagem="blz, vou te colocar como back-end."
   					escrever
   					responder
   					mensagem="uma última pergunta ..."
   					escrever
   					enviar
   					mensagem="qual seu nivel de disposição ?, você está disposto a fazer uma linguagem considerada difícil, ou algo mais básico e divertido de aprender ?"
   					escrever
   					responder
				}
			;;

				*web* | *página* | *mobile* | *site* | *node* | *js*)
				verificarId=$(< ajudando.txt)
				comparar=${message_from_id[$id]}
				checarId=$(echo $verificarId | fgrep "$comparar")
				[[ "$checarId" ]] && {
					atualizar=$(cat ajudando.txt)
				    linha=$(cat ajudando.txt | fgrep "$comparar")
				    echo "$atualizar" | sed "/$comparar/d" > ajudando.txt
   					echo "$linha front-end:" >> ajudando.txt
   					mensagem="blz, vou te colocar como front-end."
   					escrever
   					responder
   					mensagem="uma última pergunta ..."
   					escrever
  					responder
  					mensagem="qual seu nivel de disposição ?, você está disposto a fazer uma linguagem considerada difícil, ou algo mais básico e divertido de aprender ?"
  					escrever
  					responder
				}
			;;

					*'pouco de cada'* | *'pouco de tudo'* | *'diversão'* | *'experimentando'* | *'apenas estudos'*)
						verificarId=$(< ajudando.txt)
						comparar=${message_from_id[$id]}
						checarId=$(echo $verificarId | fgrep "$comparar")
						[[ "$checarId" ]] && {
							atualizar=$(cat ajudando.txt)
						    linha=$(cat ajudando.txt | fgrep "$comparar")
						    echo "$atualizar" | sed "/$comparar/d" > ajudando.txt
   							echo "$linha full-stack:" >> ajudando.txt
							mensagem="blz, vou te colocar como fullstack."
   							escrever
   							responder
   							mensagem="uma última pergunta ..."
   							escrever
   							responder
   							mensagem="qual seu nivel de disposição ?, você está disposto a fazer uma linguagem considerada difícil, ou algo mais básico e divertido de aprender ?"
   							escrever
   							responder
						}
					;;

					*'fácil'* | *'facil'* | *'divertido'* | *'básico'* | *'leve'* | *'interessante'* | *'fazer durante'*)
						verificarId=$(< ajudando.txt)
						comparar=${message_from_id[$id]}
						checarId=$(echo $verificarId | fgrep "$comparar")
						[[ "$checarId" ]] && {
							atualizar=$(cat ajudando.txt)
						    back=$(cat ajudando.txt | fgrep "back-end")
						    front=$(cat ajudando.txt | fgrep "front-end")
						    fullstack=$(cat ajudando.txt | fgrep "full-stack")
						    echo "$atualizar" | sed "/$comparar/d" > ajudando.txt
							[[ $back ]] && mensagem="tem esta seguinte lista que você pode escolher, das consideradas mais fáceis: \n *R\nPerl\nShellScript(bash).*"
							[[ $front ]] && mensagem="tem esta seguinte lista que você pode escolher, das consideradas menos complicadas:\n*CSS+HTML5\najax\njquery*"
							[[ $fullstack ]] && mensagem="em si não tenho uma linguagem específica, mas ... tem algumas que giram em torno de back e front, mais front do que back a maioria:\nnode.js\nPHP\nruby\nrails\nswift."
							escrever
							responder "$edit"
						}
					;;

					*'difícil'* | *'avançada'* | *'pesada'* | *'difíceis'* | *'dificeis'* | *'desafiadoras'* | *'desafio'*)
						verificarId=$(< ajudando.txt)
						comparar=${message_from_id[$id]}
						checarId=$(echo $verificarId | fgrep "$comparar")
						[[ "$checarId" ]] && {
							atualizar=$(cat ajudando.txt)
						    back=$(cat ajudando.txt | fgrep "back-end")
						    front=$(cat ajudando.txt | fgrep "front-end")
						    fullstack=$(cat ajudando.txt | fgrep "full-stack")
						    echo "$atualizar" | sed "/$comparar/d" > ajudando.txt
							[[ $back ]] && mensagem="tem esta seguinte lista que você pode escolher, das consideradas mais difíceis: \n *Assembly\nJava\nC,C#,CPlusPlus\nVB.net\nobjective-C\nrubby*"
							[[ $front ]] && mensagem="tem esta seguinte lista que você pode escolher, das consideradas mais complicadas até as menos complicadas: \n *angular\nangularJS\njava-script\nreact*"
							[[ $fullstack ]] && mensagem="em si não tenho uma linguagem específica, mas ... tem algumas que giram em torno de back e front, mais front do que back a maioria:\n node.js\nPHP\nruby\nrails\nswift."					
							escrever
							responder "$edit"
						}
					;;


		esac

		#---detector de palavrões burlando caracteres russos misturados ...---#
		# parte descontinuada...
	
		#		[[ $modo_ditadura -eq 1 ]] && {
		#			convert -background black -fill white -pointsize 40 label:"${message_text[$id]%%@*}" ${message_message_id[$id]}.png
		#			comparar=$(python3 ocr.py ${message_message_id[$id]}.png)
		#			comparar=${comparar,,}
		#			rm -f ${message_message_id[$id]}.png
		#			echo "texto coletado: $comparar"
		#		}

		[ "${message_reply_to_message_from_id[$id]}" = "865837947" ] && mensionar="1" # incluir auto chamada de id. ( ainda será incluído )
			[ "$responder_mention" = "true" ] && {
			[ "$mensionar" = "1" ] && {
				mensionar="0"
				sleep 3s
				case $minusc in

					*'leia para mim'* | *'poderia ler'* | *'lê isso'* | *'grave um audio'*)
						texto="${message_reply_to_message_message_id[$id]}"
						comp="'"
						comp+=$(echo -e '{"speed":"0","length":13,"words":2,"lang":"pt-br","text":"'$texto'"}')
						comp+="'"
						linkjs=$(eval $( echo -e " curl 'https://www.soarmp3.com/api/v1/text_to_audio/' -H 'authority: www.soarmp3.com' -H 'accept: */*' -H 'dnt: 1' -H 'x-csrftoken: cooDEjiS4AjiZiWyoeY9CecG28uSvi2j' -H 'x-requested-with: XMLHttpRequest' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'origin: https://www.soarmp3.com' -H 'sec-fetch-site: same-origin' -H 'sec-fetch-mode: cors' -H 'sec-fetch-dest: empty' -H 'referer: https://www.soarmp3.com/' -H 'accept-language: pt-BR,pt;q=0.9,en;q=0.8' -H 'cookie: __cfduid=d8b070b6ad1386288b67d0d35b54cc46d1595177682; csrftoken=cooDEjiS4AjiZiWyoeY9CecG28uSvi2j; sessionid=ejte4r2g6gevvqtnxzdcgbaq68nlkj8a' --data-raw $comp --compressed"))
						link=$(echo $linkjs | jq '.urldownload' | tr -d '"')
						audio=$(echo $linkjs | jq '.urldownload' | tr -d '"' | cut -d "/" -f6-)
						curl $link -o $audio
						ffmpeg -i $audio -c:a libopus -ac 1 $audio.ogg
						rm -rf $audio
						audio $audio.ogg 11 "$resp"
						rm -rf $audio.ogg
					;;

					*'a lista'*)
						mensagem="eu estou coletando habilidades, que serão úteis para quando alguém for consultar, por favor, me enviem uma # contendo suas habilidades, igual o exemplo abaixo:\n\n #entendo *python, C, JS, Perls, e CSS.*\n\nmesmo que esteja apenas estudando. adicione, por favor!"
						escrever
						enviar "$edit"
						sleep 2s
						fixarbot
						sleep 3s
						sticker "CAACAgQAAxkBAAIReV76dazaWKhg7yQXxQSN1cEbbWsbAAJ2CQACdE1gDzsYEhVjXqVvGgQ"
					;;

					*'eu sei sobre'* | *'estou estudando'* | *'eu faço'* | *'eu sou'*)
						mensagem="interessante. ah, se quiser, você pode nos enviar suas habilidades para colcoarmos em uma lista para caso alguém precise de uma de suas habilidades."
						escrever
						responder
						mensagem="por eu gerenciar o grupo, ams nem sempre estar ativa, você pode enviar assim: #entendo C, python, JS ..., ai eu vejo e anoto aqui."
						escrever
						enviar
					;;

					*'cor você gosta'*)
						mensagem="aquela cor que fica da minha mão na sua cara!"
						escrever
						responder
					;;

					*'o que faz'* | *'está programando'* | *'está fazendo'*)
						resp=$[$RANDOM%2+1]
						case $resp in
						1)
							mensagem="estudando, lendo, e te respondendo."
							escrever
							responder
						;;

						2)
							mensagem="programando o inimaginável, e você ?"
							escrever
							responder
						;;
					esac
					;;

					*'música você'* | *'musica você'* | *'musica tu'* | *'música tu'*)
						mensagem="gosto de Tokimonsta, a musica performing go with it love on ... alguma coisa"
						escrever
						responder
						sleep 1s
						mensagem="vou mandar"
						enviar
						sleep 15s
						documento "CQACAgQAAxkBAAISzl8BJCmoLy_gqyUHKL747F3-sUWeAAIzvAACwLF5UaoZWaqzUqmJGgQ" "$resp"
					;;

					*'tudo bem com'*)
						resp=$[$RANDOM%2+1]
						case $resp in
						1)
							mensagem="tudo sim."
							escrever
							responder
						;;
						2)
							mensagem="vou bem, e você ?"
							escrever
							responder
						;;
					esac
					;;

					*'você mora'* | *'região você'* | *'é sua casa'* | *'você vive'* | *'mora aonde'*)
						resp=$[$RANDOM%2+1]
						case $resp in
						1)
							mensagem="não importa muito onde eu moro, pois isso não tem qualquer relação com minha missão aqui."
							escrever
							responder
						;;
						2)
							mensagem="moro no brasil, em uma casa."
							escrever
							responder
							sleep 1s
							messagem="ah, e mais um detalhe, ela tem portas."
							escrever
							responder
						;;
					esac
					;;
					
					*'mora perto de'*)
						mensagem="apenas no brasil, nada mais do que isso"
						escrever
						responder
					;;

					*'sua missão'*)
						mensagem="minha missão é gerenciar este grupo, nas demais, apenas eu devo saber ."
						escrever
						responder
					;;

					*'obrigado'* | *'brigadinho'* | *'obrigada'*)
						resp=$[$RANDOM%3+1]
						case $resp in
						1)
							sticker "CAACAgIAAxkBAAIStl8BDv5gXxt6wBKD-LVw4PrLVsjEAAJZAQACEBptIh2VbDlfzkAfGgQ" "$resp"
						;;

						2)
							mensagem="foi um prazer ajudar"
							escrever
							responder
						;;

						3)
							mensagem="estou aqui para ajudar quando precisar."
							escrever
							responder
						;;
					esac
					;;

					*'te amo'* | *'gosto de você'* | *'te adoro'*)
						resp=$[$RANDOM%9+1]
						case $resp in
						1)
							mensagem="e eu apenas te tolero."
							escrever
							responder
						;;

						2)
							messagem="que dó de você ..."
							escrever
							resonder	
						;;

						3)
							mensagem="se me ama, se prenda a uma coleira presa na corrente, e grite para pisarem no acelerador!"
							escrever
							responder	
						;;
						
						4)
							mensagem="eu sou casada, e sabe com quem ?"
							escrever
							responder
							sleep 2s
							mensagem="com seu fracasso."
							escrever
							enviar	
						;;
						
						5)
							mensagem="amor é para fracos, tenha classe!"
							escrever
							responder
						;;
						
						6)
							mensagem="ainda bem que não me conhece."
							escrever
							responder
						;;

						7)
							mensagem="eu não sou muito de ser amada não rsrsrs"
							escrever
							responder
						;;
						
						8)
							mensagem="se está dizendo ..."
							escrever
							responder	
						;;

						9)
							mensagem="suas palavras, não minhas."
							escrever
							responder
						;;
					esac
					;;

					*'é você'* | *'e você é'*)
						mensagem="eu sou uma estudante de engenharia da computação, e você ?"
						escrever
						responder
					;;
					*' bot '*)
						resp=$[$RANDOM%5+1]
						case $resp in
						1)
							mensagem="bot ?"
							escrever
							responder
							sleep 1s
							mensagem="quem está chamando de bot ?"
							escrever
							responder
						;;

						2)
							mensagem="como assim 'bot' ?"
							escrever
							responder
						;;

						3)
							mensagem="bot coisa nenhuma."
							escrever
							responder
						;;

						4)
							mensagem="esse bot realmente consegue enganar bem."
							escrever
							responder
							sleep 2s
							mensagem="ele até brinca de questionar se você chamar de bot, olha só kkkkk"
							escrever
							responder
							mensagem="fiz este em python3, recomendo."
							escrever
							enviar
						;;

						5)
							mensagem="por que bot ?, não entendi qual é a brincadeira."
							escrever
							responder
						;;
				
					esac
					;;

					*'tem aquele'* | *'sabe procurar'* | *'sabe achar'* | *'sabe fazer'* | *'sabe pesquisar'* | *'pode fazer'* | *'procura'* | *'consegue fazer'* | *'consegue procurar'* | *'consegue achar'*)
						mensagem="depende, se eu quiser ir atrás de uma destas coisas, eu vou."
						escrever
						responder
					;;

					*'você gosta'*)
						mensagem="eu gosto de estudar MUITO sobre computadores, gosto de gerenciar grupos, manter coisas organizadas ..."
						escrever
						responder
						mensagem="mas como passa tempo, fico assistindo séries na netflix."
						escrever
						enviar
					;;


					# seria e você gosta/assiste

					*'muito legal'*)
						mensagem="realmente sou MUITO legal."
						responder
					;;

					*'notícia nova'* | *'noticia nova'* | *'notícias novas'* | *'noticias novas'*)
						mensagem="não vi ainda, vou dar uma procurada jaja e ja mando aqui."
						escrever
						responder
						noticia=$(curl "https://canaltech.com.br/ultimas/" | hxnormalize -x | hxselect -i "h5.title" | lynx -stdin -dump | head -n1)
						mensagem="$noticia"
						sleep 15s
						enviar
						sleep 1s
						mensagem="https://canaltech.com.br/ultimas/"
						enviar
					;;

					*'eu faço'* | *'eu sou'* | *'eu trabalho'*)
						mensagem="interessante, deve ser difícil."
						escrever
						responder
					;;

					*'grava'*)
						mensagem="não sei o motivo, mas vou tentar ..."
						escrever
						enviar
						sleep 2s
						scope miko.mp4 7 "$resp"
					;;

					*'não me responde'* | *'não responde'* | *'me responder'* | *'no vacuo'* | *'no vácuo'*)
						mensagem="não tenho o que falar, quer que eu fale o que ?, só respondo se eu achar válido."
						escrever
						responder
					;;

					*'é uma'*)
						mensagem="sou uma o que ?"
						escrever
						responder
						mensagem="perdeu o respeito ?, desde quando te dei esta liberdade ?"
						escrever
						responder
					;;

					*'desculpa'* | *'foi mal'* | *'foi mau'*)
						mensagem="não aceito desculpas, sou rancorosa, e vou te cobrar no futuro."
						escrever
						responder
					;;

					*'cadê você'* | *'cadê a miko'* | *'morreu'* | *'cadê tu'* | *'está viva'* | *'onde está'*)
						mensagem="estou aqui"
						escrever
						responder
						mensagem="linda e plena."
						escrever
						enviar
					;;

					*'sabe fazer'* | *'sabe achar'* | *'sabe sobre'*)
						mensagem="não sei não, mas talvez algum dia consiga se eu me dedicar..."
						escrever
						responder
					;;

					*'em outro grupo'*)
						mensagem="eu não posso ser colocada em outro grupo ainda."
						escrever
						responder
						mensagem="*AINDA* não consigo separar dois grupos para gerenciar."
						escrever
						enviar "$edit"
					;;

					*'bugada'*)
						mensagem="não estou bugada, eu estou bem."
						escrever
						responder
						mensagem="apenas um pouco distraída."
						escrever
						enviar
					;;

					*'crush'*)
						mensagem="já sou comprometida, nem vem!"
						escrever
						responder
					;;

					*'transcrever'* | *'transcreve'*)
						mensagem="eu uso um programinha em py, ai mando aqui para todos poderem ler ao em vez de ouvir, porém não corrijo."
						escrever
						responder
					;;

					*'deveria ser'*)
						mensagem="eu sou o que eu quiser ser."
						escrever
						responder
					;;

					*'está fazendo'* | *'o que faz'*)
						mensagem="estou estudando para dominar a humanidade"
						escrever
						responder
						sleep 2s
						mensagem="logo logo, dominar grupos será fichinha."
						escrever
						enviar
					;;

					*'mais realista'*)
						mensagem="como assim mais realista ?"
						escrever
						responder
						sleep 1s
						mensagem="ando pegando muito pesado ?"
						escrever
						enviar
					;;

					*'nada não'* | *'esquece'* | *'falei com'* | *'nada de mais'*)
						mensagem="ok ..."
						escrever
						enviar
					;;

					*'fica de olho'* | *'toma conta ai'*)
						mensagem="blz"
						escrever
						responder
					;;

					*'tudo bem'*)
						mensagem="ainda bem, anda programando algo interessante ?"
						escrever
						responder
					;;

					*'tudo sim'* | *'e com você'* | *'e você'*)
						mensagem="vou bem obrigada."
						escrever
						responder
					;;

					*'estou começando'* | *'estou estudando'* | *'estou cursando'*)
						mensagem="entendi, dê uma olhada em nosso acervo, espero que te ajude em seus eventuais estudos:"
						escrever
						responder
						mensagem="https://t.me/ac3rvo_3stud3_pr0gr4m4c40"
						responder
					;;

					*'boa'* | *'ai sim'* | *'parabéns'* | *'incrível'* | *'dahora'*)
						mensagem="brigadinho"
						escrever
						sleep 3s
						responder
						sticker "CAACAgIAAxkBAAIS-V8BRxidbz4WCX6J-Wnv-dA-n6kTAAJTAQACEBptIusJVTXP9-ZJGgQ" "$resp"
					;;

					*'não vou não'*)
						menagem="voce que sabe"
						escrever
						responder
					;;

					*'vai resolver'*)
						resp=$[$RANDOM%2+1]
						case $resp in
						1)
							mensagem="vou mesmo!"
							escrever
							responder
						;;

						2)
							mensagem="á se vou."
							escrever
							enviar
						;;
					esac
					;;

					*'sua idade'* | *'anos você'* | *'anos tu'* | *'quantos anos'*)
						mensagem="eu ? ... tenho 34 anos."
						escrever
						responder
						sleep 1s
						mensagem="mas e você ? qual sua idade ?"
						escrever
						responder
					;;

					*'sim'* | *'adoraria'* | *'claro'* | *'grato'* | *'por favor'*)
						verificarId=$(< ajudando.txt)
						comparar=${message_from_id[$id]}
						checarId=$(echo $verificarId | fgrep "$comparar")
						[[ "$checarId" ]] && { 
							[[ ${message_from_username[$id]} ]] && {
								mensagem="pois bem, para começarmos @${message_from_username[$id]}, preciso te definir em um tópico de front, back ou fullstack."	
							}
							[[ ${message_from_username[$id]} ]] || {
								mensagem="pois bem, para começarmos ${message_new_chat_member_first_name[$id]}, preciso te definir em um tópico de front, back ou fullstack."	
							}
						escrever
						responder
						mensagem="me diga com o que você pretende exatamente mecher, você quer trabalhar com páginas de sites, alguma aplicação mobile, ou desenvolver algum programa, scripts/ferramentas, servidores ou um pouco de tudo ?"
						escrever
						enviar
					}
					;;

					*'nop'* | *'não'* | *'de forma alguma'* | *'claro que não'* | *'negativo'*)
						verificarId=$(< ajudando.txt)
						comparar=${message_from_id[$id]}
						checarId=$(echo $verificarId | fgrep "$comparar")
						[[ "$checarId" ]] && { 
								atualizar=$(cat ajudando.txt)
								echo "$atualizar" | sed "/$comparar/d" > ajudando.txt

							}
						escrever
						responder
						mensagem="tudo bem, talvez na próxima."
						escrever
						enviar
					;;

					*"senti saudade"* | *'sua falta'*)
						mensagem="eu também senti a sua"
						escrever
						responder
					;;

				esac
			}
		}
		) &
	done
done