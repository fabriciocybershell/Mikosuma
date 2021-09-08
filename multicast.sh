#! /bin/bash

# limpar os diretórios de produção de conteúdo

echo "$(< consulta.lil)" > anterior.lil

rm -rf podcast/*
rm -rf production/*
> postagem.lil
> consulta.lil

#--------------------------------------------

contador=0

fono(){
	fonetica=${1,,}
	fonetica=${fonetica//\"/\'}
	./IBMvoz.sh "$fonetica" "${2:-podcast}/${3}" "${4}"
#	contador=$((contador+1))
}

noticiar(){
	fonetica=${1,,}
	fonetica=${fonetica//\"/\'}
	./IBMvoz.sh "$fonetica" "${2:-podcast}/${dominio}" "${3}"
}

tratando(){
	tratar=$(html2text -utf8 -nometa <<< "$materia" | sed 's/\[[^\]]*\]//g')
	tratar=${tratar#*LER A SEGUIR}
	tratar=${tratar#*receba um alerta assim que um novo artigo é publicado.}
	tratar=${tratar%Inscreva seu email*}
	tratar=${tratar%Etiquetas*}
	tratar=${tratar##*um novo artigo é publicado.}
	tratar=${tratar%Obrigado por assinar*}
	tratar=${tratar#*saiba tudo sobre}
}

#função diferença em dias:
date2stamp(){
    date --utc --date "$1" +%s
}

dateDiff(){
   case $1 in
      -s)   sec=1;      shift;;
      -m)   sec=60;     shift;;
      -h)   sec=3600;   shift;;
      -d)   sec=86400;  shift;;
       *)    sec=86400;;
   esac

   dte1=$(date2stamp $1)
   dte2=$(date2stamp $2)
   diffSec=$((dte2-dte1))
   [[ ((diffSec < 0)) ]] && abs=-1 || abs=1
   diferenca=$((diffSec/sec*abs))
}

# criar a lista dos links de criação de podcasts autorizados por padrão
[[ -a sites.url ]] || {
echo "conf1/https://www.nytimes.com/;ingles
conf2/https://canaltech.com.br/;portugues
conf1/https://olhardigital.com.br/;portugues
conf3/https://arstechnica.com/;ingles
conf4/https://www.oobservador.com.br/;portugues
conf5/https://www.cnnbrasil.com.br/;portugues
conf5/https://g1.globo.com/;portugues
conf1/https://www.omgubuntu.co.uk/;ingles
" > sites.url
}

[[ -a analisar.url ]] || {
echo "conf1/https://www.nytimes.com/;ingles
conf2/https://canaltech.com.br/;portugues
conf1/https://olhardigital.com.br/;portugues
conf3/https://arstechnica.com/;ingles
conf4/https://www.oobservador.com.br/;portugues
conf5/https://www.cnnbrasil.com.br/;portugues
conf5/https://g1.globo.com/;portugues
conf1/https://www.omgubuntu.co.uk/;ingles
" > analisar.url
}

#gerar ponte de contagem
[[ -a contagem ]] && rm contagem
[[ -a contagem ]] || mkfifo contagem

#----------------------------------------------------------------------------------------------

#verificar as datas dos cadastros.
data_atual=$(date +%y-%m-%d)

while IFS=':' read F1 F2 F3 F4 F5 F6;do
#as que não forem maiores do que a data atual, calcular dias restantes.
	[[ "${F3}" > "${data_atual}" ]] || {
		dateDiff "$(date +%y-%m-%d)" "${F3}"
		#echo "data arquivo: ${F3}, data atual: "${data_atual}" diferença: ${diferenca}"
		# se for <0 OU -1, mudar para inativo
		[[ ${diferenca} -le -1 ]] && {
			sed -i "s/${F1}:${F2}:${F3}:${F4}:${F5}:${F6}/${F1}:${F2}:inativo:${F4}:${F5}:${F6}/" fontes.ref
 		}
	}
done < fontes.ref

#verificar linhas repetidas em ambos os arquivos

sort <<< "$(< fontes.ref)" | uniq -i > fontes2.ref
echo "$(< fontes2.ref)" > fontes.ref
rm -r fontes2.ref

sort <<< "$(< analisar.url)" | uniq -i > analisar2.url
echo "$(< analisar2.url)" > analisar.url
rm -r analisar2.url

#----------------------------------------------------------------------------------------------
[[ "a" = "a" ]] && {
#contagem total de links disponíveis antes da leitura em massa
while read line;do
	[[ "${line}" = *"conf"* ]] && total_sites=$((total_sites+1))
done < analisar.url

tempo=0
while IFS='/' read F1 F2 F3 F4 F5;do
	link=''
	tempo=$((tempo+2))
	[[ "${F1}" = *"conf"* ]] && {
		(
    	# capturar nomes de domínios para utilizar em dadas situações
    	IFS='.' read D1 D2 D3 <<< "${F4}"
    	[[ "${D1}" = "www" ]] && dominio="${D2}" || dominio="${D1}"

    	# capturar idioma do site
    	IFS=';' read L1 L2 <<< "${F4}${F5}"
    	[[ "${L2}" =~ (ingles|portugues) ]] && idioma=${BASH_REMATCH[1]}

    	# captura da primeira notícia
    	[[ "${F1}" = "conf1" ]] && padr="(${F2}//${F4//./\\.}/)(([0-9]{2}|$(date +%Y))/[0-9]{2}/([0-9]{2}|$(date +%Y))|[0-9]{1,}).*[^\"]*\""
    	[[ "${F1}" = "conf2" ]] && padr="(href=\")/.{6,}/([0-9]{2}|$(date +%Y))?[^\"]*\""
    	[[ "${F1}" = "conf3" ]] && padr="https?://(${F4}).*/([0-9]{2}|$(date +%Y))/[^\"]*\""
    	[[ "${F1}" = "conf4" ]] && padr="(href=\"/).*/.*([0-9]{2,4}).*[a-z]{3,}.*[^\"]*\""
    	#[[ "${F1}" = "conf5" ]] && padr="<a href=\"https?://(${F4}).*/.*/([0-9]{2}|$(date +%Y))/.*[^\"]"
    	[[ "${F1}" = "conf5" ]] && padr="<a href=\"https?://${F4}/[a-z]{5,}[^/]*/([0-9]{1,2}|$(date +%Y)|[a-z])+[^\"]*"

    	IFS='"' read A1 A2 A3 <<< $(curl -s "${F2}//${F4}/" | egrep -o "${padr}")

    	# montagem do link
    	[[ "${F1}" = "conf1" || "${F1}" = "conf3" ]] && link="${A1}"
    	[[ "${F1}" = "conf2" || "${F1}" = "conf4" ]] && link="${F2}//${F4}${A2}"
    	[[ "${F1}" = "conf5" ]] && link="${A2}"
    	IFS=' ' read P1 P2 <<< "${link}"
      link="${P1}"

    	# captura do título
	   regex_title='<title.*>(.*)</title>'
		while read linha;do
			[[ "${linha}" =~ $regex_title ]] && {
				titulo=$(html2text -utf8 -nometa <<< ${BASH_REMATCH[1]})
				break
			}
		done <<< $(curl -s "$link")

	   consulta=$(tr -d '\n' <<< "${dominio};${link};${titulo}")
	   echo -e "${consulta}\n" >> consulta.lil

	   sleep ${tempo}s

	   #resumir notícia da página
		noticia=$(./sumarizador_novo.sh -a "$link" --no | head -n4)
		[[ "$noticia" ]] || {
			echo -e "\n\nnoticia em falta [$dominio]: ${noticia}" >> err_log.txt
			IFS=';' read L1 L2 L3 <<< $(fgrep "${dominio}" anterior.lil)
			titulo="${L3}"
			noticia=$(./sumarizador_novo.sh -a "$L2" --no | head -n4)
		}

		noticiar "$noticia" "production" "${idioma}"
		
		sleep 5s

		while :
		do
			contagem=$((contagem+1))
			[[ ${contagem} -eq 10 ]] && {
				echo -e "\n\nerr_log:$dominio:\n${noticia}" >> err_log.txt
				break
			}

			ffmpeg -i production/${dominio}.mp3 production/${dominio}.wav && {
				break
			} || {
				rm -rf production/${dominio}.mp3
				noticiar "$noticia" "production" "${idioma}"
				echo -e "\nparte inicial:$dominio:\n${noticia}" >> err_log.txt
			}
		done
		rm -rf "production/${dominio}.mp3" &

		noticiar "${titulo}" "podcast" "${idioma}"

		contagem=0
		while :
		do
			contagem=$((contagem+1))
			[[ ${contagem} -eq 10 ]] && {
				echo -e "\n\nerr_log:$titulo" >> err_log.txt
				break
			}

			ffmpeg -i podcast/${dominio}.mp3 podcast/${dominio}_intro.wav && {
				break
			} || {
				rm -rf podcast/${dominio}.mp3
				noticiar "${titulo}" "podcast" "${idioma}"
				echo -e "\nparte inicial:$titulo" >> err_log.txt
			}
		done
		rm -rf "podcast/${dominio}.mp3"

		echo "a" > contagem
	)&
	}
