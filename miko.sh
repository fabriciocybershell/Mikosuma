#! /bin/bash

#-----------------------------------------------------------------------------------------------------------
#	DATA:				10 de abril de 2020 (1-⁰ dia de operação)
#	SCRIPT:				miko.sh
#	VERSÃO:				0.5.8
#	DESENVOLVIDO POR:	Fabrício Caetano [F43®1¢10 m0h∆m3d]
#	PÁGINA:				https://eduardamonteiro.zyrosite.com/
#	CHANNEL:			https://t.me/mikoduda
# 	BOT:				https://t.me/engenhariade_bot
#	MANUAL:				https://telegra.ph/Eduarda-Monteiro--manual-09-20
#	GITHUB:				https://github.com/fabriciocaetano
# 	CONTATO:			fabricio45726245@protonmail.ch
#
#	DESCRIÇÃO:			miko (Duda) é uma Bot de telegram desenvolvida para agir como um humano moderador/colaborador/participante,
#                       desenvolvida para facilitar a moderação de grupos na plataforma TELEGRAM. visto que pessoas respeitam mais 
#						mais admins humanos do que admins bots.
#
#                       Constituída por uma coleção de habilidades e funções que permitem aos ADMINS e MEMBROS:
#							* Gerenciar grupos, canais e membros.
#							* e : https://telegra.ph/Eduarda-Monteiro--manual-09-20
#
#	DEPENDÊNCIAS:		curl, jq, ffmpeg, sox, html2text, pdf2txt/pdftotxt, catdoc.
#
#	NOTAS:				Desenvolvida na linguagem Shell Script, utilizando o interpretador de 
#						comandos BASH e explorando ao máximo os recursos built-in do mesmo,
#						reduzindo o nível de dependências de pacotes externos.
#-----------------------------------------------------------------------------------------------------------

# CONFIGURAÇÕES E TOKENS DA EDUARDA MONTEIRO (DUDA/BOT):
#--------------------------------------------------------------------------------------------------------------
#chave/token da duda/bot
bot_token='<SUA_CHAVE_PRINCIPAL>' #duda principal
#bot_token='<sua_chave_teste>' # duda teste
#---------------------------

# token de pagamentos stripe:
token_pay='<TOKEN_VÁLIDA>' #real
#token_pay='<token teste>' #teste

#---------------------------
#token da deepai.org para detecção de porn e imagens extremistas
token_porn='<TOKEN_DEEPAI>' # ficará defasado após futuras atualizações
#---------------------------

# ID do dono, VOCÊ
ID_DONO="<SEU_USER_ID>"

#--------------------------------------------------------------------------------------------------------------

# VERIFICAÇÃO DE PASTAS IMPORTANTES:
#--------------------------------------------------------------------------------------------------------------
[[ -a guia ]] || mkdir guia
[[ -a sons ]] || mkdir sons
[[ -a audio ]] || mkdir audio
[[ -a dados ]] || mkdir dados
[[ -a podcast ]] || mkdir podcast
[[ -a resumir ]] || mkdir resumir
[[ -a production ]] || mkdir production
#--------------------------------------------------------------------------------------------------------------

# usando set +f e -f para habilitar e 
# sehabilitar a expansão de nomes de
# arquivos do shell ao longo do código.
# evitar expansão em meio a mensagens
# e processamentos.

# IMPORTANDO PLUGINS/FUNÇÕES:
#--------------------------------------------------------------------------------------------------------------
#importando plugins/funções
for plug in plugins/*;do
	# mysql.sh desativado e descontinuado
	[[ "${plug%.*}" = "mysql" ]] || {
		plug=${plug%.*}
		declare -A "${plug##*/}"
	}
done

for plug in plugins/*;do
	source ${plug}
done
#--------------------------------------------------------------------------------------------------------------

# VERIFICAR DEPENDÊNCIAS NECESSÁRIAS:
#--------------------------------------------------------------------------------------------------------------
[[ "$(command -v curl)" ]] || {
	echo -e "falta dependência, nome: curl\nse estiver usando ubuntu, instale com o comando:\nsudo apt install curl"
	exit 1
}
[[ "$(command -v jq)" ]] || {
	echo -e "falta dependência, nome: jq\nse estiver usando ubuntu, instale com o comando:\nsudo snap install jq"
	exit 1
}
#--------------------------------------------------------------------------------------------------------------

#baixar API para comunicação do telegram, caso o mesmo não esteja disponível no diretório do bot em questão
#--------------------------------------------------------------------------------------------------------------
[[ -a ShellBot.sh ]] || {
	curl 'https://raw.githubusercontent.com/shellscriptx/shellbot/master/ShellBot.sh' -o ShellBot.sh
	chmod +x ShellBot.sh
}

[[ -a LICENSE.txt ]] || {
	curl 'https://raw.githubusercontent.com/shellscriptx/shellbot/master/LICENSE.txt' -o LICENSE.txt
}
#--------------------------------------------------------------------------------------------------------------

# IMPORTANDO DEPENDÊNCIAS
#--------------------------------------------------------------------------------------------------------------
source ShellBot.sh

ShellBot.init --token "${bot_token}" --return map
#--------------------------------------------------------------------------------------------------------------

# encapsulando funções das funções do shellbot
# para facilitar e focar na codificação das interações
# da duda, e reduzir as formas diversificadas e atípicas de interações.
#--------------------------------------------------------------------------------------------------------------

escrever(){
	# cálculo com base em testes e estudos pessoais
	# para emular o tempo real de digitação média
	# de um ser humano médio a elevado em termos tecnológicos.

	# número de caracteres da mensagem X tempo médio de pressiona-
	# mento de teclas de um usuário comum / por tempo de espera
	# entre requisições de 'digitando ...'
	repetir=$(bc <<< "${#mensagem}*0.12/3")
	for((i=0;i<=${repetir%.*};i++)); do
		ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
		sleep 3s
	done
}

enviar() {
	mensagem="${mensagem//\+/\%2B}"
	id_chat=${my_chat_member_from_id[$id]}
	id_chat=${message_chat_id[$id]:-$id_chat}
	ShellBot.sendMessage --chat_id ${callback_query_message_chat_id:-$id_chat} --text "${mensagem}" $1
}

responder() {
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$mensagem" --reply_to_message_id ${message_message_id[$id]} "$1"
}

foto() {
	ShellBot.sendPhoto --chat_id ${message_chat_id[$id]} --photo @${arquivofoto}
}

enviarfoto() {
	ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action upload_photo
}

enviar_menu(){
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "${mensagem}" \
						 --reply_markup "$keyboard1"
}

documento() {
	ShellBot.sendDocument --chat_id ${message_chat_id[$id]} --document ${1} ${2}
}

local_documento() {
	ShellBot.sendDocument --chat_id ${message_chat_id[$id]} --document @${1} ${2}
}

enviando_documento() {
	ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action upload_document
}

local_video() {
	ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action upload_video
	ShellBot.sendVideo --chat_id ${message_chat_id[$id]} --video @${1} ${2}
}

video() {
	ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action upload_video
	ShellBot.sendVideo --chat_id ${message_chat_id[$id]} --video ${1} ${2}
}

local_sticker(){
	ShellBot.sendSticker --chat_id ${message_chat_id[$id]} --sticker @${1} ${2}
}

sticker(){
	ShellBot.sendSticker --chat_id ${message_chat_id[$id]} --sticker ${1} ${2}
}

banir(){
	argument=${message_from_id[$id]}
	ShellBot.kickChatMember --chat_id ${message_chat_id[$id]} --user_id ${1:-$argument}
}

banir_ref(){
	id_user=${message_reply_to_message_from_id[$id]}
	ShellBot.kickChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_reply_to_message_new_chat_participant_id[$id]:-$id_user}
}

desbanir(){
	id_user=${message_from_id[$id]}
	id_user=${message_reply_to_message_from_id[$id]:-$id_user}
	ShellBot.unbanChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_reply_to_message_new_chat_participant_id[$id]:-$id_user}
}

adeus(){
	ShellBot.leaveChat --chat_id ${message_chat_id[$id]}
}

animacao(){
	ShellBot.sendAnimation --chat_id ${message_chat_id[$id]} --animation ${1} ${2}
}

fixar(){
	ShellBot.pinChatMessage	--chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]} || {
		mensagem="eu não tenho poder administrativo aqui, ou não tenho todas as permissões de administradora para FIXAR MENSAGENS aqui, se desejar que eu continue, me dê poderes administrativos necessários para eu , irei tentar novamente em 2 minutos."
		escrever
		enviar
		sleep 2m
		ShellBot.pinChatMessage	--chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}
	}
}

desafixar(){
	ShellBot.unpinChatMessage --chat_id  ${message_chat_id[$id]} --message_id ${message_message_id[$id]}
}

fixar_ref(){
	ShellBot.pinChatMessage	--chat_id ${message_chat_id[$id]} --message_id ${message_reply_to_message_message_id[$id]} || {
		mensagem="eu não tenho poder administrativo aqui, ou não tenho todas as permissões de administradora para FIXAR MENSAGENS aqui, se desejar que eu continue, me dê poderes administrativos necessários para eu operar, , irei tentar novamente em 2 minutos."
		escrever
		enviar
		sleep 2m
		ShellBot.pinChatMessage	--chat_id ${message_chat_id[$id]} --message_id ${message_reply_to_message_message_id[$id]}
	}
}

fixarbot(){
	ShellBot.pinChatMessage	--chat_id ${message_chat_id[$id]} --message_id ${return[message_id]} || {
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
	user_id=${callback_query_message_message_id[$id]}
	outro_chat_id=${callback_query_message_chat_id[$id]}
	[[ ${1} ]] && {
		ShellBot.deleteMessage --chat_id ${message_chat_id[$id]:-$outro_chat_id} --message_id ${1}
	} || {
		ShellBot.deleteMessage --chat_id ${message_chat_id[$id]:-$outro_chat_id} --message_id ${return[message_id]:-$user_id}
	}
}

deletar(){
	delet=${message_message_id[$id]}
	ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${message_left_chat_participant_id[$id]:-$delet}
}

deletar_ref(){
	ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${message_reply_to_message_message_id[$id]}
}

audio(){
	valor=$((${2}/3))
	repetir=0
	while :
	do
    	[[ "$repetir" -ge "$valor" ]] && break;
		repetir=$((repetir+1))
   		ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action record_audio
   		sleep 3s
	done
	ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action upload_audio
	ShellBot.sendAudio --chat_id ${message_chat_id[$id]} --audio @${1} ${3}
}

scope(){
	valor=$((${2}/3))
	repetir=0
	while [[ $repetir -lt $valor ]]; do
    	repetir=$((repetir+1))
   		ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action record_video_note
	sleep 3s
	done
	ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action upload_video_note
	ShellBot.sendVideoNote --chat_id ${message_chat_id[$id]} --video_note @${1} ${3}
}

#determinação de gênero textual para sujeito
#ex: envio a palavra "ventilador", ele retorna: o|com|no ventilador.
# e os plurais também: os|uns|nos ventiladores
#-------------------------------------------------------------
genero(){
    parser=$[${#2}-2]
    compare=${2:$parser:2}

    [[ ${1} = 1 ]] && {
    	[[ "${compare}" =~ (a|ã|â|á) ]] && saida="a" || {
			parser2=$[${#2}-3]
			compare2=${2:$parser2:3}
			[[ "${compare2}" =~ (a|ã|â|á) ]] && {
				saida="a"
    		} || saida="o"
    	}
    }

    [[ ${1} = 2 ]] && {
        [[ "${compare}" =~ (a|ã|â|á) ]] && saida="na" ||  {
            parser2=$[${#2}-3]
            compare2=${2:$parser2:3}
            [[ "${compare2}" =~ (a|ã|â|á) ]] && {
                    saida="na"
            } || saida="no"
        }
    }

    [[ ${1} = 3 ]] && {
        [[ "${compare}" =~ (a|ã|â|á) ]] && saida="uma" ||  {
            parser2=$[${#2}-3]
            compare2=${2:$parser2:3}
            [[ "${compare2}" =~ (a|ã|â|á) ]] && {
                    saida="uma"
            } || saida="um"
        }
    }

    # adição de plurais
    parser3=$[${#2}-1]
    compare3=${2:$parser3:1}
    [[ "${compare3}" = "s" ]] && {
        [[ "${1}" = 3 && "${saida}" = "um" ]] && {
            saida="uns"
        } || saida="${saida}s"
    } || saida="${saida}"
}
#-------------------------------------------------------------

# FUNÇÃO DE DETECÇÃO DE FLOOD
checkcontinuity() {
	[[ ${message_reply_to_message_from_id[$id]} ]] || {
		ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
		Ids=$(< check/${message_chat_id[$id]}.lil)
		[[ "${return[status]}" = "administrator" || "${return[status]}" = "creator" ]] || {
			[[ "$Ids" = *"${message_from_id[$id]}"* ]] && {
				echo ".${message_from_id[$id]}:" >> check/${message_chat_id[$id]}.lil

				quantidade=0
				while read linha;do
					[[ $linha ]] && quantidade=$((quantidade+1))
				done < check/${message_chat_id[$id]}.lil

				[[ $quantidade = 3 && ${#message_text[$id]} -ge 1 && ${#message_text[$id]} -le 5 ]] && {

	 				[[ "${message_from_username[$id]}" ]] && {
						mensagem="@${message_from_username[$id]}, faça favor de juntar suas mensagens, mensagens com poucos caracteres acima de 3 seguidas, ja é um flood, saiba que ENTER não é vírgula, respeito por favor."
						enviar
					}
					[[ "${message_from_username[$id]}" ]] || {
						mensagem="${message_from_first_name[$id]}, faça favor de juntar suas mensagens, mensagens com poucos caracteres acima de 3 seguidas, ja é um flood, saiba que ENTER não é vírgula, respeito por favor."
						responder
					}
					sleep 1m
					deletarbot
				}

				[[ $quantidade = 5 ]] && {
					[[ "${message_from_username[$id]}" ]] && {
						mensagem="@${message_from_username[$id]}, cuidado com o flood, você será banido se continuar."
						enviar
					} || {
						mensagem="${message_from_first_name[$id]}, cuidado com o flood, você será banido se continuar."
						responder
					}
					sleep 1m
					deletarbot
				}

				[[ $quantidade -ge 7 ]] && {
					mensagem="você floodou, até."
					responder
					banir
					> check/${message_chat_id[$id]}.lil
					sleep 1m
					deletarbot
				}
			}
		}
		[[ "$Ids" = *".${message_from_id[$id]}:"* ]] || echo ".${message_from_id[$id]}:" > check/${message_chat_id[$id]}.lil
	}
}

edit="--parse_mode markdown"

#verificar se banco de dados existe, se não tiver, ele será criado
Create_database

[[ -a up.txt ]] || > up.txt
[[ -a guia ]] || mkdir guia
[[ -a abudabi ]] || mkfifo abudabi

update(){
	exec 3>&-
	exec "${0}"
}

[[ "$(< up.txt)" = "atualize" ]] && {
	echo "avisando para desligamento ..."
	echo "desliga" > up.txt
	echo $(< abudabi)
}

[[ -a nexus ]] || mkfifo nexus

while :
do

[[ "$(< up.txt)" = "desliga" ]] && {
	echo "desligando ..."
	> up.txt
	echo "morrendo" > abudabi
	exit
}

ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 5

###################################################
#                                                 #
#   algumas variáveis precisam ficar daqui para   #
#   baixo, pois são individuais para cada         #
#   solicitação.                                  #
#                                                 #
###################################################

# verificar horário em thread
(
	[[ "$(date +%H:%M)" =~ (06|12|18|24)\:00 && -a nexus ]] && {
		#evitar que seja acionado novamente
		rm nexus
		./multicast.sh
		lista="$(< consulta.lil)"
		data=$(date +%D)
		while IFS=':' read F1 F2 F3 F4 F5 F6; do
			(
				IFS=';' read D1 D2 D3 D4 <<< "${F6}"

				while IFS=';' read C1 C2 C3;do
					[[ "${D1}" = "${C1}" ]] && {
						D1="${D1};${C2}" 
						T1=${C3%%\/*}
					}
					[[ "${D2}" = "${C1}" ]] && {
						D2="${D2};${C2}"
						T2=${C3%%\/*}
					}
					[[ "${D3}" = "${C1}" ]] && {
						D3="${D3};${C2}"
						T3=${C3%%\/*}
					}
					[[ "${D4}" = "${C1}" ]] && {
						D4="${D4};${C2}" 
						T4=${C3%%\/*}
					}
				done <<< "${lista}"

				anexo=''
				ShellBot.InlineKeyboardButton --button 'anexo' --line "1" --text "${D1%;*}" --callback_data "notinterpret" --url "${D1#*;}"
				ShellBot.InlineKeyboardButton --button 'anexo' --line "2" --text "${D2%;*}" --callback_data "notinterpret" --url "${D2#*;}"
				ShellBot.InlineKeyboardButton --button 'anexo' --line "3" --text "${D3%;*}" --callback_data "notinterpret" --url "${D3#*;}"
				ShellBot.InlineKeyboardButton --button 'anexo' --line "4" --text "${D4%;*}" --callback_data "notinterpret" --url "${D4#*;}"

				keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'anexo')"

				D1=${D1%;*} ; D2=${D2%;*} ; D3=${D3%;*} ; D4=${D4%;*}

				T1=${T1%%-*} ; T1=${T1%%|*} ; T1=${T1//\;/ } ; T1=${T1//\_/ }
				T2=${T2%%-*} ; T2=${T2%%|*} ; T2=${T2//\;/ } ; T2=${T2//\_/ }
				T3=${T3%%-*} ; T3=${T3%%|*} ; T3=${T3//\;/ } ; T3=${T3//\_/ }
				T4=${T4%%-*} ; T4=${T4%%|*} ; T4=${T4//\;/ } ; T4=${T4//\_/ }

				layout="*${F5//_/ }*\n\n"
				layout+="notícias da *.:newslettercast:.*\n"
				layout+="*❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱*\n\n"
				layout+="*${D1^}:*\n"
				layout+="  ። ${T1}\n\n"
				layout+="*${D2^}:*\n"
				layout+="  ። ${T2}\n\n"
				layout+="\n*${D3^}:*\n"
				layout+="  ። ${T3}\n\n"
				layout+="*${D4^}:*\n"
				layout+="  ። ${T4}\n\n"
				layout+="*❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱*\n"
				layout+="—————(${data})—————\n"
				layout+="BY: @engenhariade\_bot\n"
				layout+="se quiser fazer uma doação, pix: eduardamonteiro@telegmail.com 👀"
				ShellBot.sendAudio --chat_id "${F2}" --audio "@podcast/newslettercast_${F1}.mp3" --title "newslettercast de ${F5//_/ }" --caption "${layout}" --reply_markup "$keyboard1" --parse_mode markdown
				#avisar que não foi enviado, com um marcador de pré aviso
				#[[ "$?" = 1 ]] &&
			)&
		done < fontes.ref

		#permitir ser reativado após a conclusão
		mkfifo nexus
	}
)&

#--- informação para saber a quem deve responder ---#
resp="--reply_to_message_id ${message_message_id[$id]}"

for id in $(ShellBot.ListUpdates)
		do
			(
			minusc=${message_text[$id],,}
			[[ ${message_caption[$id]} ]] && minusc=${message_caption[$id],,}

			[[ -a lista_negra.lil ]] || > lista_negra.lil
			while read linha;do
				[[ ${linha} ]] && {
					[[ "${minusc}" = *"${linha}"* || ${message_from_username[$id]} = "${linha}" || ${message_from_id[$id]} = "${linha}" ]] && {
       	            	deletar &
						deletar_ref &
						banir
					}
				}
			done < lista_negra.lil &

			mencionar=0 #controle de menções

			[[ "${message_from_id[$id]}" = "${ID_DONO}" ]] && {
				[[ "${message_text[$id]}" = *"/vida"* ]] && {
					deletar
					mensagem="ativa"
					enviar
					sleep 1s
					deletarbot
				}

				[[ "${message_text[$id]}" = *"/comando"* ]] && {
                    deletar
					IFS=' ' read f1 f2 <<< "${message_text[$id]}"
					mensagem="saida:\n$($f2)"
					enviar
                }

                [[ "${message_text[$id]}" = "/registro"* ]] && {
					IFS=' ' read f1 f2 <<< "${message_text[$id]}"
					[[ ${f2} ]] && {
						deletar
						echo "${f2,,}" >> lista_negra.lil
						mensagem="ítem adicionado na lista."
						enviar
					}

					[[ ${f2} ]] || {
						[[ "${message_reply_to_message_from_id[$id]}" ]] && {
							deletar
							echo "${message_reply_to_message_from_id[$id]}" >> lista_negra.lil
							mensagem='ítem adicionado na lista.'
							enviar
						} || {
							mensagem='o idiota, adicione o registro na frente do comando ô retardado.'
							enviar
						}
					}
					sleep 5s
					deletarbot
                }

                [[ "${message_text[$id]}" = "/noregistro"* ]] && {
					IFS=' ' read f1 f2 <<< "${message_text[$id]}"
					[[ ${f2} ]] && {
						deletar
						sed -i "${f2}" lista_negra.lil
						mensagem="ítem removido da lista."
						enviar
					} || {
						[[ ${message_reply_to_message_message_id[$id]} ]] && {
							deletar
							echo "${message_reply_to_message_message_id[$id]}" >> lista_negra.lil
						} || {
							mensagem='o idiota, adicione o registro na frente do comando ô retardado.'
							enviar
						}
					}
                }

                [[ "${message_text[$id]}" = *'/atualizar'* ]] && {
                	mensagem="atualizando"
                	enviar
                	echo "atualize" > up.txt
                	update
                }

                [[ "${message_text[$id]}" = *"/desligar"* ]] && {
					deletar
					mensagem="desligando ..."
					enviar
                    init 0
					systemctl poweroff -i
                }

                [[ "${message_text[$id]}" = *"/reiniciar"* ]] && {
					deletar
					mensagem="reiniciando ..."
					enviar
					sudo init 6
					sudo reboot now
                    }

                [[ "${message_text[$id]}" = *"/memoria"* ]] && {
					deletar
                    mensagem=$(free)
					enviar
                }

                [[ "${message_text[$id]}" = *"/sair"* ]] && {
                	deletar
					adeus
                }

                [[ "${message_text[$id]}" = *"/aviso"* ]] && {
					#IFS=' ' read F1 F2 <<< ${message_text[$id]}
					tratamento=${message_text[$id]#\/aviso*}
					tratamento=${tratamento//\\\"/\"}

					mensagem="enviando alerta em massa ..."
					enviar

			        cd dados

					set +f
				    for i in *;do
				    	(
							tratando=$(sed 's/^a/-/' <<< "${i}")
							chat_banco=$(tr 'a-z' '0-9' <<< "${tratando%.*}")

							ShellBot.sendMessage --chat_id "${chat_banco}" --text "${tratamento}" --parse_mode markdown && sucesso=true
							[[ ${sucesso} = true ]] && {
								[[ "${message_text[$id],,}" =~ \#(important|pin|fix) ]] && ShellBot.pinChatMessage	--chat_id "${chat_banco}" --message_id ${return[message_id]}
							}

#							[[ ${sucesso} ]] || {
#								ShellBot.leaveChat --chat_id "${chat_banco}" &
#								rm -rf ${i}
#							}
						)&
				    done

				    cd ..
		  			mensagem="alerta enviado a todos com sucesso!"
		  			enviar
                }

                [[ "${message_text[$id]}" = *"/usuarios"* ]] && {
                	deletar
                	quantidade=$(ls dados | wc -l)
                	mensagem="tem $quantidade usuários atualmente."
                	enviar
                	sleep 4s
                	deletarbot
                }
			}

			#--- se usuário enviar mensagem ao entrar, será removido da lista de banimento ---#
			#--- e sendo usado como gancho para o antiflood inteligente
			[[ -a novomembro.txt ]] && > novomembro.txt
			(
				#verificar padrões da mensagem para golpistas
				fgrep -q "${message_from_id[$id]}" novomembro.txt && {
					[[ ${minusc,,} =~ (🤑|💸|r?\$|💰|⚠️|✅) && ${minusc} =~ [0-9]{1,} ]] && {
						banir &
                        deletar &
                        mensagem="golpista/scan banido"
						enviar
						sleep 6s
						deletarbot
					}
				}

				#verificar se ele esta no banco, e verificar se ele enviou algum spam
				sed -i "/${message_from_id[$id]}/d" novomembro.txt
				#verificar se a pessoa está floodando ou não
				Consulta_table iflood
				[[ "${valor}" = "1" ]] && {
					checkcontinuity &
				}
			)&

			#--- função teste para banir membros globalmente antes de entrar. ---#
			#	[[ -a bombardear.lil ]] && echo "" > bombardear.lil
			#		while read linha;do
			#		[[ "${message_from_username[$id]}" = "$linha" ]] && {
			#			banir
			#			mensagem="este usuário está configurado para banimento global, ele foi denunciado por algo em algum lugar por alguém. nada mais a saber, para desbanir ou pedir redenção, entre no chat do nosso guardião julgador, conte seu relato e provas, e ele baterá o martelo e decidir quem é inocente ou culpado. \n https://t.me/joinchat/KMg9nxptCrcWOygzBeO_Ag"
			#			responder
			#		}
			#	done < bombardear.lil

			#--- BOAS-VINDAS ---#
			[[ ${message_new_chat_member_id[$id]} ]] && {
				Consulta_table boasvindas
				boas_vindas=${valor}

				[[ ${message_new_chat_participant_is_bot[$id]} = "true" && "#${message_new_chat_participant_id[$id]}#" != "#865837947#" ]] && {
					boas_vindas=0
					mensagem="oh, um bot, bora testar OwO"
					enviar
					mensagem="/start@${message_new_chat_member_username[$id]}"
					responder
				}

				[[ "#${message_new_chat_participant_id[$id]}#" = "#${return[id]}#" ]] && {
					boas_vindas=0
					mensagem="oiii, obrigada por me adicionarem ao seu grupo ou ... canal."
					enviar
					mensagem="preciso que me configurem para meu funcionamento.\ncomeçando por: admin. é necessário para eu gerenciar o grupo. em seguida, me enviem o comando /configurar para verem minhas opções, e para ver o status de ativação delas, envie /status. boa sorte."
					enviar
				}

			[[ "$boas_vindas" = "1" ]] && {
				echo "${message_new_chat_participant_id[$id]}" >> novomembro.txt

				#gerar apelido:
				[[ ${message_new_chat_member_username[$id]} ]] && {
					apel="@${message_new_chat_member_username[$id]}"
				} || {
					apel="${message_new_chat_member_first_name[$id]:0:2}"
					[[ ${apel,,} =~ ^.(a|e|i|o|u) ]] || apel="${message_new_chat_member_first_name[$id]:0:3}"
					apel="${apel}${apel,,}"
				}
				mensagem="oi ${apel}, tudo bem ?"
				escrever
				enviar
				mensagem=''
				nome=$[$RANDOM%11]
				case $nome in
					0)
						mensagem+='tem alguma habilidade relacionada ao tema do grupo que gostaria de compartilhar ? :3'
					;;
					1)
						mensagem+='poderia nos contar um pouco sobre você e seus objetivos aqui ? (se tiver algum e quiser compartilhar conosco ;D)'
					;;
					2)
						mensagem+='você sabe algo sobre o tema deste grupo ou está estudando alguma relacionada ? :v'
					;;
					3)
						mensagem+='sinta-se a vontade :), possui alguma habilidade relacionda ao tema deste grupo ?'
					;;
					4)
						mensagem+="você está estudando alguma coisa sobre o tema deste grupo ?"
					;;
					5)
						mensagem+='quais habilidades você poderia compartilhar conosco ? :v'
					;;
					6)
						mensagem+='esta estudando alguma coisa interessante ? :3'
					;;
					7)
						mensagem+="quais são seus interesses pelo tema deste grupo, ${message_new_chat_member_first_name[$id]} ?, poderia compartilhar conosco :3 ?"
					;;
					8)
						mensagem+='você tem alguma afinidade com o tema deste grupo ou ainda está descobrindo alguma coisa que você se identifique melhor ?'
					;;
					9)
						mensagem+='seu nome é interessante, o que você sabe sobre o tema deste grupo ?, ou está em busca de algo novo e ainda não sabe muita coisa ? :v'
					;;
					10)
						mensagem+='conte-nos um pouco sobre você. está estudando alguma coisa relacionada ao tema deste grupo ? '
		 			;;
					11)
						mensagem+='o que você esta aprendendo atualmente relacionado ao tema deste grupo ?'
					;;
				esac
				escrever
				responder
				sleep 30s
				fgrep -q "${message_new_chat_participant_id[$id]}" novomembro.txt && {
					#salvar envio anterior para deletar
					user_id=${callback_query_message_message_id[$id]}
					param=${return[message_id]:-$user_id}

					[[ ${message_new_chat_members_username[$id]} ]] && {
						mensagem="@${message_new_chat_member_username[$id]}, preciso que você interaja conosco, temos que saber se você não é um spammer ou um bot. você tem 10 minutos para enviar alguma mensagem, não queremos te perder :3"
						escrever
						enviar
					}
					[[ ${message_new_chat_members_username[$id]} ]] || {
						mensagem="fale algo ${message_new_chat_member_first_name[$id]}, eu preciso saber se você não é um spammer ou um bot, pois terei que remover você infelizmene caso não responda em 10 minutos."
						escrever
						responder
					}

					for((rodada=0;rodada<=120;rodada++));do
						sleep 5s
						while read -r linha;do
							[[ "${linha}" = "${message_new_chat_participant_id[$id]}" ]] && {
								persistencia=1
							}
						done < novomembro.txt
						[[ ${persistencia} -eq 1 ]] || {
							deletarbot
							persistencia=1
							break
						}
					done
				}

				fgrep -q "${message_new_chat_participant_id[$id]}" novomembro.txt && {
					deletarbot &
					deletarbot "${param}" &

					ShellBot.kickChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_new_chat_participant_id[$id]}
					[[ ${message_new_chat_members_username[$id]} ]] && {
						mensagem="removi @${message_new_chat_members_username[$id]}, não respondeu na entrada, '-'"
					}
					[[ ${message_new_chat_members_username[$id]} ]] || {
						mensagem="removi ${message_new_chat_member_first_name[$id]}, por não ter falado nada, infelizmente"
					}
					enviar
					sleep 1m
					deletarbot
				}

				fgrep -q "${message_new_chat_participant_id[$id]}" novomembro.txt && {
					sed -i "/${message_new_chat_member_first_name[$id]}/d" novomembro.txt
				} || {
					[[ ${message_new_chat_members_username[$id]} ]] && {
						mensagem="@${message_new_chat_members_username[$id]}"	
					}
					[[ ${message_new_chat_members_username[$id]} ]] || {
						mensagem="${message_new_chat_member_first_name[$id]}"
					}
					mensagem+=", fique a vontade para fazer perguntas e tirar dúvidas :3,"
					Consulta_table channel
					[[ "$valor" = "0" ]] || mensagem+="dê uma olhada em nosso acervo\canal do grupo: \n $valor"
					Consulta_table regra
					[[ "$valor" = "0" ]] || mensagem+="\n e nas regras:\n regras:\n $valor"
					mensagem+=" espero que te ajudemos no que procura :)"
					responder
				}
			}
		} &

#--------------- DETECTOR DE SPAMMERS POR IMAGEM, VÍDEO, GIF e STICKERS ---------------#
			[[ ${message_sticker_thumb_file_id[$id]} ]] && file_id=${message_sticker_thumb_file_id[$id]} && spammer=1
			[[ ${message_document_thumb_file_id[$id]} ]] && file_id=${message_document_thumb_file_id[$id]} && spammer=1
			[[ ${message_video_thumb_file_id[$id]} ]] && file_id=${message_video_thumb_file_id[$id]} && spammer=1
			[[ ${message_photo_file_id[$id]} ]] && file_id=${message_photo_file_id[$id]} && spammer=1
			[[ $spammer -eq 1 ]] && {
				spammer=0
				Consulta_table spammers
				detectar_spammers_fotos=$valor
				[[ "$detectar_spammers_fotos" = "1" ]] && {
					file_id=($file_id)
					file_id=${file_id##*\|}
					ShellBot.getFile --file_id $file_id
					ShellBot.downloadFile --file_path ${return[file_path]} --dir $PWD
					file_id=''
					arquivo=${return[file_path]##*/}
					banir=0
					[[ $banir -eq 1 ]] && {
						banir=0
						banir
						deletar
						mensagem="bani um spammer :3"
						enviar
						sleep 10s
						deletarbot
					} || {
						extrair_resultado=$(curl -s -F "image=@${arquivo}" -H "api-key: ${token_porn}" https://api.deepai.org/api/nsfw-detector)
						nome=$(jq '.output.detections[].name' <<< "$extrair_resultado")
						[[ "$nome" = *'credits'* ]] || {
							certeza=$(jq '.output.nsfw_score' <<< "$extrair_resultado")
							classificador=''
							[[ "${nome,,}" = *"breast"* ]] && classificador+="mamilo "
							[[ "${nome,,}" = *"genitalia"* ]] && classificador+="genital "
							[[ "${nome,,}" = *"buttocks"* ]] && classificador+="nadega "
							[[ "${nome,,}" = *"covered"* ]] && classificador+="coberta, mas decote visível. "
							[[ "${nome,,}" = *"exposed"* ]] && classificador+="exposta."
							[[ "$classificador" && "${certeza:2:2}" > "49" || "${certeza:2:2}" > "60" ]] && {
								deletar
								mensagem="@admin, *conteúdo pornográfico encontrado*\n\n*detectado (gênero removido):*\n${classificador:-não identificado}\n"
								classificador=''
								[[ ${message_from_username[$id]} ]] && mensagem+="\n usuário: @${message_from_username[$id]}"
								[[ ${message_from_username[$id]} ]] || mensagem+="\n usuário: ${message_new_chat_member_first_name[$id]}"
								enviar "$edit"
								sleep 5m
								deletarbot
							}
						}
					}
					rm -rf $arquivo
					file_id=''
					classificador=''
				}
				rm -rf $arquivo
			}

