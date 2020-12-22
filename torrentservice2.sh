#! /bin/bash

# copiar arquivo gerenciado por outro bot para 
# completar uma lista finita de processos até o final

arquivo=$(< lista_de_processos.lil)

[[ $arquivo ]] || {

cat postagens.lil > lista_de_processos.lil
> postagens.lil

}

for linha in $(cat lista_de_processos.lil);do

#sshpass -p 447050 ssh pi@192.168.1.106 "cd .config/transmission/torrents ; rm -rf *"
#sshpass -p 447050 ssh pi@192.168.1.106 "cd .config/transmission/resume ; rm -rf *"
#sshpass -p 447050 ssh pi@192.168.1.106 "cd .config/transmission/blocklist ; rm -rf *"
#sshpass -p 447050 ssh pi@192.168.1.106 "cd .. ; cd .. ; cd .config ; cd transmission ; rm -rf *"
#sshpass -p 447050 ssh pi@192.168.1.106 "cd Downloads ; rm -rf *"

#verificar a quantidade de vezes que tal tag foi chamada

tag=$(cat hashtags.lil | sort | uniq -c | fgrep "#$linha" | tr -d " " | cut -d "#" -f1)

#gravar pedidos no banco de dados:
#[[ $tag ]] && {
echo "#$linha" >> hashtags.lil
#}
echo "$linha" > atual.txt

echo "######### LENDO: $linha > #$tag"

[[ $tag ]] || {
	echo "CONTEÚDO EXCLUSIVO"
	#pesquisar informações, e salvar a página na variavel
	pagina=$(curl "https://1337x.to/category-search/$linha/Other/1/")
	#filtrar os links salvos da página da variável anterior, acessar, e salvar os dados do link
	echo $pagina | tr " " "\n" | egrep -o '("/torrent).*"' | tr -d '"' > topico/$linha.links
	link=$(curl "https://1337x.to$(cat topico/$linha.links | head -n1)" | egrep -o '(magnet).*announce' | head -n1)
	#link=$(echo $pagina | tr " " "\n" | egrep -o '(magnet).*announce' | head -n1)
	echo "LINK: $link"
}

#echo $link | lynx -stdin -dump | fgrep "magnet" | head -n1 | cut -d '.' -f2- | tr -d " "

[[ $tag ]] && {
	echo "CONTEÚDO EXISTENTE"
	valor=0
	while read links;
	do
		[[ "$valor" = "$tag" ]] && {
			link=$(curl "https://1337x.to$link" | egrep -o '(magnet).*announce' | head -n1)
			echo "ACESSANDO LINK: $links"
			echo "CAPTURA: $link"
		}
		let valor++
	done < topico/$linha.links

	[[ $link ]] || {
		echo "RENOVANDO CONTEÚDO"
		#pesquisar informações, e salvar a página na variavel
		pagina=$(curl "https://1337x.to/category-search/$linha/Other/2/")
		#filtrar os links salvos da página da variável anterior, acessar, e salvar os dados do link
		echo $pagina | tr " " "\n" | egrep -o '("/torrent).*"' | tr -d '"' > topico/$linha.links
		link=$(curl "https://1337x.to$(cat topico/$linha.links | head -n1)" | egrep -o '(magnet).*announce' | head -n1)
		#renovando contagem
		cat hashtags.lil | sed -n "/$linha/p" >> hashtags.lil
	}
}

[[ "$link" ]] || {
	echo "LINK QUEBRADO ($link), PULANDO CONTEÚDO ...	"
	link=''
}

[[ "$link" ]] && {
	baixado=1
	#sshpass -p 447050 ssh pi@192.168.1.106 "echo '$linha' > topico.txt"
	echo "$linha" > topico.txt
	#ps -C transmission > /dev/null
	#[[ "$?" = "0" ]] || link=""
	#sshpass -p 447050 ssh pi@192.168.1.106 "tmpfile=\$(mktemp);chmod +x \$tmpfile ;echo -e 'killall transmission-cli;pkill transmission-cli' > \$tmpfile;transmission-cli -f \$tmpfile --encryption-required '$link'"

	tmpfile=$(mktemp)
	chmod +x $tmpfile
	echo -e 'pkill transmission\npkill transmission-cli' > $tmpfile
	transmission-cli -f $tmpfile -w baixado/ --encryption-required "$link"
}

[[ $link ]] && ./analisareupar.sh #sshpass -p 447050 ssh pi@192.168.1.106 './analisareupar.sh'

#[[ $link ]] && #sshpass -p 447050 ssh pi@192.168.1.106 "cd .config/transmission/torrents ; rm -rf *"
#[[ $link ]] && #sshpass -p 447050 ssh pi@192.168.1.106 "cd Downloads ; rm -rf *"
#[[ $link ]] && #sshpass -p 447050 ssh pi@192.168.1.106 "cd .config/transmission/torrents ; rm -rf *"
#[[ $link ]] && #sshpass -p 447050 ssh pi@192.168.1.106 "cd .config/transmission/resume ; rm -rf *"
#[[ $link ]] && #sshpass -p 447050 ssh pi@192.168.1.106 "cd .config/transmission/blocklist ; rm -rf *"
#[[ $link ]] && #sshpass -p 447050 ssh pi@192.168.1.106 "cd .. ; cd .. ; cd .config ; cd transmission ; rm -rf *"
#[[ $link ]] && #sshpass -p 447050 ssh pi@192.168.1.106 "cd Downloads ; rm -rf *"

echo 'PROCESSO FINALIZADO ...'

done < lista_de_processos.lil

cd baixado
sudo rm -rf *
cd ..

echo "LISTA TERMINADA"



> lista_de_processos.lil