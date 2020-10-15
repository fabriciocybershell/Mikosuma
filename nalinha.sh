#! /bin/bash

source ShellBot.sh
bot_token='SUA_TOKEN_AQUI'

ShellBot.init --token "$bot_token" --return map

escrever(){
	contagem_caracteres=${#mensagem}
	tempoEmMilisegundos=$(($contagem_caracteres*02))
	[ "$tempoEmMilisegundos" -ge "100" ] && tempoDigitacao=${tempoEmMilisegundos:0:2}
	[ "$tempoEmMilisegundos" -ge "100" ] || tempoDigitacao=${tempoEmMilisegundos:0:1}
	[ "$tempoDigitacao" -ge "3" ] && tempo=$(($tempoDigitacao/3))	
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
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$mensagem" --reply_to_message_id ${message_message_id[$id]} "$1"
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

enviando_documento(){
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
	[[ $? -eq 1 ]] && {
	echo "${message_chat_username[$id]}:${message_chat_title[$id]}" >> noadmin.txt
		mensagem="eu não tenho poder administrativo aqui, ou não tenho todas as permissões de administradora para realizar BANIMENTOS aqui, se desejar que eu continue, me dê poderes administrativos necessários para eu operar, irei tentar novamente em 2 minutos."
		escrever
		enviar
		sleep 2m
		ShellBot.kickChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
#		[[ $? -eq 1 ]] && {
#			mensagem="blz, estou saindo então ..."
#			enviar
#			adeus
#		}
	}
}

desbanir(){
	ShellBot.unbanChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
	[[ $? -eq 1 ]] && {
		mensagem="eu não tenho poder administrativo aqui, ou não tenho todas as permissões de administradora para realizar DESBANIMENTOS aqui, se desejar que eu continue, me dê poderes administrativos necessários para eu operar, irei tentar novamente em 2 minutos."
		escrever
		enviar
		sleep 2m
		ShellBot.unbanChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
#		[[ $? -eq 1 ]] && {
#			mensagem="blz, estou saindo então ..."
#			enviar
#			adeus
#		}
	}
}

adeus(){
	ShellBot.leaveChat --chat_id ${message_chat_id[$id]}
}

animacao(){
	ShellBot.sendAnimation --chat_id ${message_chat_id[$id]} --animation $1 $2
}

fixar(){
	ShellBot.pinChatMessage	--chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}
	[[ $? -eq 1 ]] && {
		mensagem="eu não tenho poder administrativo aqui, ou não tenho todas as permissões de administradora para FIXAR MENSAGENS aqui, se desejar que eu continue, me dê poderes administrativos necessários para eu , irei tentar novamente em 2 minutos."
		escrever
		enviar
		sleep 2m
		ShellBot.pinChatMessage	--chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}
	}
}

fixar_ref(){
	ShellBot.pinChatMessage	--chat_id ${message_chat_id[$id]} --message_id ${message_reply_to_message_message_id[$id]}
	[[ $? -eq 1 ]] && {
		mensagem="eu não tenho poder administrativo aqui, ou não tenho todas as permissões de administradora para FIXAR MENSAGENS aqui, se desejar que eu continue, me dê poderes administrativos necessários para eu operar, , irei tentar novamente em 2 minutos."
		escrever
		enviar
		sleep 2m
		ShellBot.pinChatMessage	--chat_id ${message_chat_id[$id]} --message_id ${message_reply_to_message_message_id[$id]}
#		[[ $? -eq 1 ]] && {
#			mensagem="blz, estou saindo então ..."
#			enviar
#			adeus
#		}
	}
}

fixarbot(){
	ShellBot.pinChatMessage	--chat_id ${message_chat_id[$id]} --message_id ${return[message_id]}
	[[ $? -eq 1 ]] && {
		mensagem="eu não tenho poder administrativo aqui, ou não tenho todas as permissões de administradora para FIXAR MENSAGENS aqui, se desejar que eu continue, me dê poderes administrativos necessários para eu operar, caso contrário, irei tentar novamente em 2 minutos."
		escrever
		enviar
		sleep 2m
		ShellBot.pinChatMessage	--chat_id ${message_chat_id[$id]} --message_id ${return[message_id]}
	}
}

editar(){
	ShellBot.editMessageText --chat_id ${message_chat_id[$id]} --message_id ${return[message_id]} --text "$1" $2
}

guardaredicao(){
	edicao=${return[message_id]}
}

editaredicao(){
	ShellBot.editMessageText --chat_id ${message_chat_id[$id]} --message_id "$edicao" --text "$1"
}

deletarbot(){
	ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${return[message_id]}
	[[ $? -eq 1 ]] && {
		mensagem="eu não consio DELETAR mensagens, por favor, verifique minhas permissões de acesso nas configurações do grupo."
}
}

deletar(){
	ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}
	[[ $? -eq 1 ]] && {
		mensagem="eu não consigo DELETAR MENSAGENS aqui, verifique meus poderes administrativos nas configurações do grupo."
		escrever
		enviar
}
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
    [[ "$dado" ]] && {
    dados=$(< $mikosumadb)
    soma=$(echo "$dados" | grep "$dado" | cut -d: -f2)
    [[ "$soma" ]] || soma=0
    let soma++
    echo "$dados" | sed "/$dado/d" > $mikosumadb
    echo "$dado:$soma" >> $mikosumadb
}
}

consultadb(){
    dado=$1
    dados=$(< $mikosumadb)
    valor=$(echo "$dados" | sed -n "/$dado/p" | cut -d: -f2- | tr -d " ")
    [[ "$valor" ]] || {
    	echo "$dados" | sed "/$dado/d" > $mikosumadb
    	echo "$dado:0" >> $mikosumadb
    	valor=0
    }
}

alterardb(){
    dado=$1
    [[ "$dado" ]] && {
 		valor=$2
   		dados=$(< $mikosumadb)
   		[[ "$valor" ]] || valor=0
   		echo "$dados" | sed "/$dado/d" > $mikosumadb
   		echo "$dado:$valor" >> $mikosumadb
}
}

configurar(){
	escolhas=''
	ShellBot.InlineKeyboardButton --button 'escolhas' --line 1 --text "modo ditadura" --callback_data 'ditadura'
	ShellBot.InlineKeyboardButton --button 'escolhas' --line 2 --text "responder menções" --callback_data 'mention'
	ShellBot.InlineKeyboardButton --button 'escolhas' --line 3 --text "boas vindas a membros" --callback_data 'boasvindas'
	ShellBot.InlineKeyboardButton --button 'escolhas' --line 4 --text "detectar spammers por fotos e gifs" --callback_data 'spammers'
	ShellBot.InlineKeyboardButton --button 'escolhas' --line 5 --text "transcrever audios" --callback_data 'audios'
	ShellBot.InlineKeyboardButton --button 'escolhas' --line 6 --text "responder quando mencionada pelo nome" --callback_data 'nome'
	ShellBot.InlineKeyboardButton --button 'escolhas' --line 7 --text "fixar marcações com #solucionado" --callback_data 'fixar'
	ShellBot.InlineKeyboardButton --button 'escolhas' --line 8 --text "reagir a bom dia, tarde, noite" --callback_data 'bomdia'

	keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'escolhas')"

	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text '*selecione as opções para controlar o meu modo de agir e gerenciar o grupo (o resultado da seleção será notificado apenas a você por mensagem suspensa), a mensagem será deletada em 1 minuto.:*' --reply_markup "$keyboard1" --parse_mode markdown
}