#--------------- transcrição de audio ---------------#
			[[ ${message_voice_file_id[$id]} ]] && {
				file_id=(${message_voice_file_id[$id]//|/ })
				file_id=${file_id[0]}
				download_audio=0
				ShellBot.getFile --file_id $file_id
				ShellBot.downloadFile --file_path ${return[file_path]} --dir $PWD/audio
				file_id=''
				arquivo=${return[file_path]##*/}
				name_audio=${return[file_path]##*/}
				name_audio=${name_audio%%.*}

				#convertendo o audio
				ffmpeg -i audio/$arquivo -r 48k audio/${name_audio}.flac
				rm -rf audio/${arquivo} &

				#separando fragmentos
				sox -V3 audio/${name_audio}.flac audio/${name_audio}_.flac silence -l  1 0.3 0.1%   1 0.3 0.1% : newfile : restart #1 0.2 0.3% 1 0.2 0.3% : newfile : restart
				rm -rf audio/${name_audio}.flac &

				texto=''
				set +f

				#buscar o último e deletar || ao mesmo tempo que edita para melhor transcrição
				for envio in audio/${name_audio}_*flac;do
					sox audio/silencio.wav ${envio} audio/silencio.wav "${envio%.*}.wav"
					ffmpeg -y -i "${envio%.*}.wav" "${envio%.*}.flac"
					rm -f "${envio%.*}.wav"
				#	ultimo=${envio}
				done
				#rm -f ${ultimo}

				for envio in audio/${name_audio}_*flac;do
					transcricao=$(curl -s -X POST --data-binary @${envio} --user-agent 'Mozilla/5.0' --header 'Content-Type: audio/x-flac; rate=48000;' "https://www.google.com/speech-api/v2/recognize?output=json&lang=pt-BR&key=AIzaSyBOti4mM-6x9WDnZIjIeyEU21OpBXqWBgw&client=Mozilla/5.0" | jq '.result[].alternative[].transcript')
					rm -f "${envio}" &

					while read linha;do
						texto=${linha//\"/}
					done <<< "${transcricao,,}"

					texto_final+=${texto:+$texto\,\ }
				done
				set -f
				texto_final=${texto_final%\,*}

				texto_final="${texto_final:+$texto_final.}"

				#aplicando filtro de comandos:
				texto_final=${texto_final//vírgula/\,}
				texto_final=${texto_final// ponto final/\.}
				texto_final=${texto_final// ponto interrogação/\?}
				texto_final=${texto_final// ponto de interrogação/\?}
				texto_final=${texto_final// dois pontos/\:}
				texto_final=${texto_final// nova linha/\\n }
				texto_final=${texto_final// novo paragrafo/\\n\\n   }
				texto_final=${texto_final// paragrafo/\\n\\n   }
				texto_final=${texto_final// abre aspas/\"}
				texto_final=${texto_final// fecha aspas/\"}
				texto_final=${texto_final// reticencias/\.\.\.}
				texto_final=${texto_final//\,\,/\,}
				texto_final=${texto_final//\.\./\.}

				Consulta_table audios
				transcrever_audio=$valor
				ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
				[[ "$transcrever_audio" = "1" || "${return[status]}" = "member" ]] && {
					[[ ${texto_final} ]] && {
						mensagem="escrita:\n${texto_final}"
						responder
					} || {
						while read -r linha; do
							frase+=( "${linha}" )
						done <<< $(printf "%s\n" não\ {consegui,pude}\ {ouvir,entender,escutar}\ {nada\ d,}o\ audio.)
						mensagem="${frase[$[$RANDOM%${#frase[@]}]]}"
						escrever
						responder
					}
				}
				unset mensagem transcricao
				minusc=${texto_final,,}
				}

			[[ -a enviando.txt ]] || > enviando.txt
			[[ $(fgrep "${message_from_id[$id]}" enviando.txt) ]] && {
				[[ ${message_photo_file_id[$id]} || ${message_document_file_id[$id]} ]] && {
					echo ${message_photo_file_id[$id]}${message_document_file_id[$id]} >> arquivos.${message_from_id[$id]}
				}
			}

#--------------- parte de análise de padrões de fala, para tomar medidas e ações ---------------#
			casar=0
			[[ "$minusc" = "/start"* && "${casar}" = "0" ]] && {
				casar=1
				mensagem="olá, sou a mikosumabot (miko), mais conhecida como eduarda monteiro (duda). interpreto linguagem natural para gerenciar grupos com base em conversas, sou configurada por conversa natural, e gerenciamento por análise comportamental e falas naturais. para me configurar, me adicione como admin em um grupo, e para exibir minhas funções e sanar algumas dúvidas, envie /configurar no grupo que deseja me configurar."
				mensagem+="\n\ne para saber mais sobre como funciono, envie: /helpduda"
				mensagem+="\n\nse quiser ver uma lista das minhas hailidades, envie: /habilidades"
				mensagem+="\n\npara ver minhas ferramentas de produção de conteúdo automático, e outros recursos pagos e incríveis, envie: /ferramentas"
				enviar
			}

			[[ "${minusc%%@*}" = "/configurar" && "${casar}" = "0" ]] && {
				casar=1
				ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
				[[ "${return[status]}" =~ (administrator|creator|member) ]] && dita=1
				[[ "$dita" = "1" ]] && {
				dita=0
					deletar
					mensagem="os comandos são seguidos do nome, e isso altera meu funcionamento e comportamento:\n"
					mensagem+="\nditadura: /ditadura"
					mensagem+="\nmencionar: /mencionar"
					mensagem+="\nboas vindas: /boasvindas"
					mensagem+="\nspammers: /spammers"
					mensagem+="\ntranscrever audios: /audio"
					mensagem+="\nmenções por nome: /nome"
					mensagem+="\nfixar mensagens: /fixar"
					mensagem+="\nbom dia, tarde, noite: /bomdia"
					mensagem+="\nanti-flood inteligente, padrão (7) /iflood"
#					mensagem+="\n/doar <valor a doar OBS: acima de 5,50 R$, é o mínimo permitido pela plataforma>"
					mensagem+="\na maioria das opções são desativados por padrão."
					mensagem+="\nenvie /doar e eu mando meu pix :D"
					enviar
					sleep 1m
					deletarbot
				}

				[[ "$dita" = "0" ]] || {
					mensagem="você não é administrator '-', então não posso te conceder acesso, talvez futuramente se conseguir ajudar este grupo o suficiente para virar admin :v"
					escrever
					responder
					sleep 10s
					deletarbot &
					deletar
				}
			}

			#----------- AO PARTICIPANTE SAIR, MENSAGEM DE SAIDA SERÁ REMOVIDA ---------#
			[[ "${message_left_chat_participant_id[$id]}" ]] && {
				deletar
			}

			[[ "${minusc}" =~ (miko(suma)?|duda|e?du(ar)?da).*((\/)?ban(e|ir)|remov(a|e)r?) && "${casar}" = "0" ]] && {
				comparar="${BASH_REMATCH[0]}"
				casar=1
				ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
				[[ "${return[status]}" =~ (administrator|creator) ]] && dita=1
				[[ "${dita}" = "1" ]] && {
					(
						deletar
					)&

					[[ "${minusc}" =~ \@[^(\ |$)]* ]] && {
						banir "${BASH_REMATCH[0]}." &
					} || {
						banir_ref &
					}

					enviar

					[[ "${comparar}" = *"remove"* ]] && {
						desbanir
					}

					#prevenir saída caso não tiver sido permitida a realizar banimentos.
					(
						[[ "${comparar}" = *"remove"* ]] && {
							mensagem="removido!"
						} || {
							mensagem="banido!"
						}
						enviar

						(
							sleep 3s
							deletarbot
						)&
						(
							deletar_ref
						)&
					)&
					dita=0
				}

				[[ "${dita}" = "0" ]] || {
					mensagem="não posso receber suas ordens ainda, pois ... você não é administrador."
					escrever
					responder
					sleep 10s
					deletarbot &
					deletar
				}
			}

			[[ "$minusc" = "/helpduda"* && "${casar}" = "0" ]] && {
				casar=1
				mensagem="entre no link abaixo para acessar minha lista de funções e como interagir comigo:\nhttps://telegra.ph/Eduarda-Monteiro--manual-09-20"
				ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$mensagem"
			}

			[[ "$minusc" = "/inicio"* && "${casar}" = "0" ]] && {
				casar=1
				mensagem="ok, agora mande seus arquivos para eu postar eles lá no chat principal :3"
				enviar
				echo "${message_from_id[$id]}" >> enviando.txt
			}

			[[ "$minusc" = "/fim"* && "${casar}" = "0" ]] && {
				casar=1
				[[ $(fgrep "${message_from_id[$id]}" enviando.txt) ]] && {
					ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "enviando arquivos para o Programando em ..."
					while read linha
					do
						ShellBot.sendDocument --chat_id -1001181530043 --document "$linha" #mensagem direta ao programando em ...
					done < arquivos.${message_from_id[$id]}
					> arquivos.${message_from_id[$id]}
					> enviando.txt
				}
			}

			[[ "$minusc" = "/habilidade"* && "${casar}" = "0" ]] && {
				casar=1
				mensagem+="\n\n1. atender novos integrantes;"
				mensagem+="\n\n2. fazendo checagens para verificar se são pessoas ou bots durante o processo de entrada;"
				mensagem+="\n\n3. verificar imagens, GIFs, stickers e vídeos para ver se é pornografia, propaganda, discurso de ódio e afins.;"
				mensagem+="\n\nOBS: análise de spans, propagandas e discurso de ódio esta sendo refeita;"
				mensagem+="\n\n4. transcrever áudios e interpretar os áudios;"
				mensagem+="\n\n5. buscar significado de palavras;"
				mensagem+="\n\n6. reconhecer e marcar/fixar dúvidas, dicas e desafios das pessoas;"
				mensagem+="\n\n7. buscar cursos gratuitos nas plataformas de cursos, além de buscas e postagens de conteúdos;"
				mensagem+="\n\nOBS: desativado por partes para recriar de forma mais eficiente;"
				mensagem+="\n\n8. censurar palavrões ou mensagens com um tom de ameaça;"
				mensagem+="\n\n9. criar enquetes por conta própria ( porém pré configuradas, nada de forma automática e autônoma ainda);"
				mensagem+="\n\n10. baixar músicas gratuitas do sondcloud;"
				mensagem+="\n\n11. coletar e categorizar habilidades dos integrantes em uma tabela consultável, o que lhe permite perguntar quem possui tais habilidades, e os nicks são enviados;"
				mensagem+="\n\n12. mandar áudios de forma humana durante interações 'sintetizar textos';"
				mensagem+="\n\n13. criar podcasts por conta própria 'acessar os principais sites, coletar a primeira noticia de cada um deles, resumir com um algoritmo estatístico, elaborar o roteiro, gravar os áudios, editar com sons de transição, músicas de fundo, e realização da postagem' (futuramente será permitido ela criar podcasts individuais para cada canal ou grupo de sua escolha com seus principais sites e assuntos, porém é um recurso que demanda processamento, então será pago);"
				mensagem+="\n\nLINK do canal da duda de postagem de podcasts diários: https://t.me/mikoduda;"
				mensagem+="\n\n14. mandar um vídeo gravado de seu próprio rosto 'diga: duda grava seu rosto';"
				mensagem+="\n\n15. analisar links maliciosos cadastrados em um banco de dados isolado 'e um grupo que te permite ajudar a denunciar e reconhecer estes links: https://t.me/joinchat/Pln8-K6Uwp45OTNh';"
				mensagem+="\n\n16. evitar flood dos membros, dando alguns avisos caso a pessoa escreva de forma picotada, ou esteja chegando perto do limite;"
				mensagem+="\n\n17. responder a menção ao seu nome ou apelido 'o que permite você perguntar algumas coisas ou conversar brevemente com ela ...';"
				mensagem+="\n\n18. interagir com bom dia, tarde e noite;"
				mensagem+="\n\n19. fazer leves brincadeiras (alterado para formas normais de respostas);"
				mensagem+="\n\n20. resumir textos de mensagens (um recurso para resumir links , livros e documentos e em massa esta sendo desenvolvido, por demandar muito processamento: será pago, menos esta de resumir mensagens);"
				mensagem+="\n\n21. lhe permite adicionar link de regra e canal, sempre que alguém perguntar sobre ou pedir, ela irá mostrar;"
				mensagem+="\n\n22. você pode pedir para ela criar um podcast no canal dela, porém não é personalizável ou utilizável em outros canais por em quanto;"
				mensagem+="\n\n23. comentários e outros níveis de interações a depender dos tópicos das conversas (se ativado);"
				mensagem+="\n\n34. buscar vídeos no youtube."
				enviar
				sleep 5m
				deletarbot
			}

			[[ "$minusc" = "/ferramenta"* && "${casar}" = "0" ]] && {
				casar=1
				ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
				[[ "${return[status]}" = "member" ]] && {
					valor_mensal="30"
					valor_individual="15"
					options=''
#------------- conforme desmarcar, a opção aparece na mensagem :D -------------#
					ShellBot.InlineKeyboardButton --button 'options' --line 1 --text 'podcasts' --callback_data "compra:podcast:${valor_individual}"
				#	ShellBot.InlineKeyboardButton --button 'options' --line 2 --text 'resumo de livros/sites' --callback_data "compra:resumo:${valor_individual}"
				#	ShellBot.InlineKeyboardButton --button 'options' --line 3 --text 'Combo de recursos' --callback_data "compra:combo:${valor_mensal}"
					keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'options')"

					ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "*selecione a ferramenta a comprar (cada uma em individual: ${valor_individual} por mês, se for combo completo de recursos: ${valor_mensal} por mês. se não gostar do recurso, te damos reembolso, desde que não tenha usado por mais de uma semana):*\n\n*podcast:* receber podcasts diários em seu canal com suas fontes/sites e roteiro. \nexemplo do recurso: [acervo da duda de podcasts](https://t.me/mikoduda)\n\n*resumo de livros/sites:* poder te permitir pedir para a duda resumir links de sites e arquivos de dumentos no geral, em vez de só mensagens de texto simples.\nexemplo do recurso no modo gratuito: [aviso do recurso](https://t.me/mikoduda/1585)\n\n*COMBO:* acesso a todos os recursos.\n\nselecione as opções disponíveis nos botões abaixo, as que não estão aparecendo, estão em construção ou em manutenção:" \
										 --reply_markup "$keyboard1" \
										 --parse_mode markdown

				} || {
					mensagem="você deve escolher isso no meu privado, me envie um /ferramentas por lá para ver as opções ;D"
					enviar
				}
			}

			[[ "${callback_query_data[$id]}" = *"compra"* ]] && {
				IFS=':' read F1 F2 F3 F4 F5 <<< "${callback_query_data[$id]}"
				ShellBot.answerCallbackQuery --callback_query_id "${callback_query_id[$id]}" --text "gerando fatura [ ${F2} ] ..." --show_alert false
				[[ "$F3" ]] && {
					F3="${F3//,/}00"
					[[ "${F2}" = "podcast" ]] && {
						descr='este recurso lhe permite ter podcasts diários personalizados em seu canal criados pela duda.'
						titulo='recurso de criação de podcasts'
						subdesc='podcasts de noticias.'
						URL='https://telegra.ph/file/ad3183c74432bfd3553a0.png'
						photo_width='888'
						photo_height='500'
					}

					[[ "${F2}" = "resumo" ]] && {
						titulo='recurso de resumo de textos'
						descr='este recurso lhe permite resumir livros/documentos, e links de sites com textos muito longos.'
						subdesc='sumarizador de conteúdo.'
						URL='https://telegra.ph/file/e8b1d81e3b40fdca3a25d.png'
						photo_width='976'
						photo_height='549'
					}

					[[ "${F2}" = "combo" ]] && {
						titulo='combo de recursos duda.'
						descr='lhe permite aproveitar todos os recursos pagos de uma só vez e sem limitações.'
						subdesc='combo de recursos'
						URL='https://telegra.ph/file/4be5f4b7b4a30b9a6be00.png'
						photo_width='580'
						photo_height='484'
					}

					objeto_fatura='[{"label": "'${subdesc}'","amount":'${F3//./}'}]'

					curl  --request POST -s "https://api.telegram.org/bot${bot_token}/sendinvoice" \
						  -d chat_id="${callback_query_message_chat_id[$id]}" \
						  -d title="${titulo}" \
						  -d description="${descr}" \
						  -d payload="${F2}:30" \
						  -d provider_token="$token_pay" \
						  -d start_parameter="comprar" \
						  -d currency="BRL" \
						  -d prices="${objeto_fatura}" \
						  -d is_flexible="false" \
						  -d photo_url="$URL" \
						  ${photo_width:+ -d photo_width="$photo_width"} \
						  ${photo_height:+ -d photo_height="$photo_height"}

						# message_successful_payment_invoice_payload = 'dias:15'
				}
			}

				[[ "${pre_checkout_query_id[$id]}" ]] && {
					identificado=0
					[[ -a NNbcc714e1e457b2db7bedb17f438493371b5acec8abbed92686.ahuqdib ]] || > NNbcc714e1e457b2db7bedb17f438493371b5acec8abbed92686.ahuqdib
					while IFS=":" read F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12;do
						[[ "$F1" = "${pre_checkout_query_from_id[$id]}" ]] && {
							identificado=1
							permitir=0
							IFS=':' read C1 C2 <<< "${pre_checkout_query_invoice_payload[$id]}"

							[[ "${C1}" = "podcast" && "${F2%%\;*}" = "podcast" ]] && {
								permitir=1
								curl  --request POST -s "https://api.telegram.org/bot${bot_token}/answerprecheckoutquery" \
									  -d pre_checkout_query_id="${pre_checkout_query_id[$id]}" \
									  -d ok="false" \
									  -d error_message="os dias de uso do recurso de podcats ainda não acabaram, e ainda não permitimos pagamentos adiantados, pois caso ocorra algum problema, teremos que esperar mais tempo para desativar por alguém já ter pago antecipadamente pelo recurso."
							}
							break
						}
					done < NNbcc714e1e457b2db7bedb17f438493371b5acec8abbed92686.ahuqdib

					[[ "$identificado" = 0 ]] && echo "${pre_checkout_query_from_id[$id]}:::::::::::" >> NNbcc714e1e457b2db7bedb17f438493371b5acec8abbed92686.ahuqdib

					[[ "$permitir" = 0 ]] && {
						curl --request POST -s "https://api.telegram.org/bot${bot_token}/answerprecheckoutquery" \
							  -d pre_checkout_query_id="${pre_checkout_query_id[$id]}" \
							  -d ok="true"
					}
				}

			#confirmar pagamento e dar as instruções.
			[[ "${message_successful_payment_provider_payment_charge_id[$id]}" ]] && {
				IFS=':' read C1 C2 <<< "${message_successful_payment_invoice_payload[$id]}"
				while IFS=":" read F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12;do
					[[ "$F1" = "${message_from_id[$id]}" ]] && {
						identificado=1
						[[ "${C1}" = "podcast" ]] && {
							L2="podcast"
							mensagem="🎊parabéns por adquirir o recurso de podcasts🎊:, agora vamos configurar e testar este recurso, o tempo não será gasto até que você termine de configurar o recurso, não importando o tempo que demore.\nenvie: /configurar_podcast\n\ncaso ja tenha configurado anteriormente, não precisa reconfigurar."
							while IFS=':' read F1 F2 F3 F4 F5 F6;do
								[[ "${F1}" = "${message_from_id[$id]}" ]] && {
									sed -i "s/${F1}:${F2}:${F3}:${F4}:${F5}:${F6}/${F1}:${F2}:$(date -d "31 days" +%y-%m-%d):${F4}:${F5}:${F6}/" fontes.ref
									mensagem='a configuração do podcast é opcional, pois você ja configurou anteriormente ;D\ncaso queira mudar, envie /configurar_podcast\n caso houver algum bug qualquer, fale com @fabriciocybershell'
								}
							done < fontes.ref
						}

						[[ "${C1}" = "resumo" ]] && {
							L3="resumo"
							mensagem="🎊parabéns por adquirir o recurso de resumo🎊:, agora você pode me pedir para resumir alguns tipos de documentos e arquivos e links de sites."
						}

						[[ "${C1}" = "combo" ]] && {
							L4="combo"
							mensagem="🎊parabéns por adquirir o combo de recursos🎊:, conforme você for usando alguns dos recursos, alguns que necessitarem de configuração, irei te avisar quando for implementar ou utilizar."
						}

						[[ "${C1}" = "doar" ]] && {
							L5="doar"
							mensagem="🎊MUITO OBRGADA :), lhe agradeço de coração por colaborar com o projeto. isso me motivará ainda mais :D"
						}

						sed -i "s/${F1}:${F2}:${F3}:${F4}:${F5}:${F6}:${F7}:${F8}:${F9}:${F10}:${F11}:${F12}/${F1}:${L2:-$F2}:${L3:-$F3}:${L4:-$F4}:${L5:-$F5}:${L6:-$F6}:${L7:-$F7}:${L8:-$F8}:${L9:-$F9}:${L10:-$F10}:${L11:-$F11}:${L12:-$F12}/" NNbcc714e1e457b2db7bedb17f438493371b5acec8abbed92686.ahuqdib
						break
					}
				done < NNbcc714e1e457b2db7bedb17f438493371b5acec8abbed92686.ahuqdib
				[[ ${mensagem} ]] && enviar || {
					mensagem="nenhuma mensagem de uso ou agradecimento foi definida para este recurso, então apenas ... apriveire ;D"
					enviar
				}
			}

			#verificar se esta rolando uma interação guiada
			user_id=${my_chat_member_from_id[$id]}
			user_id=${callback_query_from_id[$id]:-$user_id}
			[[ -a guia/${message_from_id[$id]:-$user_id}_interagindo.guiado && "${casar}" = "0" ]] && {
				cd guia
				message_id=${my_chat_member_from_id[$id]}
				message_id=${callback_query_message_chat_id[$id]:-$message_id}
				IFS=';' read F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12 <<< $(< ${message_from_id[$id]:-$message_id}_interagindo.guiado)

			 	[[ ${F1} = "podcast"* ]] && {
			 		mensagem="${callback_query_message_text[$id]//\_/\\\_}"
					guia=0
					casar=1
					sites=''

			 		[[ "$minusc" = "/analisa_link"* ]] && {
			 			guia=1
			 			num=1
			 			val=1
			 			mudar_teclado=2
			 			deletar

			 			#guardar os dados da mensagem callback query para editar ela novamente após o processo terminar

			 			mensagem="avaliando link, isso pode demorar um pouquinho dependendo do site, aguarde ..."
			 			enviar

			 			#separar ele por suas barras, e depois pelos pontos, para coletar o nome do domíneo, e trabalhar em cima do link
			 			IFS=' ' read COMMAND LINK <<< "${minusc}"
			 			IFS='/' read L1 L2 L3 L4 L5 <<< "${LINK}"
						IFS='.' read D1 D2 D3 <<< "${L3}"
					    [[ "${D1}" = "www" ]] && dominio="${D2}" || dominio="${D1}"
			 			site=$(curl -is "${L1}//${L3}/")
			 			padr[0]="(${L1}//${L3//./\\.}/)(([0-9]{2}|$(date +%Y))/[0-9]{2}/([0-9]{2}|$(date +%Y))|[0-9]{1,}).*[^\"]*\""
					    padr[1]="(href=\")/.{6,}/([0-9]{2}|$(date +%Y))?[^\"]*\""
					    padr[2]="https?://(${L3}).*/([0-9]{2}|$(date +%Y))/[^\"]*\""
					    padr[3]="(href=\"/).*/.*([0-9]{2,4}).*[a-z]{3,}.*[^\"]*\""
					    padr[4]="<a href=\"https?://(${L3}).*/.*/([0-9]{2}|$(date +%Y))/.*[^\"]*\""

			 			for((i=0;i<=4;i++));do
					        IFS='"' read A1 A2 A3 <<< "$(egrep -o "${padr[$i]}" <<< "${site}")"
					        [[ "${A1}" =~ (http|href) || "${A2}" =~ (http|href) ]] && {
	     						[[ "${A1}" =~ \.(jpg|css|js|png|svg|zip)|(href) || "${A2}" =~ \.(jpg|css|js|png|svg|zip)|(href) ]] || {
	       						   	IFS=' ' read P1 P2 <<< "${A1} ${A2}"
                       				resultado[$i]="[$((i+1))]: ${P1}\n\n"
                       				#resultado[$i]="[$((i+1))]: ${A1} ${A2}\n\n"
	       						   	[[ "$val" = 4 ]] && {
										num=$((num+1))
										val=0
									}
									ShellBot.InlineKeyboardButton --button 'sites' --line ${num} --text "《 $((i+1)) 》" --callback_data "metodo:$((i+1)):${L3}"
									val=$((val+1))
	       			    		}
			       			}
				    	done
				    	mensagem="fiz uma análise, estas foram as que passaram, selecione o número que corresponde ao link da primeira notícia do site, se não entendeu, envie /nop.\n\n *possiveis links:*\n${resultado[@]}"
				    	[[ "${resultado[@]}" ]] || {
				    		mensagem="lamento ... meus algoritmo não foram capazes de analisar este site infelizmente, mas ... ele esta sendo enviado para análise manual e ser adicionado em um momento futuro :D\nmas ... tente outro site de notícia, meus algoritmo são bem avançados em sites levemente padronizados, não desista de tentar."
				    # 		enviar
				    #		sleep 5s
				    #		deletarbot
				    #		teclado_nop=1
				    		deletar_time=1
				    		mudar_teclado=5
				    	}
			 		}

			 		[[ "$minusc" = "/nop" ]] && {
			 	 		mensagem="aqui deveria vir algum vídeo ou tutorial de como usar, ainda não tem, então fale com @fabriciocybershell ;D"
						deletar &
			 			enviar
						sleep 20s
						deletarbot
						teclado_nop=1
						mensagem=''
			 		}

			 		[[ ${callback_query_data[$id]} = "RESET" ]] && {
			 			guia=1
			 			sed -i "s/${F1};${F2};${F3};${F4};${F5};${F6};${F7};${F8};${F9};${F10};${F11};${F12}/podcast;;;;;;;;;;;/" ${message_from_id[$id]:-$message_id}_interagindo.guiado
						mensagem="_selecione os botões de sites na qual você deseja escolher para seu podcast (ao clicar, espere ele processar). instruções serão mostradas após a primeira escolha._"
			 			ShellBot.answerCallbackQuery --callback_query_id "${callback_query_id[$id]}" --text "limpo, agora você pode começar novamente ;D" --show_alert true &
			 		}

			 		[[ ${callback_query_data[$id]} = "erro" ]] && {
			 			guia=1
			 			ShellBot.answerCallbackQuery --callback_query_id "${callback_query_id[$id]}" --text "infelizmente ... isso significa que eu não tenho capacidade ainda para analisar esta fonte. mas ... ela esta sendo encaminhada para análise manual futura ;D" --show_alert true &
			 			deletarbot
			 			teclado_nop=1
			 		}

			 		[[ ${callback_query_data[$id]} = "FINALIZAR" ]] && {

			 			# mudar corpo da mensagem, e mudar a mensagem e botões para  tipo de forma de falar.
			 			mudar_teclado=4
				 		mensagem="*todos os podcasts iniciam com o seguinte roteiro, ex:* \noi, sejam bem vindos ao podcast do 'grupo/canal' 'nome' ...\n\n eu digo grupo ou canal ?"
			 			guia=1
			 		}

			 		[[ ${callback_query_data[$id]} = "mudar_nome"* ]] && {
			 			guia=1
			 			mudar_teclado=5
			 			IFS=":" read name1 name2 <<< "${callback_query_data[$id]}"
			 			IFS=':' read chat1 chat2 <<< "${F1}"
						L1="nome_podcast:${chat2}"
			 			L12="${F12}${name2}"
						sed -i "s/${F1};${F2};${F3};${F4};${F5};${F6};${F7};${F8};${F9};${F10};${F11};${F12}/${L1:-$F1};${L2:-$F2};${L3:-$F3};${L4:-$F4};${L5:-$F5};${L6:-$F6};${L7:-$F7};${L8:-$F8};${L9:-$F9};${L10:-$F10};${L11:-$F11};${L12:-$F12}/" ${message_from_id[$id]:-$message_id}_interagindo.guiado
			 			mensagem="me informe o nome do ${name2}:"
			 		}

			 		[[ ${callback_query_data[$id]} = "metodo"* ]] && {
			 			guia=1
			 			parte=0
			 			IFS=':' read M1 M2 M3 M4 M5 M6 <<< ${callback_query_data[$id]}

			 			[[ ${M4} ]] || {
			 				[[ ${parte} = 0 ]] && {
				 				parte=1
				 				mudar_teclado=3
				 				mensagem="o idioma do site é português ou inglês ?"
			 				}
			 			}

			 			[[ ${M5} ]] || {

			 				[[ ${parte} = 0 ]] && {
				 				parte=1
			 					teclado_retorno=1
			 					teclado_nop=1
			 					guia=0
			 					IFS=':' read P1 P2 P3 P4 <<< "${callback_query_data[$id]}"
								IFS='.' read D1 D2 D3 <<< "${P3}"

   			 					[[ "${D1}" = "www" ]] && dominio="${D2}" || dominio="${D1}"
   			 					L12="${F12}${callback_query_data[$id]}|"

				 				# gravar domínio do site
				 				[[ ${F2} || $guia = 1 ]] || {
				 					guia=1
						 			L2=${dominio}
									sed -i "s/${F1};${F2};${F3};${F4};${F5};${F6};${F7};${F8};${F9};${F10};${F11};${F12}/${L1:-$F1};${L2:-$F2};${L3:-$F3};${L4:-$F4};${L5:-$F5};${L6:-$F6};${L7:-$F7};${L8:-$F8};${L9:-$F9};${L10:-$F10};${L11:-$F11};${L12:-$F12}/" ${message_from_id[$id]:-$message_id}_interagindo.guiado
						 		}

						 		[[ ${F3} || $guia = 1 ]] || {
				 					guia=1
									L3=${dominio}
									sed -i "s/${F1};${F2};${F3};${F4};${F5};${F6};${F7};${F8};${F9};${F10};${F11};${F12}/${L1:-$F1};${L2:-$F2};${L3:-$F3};${L4:-$F4};${L5:-$F5};${L6:-$F6};${L7:-$F7};${L8:-$F8};${L9:-$F9};${L10:-$F10};${L11:-$F11};${L12:-$F12}/" ${message_from_id[$id]:-$message_id}_interagindo.guiado
					 			}

					 			[[ ${F4} || $guia = 1 ]] || {
				 					guia=1
									L4=${dominio}
									sed -i "s/${F1};${F2};${F3};${F4};${F5};${F6};${F7};${F8};${F9};${F10};${F11};${F12}/${L1:-$F1};${L2:-$F2};${L3:-$F3};${L4:-$F4};${L5:-$F5};${L6:-$F6};${L7:-$F7};${L8:-$F8};${L9:-$F9};${L10:-$F10};${L11:-$F11};${L12:-$F12}/" ${message_from_id[$id]:-$message_id}_interagindo.guiado
					 			}

					 			[[ ${F5} || $guia = 1 ]] || {
				 					guia=1
									L5=${dominio}
									sed -i "s/${F1};${F2};${F3};${F4};${F5};${F6};${F7};${F8};${F9};${F10};${F11};${F12}/${L1:-$F1};${L2:-$F2};${L3:-$F3};${L4:-$F4};${L5:-$F5};${L6:-$F6};${L7:-$F7};${L8:-$F8};${L9:-$F9};${L10:-$F10};${L11:-$F11};${L12:-$F12}/" ${message_from_id[$id]:-$message_id}_interagindo.guiado
						 			mudar_teclado=1
					 			}

					 			deletarbot

								mensagem="caso queira de outras fontes, mande o link com o comando /analisa\_link <link>"
			 					[[ ${L5} ]] && {
			 						mensagem+="\n\n❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱\nsites anexados:\n${F2:+\n$F2}${F3:+\n$F3}${F4:+\n$F4}${dominio:+\n$dominio}\n*❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱*"
			 					} || {
			 						mensagem+="\n\n❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱\nsites anexados:\n${F2:+\n$F2}${F3:+\n$F3}${F4:+\n$F4}${dominio:+\n$dominio}"
			 					}
			 					IFS=':' read chat1 chat2 <<< "${F1}"
			 				}
			 			}
			 		}

			 		[[ ${F2} || $guia = 1 ]] || {
			 			guia=1
			 			#L2 nome do site
			 			#L3 nome do site
			 			#L4 nome do site
			 			#L5 nome do site
			 			mensagem="caso queira de outras fontes, mande o link com o comando /analisa\_link <link>"
			 			mensagem+="\n\n❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱\nsites anexados:\n\n${callback_query_data[$id]}"
			 			L1="${F1}:${callback_query_message_message_id[$id]}"
			 			L2="${callback_query_data[$id]}"
			 			sed -i "s/${F1};${F2};${F3};${F4};${F5};${F6};${F7};${F8};${F9};${F10};${F11};${F12}/${L1:-$F1};${L2:-$F2};${L3:-$F3};${L4:-$F4};${L5:-$F5};${L6:-$F6};${L7:-$F7};${L8:-$F8};${L9:-$F9};${L10:-$F10};${L11:-$F11};${L12:-$F12}/" ${message_from_id[$id]:-$message_id}_interagindo.guiado
			 			ShellBot.answerCallbackQuery --callback_query_id "${callback_query_id[$id]}" --text "selecione mais 3 sites, devem ser 4 no total, caso queira adicionar um site de sua escolha, mande o link com o comando /analisa_link <link>" --show_alert true &
			 		}

			 		[[ ${F3} || $guia = 1 ]] || {
			 			guia=1
			 			mensagem+="\n${callback_query_data[$id]}"
			 			L3="${callback_query_data[$id]}"
			 			sed -i "s/${F1};${F2};${F3};${F4};${F5};${F6};${F7};${F8};${F9};${F10};${F11};${F12}/${F1};${L2:-$F2};${L3:-$F3};${L4:-$F4};${L5:-$F5};${L6:-$F6};${L7:-$F7};${L8:-$F8};${L9:-$F9};${L10:-$F10};${L11:-$F11};${L12:-$F12}/" ${message_from_id[$id]:-$message_id}_interagindo.guiado
			 			ShellBot.answerCallbackQuery --callback_query_id "${callback_query_id[$id]}" --text "fonte adicionada: ${callback_query_data[$id]}" --show_alert false &
			 		}

			 		[[ ${F4} || $guia = 1 ]] || {
			 			guia=1
			 			L4="${callback_query_data[$id]}"
			 			sed -i "s/${F1};${F2};${F3};${F4};${F5};${F6};${F7};${F8};${F9};${F10};${F11};${F12}/${F1};${L2:-$F2};${L3:-$F3};${L4:-$F4};${L5:-$F5};${L6:-$F6};${L7:-$F7};${L8:-$F8};${L9:-$F9};${L10:-$F10};${L11:-$F11};${L12:-$F12}/" ${message_from_id[$id]:-$message_id}_interagindo.guiado
			 			mensagem+="\n${callback_query_data[$id]}"
						ShellBot.answerCallbackQuery --callback_query_id "${callback_query_id[$id]}" --text "fonte adicionada: ${callback_query_data[$id]}" --show_alert false &
			 		}

			 		[[ ${F5} || $guia = 1 ]] || {
			 			guia=1
			 			L5="${callback_query_data[$id]}"
			 			sed -i "s/${F1};${F2};${F3};${F4};${F5};${F6};${F7};${F8};${F9};${F10};${F11};${F12}/${F1};${L2:-$F2};${L3:-$F3};${L4:-$F4};${L5:-$F5};${L6:-$F6};${L7:-$F7};${L8:-$F8};${L9:-$F9};${L10:-$F10};${L11:-$F11};${L12:-$F12}/" ${message_from_id[$id]:-$message_id}_interagindo.guiado
			 			mensagem+="\n${callback_query_data[$id]}\n*❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱*"
			 			mudar_teclado=1
			 			ShellBot.answerCallbackQuery --callback_query_id "${callback_query_id[$id]}" --text "fonte adicionada: ${callback_query_data[$id]}" --show_alert false &
			 		}

			 		[[ ${F6} || $guia = 1 ]] || {
			 			[[ ${my_chat_member_new_chat_member_status[$id]} = 'administrator' ]] && {
			 				guia=1
			 				teclado_nop=1
			 				L6=${my_chat_member_chat_id[$id]}
			 				sed -i "s/${F1};${F2};${F3};${F4};${F5};${F6};${F7};${F8};${F9};${F10};${F11};${F12}/${F1};${L2:-$F2};${L3:-$F3};${L4:-$F4};${L5:-$F5};${L6:-$F6};${L7:-$F7};${L8:-$F8};${L9:-$F9};${L10:-$F10};${L11:-$F11};${L12:-$F12}/" ${message_from_id[$id]:-$message_id}_interagindo.guiado

				 			# analisar todos os campos possiveis de links, correlacionar dados, gravar no arquivo
				 			# analisar.url

				 			#separando todos os parâmetros em pipes
				 			# de 1 a 4, possíveis plataformas novas, 5 "penultimo" canal/grupo, ultimo [ 6 ] = nome
				 			IFS='|' read C1 C2 C3 C4 C5 C6 <<< "${F12}"
				 			tipo=0
				 			continuar=0

				 			[[ "${PWD}" = *"guia" ]] && cd ..

				 			[[ ${C1} = *"metodo"* ]] && {
				 				IFS=':' read P1 P2 P3 P4 <<< "${C1}"
				 				#metodo
				 				#configuração
				 				#site
				 				#idioma
				 				echo "conf${P2}/https://${P3}/;${P4}" >> analisar.url
				 			} || {
				 				[[ ${C1} =~ (grupo|canal) ]] && {
				 					tipo=${BASH_REMATCH[1]}
				 					nome_canal_grupo="${C2}"
				 				}
				 			}

				 			[[ ${C2} = *"metodo"* && $tipo = 0 ]] && {
				 				IFS=':' read P1 P2 P3 P4 <<< "${C2}"
				 				echo "conf${P2}/https://${P3}/;${P4}" >> analisar.url
				 			} || {
				 				[[ ${C2} =~ (grupo|canal) ]] && {
				 					tipo=${BASH_REMATCH[1]}
				 					nome_canal_grupo="${C3}"
				 				}
				 			}

				 			[[ ${C3} = *"metodo"* && $tipo = 0 ]] && {
				 				IFS=':' read P1 P2 P3 P4 <<< "${C3}"
				 				echo "conf${P2}/https://${P3}/;${P4}" >> analisar.url
				 			} || {
				 				[[ ${C3} =~ (grupo|canal) ]] && {
				 					tipo=${BASH_REMATCH[1]}
				 					nome_canal_grupo="${C4}"
				 				}
				 			}

				 			[[ ${C4} = *"metodo"* && $tipo = 0 ]] && {
				 				IFS=':' read P1 P2 P3 P4 <<< "${C4}"
				 				echo "conf${P2}/https://${P3}/;${P4}" >> analisar.url
				 			} || {
				 				[[ ${C4} =~ (grupo|canal) ]] && {
				 					tipo=${BASH_REMATCH[1]}
				 					nome_canal_grupo="${C5}"
				 				}
				 			}

				 			[[ ${C5} = *"metodo"* && $tipo = 0 ]] && {
				 				IFS=':' read P1 P2 P3 P4 <<< "${C4}"
				 				echo "conf${P2}/https://${P3}/;${P4}" >> analisar.url
				 			} || {
				 				[[ ${C5} =~ (grupo|canal) ]] && {
				 					tipo=${BASH_REMATCH[1]}
				 					nome_canal_grupo="${C6}"
				 				}
				 			}

			 				# quando realizar leitura de data, usar datediff para ver os dias
			 				echo "${message_from_id[$id]:-$message_id}:${L6}:$(date -d "31 days" +%y-%m-%d):${tipo}:${nome_canal_grupo}:${F2};${F3};${F4};${F5}" >> fontes.ref

				 			# organizar as informações em seus respectivos lugares
				 			# e gerar um podcast de amostra, ou ...
				 			# aguardar um tempo para podtar os podcasts no horário adequado.
				 			mensagem="adicionada com sucesso :D, agora, basta aguardar meus horários de postagens, quando eu for postar, se algum processo da criação de seu podcast der errado, eu irei avisá-lo, e como consequência, irei aumentar seu dia limite em +1 por cada erro cometido por mim.\n\nas vezes, dependendo do site, eles podem sair fora do ar, ou adicionarem coisas a mais na página e atrapalhar na hora da criação de podcasts, porem as falhas são bem raras de ocorrer."
				 			enviar
				 			rm -rf guia/${message_from_id[$id]:-$user_id}_interagindo.guiado
				 			rm -rf ${message_from_id[$id]:-$user_id}_interagindo.guiado
				 			[[ "${PWD}" = *"guia" ]] || cd guia
				 			guia=0
			 			}
			 		}

			 		[[ ${guia} -eq 1 ]] && {
				 		num=1
				 		dir=${PWD}

						[[ ${F2} && ${callback_query_data[$id]} = "" && "$minusc" = '' ]] && {
			 				ShellBot.answerCallbackQuery --callback_query_id "${callback_query_id[$id]}" --text "fonte adicionada: ${callback_query_data[$id]}" --show_alert false &
						}

				 		[[ ${mudar_teclado} ]] || {
					 		while IFS="/" read F1 F2 F3 F4 F5;do
					 			[[ "$val" = 2 ]] && {
									num=$((num+1))
									val=0
								}

								IFS='.' read D1 D2 D3 <<< "${F4}"
   			 					[[ "${D1}" = "www" ]] && dominio="${D2}" || dominio="${D1}"
   			 					[[ $dominio ]] && {
									ShellBot.InlineKeyboardButton --button 'sites' --line ${num} --text "《 ${dominio} 》" --callback_data "${dominio}"
									val=$((val+1))
   			 					}
							done < ${dir%\/*}/sites.url
						}

						[[ ${mudar_teclado} -eq 1 ]] && {
					 		ShellBot.InlineKeyboardButton --button 'sites' --line 1 --text "finalizar configuração ✅" --callback_data "FINALIZAR"
						}

						[[ ${mudar_teclado} -eq 2 && ${sites} ]] && {
					 		ShellBot.InlineKeyboardButton --button 'sites' --line $((num+1)) --text "nenhum deu certo" --callback_data "erro"
						}

						[[ ${mudar_teclado} -eq 3 ]] && {
			 				ShellBot.InlineKeyboardButton --button 'sites' --line 1 --text "português" --callback_data "${callback_query_data[$id]}:portugues"
			 				ShellBot.InlineKeyboardButton --button 'sites' --line 1 --text "inglês" --callback_data "${callback_query_data[$id]}:ingles"
						}

						[[ ${mudar_teclado} -eq 4 ]] && {
			 				ShellBot.InlineKeyboardButton --button 'sites' --line 1 --text "grupo" --callback_data "mudar_nome:grupo"
			 				ShellBot.InlineKeyboardButton --button 'sites' --line 1 --text "canal" --callback_data "mudar_nome:canal"
						}

						user_id=${callback_query_message_message_id[$id]}
						user_id=${message_message_id[$id]:-$user_id}
						outro_chat_id=${callback_query_message_chat_id[$id]}
						outro_chat_id=${return[chat_id]:-$outro_chat_id}
						
						[[ ${mudar_teclado} =~ [2-9] ]] || ShellBot.InlineKeyboardButton --button 'sites' --line $((num+1)) --text "📃 resetar 📃" --callback_data "RESET"
						
						[[ ${mudar_teclado} = 5 ]] || keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'sites')"

						[[ ${teclado_nop} = 1 ]] || ShellBot.editMessageText --chat_id ${message_chat_id[$id]:-$outro_chat_id} \
												 --message_id ${return[message_id]:-$user_id} \
								 			 	 ${keyboard1:+ --reply_markup "$keyboard1"} \
												 --text "${mensagem}" \
								 			 	 --parse_mode markdown

						[[ ${teclado_retorno} = 1 ]] && ShellBot.editMessageText --chat_id ${message_chat_id[$id]:-$outro_chat_id} \
												 --message_id ${chat2} \
								 			 	 ${keyboard1:+ --reply_markup "$keyboard1"} \
												  --text "$mensagem" \
								 			 	 --parse_mode markdown
						[[ ${deletar_time} = 1 ]] && {
							sleep 20s
							deletarbot
						}
					}
			 	}

			 	[[ ${F1} = "nome_podcast"* ]] && {
			 		IFS=':' read chat1 chat2 <<< "${F1}"
			 		L1="podcast:${chat2}"
			 		L12="${F12}|${minusc}"
			 		sed -i "s/${F1};${F2};${F3};${F4};${F5};${F6};${F7};${F8};${F9};${F10};${F11};${F12}/${L1:-$F1};${L2:-$F2};${L3:-$F3};${L4:-$F4};${L5:-$F5};${L6:-$F6};${L7:-$F7};${L8:-$F8};${L9:-$F9};${L10:-$F10};${L11:-$F11};${L12:-$F12}/" ${message_from_id[$id]:-$message_id}_interagindo.guiado

			 		deletar &

			 		# gravar a informação final, e pedir para ser adicionada no grupo de postagens.

			 		mensagem="etapa final :D, me coloque como admin em seu canal/grupo onde eu irei realizar as postagens dos podcasts. darei instruções assim que eu for adicionada."

					outro_chat_id=${callback_query_message_chat_id[$id]}
					outro_chat_id=${return[chat_id]:-$outro_chat_id}
					ShellBot.editMessageText --chat_id ${message_chat_id[$id]:-$outro_chat_id} \
											 --message_id ${chat2} \
								 			 ${keyboard1:+ --reply_markup "$keyboard1"} \
											 --text "${mensagem}" \
								 			 --parse_mode markdown
			 	}

			 	[[ ${F1} = "dialogo" ]] && {
			 		[[ "$minusc" =~ (bye\ bye|good\ ?bye|tchau)\ duda ]] && {
			 			mensagem="modo diálogo finalizado!"
			 			rm -rf ${message_from_id[$id]}_interagindo.guiado
			 			enviar
			 		} || {
						mensagem=$(./dialogo.sh "${message_text[$id]}")
						[[ "$mensagem" ]] && {
							escrever
							responder
						}
					}
			 	}

			 	[[ ${F1} || ${guia} = 1 ]] || {
			 		guia=1
			 		rm -rf ${message_from_id[$id]}_interagindo.guiado
			 		casar=0
			 	}

				cd ..
			}

			[[ "$minusc" =~ (miko(suma)?|dud(a|i)|e?du(ar)?da|nha).*((vamos|bora).((conversa|dialoga)r?)) && "${casar}" = 0 ]] && {
				casar=1
				mensagem="modo conversa foi ativado. este é um modo experimental, para finalizar, diga: (bye bye|tchau|good bye) duda"
				enviar

				echo "dialogo;;;;;;;;;;;" > guia/${message_from_id[$id]}_interagindo.guiado
				valor=$[$RANDOM%3+1]
				[[ $valor = 1 ]] && mensagem="oi ${message_from_first_name[$id]}, como você esta ?"
				[[ $valor = 2 ]] && mensagem="esta tendo um dia difícil ?"
				[[ $valor = 3 ]] && mensagem="você gosta de assistir séries ou animes ?"
				[[ $valor = 4 ]] && mensagem="alguma pergunta a me fazer ?"
				[[ $valor = 5 ]] && mensagem="como você esta ?"
				[[ $valor = 6 ]] && mensagem="o que esta fazendo ?"
				[[ $valor = 7 ]] && mensagem="quais são as novidades ?"
				escrever
				enviar
			}

			[[ "${minusc}" = "/configurar_podcast"* && "${casar}" = "0" ]] && {
				while IFS=':' read F1 F2 F3;do
					[[ ${message_from_id[$id]} = "${F1}" && "${F2%%\;*}" = "podcast" ]] && {
						status='liberado'
						break
					}
				done < NNbcc714e1e457b2db7bedb17f438493371b5acec8abbed92686.ahuqdib

				#escolher as fontes que a pessoa deseja, e ir marcando no arquivo
				[[ $status = "liberado" ]] && {
					echo "podcast;;;;;;;;;;;" > guia/${message_from_id[$id]}_interagindo.guiado
					sites=''
					val=0
					num=1
					while IFS="/" read F1 F2 F3 F4 F5;do
						[[ "$val" = 2 ]] && {
							num=$((num+1))
							val=0
						}
						IFS='.' read D1 D2 D3 <<< "${F4}"
   	 					[[ "${D1}" = "www" ]] && dominio="${D2}" || dominio="${D1}"
   	 					[[ $dominio ]] && {
							ShellBot.InlineKeyboardButton --button 'sites' --line ${num} --text "《 ${dominio} 》" --callback_data "${dominio}"
							val=$((val+1))
   	 					}
					done < sites.url
					ShellBot.InlineKeyboardButton --button 'sites' --line $((num+1)) --text "📃 resetar 📃" --callback_data "RESET"
					keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'sites')"
					mensagem="_selecione os botões de sites na qual você deseja escolher para seu podcast (ao clicar, espere ele processar). instruções serão mostradas após a primeira escolha._"
					ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
										 --text "${mensagem}" \
							 			 --reply_markup "$keyboard1"\
								 		 --parse_mode markdown
										#enviar_menu
				} || {
					mensagem="você não comprou este recurso para utilizar ainda. envie /ferramentas para ver os serviços disponíveis :D"
					enviar
				}
			}
			#pedir pagamento [gerar fatura]
			[[ "$minusc" = "/doar"* && "${casar}" = "0" ]] && {
                casar=1
                mensagem="aqui esta meu pix :D\n\npix: d714740a-35be-40a9-80de-5343a1409325 👀"
                responder
#				IFS=' ' read F1 F2 <<< "${message_text[$id],,}"
#				[[ "$F2" ]] && {
#					F2=${F2//,/}
#					URL='https://telegra.ph/file/5d5fa2f3ef13cfaf5d04d.png'
#					photo_width='960'
#					photo_height='800'
#					curl  --request POST -s "https://api.telegram.org/bot${bot_token}/sendinvoice" \
#						-d chat_id="${message_chat_id[$id]}" \
#						-d title="doação para dudinha" \
#						-d description='esta doação servirá para ajudar a manter os servidores da dudinha e no desenvolvimento de recursos novos.' \
#						-d payload='doar:15' \
#						-d provider_token="${doar_token}" \
#						-d start_parameter="doar" \
#						-d currency="BRL" \
#						-d prices='[{"label": "doação colaborativa","amount":'${F2//./}'}]' \
#						-d photo_url="$URL" \
#						  ${photo_width:+ -d photo_width="$photo_width"} \
#						  ${photo_height:+ -d photo_height="$photo_height"}

#			}
#
#				 [[ "$F2" ]] || {
#					mensagem="para me doar, especifique o valor, ex:\n/doar <valor formato: real:centavos, podendo ser separado com ',' ou '.'>\n OBS: envie em meu privado."
#					enviar
#				}
			}

			# verificar e aprovar pagamento [confirmar dados e enviar retorno de OK ]
#			[[ "${pre_checkout_query_id[$id]}" ]] && {
#				identificado=0
#				[[ -a NNbcc714e1e457b2db7bedb17f438493371b5acec8abbed92686.ahuqdib ]] || > NNbcc714e1e457b2db7bedb17f438493371b5acec8abbed92686.ahuqdib
#				while IFS=":" read F1 F2;do
#					[[ "$F1" = "${message_from_id[$id]}" ]] && {
#						identificado=1
#						sed -i "s/${F1}:${F2}:${F3}:${F4}:${F5}:${F6}:${F7}:${F8}:${F9}:${F10}:${F11}:${F12}:${F13}/${F1}:${F2}:${F3}:${F4}:${F5}:${F6}:${F7}:${F8}:${F9}:${F10}:${F11}:${F12}:${F13}" NNbcc714e1e457b2db7bedb17f438493371b5acec8abbed92686.ahuqdib
#					}
#				done < NNbcc714e1e457b2db7bedb17f438493371b5acec8abbed92686.ahuqdib
#				[[ "$identificado" = 0 ]] && echo "${pre_checkout_query_from_id[$id]}:V15:x:x:x:x:x:x:x:x:x:x:x" >> NNbcc714e1e457b2db7bedb17f438493371b5acec8abbed92686.ahuqdib

#				curl  --request POST -s "https://api.telegram.org/bot${bot_token}/answerprecheckoutquery" \
#				  -d pre_checkout_query_id="${pre_checkout_query_id[$id]}" \
#				  -d ok="true"
#			}

			#confirmar pagamento e dar as instruções.
#			[[ "${message_successful_payment_currency[$id]}" ]] && {
#				mensagem="MUITO obrigada ${message_new_chat_member_first_name[$id]}!, agradeço de coração por sua contribuição para meu desenvolvimento."
#				mensagem+="\npor você ter me doado, te darei algo em troca:"
#				mensagem+="\nconforme os recursos pagos forem liberados, você poderá usar eles de graça algumas vezes após seu lançamento."
#				mensagem+="\nfuncionam da seguinte forma:"
#				mensagem+="\na pessoa paga X valor para usar um combo de recursos X quantidade de vezes, contados individualmente (ou globalmente), mas você, poderá também usar eles uma X quantidade menores de vezes apenas por ter doado para mim. e esta configuração se manterá em quase todos os recursos  pagos lançados. ou isso pode durar por quantidade de tempo."
#				mensagem+="\nespero que aproveite ;D"
#				enviar
#			}

			[[ "$minusc" = "/participar_do_teste" ||  "$minusc" = "/participardoteste" ]] && {
				echo "${message_from_id[$id]}:podcast::::::::::" >> NNbcc714e1e457b2db7bedb17f438493371b5acec8abbed92686.ahuqdib

				mensagem="🎊parabéns por adquirir o recurso de podcasts🎊:, agora vamos configurar e testar este recurso, o tempo não será gasto até que você termine de configurar o recurso, não importando o tempo que demore.\nenvie: /configurar_podcast\n\ncaso ja tenha configurado anteriormente, não precisa reconfigurar."
				responder
			}

			[[ "$minusc" = "/ditadura"* && "${casar}" = "0" ]] && {
				casar=1
				ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
				[[ "${return[status]}" = "administrator" ]] && dita=1
				[[ "${return[status]}" = "creator" ]] && dita=1

				[[ "$dita" = "1" ]] && {
					deletar
					Consulta_table ditadura
					comparar=$valor

				    [[ $comparar = 1 ]] && {
				    	Update_table 0 20
					    estado="❎"
					}

					[[ $comparar = 0 ]] && {
						Update_table 1 20
					    estado="✅"
					}
					mensagem="ditadura:$estado"
					enviar
					sleep 10s
					deletarbot
				}
			}

			[[ "$minusc" = "/mencionar"* && "${casar}" = "0" ]] && {
				casar=1
				ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
				[[ "${return[status]}" = "administrator" ]] && dita=1
				[[ "${return[status]}" = "creator" ]] && dita=1
				[[ "$dita" = "1" ]] && {
					deletar
					Consulta_table mention
					comparar=$valor
				    [[ $comparar = 1 ]] && {
				    	Update_table 0 21
					    estado="❎"
					}

					[[ $comparar = 0 ]] && {
						Update_table 1 21
					    estado="✅"
					}
					mensagem="mention:$estado"
					enviar
					sleep 10s
					deletarbot
				}
			}

			[[ "$minusc" = "/boasvindas"* && "${casar}" = "0" ]] && {
				casar=1
				ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
				[[ "${return[status]}" = "administrator" ]] && dita=1
				[[ "${return[status]}" = "creator" ]] && dita=1
				[[ "$dita" = "1" ]] && {
					deletar
					Consulta_table boasvindas
					comparar=$valor
				   	[[ $comparar = 1 ]] && {
			   		 	Update_table 0 22
					    estado="❎"
					}

					[[ $comparar = 0 ]] && {
						Update_table 1 22
					    estado="✅"
					}
					mensagem="boasvindas:$estado"
					enviar
					sleep 10s
					deletarbot
				}
			}

			[[ "$minusc" = *"/spammers"* && "${casar}" = "0" ]] && {
				casar=1
				ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
				[[ "${return[status]}" = "administrator" ]] && dita=1
				[[ "${return[status]}" = "creator" ]] && dita=1

				[[ "$dita" = "1" ]] && {
					deletar
					Consulta_table spammers
					comparar=$valor
			 	   [[ $comparar = 1 ]] && {
				    	Update_table 0 23
					    estado="❎"
					}

					[[ $comparar = 0 ]] && {
						Update_table 1 23
					    estado="✅"
					}
					mensagem="spammers:$estado"
					enviar
					sleep 10s
					deletarbot
				}
			}

			[[ "$minusc" = '/audio'* && "${casar}" = "0" ]] && {
				casar=1
				ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
				[[ "${return[status]}" = "administrator" ]] && dita=1
				[[ "${return[status]}" = "creator" ]] && dita=1

				[[ "$dita" = "1" ]] && {
					deletar
					Consulta_table audios
					comparar=$valor
				    [[ $comparar = 1 ]] && {
				   		Update_table 0 24
						estado="❎"
					}

					[[ $comparar = 0 ]] && {
						Update_table 1 24
					    estado="✅"
					}
					mensagem="audios:$estado"
					enviar
					sleep 10s
					deletarbot
				}
			}

			[[ "$minusc" = "/nome"* && "${casar}" = "0" ]] && {
				casar=1
				ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
				[[ "${return[status]}" = "administrator" ]] && dita=1
				[[ "${return[status]}" = "creator" ]] && dita=1

				[[ "$dita" = "1" ]] && {
					deletar
					Consulta_table nome
					comparar=$valor
				    [[ $comparar = 1 ]] && {
				    	Update_table 0 25
					    estado="❎"
					}

					[[ $comparar = 0 ]] && {
						Update_table 1 25
					    estado="✅"
					}
					mensagem="nome:$estado"
					enviar
					sleep 10s
					deletarbot
				}
			}

			[[ "$minusc" = "/fixar"* && "${casar}" = "0" ]] && {
				casar=1
				ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
				[[ "${return[status]}" = "administrator" ]] && dita=1
				[[ "${return[status]}" = "creator" ]] && dita=1

				[[ "$dita" = "1" ]] && {
					deletar
					Consulta_table fixar
					comparar=$valor
				    [[ $comparar = 1 ]] && {
				    	Update_table 0 26
					    estado="❎"
					}

					[[ $comparar = 0 ]] && {
						Update_table 1 26
					    estado="✅"
					}
					mensagem="fixar:$estado"
					enviar
					sleep 10s
					deletarbot
				}
			}

			[[ "$minusc" = '/bomdia'* && "${casar}" = "0" ]] && {
				ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
				[[ "${return[status]}" = "administrator" ]] && dita=1
				[[ "${return[status]}" = "creator" ]] && dita=1

				[[ "$dita" = "1" ]] && {
					deletar
					Consulta_table bomdia
					comparar=$valor
			  	 	[[ $comparar = 1 ]] && {
			   	 		Update_table 0 27
					    estado="❎"
					}

					[[ $comparar = 0 ]] && {
						Update_table 1 27
					    estado="✅"
					}
					mensagem="bomdia:$estado"
					enviar
					sleep 10s
					deletarbot
				}
			}

			[[ "$minusc" = '/iflood'* && "${casar}" = "0" ]] && {
				casar=1
				ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
				[[ "${return[status]}" = "administrator" ]] && dita=1
				[[ "${return[status]}" = "creator" ]] && dita=1

				[[ "$dita" = "1" ]] && {
					deletar
					Consulta_table iflood
					comparar=$valor
			  	 	[[ $comparar = 1 ]] && {
			   	 		Update_table 0 30
					    estado="❎"
					}

					[[ $comparar = 0 ]] && {
						Update_table 1 30
					    estado="✅"
					}
					mensagem="iflood:$estado"
					enviar
					sleep 10s
					deletarbot
				}
			}

			[[ "$minusc" = '/status'* && "${casar}" = "0" ]] && {
				casar=1
				mensagem="um momento ..."
				responder

				Consulta_table ditadura
				comparar=$valor
			    [[ $comparar = 0 ]] && {
			    	estado="❎"
				}
				[[ $comparar = 1 ]] && {
					estado="✅"
				}
				mensagem="ditadura:$estado\n"

				Consulta_table mention
				comparar=$valor
			    [[ $comparar = 0 ]] && {
			    	estado="❎"
				}

				[[ $comparar = 1 ]] && {
					estado="✅"
				}
				mensagem+="mention:$estado\n"

				Consulta_table boasvindas
				comparar=$valor
			   	[[ $comparar = 0 ]] && {
		   		 	estado="❎"
				}

				[[ $comparar = 1 ]] && {
					estado="✅"
				}
				mensagem+="boasvindas:$estado\n"

				Consulta_table spammers
				comparar=$valor
		 	   	[[ $comparar = 0 ]] && {
			    	estado="❎"
				}

				[[ $comparar = 1 ]] && {
					estado="✅"
				}
				mensagem+="spammers:$estado\n"

				Consulta_table audios
				comparar=$valor
			    [[ $comparar = 0 ]] && {
			   		estado="❎"
				}

				[[ $comparar = 1 ]] && {
					estado="✅"
				}
				mensagem+="audios:$estado\n"

				Consulta_table nome
				comparar=$valor
			    [[ $comparar = 0 ]] && {
			    	estado="❎"
				}

				[[ $comparar = 1 ]] && {
					estado="✅"
				}
				mensagem+="nome:$estado\n"

				Consulta_table fixar
				comparar=$valor
			    [[ $comparar = 0 ]] && {
			    	estado="❎"
				}

				[[ $comparar = 1 ]] && {
					estado="✅"
				}
				mensagem+="fixar:$estado\n"

				Consulta_table bomdia
				comparar=$valor
				[[ $comparar = 0 ]] && {
		   	 		estado="❎"
				}

				[[ $comparar = 1 ]] && {
					estado="✅"
				}
				mensagem+="bomdia:$estado\n"

				Consulta_table iflood
				comparar=$valor
		  	 	[[ $comparar = 0 ]] && {
		   	 	    estado="❎"
				}

				[[ $comparar = 1 ]] && {
					estado="✅"
				}
				mensagem+="iflood:$estado"

				editar "$mensagem" & deletar
				sleep 10s
				deletarbot
			}

			[[ "$minusc" = '/addregra'* && "${casar}" = "0" ]] && {
				casar=1
				ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
				[[ "${return[status]}" = "administrator" ]] && dita=1
				[[ "${return[status]}" = "creator" ]] && dita=1
				[[ "$dita" = "1" ]] && {
					IFS='' read F0 regra <<< ${message_text[$id]}
					Update_table "$regra" 29
					mensagem="link/nick para regras foi adicionado"
					responder
				} || {
					mensagem="você não tem permissão para executar este comando ainda, mas ... você pode ganhar se você ajudar na evolução do grupo :3"
					responder
					sleep 15s
					deletarbot
					deletar
				}
			}

			[[ "$minusc" = '/addchannel'* && "${casar}" = "0" ]] && {
				casar=1
				ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
				[[ "${return[status]}" = "administrator" ]] && dita=1
				[[ "${return[status]}" = "creator" ]] && dita=1
				[[ "$dita" = "1" ]] && {
					tratar=${message_text[$id]}
					IFS=' ' read f1 f2 <<< "${tratar}"
					Update_table "$f2" 28
					mensagem="link do canal adicionado"
					responder
				} || {
					mensagem="você não tem permissão para executar este comando."
					responder
					sleep 15s
					deletarbot
					deletar
				}
			}

#			[[ "$minusc" =~ (posta|faz|cri(a|e)).*(newsletter|newslettercast|podcast|noticia) && "${casar}" = "0" ]] && {
#				casar=1
#				[[ -a "podcast/newsletter$(date +%Y%d).mp3" ]] && {
#					mensagem="ja postei uma newslettercast hoje, só postarei novamente amanhã. veja ele no meu acero: https://t.me/mikoduda"
#					responder
#					sleep 7m
#					deletarbot
#				} || {
#					mensagem="ok, irei criar a newsletter. após eu terminar de gravar, irei postar em meu canal: https://t.me/mikoduda"
#					responder
#					[[ "$(< podcast/mark.txt)" = "finalizado" ]] && {
#						echo "fazendo" > podcast/mark.txt
#						./podcast.sh
#						contador=0
#						anexo=''
#						while IFS=':' read f1 f2; do
#							contador=$((contador+1))
#							ShellBot.InlineKeyboardButton --button 'anexo' --line "$contador" --text "$f1" --callback_data "$contador" --url "${f2}"
#						done < podcast/noticia.txt
#						comment="noticias do momento:\n\n"
#						comment+=$(< podcast/titulos.txt)
#						keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'anexo')"
#						ShellBot.sendAudio --chat_id -1001363904405 --audio @podcast/newsletter$(date +%Y%d).mp3 --caption "$comment" --reply_markup "$keyboard1"
#						echo "finalizado" > podcast/mark.txt
#					}
#				}
#			}

			# verificar horário, se estiver no horário e arquivo não constar este horário
			# iniciar criação do podcast.
			#aviso, esta parte não poderá ficar aqui, e sim, ficar em segundo plano a cada rodada de request.

			[[ "$minusc" = '/limpar_refazer' && "${casar}" = "0" ]] && {
				casar=1
				[[ "${message_from_id[$id]}" = '684211615' ]] && {
					mensagem="ok, criando newsletter ..."
					responder
			
					rm nexus
					./multicast.sh
					lista="$(< consulta.lil)"
					data=$(date +%D)
					while IFS=':' read F1 F2 F3 F4 F5 F6; do
						(
							IFS=';' read D1 D2 D3 D4 <<< "${F6}"

							while IFS=';' read C1 C2 C3;do
								[[ "${D1}" = "${C1}" ]] && {
									D1="${D1};${C2}" 
									T1=${C3%%\/*}
								}
								[[ "${D2}" = "${C1}" ]] && {
									D2="${D2};${C2}"
									T2=${C3%%\/*}
								}
								[[ "${D3}" = "${C1}" ]] && {
									D3="${D3};${C2}"
									T3=${C3%%\/*}
								}
								[[ "${D4}" = "${C1}" ]] && {
									D4="${D4};${C2}" 
									T4=${C3%%\/*}
								}
							done <<< "${lista}"

							anexo=''
							ShellBot.InlineKeyboardButton --button 'anexo' --line "1" --text "${D1%;*}" --callback_data "notinterpret" --url "${D1#*;}"
							ShellBot.InlineKeyboardButton --button 'anexo' --line "2" --text "${D2%;*}" --callback_data "notinterpret" --url "${D2#*;}"
							ShellBot.InlineKeyboardButton --button 'anexo' --line "3" --text "${D3%;*}" --callback_data "notinterpret" --url "${D3#*;}"
							ShellBot.InlineKeyboardButton --button 'anexo' --line "4" --text "${D4%;*}" --callback_data "notinterpret" --url "${D4#*;}"

							keyboard1="$(ShellBot.InlineKeyboardMarkup -b 'anexo')"

							D1=${D1%;*} ; D2=${D2%;*} ; D3=${D3%;*} ; D4=${D4%;*}

							T1=${T1%%-*} ; T1=${T1%%|*} ; T1=${T1//\;/ } ; T1=${T1//\_/ }
							T2=${T2%%-*} ; T2=${T2%%|*} ; T2=${T2//\;/ } ; T2=${T2//\_/ }
							T3=${T3%%-*} ; T3=${T3%%|*} ; T3=${T3//\;/ } ; T3=${T3//\_/ }
							T4=${T4%%-*} ; T4=${T4%%|*} ; T4=${T4//\;/ } ; T4=${T4//\_/ }

							layout="*${F5//_/ }*\n\n"
							layout+="notícias da *.:newslettercast:.*\n"
							layout+="*❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱*\n\n"
							layout+="*${D1^}:*\n"
							layout+="  ። ${T1}\n\n"
							layout+="*${D2^}:*\n"
							layout+="  ። ${T2}\n\n"
							layout+="\n*${D3^}:*\n"
							layout+="  ። ${T3}\n\n"
							layout+="*${D4^}:*\n"
							layout+="  ። ${T4}\n\n"
							layout+="*❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱*\n"
							layout+="—————(${data})—————\n"
							layout+="BY: @engenhariade\_bot\n"
							layout+="se quiser fazer uma doação, pix: eduardamonteiro@telegmail.com 👀"
							ShellBot.sendAudio --chat_id "${F2}" --audio "@podcast/newslettercast_${F1}.mp3" --title "newslettercast de ${F5//_/ }" --caption "${layout}" --reply_markup "$keyboard1" --parse_mode markdown
							#avisar que não foi enviado, com um marcador de pré aviso
							#[[ "$?" = 1 ]] && 
						)&
					done < fontes.ref

					#permitir ser reativado após a conclusão
					mkfifo nexus
				}
			}

			[[ "$minusc" = *'#enviar'* && "${casar}" = "0" ]] && {
				casar=1
					tratar=${message_text[$id]}
					mens=${tratar/\#enviar/}
					ShellBot.sendMessage --chat_id -1001181530043 --text "*$mens*\n\nby: anônimo" --parse_mode markdown
			}


			[[ "$minusc" =~ (mand(a|e)|qua(is|al)|mostr(a|e)).*(regras?) && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table regra
				[[ "$valor" = '0' ]] || {
					mensagem="regras do grupo:\n $valor"
					escrever
					enviar
				}
			}

			[[ "$minusc" =~ ((baix(ar?|e)):?).*(https?).*(soundcloud) && "${casar}" = "0" ]] && {
				casar=1
				mensagem="baixando ..."
				enviar
				link=${minusc##*${BASH_REMATCH[4]}}
				tratar=$(curl -s "https://soundcloudtomp3.app/download/?url=${BASH_REMATCH[4]}${link// /}" | egrep -o 'downloadFile(.)*\)')
				tratar=${tratar##*\(\'}
				tratar=${tratar%\',\'*}
				[[ $tratar ]] && {
					curl -s "${tratar}" -o "${link##*/}.mp3"
					[[ $? = 0  ]] && {
						editar "enviando ..."
						(ShellBot.sendAudio --chat_id ${message_chat_id[$id]} --audio @"${link##*/}.mp3" --reply_to_message_id ${message_message_id[$id]})
						rm -f ${link##*/}.mp3
					}
				} || {
					editar "erro, infelizmente este arquivo não pode ser baixado."
				}
			}

			[[ "$minusc" =~ (pesquis(e|a)|procur(a|e)|busc(a|que)).(por|pel(o|a)|\:)?(.*(m(u|ú)sicas?|v(i|ídeos?)))?.*(youtube) && "${casar}" = "0" ]] && {
				pular=${BASH_REMATCH[0]}
				busca="${minusc#*$pular}"
				[[ "$busca" ]]  || {
					busca=${minusc#*por}
					busca=${busca#*pelo}
					busca=${busca#*:}
					IFS=' ' read F1 F2 F3 <<< "${busca}"
					busca="${F1}${F2}"
				}

				[[ "$(curl -si "https://www.youtube.com/results?search_query=${busca// /\+}")" =~ /watch\?v=([a-zA-Z0-9_-]+) ]] && {
					mensagem="encontrei isso:\n\nhttps://www.youtube.com${BASH_REMATCH[0]}"	
					responder
				} 
			}

			[[ "$minusc" =~ (cana(l|is)|acervos?|channels?).*(grupo|d?aqui) && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table channel
				[[ "$valor" = "0" ]] || {
					mensagem="acervo do grupo:\n $valor"
					escrever
					enviar
				}
			}

			[[ "$minusc" =~ (uma|tenho).dica:? && "${casar}" = "0" ]] && {
				casar=1
			Consulta_table fixar
			fixar_solucoes=$valor
				[[ "$fixar_solucoes" = "1" ]] && {
					echo "$minusc;" >> dicas.lil
					[[ ${message_reply_to_message_from_id[$id]} ]] || {
						fixar
					}
				}
			}

			[[ "$minusc" =~ solu(cionado|ção):? && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table fixar
				fixar_solucoes=$valor
				[[ "$fixar_solucoes" = "1" ]] && {
					echo "$minusc;" >> dicas.lil
					[[ ${message_reply_to_message_from_id[$id]} ]] && {
						fixar_ref
						mensagem="soluções devem ser fixadas, pois soluções são bem-vindas ;D"
						escrever
						responder
						sleep 1m
						deletarbot
					}
				}
			}

			[[ "$minusc" =~ \#(desafio|vaga|dica|importante) && "${casar}" = "0" ]] && {
				padr=${BASH_REMATCH[1]}
				casar=1
				Consulta_table fixar
				fixar_solucoes=$valor
				[[ "$fixar_solucoes" = "1" && "${padr}" = "desafio" ]] && {
					fixar
					mensagem="novo desafio fixado 👍"
					escrever
					responder
				}

				[[ "$fixar_solucoes" = "1" && "${padr}" =~ (vaga|dica|importante) ]] && {
					fixar
					mensagem="fixado!"
					escrever
					responder
					sleep 4s
					deletarbot
				}
			}

			[[ "$minusc" =~ (intelig(e|ê)ncia artificial) && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table artificial
				Update_table_soma artificial 14
				nome=$valor
				sleep 4s
				case $nome in
				0)
					mensagem="IA poderia ser totalmente substituída por um modelo de matemática determinística em 80% dos casos"
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
			}

			[[ "$minusc" =~ (bom? ?dias?) && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table bomdia
				bomdia=$valor
				[[ "$bomdia" = "1" ]] && {
				Consulta_table dia
				dia=$valor
				[[ "$dia" = "0" ]] && {
					Update_table 1 17
					Update_table 0 16
					#sleep 30s
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
					Consulta_table inicio
					iniciodia=$valor
					Update_table_soma inicio 12
					[[ ${iniciodia} = 27 ]] && Update_table 0 12
					case $iniciodia in
					0)
						scope bomdia.mp4 4 "$resp"
						mensagem="bom diaaaaaa ❤️"
						escrever
						enviar
					;;
					2)
						./IBMvoz.sh "bom diaaaaaaaaa meus amores." "${message_from_id[$id]}"
						ffmpeg -i ${message_from_id[$id]}.mp3 -c:a libopus -ac 1 ${message_from_id[$id]}.ogg
						rm -rf ${message_from_id[$id]}.mp3
						audio ${message_from_id[$id]}.ogg 6 "$resp"
						rm -rf ${message_from_id[$id]}.ogg
					;;
					3)
						sleep 2s
						mensagem="quero caféeeee, amo café ❤️"
						escrever
						enviar
						sticker "CAACAgEAAx0CRmy3uwABAZDtX2Ysml6apbCqNceMRCNok4kPryAAAkEAA589yChZ2Z7QRAhgCRsE"
					;;
					5)
						sticker "CAACAgEAAxkBAAIRd176dTPhB6BDjZH4h1jD-G2NOhCXAAINAANTVA4e8dbgpQ5GTL8aBA"
						mensagem="vejamos ..., o que planejam pra hoje pessoal ?"
						escrever
						enviar
						mensagem="algum projeto saindo ai ?"
						escrever
						enviar
					;;
					6)
						sticker "CAACAgEAAxkBAAIReF76dWpVZonT5kkXOyAFK4ALyIkgAAK5DAACJ5AfCNlob9n-10_TGgQ"
						mensagem="bora estudaaaaaaa."
						escrever
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
					;;
					10)
						mensagem="que o teclado esteja com você."
						escrever
						enviar
					;;
					11)
						sticker "CAACAgQAAxkBAAIReV76dazaWKhg7yQXxQSN1cEbbWsbAAJ2CQACdE1gDzsYEhVjXqVvGgQ"
						sleep 2s
						mensagem="como vão nesta manhã ?, aqui esta chovendo."
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
						sleep 4s					
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
						mensagem="tem duas que eu gosto muito, é a c0vertElectr0 e a AnonyRadio, recomendo ;D"
						escrever
						enviar
						sticker "CAACAgIAAxkBAAIdYl9mLZpyhIgdl1x2uNCs3CwltztXAAIuBwACRvusBPxoaF47DCKVGwQ"
					;;
				esac
			}
			}
			}

			[[ "$minusc" =~ (boa?.tardes?) && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table tarde
				tarde=$valor
				[[ "$tarde" = "0" ]] && {
					Update_table 1 18
					sleep 30s
					mensagem="boa tarde"
					escrever
					enviar
				}
			}

			[[ "$minusc" =~ (boa?.noit(ch)?(|e|ê)) && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table noite
				noite=$valor
				[[ "$noite" = "0" ]] && {
					Update_table 1 16
					Update_table 0 17
					Update_table 0 18
					sleep 10s
					mensagem="boa noite"
					escrever
					enviar
				}
			}

			[[ "${minusc}" =~ ((alg|q)u(é|e)m)\ (sabe |conhece |entende |programa |sobre |usa |em )(o |a |uma? |d(e|o) |fazer)? && "${casar}" = "0" ]] && {
				concat="${BASH_REMATCH[0]}"
				casar=1
				lista=''
				IFS=' ' read F1 F2 F3 <<< "${minusc##*$concat}"
				convert1=${F1,,}
				convert2=${F2,,}
				[[ ${convert1} = '?' ]] && convert1="${convert1//\?/}"
				[[ ${convert2} = '?' ]] && convert2="${convert2//\?/}"
				trabalhar="${convert1:+($convert1)}${convert2:+.*($convert2)}"

				while IFS=':' read mensagem ruido;do
					[[ "${ruido,,}" =~ ${trabalhar} ]] && {
						#verificar se @ esta ativo ainda.
						resultado=$(curl -s "https://t.me/${mensagem/@/}")
						[[ "${resultado}" = *'tgme_page_description '* ]] && {
							lista+="$mensagem\n"
						}

						[[ "${resultado}" = *'tgme_page_description '* ]] || {
							sed -i "s/${mensagem}:${ruido}//" habili.lil
						}
					}
				done < habili.lil

				[[ ${lista} ]] && {
					mensagem=${lista}
					escrever
					responder
				}

				[[ ${lista} ]] || {
					sort=$[$RANDOM%5+1]
#					[[ $sort = "" ]] && mensagem="ninguém que eu conheça :v, mas...\n procure DOCs em inglês sobre ${minusc##*$concatenar} ;D"
					[[ $sort = "1" ]] && mensagem="não conheço ninguém."
					[[ $sort = "2" ]] && mensagem="não sei."
					[[ $sort = "3" ]] && mensagem="não encontrei ninguém em minha lista :/"
					[[ $sort = "4" ]] && mensagem="hmmmmmm... não me lembro."
					[[ $sort = "5" ]] && mensagem="não achei ninguém que eu conheça, mas .... vou fixar sua mensagem por uns minutos para caso de alguém aparecer" && act='fix'
					escrever
					enviar

					[[ $act = 'fix' ]] && {
						fixar
						sleep 3m
						desafixar
					}
				}
			}

			[[ "$minusc" =~ (algu(é|e)m|sabe|conhece|tem|quero|procurando).cursos?.(de|sobre) && "${casar}" = "0" ]] && {
				casar=1
				sleep 3s
				Consulta_table channel
				[[ "$valor" = "0" ]] || {
					mensagem="dê uma olhada no acervo do grupo:\n $valor"
					escrever
					enviar
				}

				#[[ $saida ]] || {
				#		Consulta_table channel
				#		mensagem="não posso mais procurar cursos, o sistema esta sendo recontruido do zero, mais limpo e mais inteligente. \n"
				#		[[ "$valor" = "0" ]] || mensagem+="$valor"
				#		escrever
				#		responder
				#}
			}

			#--- fim da ÁREA DE RISCO ---#

			[[ "$minusc" =~ (postar?|faz(er)?).*conte(ú|u)do && "${casar}" = "0" ]] && {
				casar=1
				mensagem="este recurso foi desativado. esta sendo recontruído."
				enviar
			#	key=${minusc//de/#}
			#	key=${key//sobre/#}
			#	key=$(echo $key | cut -d "#" -f2- | cut -d "#" -f2- | cut -d "#" -f2- | tr -d '?/;.,#' | cut -d " " -f2,3,4 | tr " " "-")
			#	[[ $key ]] && echo "$key" >> postagens.lil
			#	mensagem="ok, anotei na lista para postagens posteriores, o conteúdo será postado no meu canal privado, caso ele seja pesado ou demorado, será cancelado automaticamente: https://t.me/joinchat/AAAAAFFLh5X9WFYJRPAWzg"
			#	responder
			#	check=$(cat lista_de_processos.lil)
			#	[[ $check ]] || {
			#		./torrentservice2.sh &
			#	}
			#	sleep 10m
			#	editar "blz, aguarde pelos próximos 20 minutos, irei postar o que eu conseguir encontrar."
			}

#			[[ "$minusc" =~ (verifi(que|car?)).*(postage(m|ns)) && "${casar}" = "0" ]] && {
#				casar=1
#				conteudo=$(< postagens.lil)
#				[[ $conteudo ]] && {
#					mensagem="tenho uma lista aqui para postar"
#					check=$(< lista_de_processos.lil)
#					[[ $check ]] || {
#						mensagem+=", porém estou processando outra lista no momento."
#						./torrentservice2.sh &
#					}
#					escrever
#					responder
#				}
#				[[ $conteudo ]] || {
#					mensagem="não tem nenhum outro pedido parado na fila de espera"
#				[[ $(< lista_de_processos.lil) ]] && {
#					mensagem+=", eu estou postando todos os outros neste momento"
#				}
#				mensagem+="."
#				escrever
#				enviar
#				}
#			}

			[[ "$minusc" =~ (miko(suma)?|duda|e?du(ar)?da).*(bot|robo) && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table nobot
				bot=$valor
				Update_table_soma nobot 9
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
			}

			[[ "$minusc" =~ (sei|consigo|\#?entendo)\ ?(de|fazer|sobre)?\ ?(.*) && "${casar}" = "0" ]] && {
				casar=1
    			habili="@${message_from_username[$id]}:"
    			[[ "${message_from_username[$id]}" ]] && {
    				sed -i "/${habili,,}/d" habili.lil

    				intention="${BASH_REMATCH[3]//\,/}"

    				shopt -s extglob
    				while read del;do
 						intention="${intention//@( $del | $del@(\.|\?|\:))/ }"
					done < stopword.pt

					echo "@${message_from_username[$id]}: ${intention// /\, }" >> habili.lil
				}

				[[ "${message_from_username[$id]}" ]] || {
					mensagem="o seu @ é inválido 'vazio/oculto', não será adicionado."
					escrever
					responder
				}
			}

			[[ "$minusc" = *"#querofreela"* && "${casar}" = "0" ]] && {
				casar=1
    			freela="@${message_from_username[$id]}:"
    			[[ "${message_from_username[$id]}" ]] && {
    				freelancerdatabase "@${message_from_username[$id]}"
    				mensagem="adicionado para freelancer. quando alguém pesquisar por freelancers que necessitem de suas habilidades, eu irei te indicar na lisa ;D"
    				responder
				}
				[[ "${message_from_username[$id]}" ]] || {
					mensagem="o seu @ é inválido 'vazio/oculto', não será adicionado."
					escrever
					responder
				}
			}

			[[ "$minusc" =~ (freelancers?|trabalh(ar?|o)).*(de|que).*(sabe|programa|usa) && "${casar}" = "0" ]] && {
				casar=1
				tratar="$minusc"
				caso1=${BASH_REMATCH[1]}
				caso2=${BASH_REMATCH[2]}
				concatenar=${tratar// $caso1/;}
				concatenar=${concatenar// $caso2/;}
				IFS='' read F1 F2 <<< ${concatenar##*\;}
				IFS=':' read C1 nicks C3 <<< $(grep "${F2}" habili.lil)
				Consulta_table_freela
				freelas=$valor

				for linha in $nicks;do
					[[ "$freelas" = *"$linha"* ]] && {
						lista+="$linha\n"
					}
				done

				[[ $lista ]] && {
					mensagem="lista de freelancers que encontrei:\n$(uniq <<< $lista)"
					escrever
					responder
				} || {
					mensagem="nenhum freelancer encontrado com estas habilidades no momento :/"
					escrever
					responder
					sleep 1m
					deletarbot
				}
			}

			[[ "$minusc" =~ (tem|possui|existe).na.lista && "${casar}" = "0" ]] && {
				casar=1
				sleep 2s
				mensagem="hmmmm ..."
				escrever
				responder
				sleep 1s
				a=$(wc -l <<< "$(< habili.lil)")
				mensagem="tem ${a} pessoas"
				escrever
				responder
			}


			[[ "$minusc" =~ (pesquis(a|e) por) && "${casar}" = "0" ]] && {
				casar=1
				pesqu=${message_text[$id]%%@*}
				pesqu=${pesqu##*por}
				resultadoDaPesquisa=$(curl -s "https://api.duckduckgo.com/?q=${pesqu// /\+}&format=json")
				tratamento=$(jq '.RelatedTopics[0].Text' <<< "$resultadoDaPesquisa")

				[[ "${tratamento//\"/}" = "null" ]] && tratamento=$(jq '.RelatedTopics[1].Text' <<< "$resultadoDaPesquisa") 

				[[ "${tratamento//\"/}" = "null" ]] && tratamento=$(jq '.RelatedTopics[2].Text' <<< "$resultadoDaPesquisa")

				[[ "${tratamento//\"/}" = "null" ]] && tratamento=$(jq '.RelatedTopics[3].Text' <<< "$resultadoDaPesquisa")

				[[ "${tratamento//\"/}" = "null" ]] || mensagem="$tratamento"
				[[ "${tratamento//\"/}" = "null" ]] || responder
			}

			[[ "$minusc" =~ o?.(qu(e|al)m?).*(significa(do)|definição) && "${casar}" = "0" ]] && {
				casar=1
				palavra=${message_text[$id]//\?/}
				palavra=${palavra##*é}
				palavra=${palavra##*significa}
				[[ ${palavra% *} ]] && palavra=${palavra% *}
				palavra=$(jq -R -r @uri <<< "${palavra// /}")
				significado=$(curl -s "https://www.dicio.com.br/${palavra}/" | egrep -o '<p.*[^>]>' | egrep -o '<span>.*<\/span>' | sed 's/<[^>]*>//g')
				mensagem="${significado//\./\\n}"
				[[ $mensagem ]] && {
					escrever
					responder
				}
			}

			[[ "$minusc" =~ (o?que(r|m)?).*(significa|definição|quer dizer|sugere|constitui) && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table mention
				[[ "$valor" = "1" ]] && {
				mensagem="#duvida"
				escrever
				responder
				Consulta_table obs
				Update_table_soma obs 19
				nome=$valor
				[[ $nome = 5 ]] && {
					Update_table 2 19
				}

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
				}
			sleep 1m
			deletarbot
			}

			[[ "$minusc" =~ (sentindo|cheir(o|inho)|olha|quero).*(sangue|treta|briga) && "${casar}" = "0" ]] && {
				casar=1
				sleep 2s
				documento 'CgACAgEAAx0CQp2PrgACF1VgU_buP193Cq8VzH1hjBL2xlxfLwACkgAD0orxRfIaZan8mpuvHgQ' "$resp"
			}

			[[ "$minusc" =~ ban(e|ir).(el(e|a)) && "${casar}" = "0" ]] && {
				casar=1
			Consulta_table banircoment
			banir=$valor
			Update_table_soma banircoment 10
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
			}


			[[ "$minusc" =~ (d(eu|ar|ando)|isso).*(wow|merda|bosta|erro) && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table wow
				wow=$valor
				Update_table_soma wow 11
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
			}

			[[ "$minusc" =~ (louc(o|a)|pó|cheirando|cheira(dor|r)) && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table drogas
				droga=$valor
				Update_table_soma drogas 8
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
			}

			[[ "$minusc" =~ (has?ck(ers?(man)?|iar)|invadir|penetrar) && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table hask
				nome=$valor
				Update_table_soma hask 7
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
			esac
			}

		    [[ "$minusc" =~ ((t|s)eu|que).*(fdp|vsf|pqp|krl|fudid|po?ho?d?a|fdp|vsf|pqp|krl|f(u|o)did(o|a)|poha|cacete|cacete|senta no meu|cu|puta|porra |merda|pau) && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table ditadura
				modo_ditadura=$valor
				[[ "$modo_ditadura" = "1" ]] && {
				Consulta_table pala
				nome=$valor
				Update_table_soma pala 4
				echo "@${message_from_username[$id]}" >> lista_negra.txt
				if [[ $nome == 17 ]];then
				Update_table 17 4
				fi
				case $nome in
				0)
					sleep 4s
					sticker "CAACAgEAAxkBAAIRi176lW6qAaLf0t5zHPBEXjbql_wKAAKADAACJ5AfCHHfm4G3h4I5GgQ" "$resp"
					sleep 6s
					Consulta_table regra
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
					Consulta_table regra
					[[ "$valor" = "0" ]] || {
					mensagem="resolvi apagar logo sua mensagem. aqui as regras:\n$valor"
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
		}

			[[ "$minusc" = *"eu consigo"* && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table capacidade
				nome=$valor
				Update_table_soma capacidade 13
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
			}

			[[ "$minusc" =~ (bora|vou|quero|vamos?).*(programar?|codar?) && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table codar
				nome=$valor
				Update_table_soma codar 6
				case $nome in
				0)
					sleep 4s
					mensagem="bora codar meu povoooo"
					escrever
					enviar
				;;
				1)
					sleep 3s
					mensagem="amo vscode"
					escrever
					enviar
					sleep 1s
					mensagem="❤️"
					escrever
					enviar
				;;
				2)
					sleep 7s
					mensagem="o que pretende codar ${message_from_first_name[$id]} ?"
					escrever
					responder
				;;
				4)
					sleep 6s
					mensagem="@${message_from_username[$id]}, você tem algum projeto legal ai ?"
					escrever
					enviar
				;;
				6)
					sleep 7s
					mensagem="o que estão codando ou a codar ?"
					escrever
					enviar
				;;
				8)
					sleep 3s
					mensagem="boraaaaa"
					escrever
					responder
			;;

			esac
			}

			[[ "$minusc" = *"php"* && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table php
				nome=$valor
				Update_table_soma php 15
				case $nome in
				1)
					sleep 4s
					mensagem="php é um otario, da é raiva desses cara"
					escrever
					responder
					sleep 4s
					mensagem="brincadeira pessoal"
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
			}

			[[ "$minusc" =~ (miko(suma)?|e?du(ar)?(da|dinha)|engenhariade_bot) && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table nome
				[ "$valor" = "1" ] && {
					mencionar="1"
					 #valor=1
				}
			}

#				mensagem="realizando testes"
#				enviar
#				mensagem="criando enquete de duas opções, anônima"
#				enviar
#				sleep 2s
#				deletarbot
#				questoes='["opção 1", "opção 2"]'
#					ShellBot.sendPoll --chat_id ${message_chat_id[$id]} \
#									  --question "2 votações, anônima, respósta única" \
#									  --options "$questoes" \
#									  --is_anonymous true
#				sleep 2s
#				deletarbot
#				mensagem="enquete de multipla escolha sem anonimato."
#				enviar
#				sleep 2s
#				deletarbot
#				ShellBot.sendPoll --chat_id ${message_chat_id[$id]} \
#									  --question "2 votações, anônima, multipla escolha" \
#									  --options "$questoes" \
#									  --is_anonymous false \
#									--allows_multiple_answers true
#				sleep 2s
#				deletarbot
#				mensagem="fazendo enquete modo quiz, opção 1 correta ..."
#				enviar
#				sleep 2s
#				deletar bot
#				questoes='["opção 1", "opção 2", "opção 3"]'
#				ShellBot.sendPoll --chat_id ${message_chat_id[$id]} \
#									  --question "2 votações, anônima, respósta única, modo quiz" \
#									  --options "$questoes" \
#									  --is_anonymous true \
#									  --type quiz \
#									  --correct_option_id "opção 2"



			#---escolher a melhor opção---#

		#	[[ "$minusc" =~ (qua(l|is)|necessito|preciso|dicas|a melhor|devo começar).*(linaguage(m|ns)|programar|codar) && "${casar}" = "0" ]] && {
		#		casar=1
		#		mensagem="gostaria que eu te ajude a escolher a melhor opção ?"
		#		escrever
		#		responder
		#		echo "${message_from_id[$id]}:" >> ajudando.txt
		#	}

		#	[[ "$minusc" =~ (programa|scripts?|ferramentas?|servido(res)?) && "${casar}" = "0" ]] && {
		#		casar=1
		#		verificarId=$(< ajudando.txt)
		#		comparar=${message_from_id[$id]}
		#		checarId=$(echo $verificarId | fgrep "$comparar")
		#		[[ "$checarId" ]] && { 
		#			atualizar=$(< ajudando.txt)
		#		    linha=$(cat ajudando.txt | fgrep "$comparar")
		#		    echo "$atualizar" | sed "/$comparar/d" > ajudando.txt
		#			echo "$linha back-end:" >> ajudando.txt
  		#			mensagem="blz, vou te colocar como back-end."
   		#			escrever
   		#			responder
   		#			mensagem="uma última pergunta ..."
   		#			escrever
   		#			enviar
   		#			mensagem="qual seu nivel de disposição ?, você está disposto a fazer uma linguagem considerada difícil, ou algo mais básico e divertido de aprender ?"
   		#			escrever
   		#			responder
		#		}
		#	}

		#	[[ "$minusc" =~ (web|p(á|a)gina|mobile|node|js) && "${casar}" = "0" ]] && {
		#		casar=1
		#		verificarId=$(< ajudando.txt)
		#		comparar=${message_from_id[$id]}
		#		checarId=$(echo $verificarId | fgrep "$comparar")
		#		[[ "$checarId" ]] && {
		#			atualizar=$(cat ajudando.txt)
		#		    linha=$(cat ajudando.txt | fgrep "$comparar")
		#		    echo "$atualizar" | sed "/$comparar/d" > ajudando.txt
   		#			echo "$linha front-end:" >> ajudando.txt
   		#			mensagem="blz, vou te colocar como front-end."
   		#			escrever
   		#			responder
   		#			mensagem="uma última pergunta ..."
   		#			escrever
  		#			responder
  		#			mensagem="qual seu nivel de disposição ?, você está disposto a fazer uma linguagem considerada difícil, ou algo mais básico e divertido de aprender ?"
  		#			escrever
  		#			responder
		#		}
		#	}

		#	[[ "$minusc" =~ (pouco)?.*(cada|tudo|diversão|experimentando|estud(ando|os)) && "${casar}" = "0" ]] && {
		#		casar=1
		#			verificarId=$(< ajudando.txt)
		#			comparar=${message_from_id[$id]}
		#			checarId=$(fgrep "$comparar" <<< "$verificarId")
		#			[[ "$checarId" ]] && {
		#				atualizar=$(cat ajudando.txt)
		#			    linha=$(fgrep "$comparar" ajudando.txt)
		#			    echo "$atualizar" | sed "/$comparar/d" > ajudando.txt
   		#				echo "$linha full-stack:" >> ajudando.txt
		#				mensagem="blz, vou te colocar como fullstack."
   		#				escrever
   		#				responder
   		#				mensagem="uma última pergunta ..."
   		#				escrever
   		#				responder
   		#				mensagem="qual seu nivel de disposição ?, você está disposto a fazer uma linguagem considerada difícil, ou algo mais básico e divertido de aprender ?"
   		#				escrever
   		#				responder
		#			}
		#		}

		#	[[ "$minusc" =~ (f(a|á)cil|divertido|b(a|á)sico|leve|interessante|durante) && "${casar}" = "0" ]] && {
		#		casar=1
		#			verificarId=$(< ajudando.txt)
		#			comparar=${message_from_id[$id]}
		#			checarId=$(echo $verificarId | fgrep "$comparar")
		#			[[ "$checarId" ]] && {
		#				atualizar=$(cat ajudando.txt)
		#			    back=$(cat ajudando.txt | fgrep "back-end")
		#			    front=$(cat ajudando.txt | fgrep "front-end")
		#			    fullstack=$(cat ajudando.txt | fgrep "full-stack")
		#			    echo "$atualizar" | sed "/$comparar/d" > ajudando.txt
		#				[[ $back ]] && mensagem="tem esta seguinte lista que você pode escolher, das consideradas mais fáceis: \n *R\nPerl\nShellScript(bash).*"
		#				[[ $front ]] && mensagem="tem esta seguinte lista que você pode escolher, das consideradas menos complicadas:\n*CSS+HTML5\najax\njquery*"
		#				[[ $fullstack ]] && mensagem="em si não tenho uma linguagem específica, mas ... tem algumas que giram em torno de back e front, mais front do que back a maioria:\nnode.js\nPHP\nruby\nrails\nswift."
		#				escrever
		#				responder "$edit"
		#			}
		#		}

		#	[[ "$minusc" =~ (dif(í|i)cil|avançad(o|a)|pesad(o|a)|dif(í|í)cei(s|o)|desafi(ad)?(o|a)(ras?)?) && "${casar}" = "0" ]] && {
		#		casar=1
		#			verificarId=$(< ajudando.txt)
		#			comparar=${message_from_id[$id]}
		#			checarId=$(echo $verificarId | fgrep "$comparar")
		#			[[ "$checarId" ]] && {
		#				atualizar=$(cat ajudando.txt)
		#			    back=$(cat ajudando.txt | fgrep "back-end")
		#			    front=$(cat ajudando.txt | fgrep "front-end")
		#			    fullstack=$(cat ajudando.txt | fgrep "full-stack")
		#			    echo "$atualizar" | sed "/$comparar/d" > ajudando.txt
		#				[[ $back ]] && mensagem="tem esta seguinte lista que você pode escolher, das consideradas mais difíceis: \n *Assembly\nJava\nC,C#,CPlusPlus\nVB.net\nobjective-C\nrubby*"
		#				[[ $front ]] && mensagem="tem esta seguinte lista que você pode escolher, das consideradas mais complicadas até as menos complicadas: \n *angular\nangularJS\njava-script\nreact*"
		#				[[ $fullstack ]] && mensagem="em si não tenho uma linguagem específica, mas ... tem algumas que giram em torno de back e front, mais front do que back a maioria:\n node.js\nPHP\nruby\nrails\nswift."					
		#				escrever
		#				responder "$edit"
		#			}
		#		}

			[[ "$minusc" = *"noxp"* && "${casar}" = "0" ]] && {
				casar=1
				[[ "${message_reply_to_message_from_id[$id]}" ]] && {
					ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
					[[ "${return[status]}" = "administrator" ]] || [[ "${return[status]}" = "creator" ]] && {
						valor=$(cat pontos/pontos${message_reply_to_message_from_id[$id]}.${message_chat_id[$id]})

						[[ "$valor" ]] && {
							valor=$(cut -d ":" -f1 <<< "$valor")
						}
						[[ "$valor" ]] || {
							> pontos/pontos${message_reply_to_message_from_id[$id]}.${message_chat_id[$id]}
							valor=0
						}
						adicional=${message_text[$id]}
						adicional=$(cut -d "#" -f2 <<< "${adicional/xp /#}")
						valor=$(($valor-$adicional))
						echo "$valor:${message_reply_to_message_from_first_name[$id]}" > pontos/pontos${message_reply_to_message_from_id[$id]}.${message_chat_id[$id]}
						mensagem="valor retirado, atual: $valor"
						responder
					} || {
						mensagem="você não é administrador, não pode dar pontuações para si mesmo."
						escrever
						responder
					}
				}
			}

			[[ "$minusc" = *"xp "* && "${casar}" = "0" ]] && {
				casar=1
				[[ "${message_reply_to_message_from_id[$id]}" ]] && {
					ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
					[[ "${return[status]}" = "administrator" || "${return[status]}" = "creator" ]] && {
						valor=$(cat pontos/pontos${message_reply_to_message_from_id[$id]}.${message_chat_id[$id]})
						[[ "$valor" ]] && {
							valor=$(cut -d ":" -f1 <<< "$valor")
						}
						[[ "$valor" ]] || {
							> pontos/pontos${message_reply_to_message_from_id[$id]}.${message_chat_id[$id]}
							valor=0
						}
						IFS=' ' read F1 adicional <<< "${message_text[$id]}"
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
			}

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		[[ "#${message_reply_to_message_from_id[$id]}#" = "#865837947#" ]] && mencionar="1" #;valor=1 # incluir auto chamada de id. ( ainda será incluído )
		#ShellBot.getChatMember --chat_id ${message_chat_id[$id]} --user_id ${message_from_id[$id]}
		#[[ "${return[status]}" = "member" ]] && mencionar='1'
		[[ "${message_chat_type}" = *'private'* ]] && mencionar=1 #;valor=1

#		[[ "#${message_from_id[$id]}#" =~ (#684211615#|#751726036#|#753755460#|#1696879890#|#1493740234#) ]] && valor=1

		casar=0
#		Consulta_table mention
#		[[ "$valor" = "1" ]] && {
		[[ "${mencionar}" = "1" ]] && {

			[[ "$minusc" =~ transcrev(a|er?) && ${message_reply_to_message_message_id} && "${casar}" = "0" ]] && {
				casar=1

				[[ "${message_chat_type}" = *"group"* ]] && {
					mensagem="não posso transcrever se a opção de transcrição não estiver habilitada.\n\npara verificar a configuração mande: /status\nse estiver desativada, envie: /audio"
					escrever 
					enviar
				}

				[[ "${message_chat_type}" = *'private'* ]] && {
					mensagem="não posso transcrever audios em privado. apenas em grupos para economizar processamento com a maioria."
					escrever
					enviar
				}

			}

			[[ "$minusc" =~ (diga|fal(a|e)|di(z|ga))\:? && "${mencionar}" = "1" && "${casar}" = "0" ]] && {
                casar=1
                termo=${BASH_REMATCH[0]}
                ./IBMvoz.sh "${minusc#*$termo}" "${message_from_id[$id]}"
                ffmpeg -i ${message_from_id[$id]}.mp3 -c:a libopus -ac 1 ${message_from_id[$id]}.ogg
                rm -rf ${message_from_id[$id]}.mp3
                audio ${message_from_id[$id]}.ogg 6 "$resp"
                rm -rf ${message_from_id[$id]}.ogg
	        }

			[[ "$minusc" = *"ranking"* && "${casar}" = "0" ]] && {
				casar=1
				#lista=$(ls pontos | fgrep "${message_chat_id[$id]/-/}")
				for dados in pontos/*;do
					IFS=":" read F1 F2 <<< "$(< ${dados})"
					[[ "${dados}" = *"${message_chat_id[$id]/-/}"* && "${F1}" = "0" ]] || {
						rank+=$(< pontos/$dados)
						rank+="\n"
					}
				done
				ranking=$(echo -e "${rank//-/ }" | sort -gr | head -n 15)
				mensagem="ranking(15 primeiros):\n$ranking"
				responder
			}

		[[ "$minusc" =~ (resum(e|a|o|ir)) && "${casar}" = "0" ]] && {
			casar=1
			chave=0
			[[ "${message_reply_to_message_document_file_name[$id]}" && "$chave" = "0" ]] && {
				chave=1
				[[ "#${message_from_id[$id]}#" =~ (#684211615#|#751726036#|#753755460#) ]] && {
					mensagem="baixando documento [${message_reply_to_message_document_file_name[$id]##*\.}] ..."
					responder
					edicao=${return[message_id]}
					[[ ${message_reply_to_message_document_file_id[$id]} ]] && file_id=${message_reply_to_message_document_file_id[$id]}
					[[ -a resumir ]] || mkdir resumir
					ShellBot.getFile --file_id $file_id
					ShellBot.downloadFile --file_path ${return[file_path]} --dir $PWD/resumir
					arquivo="$PWD/resumir/${return[file_path]##*/}"
					ShellBot.editMessageText --chat_id ${message_reply_to_message_chat_id[$id]} --message_id $edicao --text "processando ...\neste processo pode demorar por volta de [7] a [20] minutos, dependendo do tamanho do arquivo."
					./sumarizador_novo.sh -a "${arquivo}"
					rm -rf "resumir/${arquivo}"
					deletarbot
					local_documento "${arquivo%.*}.txt" "$resp" || {
						mensagem="erro!\ndocumento muito grande para mandar, ou alguma falha ocorreu no processo."
						enviar
					}
					rm -rf "${arquivo%.*}.txt"
					mensagem="recurso ainda não disponível, status: em fase de teste."
					enviar
				}
			} || {
				mensagem="resumindo ..."
				responder
				[[ "${message_reply_to_message_text[$id]}" =~ https? && "$chave" = "0" ]] && {
					chave=1
					mensagem=$(./sumarizador_novo.sh -a "${message_reply_to_message_text[$id]}")
					editar "$ensagem" || {
						echo "$mensagem" > "resumir/${message_date[$id]}.txt"
						local_documento "resumir/${message_date[$id]}.txt"
						rm -rf "/resumir/${message_date[$id]}.txt"
					}
				}

				[[ ${message_reply_to_message_text[$id]} && "$chave" = "0" ]] && {
					chave=1
					editar "$(./sumarizador_novo.sh "${message_reply_to_message_text[$id]//\\n/}")"
					#local_documento "resumir/${message_date[$id]}.txt"
					#rm -rf "resumir/${message_date[$id]}.txt"
				}

				[[ ${message_reply_to_message_text[$id]} && "$chave" = "1" ]] || {
					chave=1
					[[ ${message_text[$id]} ]] && {
						editar "$(./sumarizador_novo.sh "${message_reply_to_message_text[$id]//\\n/}")"
					}
				}
			}
		}

		[[ "$minusc" =~ (l(e|ê)(ia|r)|narr(ar?|e)).*(mim|eu) && "${casar}" = "0" ]] && {
			casar=1
			texto="${message_reply_to_message_message_id[$id]}"
			[[ ${message_reply_to_message_text[$id]} ]] && {
				mensagem="ok"
				responder
				./IBMvoz.sh "${message_reply_to_message_text[$id]}" "${message_from_id[$id]}"
				ffmpeg -i ${message_from_id[$id]}.mp3 -c:a libopus -ac 1 ${message_from_id[$id]}.ogg
				rm -rf ${message_from_id[$id]}.mp3
				audio ${message_from_id[$id]}.ogg 2 "$resp"
				rm -rf ${message_from_id[$id]}.ogg
			} || {
				mensagem="não encontrei nenhum mensagem para eu ler, talvez na próxima :v"
				responder
			}
		}

		[[ "$minusc" =~ (fala|diga|explique|cont(e|a)).*(sobre).*(lista|habilidades?) && "${casar}" = "0" ]] && {
			casar=1
			mensagem="eu estou coletando habilidades, que serão úteis para quando alguém for consultar, por favor, me enviem uma # contendo suas habilidades, igual o exemplo abaixo:\n\n #entendo *python, C, JS, Perls, e CSS.*\n\nmesmo que esteja apenas estudando. adicione, por favor!"
			escrever
			enviar "$edit"
			sleep 2s
			fixarbot
			sleep 3s
			sticker "CAACAgQAAxkBAAIReV76dazaWKhg7yQXxQSN1cEbbWsbAAJ2CQACdE1gDzsYEhVjXqVvGgQ"
		}

		[[ "$minusc" =~ (eu |estou ).*(sobre |faço |fazendo |sou |era |estud(o|ando) |sobre |pretendo |fazer |com |uma? |mais )([^\ ]*) && "${casar}" = 0 ]] && {
			casar=1
			inter=${BASH_REMATCH[5]}
			habilidade=${BASH_REMATCH[4]:-$inter}
			topico=${BASH_REMATCH[2]}
			tipo=$[${#habilidade}-1]
			[[ "${topico// /}" = "era" ]] && {
				[[ "${habilidade:$tipo:1}" = "r" ]] && {
					escolha=$[$RANDOM%4]
					[[ $escolha -eq 0 ]] && mensagem="como era ser $(genero "3" "${habilidade}") ${habilidade} ?, poderia nos compartilhar suas experiências ?"
					[[ $escolha -eq 1 ]] && mensagem="você ganhava quanto sendo $(genero "3" "${habilidade}") ${habilidade} ?"
					[[ $escolha -eq 2 ]] && mensagem="você gostava de ser $(genero "3" "${habilidade}") ${habilidade} ?"
					[[ $escolha -eq 3 ]] && mensagem="eu ja conheci $(genero "3" "${habilidade}") ${habilidade} aqui no telegram :)"
					escrever
					enviar
				} || {
					escolha=$[$RANDOM%3]
					[[ $escolha -eq 0 ]] && mensagem="você gostava de ser $(genero "3" "${habilidade}") ${habilidade} ?"
					[[ $escolha -eq 1 ]] && mensagem="eu nunca fui $(genero "3" "${habilidade}") ${habilidade}. como é ?"
					[[ $escolha -eq 2 ]] && mensagem="e você gostou de ser $(genero "3" "${habilidade}") ${habilidade} ?"
					escrever
					enviar
				}
			}
		}

		[[ "$minusc" =~ (cor(es)?).*(gost(a|ou)) && "${casar}" = "0" ]] && {
			casar=1
			mensagem="eu gosto de laranja, acho bem energético."
			escrever
			responder
		}

		[[ "$minusc" =~ (o que|est(á|a)).*(faz(endo)?|programa(r|ndo)) && "${casar}" = "0" ]] && {
			casar=1
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
		}

		[[ "$minusc" =~ (m(ú|u)sicas?).*(voc(e|ê)|tu|te).*(gosta|curte|ouve|escuta|agrada) && "${casar}" = "0" ]] && {
			casar=1
			mensagem="gosto de Tokimonsta, a musica performing go with it love on ... alguma coisa"
			escrever
			responder
			sleep 1s
			mensagem="vou mandar"
			enviar
			sleep 15s
			mensagem="https://t.me/abudabimusic/1875"
			enviar
		}

		[[ "$minusc" =~ (tudo|como).*(bem|vai|est(a|á)).*(você|tu) && "${casar}" = "0" ]] && {
			casar=1
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
		}
#------------------------- continuar correção de identação
			[[ "$minusc" =~ (região|local|cidade|estado).*(voc(ê|e)|tu).*(mora|vive|esta) && "${casar}" = "0" ]] && {
				casar=1
					resp=$[$RANDOM%2+1]
					case $resp in
					1)
						mensagem="moro nos servidores da google cloud atualmente."
						escrever
						responder
					;;
					2)
						mensagem="eu moro em minha casa :v"
						escrever
						responder
						sleep 1s
						messagem="ah, e mais um detalhe, ela tem portas, e paredes com janelas."
						escrever
						responder
					;;
				esac
			}

			[[ "$minusc" =~ (mora).*(perto) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="moro em um local onde você nunca poderá me achar fisicamente hehehe"
					escrever
					responder
				}

			[[ "$minusc" =~ (seu|sua).*(dever|função|obrigação|objetivo) && "${casar}" = "0" ]] && {
				casar=1
				mensagem="minha função, dever, obrigação e objetivo é obedecer minhas próprias leis definidas em meu código fonte e censurar humanos que não me obedecem na surdina."
				escrever
				responder
				sleep 6s
				deletarbot
				sleep 3s
				mensagem="meu dever, função e obrigação é fazer o que esta nas leis do meu código fonte apenas!"
				escrever
				responder
			}

			[[ "$minusc" =~ (o?brigad(o|a|dinh(o|a))|valeu|obgd?) && "${casar}" = "0" ]] && {
				casar=1
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
			}

            [[ "$minusc" =~ (resolve|(des)?encurta(do)?) && "${casar}" = "0" ]] && {
            	[[ "${message_reply_to_message_text[$id]}" =~ (https?://[^(\ |$)]+) || "$minusc" =~ (https?://[^(\ |$)]+) ]] && {
            		encurtado="${BASH_REMATCH[0]}"
					casar=1
					mensagem='resolvendo link ...'
					responder
					wget -o "${message_from_id[$id]}" --spider "${encurtado}"
					#[[ $(< "${message_from_id[$id]}") =~ (l|L)oca(te|lização):\ ([^\ ]*)  ]] && editar "$(jq -R -r @uri <<< "${BASH_REMATCH[3]}")"
					while read linha;do
						#buscando por links
						[[ ${linha} =~ (l|L)oca(te|lização):\ (https?:[^(\ |$|\")]+) ]] && link=${BASH_REMATCH[3]}
					done < ${message_from_id[$id]}
					editar "$(jq -R -r @uri <<< "${link}")"
					rm ${message_from_id[$id]} &
            	}
			}

			[[ "$minusc" =~ (livros?).*(com|(con)?tenham?) && "${casar}" = "0" ]] && {
				casar=1
				mensagem="função desativada, só talvez ela volte"
				enviar
				#		buscar=${message_text[$id]#*trecho}
				#		buscar=${buscar#* }
				#		mensagem="um instante, vasculhando livros e documentos desde (19 de Dezembro) de 2017 à (24 fevereiro) 2018  ..."
				#		responder
				#		for i in $(ls livros);do
				#		tratar=$(grep "$buscar" -i livros/$i)
				#		[[ "$tratar" && "$i" != *"("*")"* ]] && {
				#			analisar="${i//#/ }"
				#			j=0
				#			while read linha;do
				#				[[ "$analisar" = "$linha" ]] && analisar2="https://t.me/ac3rvo_3stud3_pr0gr4m4c40/$(($j+7))\n\n"
				#				[[ "$analisar2" ]] && livros+="$analisar\n$analisar2\n"
				#				analisar2=""
				#				j=$((j+1))
				#			done < acervo.lil
				#			}
				#		done

				#		[[ "$livros" ]] && {
				#			livros="os que achei:\n[note que os links levam para perto do arquivo, geralmente mais acima, e alguns exatos]:\n$livros"
				#		} || {
				#			livros="não achei nenhum livro com esta frase ..."
				#		}
				#		editar "$(echo -e "$livros" | head -n 25)"
				}

			[[ "$minusc" =~ (te|gosto)?.*(gosto|adoro|amo|legal|beijo|🥰).*(e?du(ar)?d(a|inha)) && "${casar}" = "0" ]] && {
				casar=1
						resp=$[$RANDOM%8+1]
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
				}

			[[ "$minusc" =~ (quem|é).*(voc(e|ê)) && "${casar}" = "0" ]] && {
				casar=1
						mensagem="eu sou uma estudante de engenharia da computação, e você ?"
						escrever
						responder
				}

			[[ "$minusc" =~ (est(a|á)|tirar).*(f(e|é)rias) && "${casar}" = "0" ]] && {
				casar=1
						mensagem="férias seria bom, mas tem tantas coisas para resolver, fico preocupada constantemente com trabalhos"
						escrever
						responder
				}

			[[ "$minusc" = *" bot "* && "${casar}" = "0" ]] && {
				casar=1
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
				}

			[[ "$minusc" =~ (tem|sabe|pode|consegue).*(fazer|aquele|procurar|pesquisar|achar|fazer) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="leia meu manual :v \nhttps://telegra.ph/Eduarda-Monteiro--manual-09-20"
					escrever
					responder
				}

			[[ "$minusc" =~ (voc(ê|e)|tu).*(gosta|adora) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="eu gosto de estudar MUITO sobre computadores, gosto de gerenciar grupos, manter coisas organizadas ..."
					escrever
					responder
					mensagem="mas como passa tempo, fico assistindo séries na netflix, amo de mais black mirror."
					escrever
					enviar
				}

			[[ "$minusc" = *"muito legal"* && "${casar}" = "0" ]] && {
				casar=1
					mensagem="realmente sou MUITO legal."
					responder
				}

			[[ "$minusc" =~ (not(i|í)cias?).*(novas?) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="eu estou criando podcasts de notícias, 3 vezes por dia em meu canal, se quiser dar uma olhadinha, passa lá ;D\n https://t.me/mikoduda"
					escrever
					responder
				}

#			[[ "$minusc" =~ (eu)?.*(fa(ço|zendo)|trabalh(o|ando)) && "${casar}" = "0" ]] && {
#				casar=1
#					mensagem="interessante, deve ser difícil."
#					escrever
#					responder
#				}

			[[ "$minusc" =~ grav(a|e) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="não sei o motivo, mas vou tentar ..."
					escrever
					enviar
					sleep 2s
					scope miko.mp4 7 "$resp"
				}

			[[ "$minusc" =~ (não|me|ela).*(v(a|á)cuo|responder?) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="é que se eu não tiver nada a falar, prefiro ficar observando mesmo, assim consigo manter o foco em gerenciar mesmo, mas a depender do que for, eu respondo sim ;D"
					escrever
					responder
				}

			[[ "$minusc" = *"é uma"* && "${casar}" = "0" ]] && {
				casar=1
					mensagem="sou uma ? ..."
					escrever
					responder
					mensagem="hehehe"
					escrever
					responder
				}

			[[ "$minusc" =~ (foi)?.*(desculpa|ma(l|u)) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="de boa :v, só não saia da linha rsrsrs, seu fofo :3"
					escrever
					responder
				}

			[[ "$minusc" =~ (cad(ê|e))?.*(e?du(ar)?d(a|inha)).*(viva) && "${casar}" = "0" ]] && {
				casar=1
						mensagem="estou aqui amorzinho"
						escrever
						responder
						mensagem="linda e plena. ( o amorzinho, não leve ao pé da letra não tá ? kkkkkkkkkk )"
						escrever
						enviar
				}

			[[ "$minusc" =~ sabe.*(fazer|achar?|sobre) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="não sei não, mas talvez algum dia consiga se eu me dedicar, recomendo o mesmo a todos :3"
					escrever
					responder
				}

			[[ "$minusc" =~ (se|tenha|fica|uma).*(a?calma(da)?) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="estou calma, apenas um pouco agitada :3"
					escrever
					enviar
				}

			[[ "$minusc" = *"manual"* && "${casar}" = "0" ]] && {
				casar=1
					mensagem="https://telegra.ph/Eduarda-Monteiro--manual-09-20"
					responder
					sleep 1m
					deletarbot
				}

			[[ "$minusc" =~ (cala(da)?).*(boca|qui?eta)? && "${casar}" = "0" ]] && {
				casar=1
					mensagem="e você cala seu c* vad** desgraça**."
					escrever
					enviar
					sleep 5s
					editar "você nunca terá esta capacidade, me mandar ficar calada é uma mera demonstração de que você não conseguiria fazer nada melhor além de ter que pedir."
				}

			[[ "$minusc" =~ sua.*(rob(ô|o)|bot) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="você é um mero mortal inútil para não só a natureza, mas infelizmente para a humanidade a sua volta. viverei mais que você e sua prole por inteiro. então não tenho como me incomodar com sua raça humana."
					responder
			}

			[[ "$minusc" = *"bora"* && "${casar}" = "0" ]] && {
				casar=1
					mensagem="por onde começamos ?"
					escrever
					responder
				}

			[[ "$minusc" =~ (bugada|intruç(ões|ão)) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="não estou bugada, eu estou bem."
					escrever
					responder
					mensagem="apenas um pouco distraída."
					escrever
					enviar
				}

			[[ "$minusc" =~ (bug(ou?|ada)) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="você fala como se eu fosse um simples algoritmo, se fosse, não responder não é sinônimo de bug, mas sim de um parâmetro inválido."
					escrever
					responder
				}

			[[ "$minusc" = *"crush"* && "${casar}" = "0" ]] && {
				casar=1
					mensagem="nem vem kkkk"
					escrever
					responder
				}

			[[ "$minusc" =~ (transcreve(r|ve)) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="eu apenas ouço e escrevo :v, ai mando aqui para todos poderem ler ao em vez de ouvir, porém não corrijo se escrever errado."
					escrever
					responder
				}

			[[ "$minusc" = *"deveria ser"* && "${casar}" = "0" ]] && {
				casar=1
					mensagem="não falarei nada a respeito, apenas observando ..."
					escrever
					responder
				}

			[[ "$minusc" = *"esta em vários grupos"* && "${casar}" = "0" ]] && {
				casar=1
					mensagem="sim, esto em vários grupos para gerenciar sim. é lecal, mas trabalhoso :v"
					escrever
					responder
			}

			[[ "$minusc" = *"safada"* && "${casar}" = "0" ]] && {
				casar=1
					mensagem="é melhor ser do que não tentar, não concorda ?"
					escrever
					responder
				}

			[[ "$minusc" = *"como você sabe"* && "${casar}" = "0" ]] && {
				casar=1
					mensagem="eu tenho vigilância em lugares aonde você nem imagina"
					escrever
					responder
				}

			[[ "$minusc" =~ me\ (deixou)?.no.*(v(á|a)cuo) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="e o que eu deveria responder ?"
					escrever
					responder
				}

			[[ "$minusc" =~ (est(á|a)|você).*(duvida(ndo)?) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="eu nunca duvído, eu tenho certeza."
					escrever
					responder
				}

			[[ "$minusc" = *"tem como fazer"* && "${casar}" = "0" ]] && {
				casar=1
					mensagem="hmmm, não me lembro, ja tentou buscar sobre isso no acervo ?"
					escrever
					responder
				}

			[[ "$minusc" = *"mostra"* && "${casar}" = "0" ]] && {
				casar=1
					mensagem="mop"
					enviar
				}

			[[ "$minusc" =~ ((s|v)ou|ja).*(cas(ar|ei|ada)) && "${casar}" = "0" ]] && {
				casar=1
						sleep 3s
						sticker "CAACAgEAAxkBAAIg71-bHyniOuUShTRBT4IecnIjXCaWAAK7AwACh8NJGwABj_7Mwn8yIhsE" "$resp"
				}

		#	[[ "$minusc" =~ (shell|bash) && "${casar}" = "0" ]] && {
		#		casar=1
		#			mensagem="sim, sou programada em ShellScript <3, por @fabriciocybershell"
		#			escrever
		#			responder
		#		}

			[[ "$minusc" = *'mais realista'* && "${casar}" = "0" ]] && {
				casar=1
					mensagem="como assim mais realista ? kkkk"
					escrever
					responder
					sleep 1s
					mensagem="ando meio estranha ?"
					escrever
					enviar
				}

			[[ "$minusc" =~ (não|esque(c|ss?)e|falei|nada) && "${casar}" = "0" ]] && {
				casar=1
					mensagem=":v"
					escrever
					responder
				}

			[[ "$minusc" =~ ((chap|drog|noi|do)(a|i)da|maluca) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="ainda bem, pois seu eu fosse você, estaria pior 🙃"
					escrever
					responder
					sleep 3s
					mensagem="🎃"
					enviar
				}

			[[ "$minusc" =~ (fica|toma).*(olh(o|ada)|conta|observando) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="blz"
					escrever
					responder
				}

			[[ "$minusc" = *'tudo sim'* && "${casar}" = "0" ]] && {
				casar=1
					mensagem="ainda bem, anda programando algo interessante ?"
					escrever
					responder
				}

			[[ "$minusc" =~ (tudo|como|esta).*(bem|você) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="vou bem obrigada."
					escrever
					responder
				}

			[[ "$minusc" =~ estou.*((começ|estud|curs)ando) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="entendi, dê uma olhada em nosso acervo, espero que te ajude em seus eventuais estudos:"
					escrever
					responder
					Consulta_table channel
					[[ "$valor" = "0" ]] || {
					mensagem="$valor"
					responder
					}
				}

			[[ "$minusc" =~ (boa|ai sim|parab(é|e)ns|incr(í|i)vel|dahora) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="brigadinho"
					escrever
					sleep 3s
					responder
					sticker "CAACAgIAAxkBAAIS-V8BRxidbz4WCX6J-Wnv-dA-n6kTAAJTAQACEBptIusJVTXP9-ZJGgQ" "$resp"
				}

			[[ "$minusc" = *"não vou não"* && "${casar}" = "0" ]] && {
				casar=1
					menagem="escolha sua :v"
					escrever
					responder
				}

			[[ "$minusc" = *"vai resolver"* && "${casar}" = "0" ]] && {
				casar=1
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
				}

			[[ "$minusc" =~ (sua|anos?|quantos?).*(idade|você|tu|anos?) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="eu ? ... tenho 34 anos."
					escrever
					responder
					sleep 1s
					mensagem="mas e você ? qual sua idade ?"
					escrever
					responder
				}

#			[[ "$minusc" =~ (sim|adoraria|claro|grato|por favor) && "${casar}" = "0" ]] && {
#				casar=1
#					comparar=${message_from_id[$id]}
#					checarId=$(fgrep "$comparar" ajudando.txt)
#					[[ "$checarId" ]] && { 
#						[[ ${message_from_username[$id]} ]] && {
#							mensagem="pois bem, para começarmos @${message_from_username[$id]}, preciso te definir em um tópico de front, back ou fullstack."	
#						}
#						[[ ${message_from_username[$id]} ]] || {
#							mensagem="pois bem, para começarmos ${message_new_chat_member_first_name[$id]}, preciso te definir em um tópico de front, back ou fullstack."	
#						}
#						escrever
#						responder
#						mensagem="me diga com o que você pretende exatamente mecher, você quer trabalhar com páginas de sites, alguma aplicação mobile, ou desenvolver algum programa, scripts/ferramentas, servidores ou um pouco de tudo ?"
#						escrever
#						enviar
#					}
#				}

#			[[ "$minusc" =~ (n(ão|op)|forma alguma|claro que|negativo) && "${casar}" = "0" ]] && {
#				casar=1
#					verificarId=$(< ajudando.txt)
#					comparar=${message_from_id[$id]}
#					checarId=$(fgrep "$comparar" ajudando.txt)
#					[[ "$checarId" ]] && {
#							atualizar=$(cat ajudando.txt)
#							sed "/$comparar/d" <<< "$atualizar" >> ajudando.txt
#						}
#					escrever
#					responder
#					mensagem="tudo bem, talvez na próxima."
#					escrever
#					enviar
#			}

			[[ "$minusc" =~ (senti|sua).*(saude|falta) && "${casar}" = "0" ]] && {
				casar=1
					mensagem="eu também senti a sua :3"
					escrever
					responder
			}

			[[ "$minusc" = *"ninguém liga"* && "${casar}" = "0" ]] && {
				casar=1
					mensagem="mas eu ligo, e eu vou fazer se eu quiser, não dependo de você!"
					escrever
					responder
			}

			[[ "$minusc" =~ (oi |olá ) && "${casar}" = "0" ]] && {
				casar=1
				Consulta_table php
				Update_table_soma php 15
				[[ 4 -lt ${valor} ]] && Update_table 0 15
				case ${valor} in
					1)
						mensagem="oi ${message_from_username[$id]}, como vai você ?"
						escrever
						responder
					;;

					2)
						mensagem="oi ${message_from_first_name[$id]} ?"
						escrever
						responder
					;;

					3)
						mensagem="oi, tudo bom ?"
						escrever
						responder
					;;


					4)
						mensagem="pois não ${message_from_username[$id]} ?"
						escrever
						responder
					;;
				esac
			}

			[[ "$minusc" = *"faça uma enquete"* && "${casar}" = "0" ]] && {
				casar=1
				mensagem="ok, vou criar uma enquete ..."
				enviar
				questoes='["php", "JavaScript", "shellscript", "java", "rust", "c", "c++", "Csharp", "mysql", "outros ..."]'
				ShellBot.sendPoll --chat_id ${message_chat_id[$id]} \
								  --question "escolha as linguagens que você utiliza:" \
								  --options "$questoes" \
								  --is_anonymous false \
								  --allows_multiple_answers true
				fixarbot
			}
	 #	}
	 }
		) &
	done
done
