#! /bin/bash

# primeiras versões do algoritmo de criação
# e postagem de podcasts automatizados, com 
# base em dados coletados de sites relevantes
# de notícias e usando a tecnologia a biblioteca
# maravilhosa chamada sox.

#limpar os diretórios de produção de conteúdo
rm podcast/noticia.txt
rm podcast/*.mp3
rm podcast/*.wav
rm production/*
#--------------------------------------------

contador=0

fono(){
	fonetica=${1,,}
	fonetica=${fonetica//\"/\'}
	./IBMvoz.sh "$fonetica" "podcast/${contador}saida${seu_id}"
	contador=$((contador+1))
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

# criar a lista dos links de criação de podcasts autorizados por padrão
echo "
conf1/https://www.nytimes.com/;ingles
conf2/https://canaltech.com.br/;portugues
conf1/https://olhardigital.com.br/;portugues
conf3/https://arstechnica.com/;ingles
conf4/https://www.oobservador.com.br/;portugues
conf5/https://www.cnnbrasil.com.br/;portugues
conf5/https://g1.globo.com/;portugues
conf1/https://www.omgubuntu.co.uk/;ingles
" > sites.url

#padronização dos campos de delimitação
#f1 ID do usuário
#f2 fonte que ele deseja
#f3 fonte que ele deseja
#f4 fonte que ele deseja
#f5 fonte que ele deseja
# id:conf_numero_/link

while IFS='/' read F1 F2 F3 F4 F5;do

  link=''
  [[ "${F1}" = *"conf"* ]] && {

    #capturar nomes de domínios para utilizar em dadas situações
    IFS='.' read D1 D2 D3 <<< "${F4}"
    [[ "${D1}" = "www" ]] && dominio="${D2}" || dominio="${D1}"

    [[ "${F1}" = "conf1" ]] && padr="(${F2}//${F4//./\\.}/)(([0-9]{2}|$(date +%Y))/[0-9]{2}/([0-9]{2}|$(date +%Y))|[0-9]{1,}).*[^\"]*\""
    [[ "${F1}" = "conf2" ]] && padr="(href=\")/.{6,}/([0-9]{2}|$(date +%Y))?/[a-z]{3,}.*[^\"]*\""
    [[ "${F1}" = "conf3" ]] && padr="https?://(${F4}).*/([0-9]{2}|$(date +%Y))/[^\"]*\""
    [[ "${F1}" = "conf4" ]] && padr="(href=\"/).*/.*([0-9]{2,4}).*[a-z]{3,}.*[^\"]*\""
    [[ "${F1}" = "conf5" ]] && padr="<a href=\"https?://(${F4}).*/.*/([0-9]{2}|$(date +%Y))/.*[^\"]*\""
    
    IFS='"' read A1 A2 A3 <<< "$(curl -is "${F2}//${F4}/" | egrep -o "${padr}")"

    [[ "${F1}" = "conf1" || "${F1}" = "conf3" ]] && link="${A1}"
    [[ "${F1}" = "conf2" || "${F1}" = "conf4" ]] && link="${F2}//${F4}${A2}"
    [[ "${F1}" = "conf5" ]] && link="${A2}"

    # daqui para > tratar página e resumir
   # echo -e "$link\n"
done < render.url
#------------------------------------------------------------------

# datas faladas
meses=('unknow' 'janeiro' 'fevereiro' 'março' 'abril' 'maio' 'junho' 'julho' 'agosto' 'setembro' 'outubro' 'novembro' 'dezembro')
mes=$(date +%m)
dia=$(date +%d)
[[ "${dia:0:1}" = '0' ]] && dia=${dia/0/}

#narrar o roteiro
tipo="grupo"
nome="programando em ..."

intro="oi, sejam bem vindos ao podcast do ${tipo} ${nome}, eu me chamo eduarda, hoje é dia $dia de ${meses[$mes]}, e vamos para as principais notícias do momento."
transit="e agora vamos para as notícias."
ref="estas notícias foram retiradas do canal téqui, olhár digital, o observador, e CNN brasil."
fim="e estes foram os principais destaques até o momento, espéro que tenham gostado, tenha um ótimo dia."

titulo=$(curl -s 'https://canaltech.com.br/ultimas/' | egrep -o '<h3[^<]*</h3>' | head -n 1)
link_noticia_canaltech=$(curl -s 'https://canaltech.com.br/ultimas/' | egrep -o '<a .*type-artigo[^>]*>' | head -n 1)
titulo1=${titulo#*>}
titulo1=$(html2text -utf8 -nometa <<< "${titulo1%<*}")

link_noticia_canaltech=${link_noticia_canaltech#*/}
link_noticia_canaltech=${link_noticia_canaltech%%\"*}
materia=$(curl -s "https://canaltech.com.br/${link_noticia_canaltech}" | egrep -o '<p>.*<\/p[^>]*>' | sed 's/<[^>]*>//g')
tratando
noticia1=$(html2text -utf8 -nometa <<< "${tratar}")

noticia1=$(tr -d '\n' <<< "$noticia1")


link_noticia_olhar_digital=$(curl -s 'https://olhardigital.com.br/editorias/noticias/' | egrep -o '<a href="[^>]*alt=.*>' | sed 's/\&[^;]*;//g' | head -n1)

title=$(egrep -o 'title="[^"]*"' <<< "${link_noticia_olhar_digital}")
IFS='"' read f1 titulo2 <<< ${title}
titulo2=$(html2text -utf8 -nometa <<< "$titulo2")

link=$(egrep -o 'href="[^"]*"' <<< "${link_noticia_olhar_digital}")
IFS='"' read f1 link_noticia_olhar_digital <<< ${link}

materia=$(curl -s "$link_noticia_olhar_digital" | egrep -o '<p>.*</p>' | sed 's/<[^>]*>//g')

tratando

noticia2=$(html2text -utf8 -nometa <<< "${tratar}")
noticia2=$(tr -d '\n' <<< "$noticia2")

IFS='"' read f1 f2 f3 f4 f5 <<< $(curl -s 'https://observador.pt/seccao/auto/mercado/' | egrep -o '<a class="obs-accent-color" href="https://observador.pt/[0-9]{4}.*[^>]*/a>' | head -n1)
titulo3=${f5#\>*}
titulo3=${titulo3##*\/span\>}
titulo3=$(html2text -utf8 -nometa <<< "${titulo3%\<*}")

link_noticia_observador=$f4

materia=$(curl -s "$f4" | egrep -o '<p>.*</p>' | sed 's/<[^>]*>//g')

tratando
noticia3=$(html2text -utf8 -nometa <<< "$tratar")
noticia3=$(tr -d '\n' <<< "$noticia3")

IFS='"' read f1 f2 f3 f4 f5 <<< $(curl -s 'https://www.cnnbrasil.com.br/' | egrep -o '<a title[^>]*>' | egrep '/[0-9]{4}/[0-9]{2}' | head -n1)
[[ "$f4" ]] && {
	link_noticia_cnn_brasil="https://www.cnnbrasil.com.br/$f4"
} || {
	IFS='"' read f1 f2 f3 f4 f5 <<< $(curl -s 'https://www.cnnbrasil.com.br/' | egrep -o '<a [^>]*>' | egrep '/[0-9]{4}/[0-9]{2}' | head -n1)
	link_noticia_cnn_brasil="$f2"
}

[[ "$f2" = *'http'* ]] && {
	titulo4='titulo não capiturado'
} || {
	titulo4=$(html2text -utf8 -nometa <<< "$f2")
}

materia=$(curl -s "$link_noticia_cnn_brasil" | egrep -o '<p>.*</p>' | sed 's/<[^>]*>//g')

tratando
noticia4=$(html2text -utf8 -nometa <<< "${tratar%%\<*}")
noticia4=$(tr -d '\n' <<< "$noticia4")
#echo ${titulo4} | html2text -utf8 -nometa >> podcast/comment.txt

echo "1: ${titulo1:-titulo não capiturado}<br><br>2: ${titulo2:-titulo não capiturado}<br><br>3: ${titulo3:-titulo não capiturado}<br><br>4: ${titulo4:-titulo não capiturado}<br><br>BY: @engenhariade_bot<br><br>links/fontes:<br><br>" | html2text -utf8 -nometa > podcast/titulos.txt

fono "$intro"
fono "$titulo1"
fono "$titulo2"
fono "$titulo3"
fono "$titulo4. $transit"
noticia1=$(./sumarizador_novo.sh "$noticia1" | head -n5)
fono "canal téck. ${noticia1#*\%}"
noticia2=$(./sumarizador_novo.sh "$noticia2" | head -n5)
fono "olhar digital. ${noticia2#*\%}"
noticia3=$(./sumarizador_novo.sh "$noticia3" | head -n5)
fono "observador. ${noticia3#*\%}"
noticia4=$(./sumarizador_novo.sh "$noticia4" | head -n5)
fono "cnn brasil. ${noticia4#*\%}"
fono "$ref"
fono "$fim"

cd podcast

for i in *;do
	[[ "$i" = *'.mp3'* ]] && {
		ffmpeg -i $i ${i%.*}.wav
	}
done

rm -rf *.mp3

for i in *;do
	[[ "$i" = *'.wav'* ]] && {
		sox $i -r 16000 ${i%saida*}segudaetapa.wav vol 2.5
	}
done

rm -rf *saida*

for i in *;do
	[[ "$i" = *'.wav'* ]] && {
		sox $i ../sons/transit.wav ${i%segudaetapa*}finalizar.wav
	}
done

rm -rf *segudaetapa.wav

juntar=''
for i in {0..4};do
	juntar+="${i}finalizar.wav "
done

sox $juntar primeiraparte.wav

rm $juntar

juntar=''
referencia=''
numero=1

while read linha;do
	[[ "$linha" = *"primeiraparte"* ]] || {
		[[ "$linha" = *'.wav'* ]] && {
			juntar+="${linha%%finalizar*}finalizar.wav "
			duration=$(sox --i $linha | fgrep 'Duration')
			duration=${duration#*:}
			duration=${duration%% =*}
			duration=${duration%.*}
			#echo "$numero: [ $duration ] " >> titulos.txt
			numero=$((numero+1))
		}
	}
done <<< $(printf "%s\n" * | sort -n)

sox $juntar segundaparte.wav

rm $juntar

duration=$(sox --i primeiraparte.wav | fgrep 'Duration')
duration=${duration#*:}
duration=${duration% =*}

sox ../sons/fundo$[$RANDOM%7+1].wav som.wav trim 0 ${duration}

sox -m primeiraparte.wav som.wav 0primeiraparte.wav

rm som.wav primeiraparte.wav

duration=$(sox --i segundaparte.wav | fgrep 'Duration')
duration=${duration#*:}
duration=${duration% =*}

sox ../sons/saida$[$RANDOM%3+1].wav som.wav trim 0 ${duration}

sox -m segundaparte.wav som.wav 1segundaparte.wav

rm som.wav segundaparte.wav

contador=0
for i in *;do
	[[ "$i" = *'.wav'* ]] && {
		ffmpeg -i $i -ac 1 ${contador}mono.wav
		contador=$((contador+1))
		rm $i
	}
done

sox 0mono.wav 1mono.wav newsletter.wav

rm 0mono.wav 1mono.wav

ffmpeg -i newsletter.wav -vn -ar 44100 -ac 2 -b:a 192k newsletter.mp3

rm newsletter.wav

mv newsletter.mp3 newsletter$(date +%Y%d).mp3

echo "canaltech:https://canaltech.com.br/$link_noticia_canaltech" > noticia.txt
echo "olhar digital:$link_noticia_olhar_digital" >> noticia.txt
echo "observador:$link_noticia_observador" >> noticia.txt
echo "cnn brasil:$link_noticia_cnn_brasil/" >> noticia.txt