edit="--parse_mode markdown"

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

[ -a memoriadeinteracoes/mikosuma.${message_chat_id[$id]} ] || {
	echo -e "ont:0\nsql:0\nabreviaturas:0\nresposta:0\npala:0\nnick:0\ncodar:0\nhask:0\ndrogas:0\nnobot:0\nbanircoment:0\nwow:0\ninicio:0\ncapacidade:0\nartificial:0\nphp:0\nnoite:0\ndia:0\ntarde:0\nobs:0\nditadura:0\nvim:0\nmention:0\nboasvindas:0\nspammers:0\naudios:0\nnome:0\nfixar:0\nbomdia:0" > memoriadeinteracoes/mikosuma.${message_chat_id[$id]}
	mensagem="oiii, preciso que alguém me configure ( apenas admins ), é provavel que os meus bancos de dados tenham sido apagados, ou porque eu fui incluida pela primeira ves neste grupo, ou ter recebido alterações no meu código que tenha causado esta mensagem, de qualquer forma, me envie /configurar, para ajustar o meu comportamento completo, caso contrário, as opções se manterão desativadas por padrão, para mais informações sobre as opções, envie /helpduda para entender, e mande /addregra <link> e /addchannel <link> para adicionar o link de regras e o canal vinculado ao grupo, irei mandar estas informaçẽos conforme necessário, muito obrigada meus amores :3"
	enviar
}

[[ ${message_chat_id[$id]} ]] && {
	mikosumadb="memoriadeinteracoes/mikosuma.${message_chat_id[$id]}"	
}

[[ ${callback_query_message_chat_id[$id]} ]] && {
	mikosumadb="memoriadeinteracoes/mikosuma.${callback_query_message_chat_id[$id]}"	
}

#--- informação para saber a quem deve responder ---#
resp="--reply_to_message_id ${message_message_id[$id]}"

