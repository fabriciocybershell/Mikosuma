#! /bin/bash

#fonetica=$(echo $1| tr -d '\n')
fonetica=${1,,}
fonetica=${fonetica//google/gúgou}
fonetica=${fonetica//play/plêy}
fonetica=${fonetica//ifood/aifuud}
fonetica=${fonetica//whatch/uóti}
fonetica=${fonetica//covid-19/covid dizenove}
fonetica=${fonetica//eléctrico/elétrico}
fonetica=${fonetica//spotfy/spóti fái}
fonetica=${fonetica//playlist/pleylist}
fonetica=${fonetica//yahoo/iaruu}
fonetica=${fonetica//podcast/pódiquésti}
fonetica=${fonetica//display/displei}
fonetica=${fonetica//iphone/aifone}
fonetica=${fonetica//live/láive}
fonetica=${fonetica// ,/, }
fonetica=${fonetica// \?/\? }
fonetica=${fonetica//headset/readsét}
fonetica=${fonetica//chrome/crome}
fonetica=${fonetica//startup/estartáp}
fonetica=${fonetica//setup/setáp}
fonetica=${fonetica// \|/\,}
fonetica=${fonetica//action/éction}
fonetica=${fonetica//online/onláine}
fonetica=${fonetica//software/sóftwér}
fonetica=${fonetica//whatsapp/uátzap}
fonetica=${fonetica//bing/bíng}
fonetica=${fonetica//ransomware/ransomwér}
fonetica=${fonetica//smart/smárt}
fonetica=${fonetica//device/deváice}
fonetica=${fonetica//iot/íótêê}
fonetica=${fonetica//designer/desáiner}
fonetica=${fonetica//site/sáite}
fonetica=${fonetica//renault/renôú}
fonetica=${fonetica//facebook/feicebúck}
fonetica=${fonetica//microsoft/maicroçófit}
fonetica=${fonetica//windows/uindouls}
fonetica=${fonetica//apple/épou}
fonetica=${fonetica//telegram/télegrâm}
fonetica=${fonetica//instagram/ínstagrâm}
fonetica=${fonetica//uber/úber}
fonetica=${fonetica//bluetooth/blutufi}
fonetica=${fonetica//like/láique}
tratar=${fonetica//usuarios/usuáríos}
tratar=${tratar//puta/mãe}
tratar=${tratar//cyberpunk/saiberpânk}
tratar=${tratar//porra/lindo}
tratar=${tratar//caralho/delícia}
tratar=${tratar//bunda/nádega}
tratar=${tratar//app/ép}
tratar=${tratar//canaltech/canal téck}
tratar=${tratar//delivery/delíveri}

tratar=$(tr -d '\&\*\+\-\/\<\=\>\^\_\`\{\|\}\~' <<< "$tratar" | sed 's/([^)]*)//')
tratar=$(jq -R -r @uri <<< "$tratar")
tratar=$(tr -d '\n' <<< $tratar)

[[ "${3}" =~ "portugues" ]] && idioma="pt-BR_IsabelaV3Voice"
[[ "${3}" =~ "ingles" ]] && idioma="en-US_AllisonV3Voice"

curl -s "https://text-to-speech-demo.ng.bluemix.net/api/v3/synthesize?text=${tratar:-erro, conteúdo não capturado.}&voice=${idioma:-pt-BR_IsabelaV3Voice}&ssmlLabel=SSML&download=true&accept=audio%2Fmp3" \
  -H 'Connection: keep-alive' \
  -H 'DNT: 1' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36' \
  -H 'Accept: */*' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-Mode: no-cors' \
  -H 'Sec-Fetch-Dest: audio' \
  -H 'Referer: https://text-to-speech-demo.ng.bluemix.net/' \
  -H 'Accept-Language: pt-BR,pt;q=0.9,en;q=0.8' \
  --output ${2}.mp3
