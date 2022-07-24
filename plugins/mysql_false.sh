#! /bin/bash

Create_database(){
		echo "sistema de banco de dados ativado com suicesso!"
}

Create_table(){
	name=$(tr "[0-9]" "[a-z]" <<< "${message_chat_id[$id]}" | tr "-" "a")
	> dados/${name}.lil
	echo ".1:ont:0
.2:abreviaturas:0
.3:resposta:0
.4:pala:0
.5:nick:0
.6:codar:0
.7:hask:0
.8:drogas:0
.9:nobot:0
.10:banircoment:0
.11:wow:0
.12:inicio:0
.13:capacidade:0
.14:artificial:0
.15:php:0
.16:noite:0
.17:dia:0
.18:tarde:0
.19:obs:0
.20:ditadura:0
.21:mention:1
.22:boasvindas:1
.23:spammers:0
.24:audios:1
.25:nome:1
.26:fixar:1
.27:bomdia:1
.28:channel:0
.29:regra:0
.30:iflood:0" >> dados/${name}.lil
}

Insert_table(){
	name=$(tr "[0-9]" "[a-z]"  <<< "${message_chat_id[$id]}" | tr "-" "a")
	sed -i "s/${1}/${2}/" dados/${name}.lil
}

Select_table(){
	name=$(tr "[0-9]" "[a-z]"  <<< "${message_chat_id[$id]}" | tr "-" "a")
	fgrep ".${1}" dados/${name}.lil
}

Update_table(){
	[[ "${1}" && "${2}" ]] && {
		name=$(tr "[0-9]" "[a-z]"  <<< "${message_chat_id[$id]}" | tr "-" "a")
		IFS=':' read F1 nome registro <<< $(fgrep ".${2}:" dados/$name.lil)
		sed -i "s/.${2}:$nome:$registro/.${2}:$nome:${1}/" dados/$name.lil
	}
}

Update_table_soma(){
	[[ "${1}" && "${2}" ]] && {
		name=$(tr "[0-9]" "[a-z]"  <<< "${message_chat_id[$id]}" | tr "-" "a")
		IFS=':' read F1 nome registro <<< $(fgrep ".${2}:" dados/$name.lil)
		sed -i "s/.${2}:${1}:${registro}/.$2:${1}:$((registro+1))/" dados/${name}.lil
	}
}

Consulta_table(){
	name=$(tr "[0-9]" "[a-z]" <<< "${message_chat_id[$id]}" | tr "-" "a")
	[[ ${1} ]] && {
		valor=$(fgrep "${1}" dados/${name}.lil)
	}
	[[ $valor ]] && {
		valor=${valor##*:}
	}
	[[ $valor ]] || {
		echo "VALOR INEXISTENTE, criando tabela ..."
		Create_table
		valor=0
	}
}

freelancerdatabase(){
	tables=dados/*
	name="freelancers"
	echo "freela:${1}" >> dados/freelancers.lil
}

Consulta_table_freela(){
	name="freelancers"
	valor="$(< dados/freelancers.lil)"
	[[ $valor ]] && {
		valor=${valor##*freela\:}
	}
}