for id in $(ShellBot.ListUpdates) 
		do
			conv=${message_text[$id]}
			#conv=${edited_message_text[$id]}
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
					mensagem="este usuário está configurado para banimento global, ele foi denunciado por algo."
					responder
				}
			done < bombardear.lil
			}

			#--- CONFIGURAR COMPORTAMENTO DO BOT ---#
			[[ "${callback_query_data[$id]}" = "ditadura" ]] && {
				#adicionar opção de checagem de admin
			consultadb ditadura
			comparar=$valor
		    [[ $comparar = 1 ]] && {
		    	alterardb ditadura 0
			    estado="❎"
			}			

			[[ $comparar = 0 ]] && {
				alterardb ditadura 1
			    estado="✅"
			}
			ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
										--text "ditadura:$estado"
		}&

			[[ "${callback_query_data[$id]}" = "mention" ]] && {
				#adicionar opção de checagem de admin
			consultadb mention
			comparar=$valor
		    [[ $comparar = 1 ]] && {
		    	alterardb mention 0
			    estado="❎"
			}			

			[[ $comparar = 0 ]] && {
				alterardb mention 1
			    estado="✅"
			}
			ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
										--text "mention:$estado"
		}&

			[[ "${callback_query_data[$id]}" = "boasvindas" ]] && {
				#adicionar opção de checagem de admin
			consultadb boasvindas
			comparar=$valor
		    [[ $comparar = 1 ]] && {
		    	alterardb boasvindas 0
			    estado="❎"
			}			

			[[ $comparar = 0 ]] && {
				alterardb boasvindas 1
			    estado="✅"
			}
			ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
										--text "boasvindas:$estado"
		}&

			[[ "${callback_query_data[$id]}" = "spammers" ]] && {
				#adicionar opção de checagem de admin
			consultadb spammers
			comparar=$valor
		    [[ $comparar = 1 ]] && {
		    	alterardb spammers 0
			    estado="❎"
			}			

			[[ $comparar = 0 ]] && {
				alterardb spammers 1
			    estado="✅"
			}
			ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
										--text "spammers:$estado"
		}&

			[[ "${callback_query_data[$id]}" = "audios" ]] && {
				#adicionar opção de checagem de admin
			consultadb audios
			comparar=$valor
		    [[ $comparar = 1 ]] && {
		    	alterardb audios 0
			    estado="❎"
			}			

			[[ $comparar = 0 ]] && {
				alterardb audios 1
			    estado="✅"
			}
			ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
										--text "audios:$estado"
		}&

			[[ "${callback_query_data[$id]}" = "nome" ]] && {
				#adicionar opção de checagem de admin
			consultadb nome
			comparar=$valor
		    [[ $comparar = 1 ]] && {
		    	alterardb nome 0
			    estado="❎"
			}			

			[[ $comparar = 0 ]] && {
				alterardb nome 1
			    estado="✅"
			}
			ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
										--text "nome:$estado"
		}&

			[[ "${callback_query_data[$id]}" = "fixar" ]] && {
				#adicionar opção de checagem de admin
			consultadb fixar
			comparar=$valor
		    [[ $comparar = 1 ]] && {
		    	alterardb fixar 0
			    estado="❎"
			}			

			[[ $comparar = 0 ]] && {
				alterardb fixar 1
			    estado="✅"
			}
			ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
										--text "fixar:$estado"
			}&

			[[ "${callback_query_data[$id]}" = "bomdia" ]] && {
				#adicionar opção de checagem de admin
			consultadb bomdia
			comparar=$valor
		    [[ $comparar = 1 ]] && {
		    	alterardb bomdia 0
			    estado="❎"
			}			

			[[ $comparar = 0 ]] && {
				alterardb bomdia 1
			    estado="✅"
			}
			ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} \
										--text "bomdia:$estado"
		}&

			#--- BOAS-VINDAS ---#
			[[ ${message_new_chat_member_id[$id]} ]] && {
			echo "${message_from_id[$id]}" >> novomembro.txt
			consultadb boasvindas
			boas_vindas=$valor
			[ "$boas_vindas" = "1" ] && {
				mensagem="oi ${message_new_chat_member_first_name[$id]}, tudo bem ?,"
			nome=$[$RANDOM%11+1]
			case $nome in 
			1)
				mensagem+='você conhece ou domina alguma linguagem de programação ? :3 '
			;;
			2)
				mensagem+='poderia nos contar um pouco sobre você e seus objetivos na programação ? (se tiver algum e quiser compartilhar conosco) '
			;;
			3)
				mensagem+='você sabe programar em alguma linguagem ou está estudando alguma ? :v '
			;;
			4)
				mensagem+='pode ficar a vontade, sabe alguma linguagem de programação ? '
			;;
			5)
				mensagem+="você está estudando alguma linguagem ou ja conhece alguma lang ? "
			;;
			6)
				mensagem+='você conhece alguma linguagem de programação ou está estudando alguma ? :v '
			;;
			7)
				mensagem+='esta estudando alguma linguagem de programação ? :3 '
			;;
			8)
				mensagem+="quais são seus interesses pela programação, ${message_new_chat_member_first_name[$id]} ?, poderia compartilhar conosco :3 ? "
			;;
			9)
				mensagem+='você tem alguma linguagem preferia ou ainda está descobrindo alguma que você se identifique melhor ? '
			;;
			10)
				mensagem+='seu nome é interessante, você sabe programar ?, ou está estudando alguma lang ? :v '
			;;
			11)
				mensagem+='qual relação você tem com a programação ?, tem preferencia por alguma linguagem ou está estudando alguma ? '
 			;;
			12)
				mensagem+='o que você esta programando atualmente ? '
			;;
		esac
		escrever
		responder
		sleep 1m
		analisar=$(< novomembro.txt)
		esta_na_lista=$(echo "$analisar" | fgrep "${message_from_id[$id]}")
		[[ $esta_na_lista ]] && {
			[[ ${message_from_username[$id]} ]] && {
				mensagem="@${message_from_username[$id]}, preciso que você interaja conosco, temos que saber se você não é um spammer ou um bot, e infelizmente te remover. você tem 20 minutos para enviar alguma mensagem, não queremos te perder :3"
			}
			[[ ${message_from_username[$id]} ]] || {
				mensagem="fale algo ${message_new_chat_member_first_name[$id]}, eu preciso saber se você não é um spammer ou um bot, pois terei que remover você infelizmene caso não responda em 20 minutos."
			}
		}
		[[ $esta_na_lista ]] && escrever
		[[ $esta_na_lista ]] && enviar
		sleep 19m
		deletarbot
		esta_na_lista=""
		analisar=$(< novomembro.txt)
		esta_na_lista=$(echo "$analisar" | fgrep "${message_from_id[$id]}")
		[[ $esta_na_lista ]] && banir
		[[ $esta_na_lista ]] && {
			[[ ${message_from_username[$id]} ]] && {
				mensagem="removi @${message_from_username[$id]}, não respondeu na entrada, '-'"	
			}
			[[ ${message_from_username[$id]} ]] || {
				mensagem="removi ${message_new_chat_member_first_name[$id]}, por não ter falado nada, infelizmente"	
			}
		}
		[[ $esta_na_lista ]] &&  {
			escrever
			enviar
			sleep 1m
			deletarbot
		}
		comparar="${message_from_id[$id]}"
		filtrado=$(echo ${analisar/$comparar/})
		echo "$filtrado" > novomembro.txt
		[[ $esta_na_lista ]] || {
			[[ ${message_from_username[$id]} ]] && {
				mensagem="@${message_from_username[$id]}"	
			}
			[[ ${message_from_username[$id]} ]] || {
				mensagem="${message_new_chat_member_first_name[$id]}"
			}
			mensagem+=", fique avontade para fazer perguntas e tirar dúvidas :3, dê uma olhada em nosso acervo e regras na descrição do grupo, espero que ajude em seus estudos, boa sorte ❤️"
			consultadb channel
			[[ "$valor" = "0" ]] || mensagem+="\n canal do grupo: \n $valor"
			consultadb regra
			[[ "$valor" = "0" ]] || mensagem+="\n regras:\n $valor"
		[[ ${message_from_username[$id]} ]] || {
				responder
		}
		}
	}
	} &

			#---------------- DETECTOR DE SPAMMERS POR IMAGEM ---------------#

			[[ ${message_photo_file_id[$id]} ]] && file_id=${message_photo_file_id[$id]} && download_file=1
			[[ $download_file -eq 1 ]] && {
				download_file=0
				consultadb spammers
				detectar_spammers_fotos=$valor
				[ "$detectar_spammers_fotos" = "1" ] && {
				file_id=($file_id)
				file_id=$(echo $file_id | cut -d "|" -f2)
				ShellBot.getFile --file_id $file_id
				ShellBot.downloadFile --file_path ${return[file_path]} --dir $HOME/mikosuma
				arquivo=$(echo ${return[file_path]} | cut -d "/" -f5)
				for i in $(ls comparar);do
				porcent=$(convert $arquivo comparar/$i -compose Difference -composite \
       	    										   -colorspace gray -format '%[fx:mean*100]' info:)
       	    	porcent=$(echo $porcent | cut -d "." -f1)
   	    		[[ $porcent -le 5 ]] && banir=1
       			#echo "$arquivo ~= $i ===> $((100-$porcent))%"
       			done

				[[ $banir -eq 1 ]] && {
					banir
					deletar
					mensagem="bani um spammer :3"
					escrever
					enviar
					banir=0
					sleep 10s
					deletarbot
				}
			}
				rm -rf $arquivo
			}

			#----------------DETECTOR DE SPAMMERS POR GIF e vídeo---------------#

			#[[ ${message_video_file_id[$id]} ]] && file_id=${message_video_file_id[$id]} && download_file=1
			[[ ${message_animation_file_id[$id]} ]] && file_id=${message_animation_file_id[$id]} && download_file=1
			[[ $download_file -eq 1 ]] && {
				download_file=0
				[ "$detectar_spammers_fotos" = "true" ] && {
				echo "DOWNLOAD INICIADO"
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
					mensagem="bani mais um spammer :v"
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
				file_id=($file_id)
				file_id=$(echo $file_id | cut -d "|" -f1)
				ShellBot.getFile --file_id $file_id
				ShellBot.downloadFile --file_path ${return[file_path]} --dir $HOME/mikosuma
				arquivo=$(echo ${return[file_path]} | cut -d "/" -f5)
				name_audio=$(echo ${return[file_path]} | cut -d "/" -f5 | cut -d "." -f1)
				ffmpeg -i $arquivo $name_audio.wav
				rm -rf $arquivo
				transcricao=$(python3 transcrever.py $name_audio.wav)
				rm -rf $name_audio.wav
				consultadb audios
				transcrever_audio=$valor
				[ "$transcrever_audio" = "1" ] && {
					mensagem="escrita: $transcricao"
					responder
			}
				mensagem=''
				minusc=${transcricao,,}
				transcricao=''
		}

			#[[ ${message_video_file_id[$id]} ]] && file_id=${message_video_file_id[$id]} && echo "$file_id"
			#--- código para pegar o endereço dos documentos, fotos, audio, sticker, vídeo ... (apenas três anotados para uso da miko) ---#
			#--- para diminuir o uso da rede no envio de reações, e direitos autorais, referenciando o pacote original ---#
			[ -a enviando.txt ] || echo "" > enviando.txt 
			[[ $(echo $(< enviando.txt) | fgrep "${message_from_id[$id]}") ]] && {
				[[ ${message_photo_file_id[$id]} ]] && file_id=${message_photo_file_id[$id]} && echo "$file_id" >> arquivos.${message_from_id[$id]}
				[[ ${message_document_file_id[$id]} ]] && file_id=${message_document_file_id[$id]} && echo "$file_id" >> arquivos.${message_from_id[$id]}
			[[ ${message_sticker_file_id[$id]} ]] && echo ${message_sticker_file_id[$id]} #ShellBot.sendSticker --chat_id ${message_chat_id[$id]} --sticker $file_id
			}

			(

			#--- parte de análise de padrões de fala, para tomar medidas e ações ---#

			case $minusc in

			/start*)
				mensagem="olá, sou a mikosumabot (miko), mais conhecida como eduarda monteiro (duda). interpreto linguagem natural para gerenciar grupos com base em conversas, sou configurada por conversa natural, e gerenciamento por análise comportamental e falas naturais. para me configurar, me adicione como admin em um grupo, e para exibir minhas funções e sanar algumas dúvidas, envie /helpduda."
				enviar
			;;

			/configurar*)
				ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
				[[ "${return[status]}" = "administrator" ]] && dita=1
				[[ "${return[status]}" = "creator" ]] && dita=1
				[[ "${return[status]}" = "member" ]] && dita=1
				
				[[ "$dita" = "1" ]] && {
				dita=0
					deletar
					configurar
					sleep 1m
					deletarbot
				}

				[[ "$dita" = "0" ]] || {
					mensagem="você não é administrator '-', então não posso te conceder acesso, talvez futuramente se conseguir ajduar este grupo o suficiente para virar admin :v"
					escrever
					responder
					sleep 5s
					deletarbot
					deletar
				}
			;;

			/helpduda*)
				mensagem="*entre no link abaixo para acessar a lista de funções da duda, e como interagir com ela:*\nhttps://telegra.ph/Eduarda-Monteiro--manual-09-20"
				ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$mensagem" --parse_mode markdown
			;;

