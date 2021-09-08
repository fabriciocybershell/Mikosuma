#! /bin/bash

cort(){
	[[ "${1,,}" =~ (pref(á|a)cio|ap(e|ê)ndice|about) ]] && cort=$(tr -d '\n' <<< "${1#*${BASH_REMATCH[0]}}") || cort=$(tr -d '\n' <<< "$1")
}

quebra_edit(){
	cort=${cort//\./\.\\n}
	cort=${cort//\?/\?\\n}
	cort=${cort//\!/\!\\n}
	sent=$(echo -e "$cort") # criar quebra de linha nos textos da variável.
	arquivo=${1%.*}
}

[[ "$1" = "-a" ]] && {

	[[ "$2" = *".txt"* ||  "$2" = *".md"* ]] && {
		cort "$(< $2)"
		quebra_edit
		rm ${2}
	}

	[[ "$2" = *".pdf"* ]] && {
		pdf2txt "$2" -o "${2%.*}.txt"
		cort "$(< ${2%.*}.txt)"
		quebra_edit
	}

	[[ "${2,,}" =~ https? ]] && {
		site=$(curl -s "$2")
		avaliar1=$(egrep -o '<p(.*)??>(.*)(</p>)?' <<< "$site")
		[[ "${avaliar1}" =~ (\{|\}| class\=) ]] && avaliar1=$(egrep -o '<p(.*)??>(.*)</p>' <<< "$site")
		cort "$(sed 's/<[^>]*>//g' <<< "${avaliar1}" | html2text -utf8 -nometa)"
		quebra_edit
	}

	[[ "$2" = *".doc"* ]] && { # ou docx
		catdoc "$2" > "${2%.*}.txt"
		rm "$2"
		cort "$(< ${2%.*}.txt)"
		rm "${2%.*}.txt"
		quebra_edit
	}
	arquivo=${2%.*}
} || {
	cort "$1"
	quebra_edit
}

#echo "fase:1"

num=0
while read sentenca;do
	[[ $sentenca ]] && {
		[[ "$sentenca" = *'“'* || "$sentenca" = *'”'*  || "$sentenca" = *'"'* || "$sentenca" = *':'* ]] && {
			[[ $segundo ]] && {
				array[$num]="${primeiro} ${sentenca}"
				array_tratado[$num]="${primeiro} ${sentenca}"
				num=$((num+1))
				segundo=''
			} || {
				primeiro=${sentenca}
				segundo=1
			}
		} || {
			array[$num]="${sentenca}"
			array_tratado[$num]="${sentenca,,}"
			num=$((num+1))
		}
	}
done <<< $sent

#echo "fase:2"

peso=$(tr ' ' '\n' <<< ${array_tratado[@],,} | tr -d '\!\"\“\”\#\$\%\&\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~' | sort | uniq -c)

#echo "fase:3"

for ((i=0;i<=$num;i++));do
	total=0
	value=0
	while read del;do
		del=" $del "
		array_tratado[$i]=${array_tratado[$i]//$del/ }
	done < stopword.pt

	for palavra in ${array_tratado[$i]};do
			value=$(fgrep " $palavra" <<< $peso | egrep -o '[0-9]{,12}' | head -n1)
			total=$((total+value))
	done
	array2[$i]=$total
done

#echo "fase:4"

for((i=0;i<=$num;i++));do
	somatoria[$i]="#${array2[$i]}: ${array[$i]}"
done

#echo "fase:5"

media=${array2[@]}
media=$((${media// /\+}))
[[ $media = 0 ]] && media=1
[[ $num = 0 ]] && num=1
media=$((media/num))

# redurir ainda mais na media
part=$((media/2))
media=$((media+part))

#echo "fase:6"
final=''

while read linha;do
	[[ "${linha%%:*}" =~ ^[0-9]{1,}$ ]] && {
		[[ ${linha%%:*} -ge $media ]] && {
			final+="${linha#*:}\n"
		}
	}
done <<< $(echo -e "${somatoria[@]//#/\\n}")

#echo "fase:7"

[[ "${@}" = *"--no"* ]] || {
	porcent=$((${#final}*100))
	porcent=$((${porcent:-1}/${#sent}))
	porcent=$((100-porcent))
	echo -e "nível de redução: ${porcent/-/}%\n"
}

sent=''

[[ "$1" = "-a" ]] && {
	[[ "$2" = *'http'* ]] && {
		echo -e "$final"
	} || {
		echo -e "$final" > "$arquivo.txt"
	}
} || {
	echo -e "$final"
}
