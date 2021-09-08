#! /bin/bash

	fala="$1"

	fala=$(tr -d '\!\"\“\”\#\$\%\&\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~' <<< "$fala" )
	i=0

	#etapa de pontuação de fala
	while IFS=':' read f1 f2;do
		f1=$(tr -d '\!\"\“\”\#\$\%\&\(\)\*\+\,\-\.\/\:\;\<\=\>\@\[\\\]\^\_\`\{\|\}\~' <<< "$f1" )
		for palavra in $fala;do
			[[ "$f1" = *"$palavra"* ]] && ponto=$((ponto+1))
		done
		[[ "${f1}" ]] && {
			array[$i]="#${ponto:-0}:$f2"
			ponto=0
			i=$((i+1))
		}
	done < base.txt

	frase=$(echo -e "${array[@]//#/\\n}" | sort -nr | head -n1)
	IFS=':' read F1 F2 <<< "$frase"

	[[ "${F1}" = "0" ]] && {
		echo "hmmm..."
	} || {
		echo "${F2}"
	}