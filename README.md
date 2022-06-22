<img src="https://img.shields.io/liberapay/gives/fabriciocybershell.svg?logo=liberapay">

[<img src="https://img.shields.io/github/languages/code-size/fabriciocaetano/mikosuma">](https://img.shields.io/github/languages/code-size/fabriciocaetano/mikosuma)
# eduarda monteiro

**eduarda** é um projeto de bot para telegram, capaz de gerenciar um grupo completo por linguagem natural e poucos comandos, agindo como uma humana comum, capaz de realizar as seguntes ações:

1. atender novos integrandes;"
2. fazendo checagens para verificar se são pessoas ou bots durante o processo de entrada;"
3. verificar imagens, GIFs, stickers e vídeos para ver se é pornografia, propaganda, discurso de ódio e afins.;"
OBS: análise de spans, propagandas e discurso de ódio esta sendo refeita;"
4. transcrever audios e interpretar os audios;"
5. buscar significado de palavras;"
6. reconhecer e marcar/fixar dúvidas, dicas e desafios das pessoas;"
7. buscar cursos gratuitos nas plataformas de cursos, além de buscas e postagens de conteúdos;"
OBS: desativado por partes para recriar de forma mais eficiente;"
8. censurar palavrões ou mensagens com um tom de ameaça;"
9. criar enquetes por conta própria ( porém pré configuradas, nada de forma automática e autônoma ainda);"
10. baixar músicas gratuitas do sondcloud;"
11. coletar e categorizar habilidades dos integrantes em uma tabela consultável, o que lhe permite perguntar quem possui tais habilidades, e os nicks são enviados;"
12. mandar audios de forma humana durante interações 'sintetizar textos';"
13. criar podcasts por conta própria 'acessar os principais sites, coletar a primeira noticia de cada um deles, resumir com um algoritmo estatístico, elaborar o roteiro, gravar os audios, editar com sons de transição, músicas de fundo, e realização da postagem' (ela permite você configurar a criação de podcasts individuais para cada canal ou grupo de sua escolha. notícias personalizadas diariamente apenas para você em seus canais e grupos, 4 por dia de 6 em 6 horas);"
LINK do canal da duda de postagem de podcasts diários: https://t.me/mikoduda;"
14. mandar um vídeo gravado de seu próprio rosto 'diga: duda grava seu rosto';"
15. analisar links maliciosos cadastrados em um banco de dados isolado 'e um grupo que te permite ajudar a denunciar e reconhecer estes links: https://t.me/joinchat/Pln8-K6Uwp45OTNh';"
16. evitar flood dos membros, dando alguns avisos caso a pessoa escreva de forma picotada, ou esteja chegando perto do limite;"
17. responder a mensções ao seu nome ou apelido 'o que permite você perguntar algumas coisas ou conversar brevemente com ela ...';"
18. interagir com bom dia, tarde e noite;"
19. fazer leves brincadeiras (alterado para formas normais de respóstas);"
20. resumir textos de mensagens (um recurso para resumir links , livros e documentos e em massa, esta sendo desenvolvido, por demandar muito processamento: será pago, menos esta de resumir mensagens);"
21. lhe permite adicionar link de regra e canal, sempre que alguém perguntar sobre ou pedir, ela irá mostrar;"
22. comentários e outros níveis de interações a depender dos tópicos das conversas (se ativado);"
23. buscar vídeos no youtube."

## API utilizada para 90% da comunicação com o telegram:

[ShellBot](https://github.com/shellscriptx/ShellBot)

## atualização
um novo sistema de banco de dados foi criado baseado no mysql, usando metodologias parecidas, porém usando recursos disponibilizados pelo shell.
o desempenho é ABSURDO, e entre outras coisas, todos os códigos foram refatorados, e os novos e alguns antigos criados foram separados em módulos, o que lhes permitem serem usados para outros projetos, funções novas da duda e APIs futuras.

## nota:
todo o código foi refatorado do absoluto 0, cada método foi refeito e reprojetado, funções mais inteligentes e algoritmos muito poderosos foram reconstruidos do zero, e outros construidos novos com técnicas mais atuais.

## obs:
use a duda por sua conta e rísco, fique sempre de olho no algoritmo em execussão, pois ela mesmo não necessariamente aprendendo com os dados como uma IA, porém os algoritmos são avançados o suficiente para já conseguirem mudar algumas das respóstas e comportamentos em diversas situações, algumas delas não programadas.

ela é autônoma, o que significa que muitos erros e problemas que ocorrerem ela esta programada para tentar lidar com eles por conta própria em alguns casos, porém em casos de parada, é recomendável verificar seu funcionamento online com o comando /vida, e se não houver respóstas, force a parada do algoritmo imediatamente se possível. boa sorte :D

<a href="https://liberapay.com/fabriciocybershell/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a> Pix: eduardamonteiro@telegmail.com

# dependências

## aqui estão listadas as dependências necessárias, as seguintes são para recursos ainda em desenvolvimento.

```
curl, jq, ffmpeg, sox, html2text.
```

## estes são os não necessários, pois os recursos estão desativados no código.
```
pdf2txt/pdftotxt, catdoc.

```

## comando direto para instalação de dependências:
```
sudo apt install curl ffmpeg html2text sox && sudo snap install jq || sudo apt install jq
```

## como rodar:
dê as permissões necessárias para o arquivo ser executado dentro da pasta:
```
chmod +x miko.sh
```
e rodando com:
```
./miko.sh
```
se aparecer um "dane-se" na tela, é porque esta tudo ok :D
