#! /bin/bash

# permissão de acesso ao banco de dados mysql
sudo echo "permissão concedida"
[[ "$?" = "1" ]] && echo "ACESSO AO BANCO DE DADOS NEGADO, ERROS PODERÃO OCORRER."

#senha em base 64
passwd=$(echo "sua senha" | base64 -d)

#conexão com o banco de dados/DATABASE
CS="mysql -u root -p$passwd -e"

#criar database
Create_database(){
	database=$($CS "show databases;")
	[[ "$database" = *"duda"* ]] || {
		echo "CRIANDO BANCO DE DADOS PARA A DUDA, nome: duda"
		sudo $CS "create database duda default character set utf8 default collate utf8_general_ci;"
}
}

#criar tabela
Create_table(){
	tables=$($CS "use duda; show tables;")
	name=$(echo ${message_chat_id[$id]} | tr "[0-9]" "[a-z]" | tr "-" "a")
	#[[ "$tables" = *"${name}"* ]] &&  echo "a tabela existe" || echo "tabela não encontrada"
	[[ "$tables" = *"${name}"* ]] || {
	$CS "use duda; create table ${name}(id int not null unique auto_increment primary key, config varchar(20), estado varchar(120));"
	$CS "use duda; 
		 INSERT INTO ${name}(config, estado) VALUES('ont', 0);
		 INSERT INTO ${name}(config, estado) VALUES('abreviaturas', 0);
		 INSERT INTO ${name}(config, estado) VALUES('resposta', 0);
		 INSERT INTO ${name}(config, estado) VALUES('pala', 0);
		 INSERT INTO ${name}(config, estado) VALUES('nick', 0);
		 INSERT INTO ${name}(config, estado) VALUES('codar', 0);
		 INSERT INTO ${name}(config, estado) VALUES('hask', 0);
		 INSERT INTO ${name}(config, estado) VALUES('drogas', 0);
		 INSERT INTO ${name}(config, estado) VALUES('nobot', 0);
		 INSERT INTO ${name}(config, estado) VALUES('banircoment', 0);
		 INSERT INTO ${name}(config, estado) VALUES('wow', 0);
		 INSERT INTO ${name}(config, estado) VALUES('inicio', 0);
		 INSERT INTO ${name}(config, estado) VALUES('capacidade', 0);
		 INSERT INTO ${name}(config, estado) VALUES('artificial', 0);
		 INSERT INTO ${name}(config, estado) VALUES('php', 0);
		 INSERT INTO ${name}(config, estado) VALUES('noite', 0);
		 INSERT INTO ${name}(config, estado) VALUES('dia', 0);
		 INSERT INTO ${name}(config, estado) VALUES('tarde', 0);
		 INSERT INTO ${name}(config, estado) VALUES('obs', 0);
		 INSERT INTO ${name}(config, estado) VALUES('ditadura', 0);
		 INSERT INTO ${name}(config, estado) VALUES('mention', 0);
		 INSERT INTO ${name}(config, estado) VALUES('boasvindas', 0);
		 INSERT INTO ${name}(config, estado) VALUES('spammers', 0);
		 INSERT INTO ${name}(config, estado) VALUES('audios', 0);
		 INSERT INTO ${name}(config, estado) VALUES('nome', 0);
		 INSERT INTO ${name}(config, estado) VALUES('fixar', 0);
		 INSERT INTO ${name}(config, estado) VALUES('bomdia', 0);
		 INSERT INTO ${name}(config, estado) VALUES('channel', '');
		 INSERT INTO ${name}(config, estado) VALUES('regra', '');
		 INSERT INTO ${name}(config, estado) VALUES('iflood', 0);
	"
}
}

#inserir valores na tabela
Insert_table(){
	name=$(echo ${message_chat_id[$id]} | tr "[0-9]" "[a-z]" | tr "-" "a")
	$CS "use duda; INSERT INTO ${name}(config, estado) VALUES('$1','$2');"
}

#selecionar/consultar partes da tabela
Select_table(){
	[[ "$1" = "all" ]] && element="*" || element="$1"
	[[ "$1" ]] || element="*"
	name=$(echo ${message_chat_id[$id]} | tr "[0-9]" "[a-z]" | tr "-" "a")
	$CS "use duda; select $element from ${name};"
}

#atudalizar informação da tabela
Update_table(){
	[[ "$1" && "$2" ]] && {
	name=$(echo ${message_chat_id[$id]} | tr "[0-9]" "[a-z]" | tr "-" "a")
	$CS "use duda; update $name set estado='$1' where id=$2;" # 1 -> coluna 2 -> valor 3 -> coluna 4 -> dado da linha 
	}
}

#somar informação da tabela
Update_table_soma(){
	[[ "$1" && "$2" ]] && {
	Consulta_table $1
	registro=$valor
	name=$(echo ${message_chat_id[$id]} | tr "[0-9]" "[a-z]" | tr "-" "a")
	$CS "use duda; update $name set estado=$(($registro+1)) WHERE id=$2;" # 1 -> coluna 2 -> valor 3 -> coluna 4 -> dado da linha 
	}
}

#consultar valor da tabela, devolver valor com a variavel: $valor
Consulta_table(){
	name=$(echo ${message_chat_id[$id]} | tr "[0-9]" "[a-z]" | tr "-" "a")
	[[ $1 ]] && {
		valor=$($CS "use duda; select config, estado from ${name};" | grep -F "$1")
	}
	[[ $valor ]] && {
		valor=$(echo ${valor/$1/#} | cut -d "#" -f2 | tr -d ' ')
	}
	[[ $valor ]] || {
		valor=$($CS "use duda; select config, estado from ${name};" | grep -F "ont")
	[[ $valor ]] && valor=0 ; Insert_table "$1" 0
	[[ $valor ]] || {
	echo "VALOR INEXISTENTE, criando tabela ..."
	Create_table
	valor=0
}
}
}

freelancerdatabase(){
	tables=$($CS "use duda; show tables;")
	name="freelancers"
	[[ "$tables" = *"${name}"* ]] || {
	$CS "use duda; create table ${name}(id int not null unique auto_increment primary key, config varchar(20), estado varchar(120));"
	}
	$CS "use duda; INSERT INTO ${name}(config, estado) VALUES('freela','$1');"
}

Consulta_table_freela(){
	name="freelancers"
	valor=$($CS "use duda; select config, estado from ${name};" | fgrep "freela")
	[[ $valor ]] && {
		valor=$(echo ${valor//freela/#} | tr -d " " | tr "#" "\n")
	}
}

#Create_database#
#Create_table#
#Update_table 19 23#
#Update_table_soma php 12#
#Consulta_table spammers#