done < analisar.url

#esperar todos os subprocessos finalizarem
while :
do
	soma=$(wc -l <<< $(cat contagem))
	contagem=$((contagem+soma))
	[[ "$contagem" = "${total_sites}" ]] && break
done

for i in production/*.wav;do
	sox ${i} -r 16000 ${i%.*}_news.wav vol 2.7
	rm -rf ${i}
	sox ${i%.*}_news.wav sons/transit.wav ${i%.*}_intro_modify.wav
	rm ${i%.*}_news.wav
	mv ${i%.*}_intro_modify.wav ${i%.*}_news.wav
done

for i in podcast/*.wav;do
	sox ${i} -r 16000 ${i%.*}_news.wav vol 2.7
	rm ${i}
	sox ${i%.*}_news.wav sons/transit.wav ${i%.*}_modify.wav
	rm ${i%.*}_news.wav
	mv ${i%.*}_modify.wav ${i%.*}.wav
done
}

# datas faladas
meses=('unknow' 'janeiro' 'fevereiro' 'março' 'abril' 'maio' 'junho' 'julho' 'agosto' 'setembro' 'outubro' 'novembro' 'dezembro')
IFS=':' read dia mes <<< $(date +%d:%m)
[[ "${dia:0:1}" = '0' ]] && dia=${dia/0/}
[[ "${mes:0:1}" = '0' ]] && mes=${mes/0/}

#dado imutável
transit="e agora vamos para as notícias."
fim="e estes foram os principais destaques até o momento, espéro que tenham gostado, tenha um ótimo dia."

#contagem de usuários registrados
while read line;do
	[[ "${line}" ]] && {
		[[ "${line}" = *":inativo:"* ]] || total_users=$((total_users+1))
	}
done < fontes.ref

tempo=0
#dados mutáveis dependentes de dados individuais
while IFS=':' read F1 F2 F3 F4 F5 F6;do
	[[ "${F1}" ]] && {
		[[ "${F3}" = "inativo" ]] || {
			tempo=$((tempo+2))
		(
			sleep ${tempo}s

			intro="oi, sejam bem vindos ao podcast do ${F4} ${F5}, eu me chamo eduarda, hoje é dia $dia de ${meses[$mes]}, e vamos para as principais notícias do momento."
			IFS=';' read S1 S2 S3 S4 <<< "${F6}"
			ref="estas notícias foram retiradas do ${S1}, ${S2}, ${S3}, e ${S4}."

#INTRODUÇÃO
			fono "${intro}" "podcast" "${F1}_intro" "${idioma}"

			sleep 0.5s

			ffmpeg -i podcast/${F1}_intro.mp3 podcast/${F1}_intro.wav

			rm -rf podcast/${F1}_intro.mp3

				IFS=';' read C1 C2 C3 <<< "$(fgrep "${S4}" consulta.lil)"
				
				[[ "${C1}" =~ (nytimes|arstechnica|omgubuntu) ]] && idioma="ingles" || idioma="portugues"
				C3+=". ${transit}"

				fono "${C3}" "podcast" "${F1}_intro_1" "${idioma}"

				ffmpeg -i podcast/${F1}_intro_1.mp3 podcast/${F1}_intro_1.wav
				rm -rf podcast/${F1}_intro_1.mp3

# regulando volumes

			sox podcast/${F1}_intro.wav -r 16000 podcast/${F1}_segunda-etapa0.wav vol 2.5
			sox podcast/${F1}_intro_1.wav -r 16000 podcast/${F1}_segunda-etapa1.wav vol 2.5
			rm -rf podcast/${F1}_intro_1.wav podcast/${F1}_intro.wav

#último título receberá som de transição. logo, juntar todos, e depois som de transição.

				sox podcast/${F1}_segunda-etapa0.wav sons/transit.wav podcast/${F1}_segunda-etapa0_modify.wav
				sox podcast/${F1}_segunda-etapa1.wav sons/transit.wav podcast/${F1}_segunda-etapa1_modify.wav
				rm podcast/${F1}_segunda-etapa0.wav podcast/${F1}_segunda-etapa1.wav
				mv podcast/${F1}_segunda-etapa0_modify.wav podcast/${F1}_segunda-etapa0.wav
				mv podcast/${F1}_segunda-etapa1_modify.wav podcast/${F1}_segunda-etapa1.wav

#juntar todos eles em um só de forma organizada, e deletar todos os anteriores soltos

			juntar+="podcast/${F1}_segunda-etapa0.wav podcast/${S1}_intro.wav podcast/${S2}_intro.wav podcast/${S3}_intro.wav podcast/${F1}_segunda-etapa1.wav"

			sox $juntar podcast/${F1}_primeira_parte.wav
			[[ -a podcast/${F1}_primeira_parte.wav ]] || {
				sox $juntar podcast/${F1}_primeira_parte.wav || {
					echo -e "\n\narquivo da primeira parte não convertido, podcast[${F1}], dados do fono:${C2}|podcast|${F1}_intro|${idioma}" >> err_log.txt
				}			
			}
			rm -rf podcast/${F1}_segunda-etapa0.wav podcast/${F1}_segunda-etapa1.wav

#juntar notícias que serão narradas para este usuário

			news="production/${S1}_news.wav production/${S2}_news.wav production/${S3}_news.wav production/${S4}_news.wav"

#juntar as notícias com roteiro final
			sox ${news} podcast/${F1}_segunda_parte.wav

#incluir a música de fundo da primeira parte

#pegar a duração total da primeira parte
			[[ "$(sox --i podcast/${F1}_primeira_parte.wav)" =~ ([0-9]{2}\:){2}[0-9]{2}\.[0-9]{2} ]]

#escolher som de fundo e cortar na proporção da primeira parte

			sox sons/fundo$[$RANDOM%7+1].wav podcast/${F1}_primeiro_som.wav trim 0 ${BASH_REMATCH[0]}

#juntar som de fundo com a primeira parte
			sox -m podcast/${F1}_primeira_parte.wav podcast/${F1}_primeiro_som.wav podcast/${F1}_camada1.wav
			rm -rf podcast/${F1}_primeira_parte.wav podcast/${F1}_primeiro_som.wav

#incluir a música de fundo da segunda parte
#pegar a duração total da segunda parte
			[[ "$(sox --i podcast/${F1}_segunda_parte.wav)" =~ ([0-9]{2}\:){2}[0-9]{2}\.[0-9]{2} ]]

#escolher som de fundo e cortar na proporção da primeira parte

			sox sons/saida$[$RANDOM%3+1].wav podcast/${F1}_segundo_som.wav trim 0 ${BASH_REMATCH[0]}

#juntar som de fundo com a primeira parte
			sox -m podcast/${F1}_segunda_parte.wav podcast/${F1}_segundo_som.wav podcast/${F1}_camada2.wav
			rm -rf podcast/${F1}_segunda_parte.wav podcast/${F1}_segundo_som.wav

#converter as duas partes para mono
			for i in podcast/${F1}_camada*.wav;do
				[[ "${i}" =~ ${F1}_camada(.{1,2})\.wav ]] && {
					ffmpeg -i ${i} -ac 1 podcast/${F1}_camada_mono${BASH_REMATCH[1]}.wav || {
						rm -rf podcast/${F1}_camada_mono${BASH_REMATCH[1]}.wav
						ffmpeg -i ${i} -ac 1 podcast/${F1}_camada_mono${BASH_REMATCH[1]}.wav
					}
				rm -rf ${i}
				}
			done

			sox podcast/${F1}_camada_mono1.wav podcast/${F1}_camada_mono2.wav podcast/${F1}_final.wav
			rm -rf podcast/${F1}_camada_mono1.wav podcast/${F1}_camada_mono2.wav

			ffmpeg -i podcast/${F1}_final.wav -vn -ar 44100 -ac 2 -b:a 192k podcast/newslettercast_${F1}.mp3
			rm -rf podcast/${F1}_final.wav

			echo "a" > contagem
		)&
	}
}
done < fontes.ref

#esperar todos os subprocessos finalizarem
contagem=''
while :
do
	recebido=$(wc -l <<< $(cat contagem))
	verify=${recebido#*0}
	contagem=$((contagem+${rerify:-$recebido}))
	[[ "${contagem}" = "${total_users}" ]] && break
done