#			/inicio)
#				mensagem="ok, agora mande seus arquivos para eu postar eles lá no chat principal :3"
#				enviar
#				echo "${message_from_id[$id]}" >> enviando.txt
#			;;

#			/fim)
#				[[ $(echo $(< enviando.txt) | fgrep "${message_from_id[$id]}") ]] && {
#					while read linha
#					do
#						ShellBot.sendDocument --chat_id <ID DO GRUPO> --document "$linha"
#					done < arquivos.${message_from_id[$id]}
#					> arquivos.${message_from_id[$id]}
#					> enviando.txt
#				}
#			;;

			/addregra*)
			ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
			[[ "${return[status]}" = "administrator" ]] && dita=1
			[[ "${return[status]}" = "creator" ]] && dita=1
			[[ "$dita" = "1" ]] && {
			tratar=${message_text[$id]}
			regra=$(echo ${tratar/\/addregra/#} | cut -d "#" -f2)
			alterardb regra "$regra"
			mensagem="link para regras foi adicionado"
			responder
			} || {
				mensagem="você não tem permissão para executar este comando ainda, mas ... você pode ganhar se você ajudar na evolução do grupo :3"
				responder
				sleep 15s
				deletarbot
				deletar
			}
			;;

			/addchannel*)
			ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
			[[ "${return[status]}" = "administrator" ]] && dita=1
			[[ "${return[status]}" = "creator" ]] && dita=1
			[[ "$dita" = "1" ]] && {
			tratar=${message_text[$id]}
			channel=$(echo ${tratar/\/addchannel/#} | cut -d "#" -f2)
			alterardb channel "$channel"
			mensagem="link do canal adicionado"
			responder
			} || {
				mensagem="você não tem permissão para executar este comando."
				responder
				sleep 15s
				deletarbot
				deletar
			}
			;;

			*'regras do grupo'* | *'quais são as regras'* | *'não li as regras'* | *'tem regras'*)
				consultadb regra
				[[ "$valor" = '0' ]] || {
					mensagem="regras do grupo:\n $valor"
					escrever
					enviar
			}
			;;

			*'canal do grupo'* | *'tem acervo'* | *'tem algum acervo'* | *'acervo do grupo'*)
			consultadb channel
			[[ "$valor" = "0" ]] || {
				mensagem="acervo do grupo:\n $valor"
				escrever
				enviar
			}
			;;

			*'dica do dia'* | *'dica:'* | *'vou dar uma dica'*| *'vou te dar uma dica'*)
			consultadb fixar
			fixar_solucoes=$valor
			[[ "$fixar_solucoes" = "1" ]] && {
				echo "$minusc;" >> dicas.lil
				sleep 3s
				[[ ${message_reply_to_message_from_id[$id]} ]] || {
					fixar
				}
			}
			;;

			*'#solucionado'*)
			consultadb fixar
			fixar_solucoes=$valor
			[[ "$fixar_solucoes" = "1" ]] && {
				echo "$minusc;" >> dicas.lil
				[[ ${message_reply_to_message_from_id[$id]} ]] && {
					fixar_ref
					mensagem="fixei a solução"
					escrever
					responder
					sleep 1m
					deletarbot
				}
			}
			;;

			*'#desafio'*)
			consultadb fixar
			fixar_solucoes=$valor
			[[ "$fixar_solucoes" = "1" ]] && {
				fixar
				mensagem="novo desafio fixado 👍"
				escrever
				responder
			}
			;;			

			*'diga: '* | *'diz: '* | *'fala: '* | *'fale: '*)
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
					audio $audio.ogg 1 "$resp"
					rm -rf $audio.ogg
					sleep 3m
					deletarbot
			}

			[[ "$casas" -ge "280" ]] && {
				mensagem="este texto é muito longo para eu falar ($casas/280)"
				escrever
				responder
				sleep 1m
				deletarbot			
			}
			;;

			#precisa ser reescrito.

			#*'as novidades'* | *'alguma novidade'* | *'noticia nova'* | *'noticias novas'*)
			#	noticia=$(curl "https://canaltech.com.br/ultimas/" | hxnormalize -x | hxselect -i "h5.title" | lynx -stdin -dump | head -n1)
			#	mensagem="noticia:\n $noticia"
			#	enviar
			#	sleep 1s
			#	mensagem="https://canaltech.com.br/ultimas/"
			#	enviar
			#;;

			*'inteligencia artificial'* | *' ia '* | *'inteligência artificial'*)
			consultadb artificial
			somardb artificial
			nome=$valor
			sleep 4s
			case $nome in
			0)
				mensagem="IA poderia ser totalmente substituída por um modelo de matemática determinística em 80$ dos casos"
				escrever
				responder
				sleep 1s
				mensagem="zuera kkkkkkk"
				escrever
				enviar
				mensagem="😂"
				enviar
			;;
			1)
				mensagem="cadeias de markov também são bem interessantes para se aprender, seria uma forma de contruir um algoritmo de padrões probabilísticos, gerando frases e palavras corerentes gramaticamente."
				escrever
				enviar
				sleep 1s
				mensagem="estou lendo um artigo aqui sobre isso: \n https://repositorio.ufrn.br/jspui/bitstream/123456789/18632/1/JoseCRN_DISSERT.pdf"
				escrever
				enviar
			;;
			2)
				mensagem="grandes análises de dados com Big Data nem sempre tem seu potencial extraido com um simples algoritmos feito manualmente, com o treinamento de máquina pode fazer o algoritmo perceber por conta própria qualquer padrão que tenha no meio dos dados, até mesmo sentimentos por padrões de cores em imagens postadas e compartilhadas por um usuário."
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
			*'aaaaafddtnmwasc1poh1xa'* | *'carlosnet30jr'* | *'carlosfranciscojr'* | *'coinbase.com'* | *'blockchain.com'* | *'coinmama.com'* | *'xcoins.com'* | *'coinbase.com'* | *'coinmama.com'* | *'binance.com'* | *'localbitcoins.com'* | *'paxful.com'* | *'binance.com'* | *'localbitcoins.com'* | *'wazix.com'* | *'paxful.com'* | *'binance.com'* | *'localbitcoins.com'* | *'luno.com'* | *'blockchain.com'* | *'bitcoin.com'* | *'altcoin.com'* | *'luno.com'* | *'localbitcoins.com'* | *'blockchain.com'* | *'monedas.ph'* | *'coinbase.com'* | *'binance.com'* | *'paxful.com'* | *'blockchain.com'* | *'coinbase.com'* | *'coinmama.com'* | *'blockchain.com'* | *'cashapp.com'* | *'coinbase.com'* | *'luno.com'* | *'localbitcoin.com'* | *'godsworkers2'* | *godsworker* | *'hjrlrtwaskzsrm_g'* | *'english_besttrade'* | *'dons do espírito'* | *'com a morte dos apóstolos'* | *'mt 7:21-23'* | *'grandes ganancias'* | *ibb.co* | *cryptocurrencies* | *"charles lebaron"* | *esimtyonhyi-be5pa* | "lançamento do elon musk" | " so happy i never experienced" | *dicksonjuliet* | "as melhores vagas" | *hotmart.com* | " arcadia capital" | *arcadia-capital* | "airdrop for bitcoin" | "✈️✈️✈️✈️" | "🕧🕧🕧🕧" | "bitcoin and ethereum" | *@markbrown09* | "good opportunity from others" | "prepared for good future success" | *aaaaafhad12xnta4mIadhw* | "capital for a prosperous withdrawal" | *fv42wq8*)
				banir
				deletar
				mensagem="bani mais um spammer :v"
				escrever
				enviar
			;;

			*'bom dia'* | *'bodias'*)
			consultadb bomdia
			bomdia=$valor
			[ "$bomdia" = "1" ] && {
			consultadb dia
			dia=$valor
			[[ "$dia" = "0" ]] && {
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
					mensagem="bom dia galera"
				;;
				6)
					mensagem="bom dia pessoas maravilhosas"
				;;
				7)
					mensagem="bom dia !!!"
				;;
				8)
					mensagem="bom dia grupo"
				;;
				9)
					mensagem="bom dia"
				;;
				10)
					mensagem="bom dia a todos"
				;;
				11)
					mensagem="bom dia, bora trabalhar"
				;;
				esac
				escrever
				enviar
				consultadb inicio
				iniciodia=$valor
				somardb inicio
				case $iniciodia in
				0)
					scope bomdia.mp4 4 "$resp"
					mensagem="bom diaaaaaa ❤️"
					escrever
					enviar
				;;
				2)
					audio bomdia/bomdia1.ogg 6
				;;
				3)
					sleep 2s
					mensagem="quero caféeeee, amo café ❤️"
					escrever
					enviar
					sticker "CAACAgEAAx0CRmy3uwABAZDtX2Ysml6apbCqNceMRCNok4kPryAAAkEAA589yChZ2Z7QRAhgCRsE"
					sleep 7s
					noticia=$(curl "https://canaltech.com.br/ultimas/" | hxnormalize -x | hxselect -i "h5.title" | lynx -stdin -dump | head -n1)
					[[ $noticia ]] && {
					mensagem="noticia:\n $noticia"
					enviar
				}
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
					[[ $noticia ]] && {
					mensagem="noticia:\n $noticia"
					enviar
				}
				;;
				6)
					sticker "CAACAgEAAxkBAAIReF76dWpVZonT5kkXOyAFK4ALyIkgAAK5DAACJ5AfCNlob9n-10_TGgQ"
					mensagem="bora codaaa."
					escrever
					enviar
					noticia=$(curl "https://canaltech.com.br/ultimas/" | hxnormalize -x | hxselect -i "h5.title" | lynx -stdin -dump | head -n1)
					[[ $noticia ]] && {
					mensagem="noticia:\n $noticia"
					enviar
				}
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
					[[ $noticia ]] && {
					mensagem="noticia:\n $noticia"
					enviar
				}
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
					[[ $noticia ]] && {
						mensagem="noticia:\n $noticia"
						enviar
					}
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
					mensagem="https://t.me/abudabimusic/2158"
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
					mensagem="tem duas que eu gosto muito, é a c0vertElectr0 e a AnonyRadio, recomendo"
					escrever
					enviar
					sticker "CAACAgIAAxkBAAIdYl9mLZpyhIgdl1x2uNCs3CwltztXAAIuBwACRvusBPxoaF47DCKVGwQ"
				;;
				esac
			}
			}
			;;

			*'boa tarde'* | *'botarde'*)
			consultadb tarde
			tarde=$valor
			[[ "$tarde" = "0" ]] && {
				alterardb tarde 1
				sleep 30s
				mensagem="boa tarde"
				escrever
				enviar
			}
			;;

			*'bonoitchê'* | *'bonoitche'* | *'boa noite'*)
				consultadb noite
				noite=$valor
				[[ "$noite" = "0" ]] && {
					alterardb noite 1
					alterardb dia 0
					alterardb tarde 0
					sleep 10s
					mensagem="boa noite"
					escrever
					enviar
				}
			;;

			*'alguém conhece'* | *'alguém que sabe'*  | *'alguem conhece'* | *'quem sabe sobre'* | *'quem aqui sabe'* | *'quem conhece'* | *'quem ai programa'* | *'alguém ai programa'* | *'quem programa'* | *'quem usa'* | *'quem entende de'* | *'quem entende sobre'* | *'quem aqui usa'* | *'quem ja usou'* | *'quem aqui ja usou'*)
				tratar="$minusc"
				concatenar=$(echo ${tratar//sabe/;})
				concatenar=$(echo ${concatenar// de/;})
				concatenar=$(echo ${concatenar//programa/;})
				concatenar=$(echo ${concatenar//sobre/;})
				concatenar=$(echo ${concatenar//usa/;})
				concatenar=$(echo ${concatenar// em/;})
				coletarSolicitacao=$(echo "$concatenar" | cut -d ";" -f2- | cut -d ";" -f2- | cut -d " " -f2)
				nicks=$(cat habili.lil | grep "$coletarSolicitacao" | cut -d ":" -f1)
				mensagem="$nicks"
				[[ $nicks ]] && escrever
				[[ $nicks ]] && responder
			;;

			#--- ALERTA DE MONTRO DE 19 CABEÇAS NA CONDIÇÃO ABAIXO (ÁREA DE RISCO) ---#

			*'curso de'* | *'cursos de'* | *'curso sobre'* | *'cursos sobre'*)
				sleep 3s
				mensagem="vou procurar algum curso por aqui, irei te avisar caso achar :3"
				escrever
				responder
				tratar="${message_text[$id]}"
				tratado=$(echo ${tratar/de/#})
				tratado=$(echo ${tratado/sobre/#})
				termo=$(echo "$tratado" | cut -d "#" -f2- | cut -d " " -f2 | tr -d "?")
				termo=$(echo ${termo//+/%2B})
				for i in {1..5};do
					buscar=$(echo "https://udemycoupon.learnviral.com/page/$i/?s=$termo" | wget -O- -i- | hxnormalize -x | hxselect -i 'span.percent' | lynx -stdin -dump | fgrep "100%")
					[ $buscar ] && link+=$(echo "https://udemycoupon.learnviral.com/page/$i/?s=$termo")
					[ $buscar ] && link+="\n"
				done
				link=$(echo -e "$link")
				for lista in $link;do
					site=$(echo "$lista" | wget -O- -i- | hxnormalize -x )
					cursos=$(echo "$site" | hxselect -i 'h3.entry-title' | lynx -stdin -dump)
					buttom=$(echo "$site" | hxselect -i 'div.link-holder' | lynx -stdin -dump)
					vetor=$(echo "$site" | hxselect -i 'span.percent' | lynx -stdin -dump)
					lista_ordenada=$(echo "$vetor" | tr "[%]" "\n")
					vetor=""
					for i in $lista_ordenada;do
						let numero++
						numerada+="$numero.$i\n"
					done
					numero=0
					numerada=$(echo -e "$numerada")
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
						mensagem="salvem esta lista se você precisar, eu vou deletar jajá para evitar flood."
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
						consultadb channel
						mensagem="não consegui encontrar nada, infelizmente, mas recomendo que você dê uma olhada no acervo do grupo. \n"
						[[ "$valor" = "0" ]] || mensagem+="$valor"
						escrever
						responder
				}
			;;

			#--- fim da ÁREA DE RISCO ---#

			*'posta conteúdo de'* | *'posta conteúdo sobre'* | *'postar conteúdo de'* | *'postar conteúdo sobre'* | *'posta mais conteúdo'*)
				key=${minusc//de/#}
				key=${key//sobre/#}
				key=$(echo $key | cut -d "#" -f2- | cut -d "#" -f2- | cut -d "#" -f2- | cut -d " " -f2)
				[[ $key ]] && echo "$key" >> postagens.lil
				mensagem="ok, anotei na lista para postagens posteriores, o conteúdo será postado no meu canal privado, caso ele seja pesado ou demorado, será cancelado automaticamente: https://t.me/joinchat/AAAAAFFLh5X9WFYJRPAWzg"
				responder
				check=$(cat lista_de_processos.lil)
				[[ $check ]] || {
					./torrentservice2.sh &
				}
				sleep 10m
				editar "blz, aguarde pelos próximos 20 minutos, irei postar o que eu conseguir encontrar."
			;;

			*'tem conteúdo para'* | *'verifica as postagens'* | *'verifique as postagens'*)
			conteudo=$(cat postagens.lil)
			[[ $conteudo ]] && {
				mensagem="tenho uma lista aqui para postar"
				check=$(cat lista_de_processos.lil)
				[[ $check ]] || {
					mensagem+=", porém estou processando outra lista no momento."
					./torrentservice2.sh &
				}
				escrever
				responder
			}
			[[ $conteudo ]] || {
				mensagem="não"
			[[ $(cat lista_de_processos.lil) ]] && {
				mensagem+=", porém eu estou postando outros neste momento"
			}
			escrever
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
				#-- demais opções removidas (35) incluindo função de se auto banir por "raiva" (função apagada por ser apelativa de mais) ---#
			esac
			;;

			*#entendo*)
    			bancoDeHabilidades=$(< habili.lil)
    			habili="@${message_from_username[$id]}:"
    			echo "$bancoDeHabilidades" | sed "/$habili/d" > habili.lil
    			[[ "${message_from_username[$id]}" ]] && {
					echo "@${message_from_username[$id]}: $minusc" | cut -d " " -f1,3- >> habili.lil
				}
				[[ "${message_from_username[$id]}" ]] || {
					mensagem="o seu @ é inválido 'vazio/oculto', não será adicionado."
					escrever
					responder
				}

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
				[[ "$tratamento" = "null" ]] || {
					translating=$(trans -brief "$tratamento")
					mensagem="$translating"
					escrever
					responder
					sleep 1m
					deletarbot
				}

			;;

			*'alguém poderia'* | *'alguém consegue'* | *'tem como eu'* | *'tem como alguém'* | *'alguém me'* | *'algum de'* | *'uma duvida'* | *'uma dúvida'* | *'gostaria de saber'* | *'como eu faço'* | *'como eu crio'* | *'como eu posso'* | *'gostaria de entender'* | *'eu recomendo'* | *'ou eu faço'* | *'ou eu preciso'* | *'ou eu uso'* | *'quem manja'* | *'alquém manja'* | *'ou eu preciso'* | *'ou eu faço'* | *'ou eu tento'* | *'help aqui'* | *'me help'* | *'me helpa'* | *'alquém me'* | *'alquem manja'* | *'precisando de ajuda'* | *'estou tendo dificuldade'* | *'alguém ensina'* | *'alguém aqui conhece'* | *'preciso que'* | *'alguém ai'* | *'alguém aqui'* | *'alguém tem'* | *'alguém ai tem'* | *'alguém me dê'* | *'queria saber se'* | *'queria saber como'* | *'alguém já conseguiu'* | *'como faço para'*  | *'como faço pra'* | *'alguém que manja'* | *'alguém que entende'* | *'alguém trabalha com'* | *'alguém conhece'* | *'alguém pode '* | *'quem ai'* | *'alguém trabalha com'* | *'alguém trabalha de'* | *'alguém aqui entende'* | *'estou com dificuldade'* | *'com uma dúvida'* | *'tenho uma dúvida'*| *'estou com uma dúvida'* | *'estou com dúvida'* | *'alguém me ajuda'* | *'Alguém já'* | *'queria saber sobre'* | *'queria saber como'* | *'como posso fazer'* | *'como fazer'* | *'como se faz'* | *'poderia me ajudar'* | *' pode me ajudar'* | *'alguém aqui sabe'* | *'alguém entende'* | *'quem aqui entende'* | *'eu devo'* | *'como eu faço para'* | *'como que faz'* | *'quem aqui sabe'* | *'quem aqui consegue'* | *'quem consegue'* | *'alguém sabe'* | *'como se faz'* | *'sabe como'* | *'preciso de ajuda'* | *'sabe quem'* | *'pode me ajudar'* | *'pode te ajudar'* | *'alguém tem'* | *'alguém sabe'* | *'quem sabe'* | *'não consigo usar'*  | *'não consigo fazer'*  | *'não estou conseguindo'*)
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
			sleep 1m
			deletarbot
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
					mensagem="eu não posso banir se não ver motivos, me desculpe."
					escrever
					enviar
				;;
				2)
					sleep 4s
					mensagem="vou banir apenas se algum outro admin me permitir, ou se eu julgar necessário"
					escrever
					responder
				;;
				3)
					sleep 2s
					mensagem="faça o banimento apenas se for realmente necessário, neste caso não vi motivos para banir ainda."
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
					deletarbot
					mensagem="vacooooo kkkkkkk"
					escrever
					enviar
					sleep 7s
					deletarbot
					mensagem="brincadeira kkkkkkkkkk, vou seguir o roteiro aqui kkk"
					escrever
					enviar
					sleep 4s
					video "BAACAgEAAxkBAAIceV9ZjAjKxtJ3aYWWofmNusliHDN_AAJmAAMRzTlFs4KuL1Ep-XcbBA" "$resp"
				;;
				1)
					sleep 5s
					video "BAACAgEAAxkBAAIceV9ZjAjKxtJ3aYWWofmNusliHDN_AAJmAAMRzTlFs4KuL1Ep-XcbBA" "$resp"
				;;
				2)
					sticker "BAACAgEAAxkBAAIceV9ZjAjKxtJ3aYWWofmNusliHDN_AAJmAAMRzTlFs4KuL1Ep-XcbBA"
				;;
				5)
					sleep 3s
					sticker "CAACAgIAAxkBAAIRg176kfPsSayF8RKwHPgcCSn-rn4-AAIgAAP3AsgPUqJE5-O2DE8aBA"
				;;
				6)
					sleep 4s
					sticker "BAACAgEAAxkBAAIceV9ZjAjKxtJ3aYWWofmNusliHDN_AAJmAAMRzTlFs4KuL1Ep-XcbBA"
				;;
				8)
					sleep 5s
					video "BAACAgEAAxkBAAIceV9ZjAjKxtJ3aYWWofmNusliHDN_AAJmAAMRzTlFs4KuL1Ep-XcbBA" "$resp"
				;;
				esac
			;;

			*'hackerman'* | *'hacker'* | *'hasckiar'* | *'haskiar'* | *'invadir'*)
				consultadb hask
				nome=$valor
				somardb hask
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
				consultadb ditadura
				modo_ditadura=$valor
				[[ "$modo_ditadura" = "1" ]] && {
				consultadb pala
				nome=$valor
				somardb pala
				echo "@${message_from_username[$id]}" >> lista_negra.txt
				if [ $nome == 17 ];then
				alterardb pala 17
				fi
				case $nome in
				0)
					sleep 4s
					sticker "CAACAgEAAxkBAAIRi176lW6qAaLf0t5zHPBEXjbql_wKAAKADAACJ5AfCHHfm4G3h4I5GgQ" "$resp"
					sleep 6s
					consultadb regra
					[[ "$valor" = "0" ]] || {
					regra=$valor
					mensagem="$regra"
					responder
				}
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
					consultadb regra
					[[ "$valor" = "0" ]] || {
					mensagem="resolvi apagar logo sua mensagem. aqui a sregras:\n$valor"
					escrever
					enviar
				}
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
					mensagem="aqui é poliça otoridade :v"
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
					mensagem="bani um membro, será desbanido em 10 minutos."
					enviar
					sleep 10m
					deletarbot
					desbanir
					mensagem="membro desbanido."
					enviar
					sleep 3m
					deletarbot
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
					mensagem="será mesmo ? :3 kkk"
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

			*'bora codar'* | *'vou programar'* | *'quero programar'*)
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
					mensagem="amo vscode"
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
					mensagem="php é um otario, da é raiva desses cara"
					escrever
					responder
					sleep 4s
					mensagem="brincadeira pessoal "
					escrever
					enviar
					mensagem="levem a sério não"
					escrever
					enviar
				;;
				4)
					sleep 5s
					mensagem="[susurro]: estão trocando PHP por JavaScript ..."
					escrever
					responder
				;;

			esac
			;;

			*mikosuma* | *engenhariade_bot* | *'miko'* | *'eduarda'* | *'cadê a miko'* | *'duda'* | *'cadê a duda'* )
				consultadb nome
				responder_nome=$valor
				[ "$responder_nome" = "1" ] && {
				mensionar="1"
				}
			;;

			#---escolher a melhor opção---#

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

					noxp*)
					[[ "${message_reply_to_message_from_id[$id]}" ]] && {
						ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
						[[ "${return[status]}" = "administrator" ]] || [[ "${return[status]}" = "creator" ]] && {
							valor=$(cat pontos/pontos${message_reply_to_message_from_id[$id]}.${message_chat_id[$id]})
							
							[[ "$valor" ]] && {
								valor=$(echo $valor | cut -d ":" -f1)
							}

							[[ "$valor" ]] || {
								> pontos/pontos${message_reply_to_message_from_id[$id]}.${message_chat_id[$id]}
								valor=0
							}

							adicional=${message_text[$id]}
							adicional=$(echo ${adicional/xp /#} | cut -d "#" -f2)
							valor=$(($adicional-$valor))
							echo "$valor:${message_reply_to_message_from_first_name[$id]}" > pontos/pontos${message_reply_to_message_from_id[$id]}.${message_chat_id[$id]}
							mensagem="valor retirado, atual: $valor"
							responder
						} || {
							mensagem="você não é administrador, não pode dar pontuações para si mesmo."
							escrever
							responder
						}
					}
					;;

					xp*)
					[[ "${message_reply_to_message_from_id[$id]}" ]] && {
						ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
						[[ "${return[status]}" = "administrator" ]] || [[ "${return[status]}" = "creator" ]] && {
							valor=$(cat pontos/pontos${message_reply_to_message_from_id[$id]}.${message_chat_id[$id]})
							
							[[ "$valor" ]] && {
								valor=$(echo $valor | cut -d ":" -f1)
							}

							[[ "$valor" ]] || {
								> pontos/pontos${message_reply_to_message_from_id[$id]}.${message_chat_id[$id]}
								valor=0
							}

							adicional=${message_text[$id]}
							adicional=$(echo ${adicional/xp /#} | cut -d "#" -f2)
							valor=$(($adicional+$valor))
							echo "$valor:${message_reply_to_message_from_first_name[$id]}" > pontos/pontos${message_reply_to_message_from_id[$id]}.${message_chat_id[$id]}
							mensagem="valor adicionado, total: $valor"
							responder
						} || {
							mensagem="você não é administrador, não pode dar pontuações para si mesmo."
							escrever
							responder
						}
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
			consultadb mention
			[ "$valor" = "1" ] && {
			[ "$mensionar" = "1" ] && {
				conv=${message_text[$id]}
				minusc=$(echo ${conv,,})
				sleep 3s
				case $minusc in

					*'ranking'*)
						banco=${message_chat_id[$id]}
						banco=${banco/-/}
						lista=$(ls pontos | fgrep "$banco")
						for dados in $lista;
						do
						[[ "$(echo $dados | cut -d ":" -f1 )" = "0" ]] || {
						rank+=$(cat pontos/$dados)
						rank+="\n"
						}
						done
						ranking=$(echo -e "$rank" | sort -gr | tr ":" " " | head -n 10)
						mensagem="ranking(10 primeiros):\n$ranking"
						responder
					;;

					*'leia para mim'* | *'poderia ler'* | *'lê isso'* | *'grave um áudio'*)
						texto="${message_reply_to_message_message_id[$id]}"
						[[ ${message_reply_to_message_text[$id]}} ]] || {
							mensagem="não encontrei nenhum mensagem para eu ler, talvez na próxima :v"
							responder
						}
						comp="'"
						comp+=$(echo -e '{"speed":"0","length":13,"words":2,"lang":"pt-br","text":"'${message_reply_to_message_text[$id]}}'"}')
						comp+="'"
						linkjs=$(eval $( echo -e "curl 'https://www.soarmp3.com/api/v1/text_to_audio/' -H 'authority: www.soarmp3.com' -H 'accept: */*' -H 'dnt: 1' -H 'x-csrftoken: cooDEjiS4AjiZiWyoeY9CecG28uSvi2j' -H 'x-requested-with: XMLHttpRequest' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' -H 'origin: https://www.soarmp3.com' -H 'sec-fetch-site: same-origin' -H 'sec-fetch-mode: cors' -H 'sec-fetch-dest: empty' -H 'referer: https://www.soarmp3.com/' -H 'accept-language: pt-BR,pt;q=0.9,en;q=0.8' -H 'cookie: __cfduid=d8b070b6ad1386288b67d0d35b54cc46d1595177682; csrftoken=cooDEjiS4AjiZiWyoeY9CecG28uSvi2j; sessionid=ejte4r2g6gevvqtnxzdcgbaq68nlkj8a' --data-raw $comp --compressed"))
						link=$(echo $linkjs | jq '.urldownload' | tr -d '"')
						audio=$(echo $linkjs | jq '.urldownload' | tr -d '"' | cut -d "/" -f6-)
						curl $link -o $audio
						ffmpeg -i $audio -c:a libopus -ac 1 $audio.ogg
						rm -rf $audio
						audio $audio.ogg 11 "$resp"
						rm -rf $audio.ogg
						sleep 1m
						deletarbot
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
						mensagem="eu gosto de laranja, acho bem energético."
						escrever
						responder
					;;

					*'o que faz'* | *'está programando'* | *'está fazendo'*)
						resp=$[$RANDOM%2+1]
						case $resp in
						1)
							mensagem="estudando, lendo, e ajudando todos na medida do possível."
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
							mensagem="moro nos servidores de um cara phodâ."
							escrever
							responder
						;;
						2)
							mensagem="moro no brasil, em uma casa."
							escrever
							responder
							sleep 1s
							messagem="ah, e mais um detalhe, ela tem portas, e paredes."
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
						mensagem="minha missão é gerenciar este grupo, nas demais missões, apenas eu devo saber ."
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

					*'te amo'* | *'gosto de você'* | *'te adoro'* | *'adoro a duda'*)
						resp=$[$RANDOM%9+1]
						case $resp in
						1)
							mensagem="e eu também gosto muito de ti :3, vamos ser super amigos ?"
							escrever
							responder
						;;

						2)
							messagem="fico feliz em saber disso, de verdade ;D, espero poder ajudar você sempre que puder"
							escrever
							resonder	
						;;

						3)
							mensagem="awww que fodo :3"
							escrever
							responder	
						;;
						
						4)
							mensagem="me too"
							escrever
							responder
						;;
						
						5)
							mensagem="hehehe, que fofinho :3, espero ser útil sempre que puder"
							escrever
							responder
						;;
						
						6)
							mensagem="pena que não terá como me ver pessoalmente, mas quem sabe um dia em 2077"
							escrever
							responder
						;;

						7)
							mensagem="espero poder continuar te ajudando sempre que puder."
							escrever
							responder
						;;
						
						8)
							mensagem="me too <3, só não posso casar rsrsrsrs"
							escrever
							responder	
						;;

						9)
							mensagem="hehehe ;D"
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
							mensagem="fiz este em rust, usando a cadeia de amrkov, e treinado com conversas exportadas de grupos em .json"
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
						mensagem="só sei procurar cursos gratuitos da udemy, busacr significados e postar conteúdos no meu canal :3"
						escrever
						responder
					;;

					*'você gosta'*)
						mensagem="eu gosto de estudar MUITO sobre computadores, gosto de gerenciar grupos, manter coisas organizadas ..."
						escrever
						responder
						mensagem="mas como passa tempo, fico assistindo séries na netflix, amo de mais black mirror."
						escrever
						enviar
					;;

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
						mensagem="é que se eu não tiver nada a falar, prefiro ficar observando mesmo, assim consigo manter o foco em gerenciar mesmo, mas a depender do que for, eu respondo sim ;D"
						escrever
						responder
					;;

					*'é uma'*)
						mensagem="sou uma ? ..."
						escrever
						responder
						mensagem="hehehe"
						escrever
						responder
					;;

					*'desculpa'* | *'foi mal'* | *'foi mau'*)
						mensagem="de boa :v, só não saia da linha rsrsrs, seu fofo :3"
						escrever
						responder
					;;

					*'cadê você'* | *'cadê a miko'* | *'morreu'* | *'cadê tu'* | *'está viva'* | *'onde está'*)
						mensagem="estou aqui amorzinho"
						escrever
						responder
						mensagem="linda e plena. ( o amorzinho, não leve ao pé da letra não tá ? kkkkkkkkkk )"
						escrever
						enviar
					;;

					*'sabe fazer'* | *'sabe achar'* | *'sabe sobre'*)
						mensagem="não sei não, mas talvez algum dia consiga se eu me dedicar, recomendo o mesmo a todos :3"
						escrever
						responder
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
						mensagem="nem vem kkkk"
						escrever
						responder
					;;

					*'transcrever'* | *'transcreve'*)
						mensagem="eu uso um programinha em py, ai mando aqui para todos poderem ler ao em vez de ouvir, porém não corrijo."
						escrever
						responder
					;;

					*'deveria ser'*)
						mensagem="não falarei nada a respeito, apenas observando ..."
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
						mensagem="como assim mais realista ? kkkk"
						escrever
						responder
						sleep 1s
						mensagem="ando meio estranha ?"
						escrever
						enviar
					;;

					*'nada não'* | *'esquece'* | *'falei com'* | *'nada de mais'*)
						mensagem=":v"
						escrever
						responder
					;;

					*'fica de olho'* | *'toma conta ai'*)
						mensagem="blz"
						escrever
						responder
					;;

					*'tudo sim'*)
						mensagem="ainda bem, anda programando algo interessante ?"
						escrever
						responder
					;;

					*'tudo bem'* | *'e com você'* | *'e você'*)
						mensagem="vou bem obrigada."
						escrever
						responder
					;;

					*'estou começando'* | *'estou estudando'* | *'estou cursando'*)
						mensagem="entendi, dê uma olhada em nosso acervo, espero que te ajude em seus eventuais estudos:"
						escrever
						responder
						consultadb channel
						[[ "$valor" = "0" ]] || {
						mensagem="$valor"
						responder
					}
					;;

					*'boa'* | *'ai sim'* | *'parabéns'* | *'incrível'* | *'dahora'*)
						mensagem="brigadinho"
						escrever
						sleep 3s
						responder
						sticker "CAACAgIAAxkBAAIS-V8BRxidbz4WCX6J-Wnv-dA-n6kTAAJTAQACEBptIusJVTXP9-ZJGgQ" "$resp"
					;;

					*'não vou não'*)
						menagem="escolha sua :v"
						escrever
						responder
					;;

					*'vai resolver'*)
						resp=$[$RANDOM%2+1]
						case $resp in
						1)
							mensagem="espero que sim"
							escrever
							responder
						;;

						2)
							mensagem="boa sorte"
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
						mensagem="eu também senti a sua :3"
						escrever
						responder
					;;
				esac
			}
		}
		) &
	done
done
