#! /bin/bash

# primeira versão do sumarizador.

#add stop words com bash patterns a partir de um arquivo .pt

i=0
while read word;do
	stopwords[$i]="$word"
	i=$((i+1))
done < stopword.pt

printf -v stop_word '%s|' "${stopwords[@]}"

tr '.' '\n' <<< "$(< texto.txt)" | tr '?' '\n' | tr '!' '\n' > sent.txt

num=0
while read sentenca;do
	[[ $sentenca ]] && {
		[[ "$sentenca" = *'“'* || "$sentenca" = *'”'*  || "$sentenca" = *'"'* ]] && {
			[[ $segundo ]] && {
				array[$num]="${primeiro} $sentenca"
#				echo ${array[$num]}
				num=$((num+1))
				segundo=''
			} || {
				primeiro=${sentenca,,}
				segundo=1
			} 
		} || {
			array[$num]="${sentenca,,}."
			num=$((num+1))
		}
	}
done < sent.txt

tr -d '\!\"\“\”\\#\$\%\&\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~' <<< ${array[@]} | sort | uniq -c > peso.pso

#echo "preposições: $num"
for((i=0;i<=$num;i++));do
	total=0
	value=0
	[[ ${array[$i]} ]] && {
	for palavra in ${array[$i]};do
		[[ $palavra == *(*)?( )@(${stop_word%|})?( )*(*) ]] || {
		value=$(fgrep " $palavra" peso.pso | head -n1 | egrep -o '[0-9]{,3}' | head -n1)
		total=$((total+value))
		array2[$i]=$total
	}
	#printf "valor: $i \r"
	done
}
done

for((i=0;i<=$num;i++));do
	somatoria[$i]="# ${array2[$i]}: ${array[$i]}"
done

quantia=${array2[@]}
quantia=${quantia// /}
quantia=${#quantia}
[[ $quantia = 0 ]] && quantia=1

media=${array2[@]}
media=$((${media// /\+}))
media=$((media/quantia))
[[ $media = 0 ]] && media=1

 > sent.txt

echo "${somatoria[@]}" | tr '#' '\n' | while read linha;do
[[ ${linha%%:*} -ge $media ]] && {
	echo "$linha" >> sent.txt	
}
done

final=''

while IFS=':' read f1 f2;do
	[[ $f2 ]] && final+="$f2\n"
done < sent.txt

#echo -e "$final" > texto.txt

echo -e "$final"
