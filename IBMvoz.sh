#! /bin/bash

tratar="$1"
tratar=${tratar//\+/\%\2\B}
tratar=${tratar// /\+}
tratar=${tratar//â/\%\C\3\%\A\2}
tratar=${tratar//ã/\%\C\3\%\A\3}
tratar=${tratar//ç/\%\C\3\%\A\7}
tratar=${tratar//á/\%\C\3\%\A\1}
tratar=${tratar//\,/\%\2\C}
tratar=${tratar//\:/\%\3\A}
tratar=${tratar//\;/\%\3\B}
tratar=${tratar//\//\%\2\F}
tratar=${tratar//\?/\%\3\F}
tratar=${tratar//\*/\%\2\A}
tratar=${tratar//\{/\%\7\B}
tratar=${tratar//\}/\%\7\D}
tratar=${tratar//ó/\%\C\3\%\B\3}
tratar=${tratar//ô/\%\C\3\%\B\4}
tratar=${tratar//é/\%\C\3\%\A\9}
tratar=${tratar//ê/\%\C\3\%\A\A}
tratar=${tratar//í/\%\C\3\%\A\D}
tratar=${tratar//ú/\%\C\3\%\B\A}
tratar=${tratar//\</\%\3C}
tratar=${tratar//\>/\%\3\E}
tratar=${tratar//porra/lindo}
tratar=${tratar//caralho/delicia}
tratar=${tratar//bunda/nadegas}

curl "https://text-to-speech-demo.ng.bluemix.net/api/v3/synthesize?text=${tratar}&voice=pt-BR_IsabelaV3Voice&ssmlLabel=SSML&download=true&accept=audio%2Fmp3" \
  -H 'Connection: keep-alive' \
  -H 'DNT: 1' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36' \
  -H 'Accept: */*' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-Mode: no-cors' \
  -H 'Sec-Fetch-Dest: audio' \
  -H 'Referer: https://text-to-speech-demo.ng.bluemix.net/' \
  -H 'Accept-Language: pt-BR,pt;q=0.9,en;q=0.8' \
  --compressed --output ${2}.mp3