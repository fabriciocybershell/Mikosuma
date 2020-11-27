<img src="https://img.shields.io/liberapay/gives/fabriciocybershell.svg?logo=liberapay">

# mikosuma

**mikosuma** é um projeto de bot para telegram, capaz de gerenciar um grupo completo **apenas** pela linguagem natural, agindo como uma humana comum, capaz de realizar as seguntes coisas:

1. atender novos integrandes;
2. fazendo checagens para verificar se são pessoas ou bots;
3. verificar imagens para ver se é algum tipo de spam ou propaganda;
4. transcrever audios e interpretar os audios;
5. buscar significado de palavras;
6. reconhecer e marcar dúvida das pessoas;
7. buscar cursos gratuitos nas plataformas de cursos;
8. sensurar palavrões ou mensagens com um tom de ameaça;
9. criar enquetes por conta própria ( porém pré configuradas, nada de forma automática e por conta própria ainda );
10. fixar soluções de dúvidas;
11. categorizar habilidades dos integrantes;
12. mandar audios de forma humana;
13. mandar stickers;
14. mandar fotos;
15. mandar videos em scope;
16. mandar arquivos;
17. responder a mensções ao seu nome ou apelido;
18. interagir com bom dia, tarde e noite;
19. fazer leves brincadeiras;
20. detectar spammers por palavras chave e links maliciosos;
21. realizar anotações interna das dúvidas, habilidades, e usuários sendo avaliados;
22. simular algumas breves dúvidas em alguns assuntos para dar assuntos ao grupo ( apenas com algumas duvidas configuradas, sobre PHP, e comentários sobre inteligencia artificial. );
23. um novo sistema de postagem de conteúdo automatizada;
34. possui controle comportamental por botões de menua, permitindo configurar como ela irá agir nos grupos.

## atualização
1. a nova atualização permite a customização das ações da duda, você pode configurar a "personalidade" dela em como ela irá agir nos grupos e o que ela irá avaliar;
2. sistema de postagem de conteúdo automatizada. este sistema permite ela ir atrás de conteúdos pela internet para realizar postagens em canais de forma autonoma, com título e tag do tópico solicitado. o canal padrão é definido dentro do código, ainda não adaptado para personalização.
3. personalização de referências. agora você pode personalizar qual o canal do grupo e o link de regras do grupo. para que ela possa orientar novos membros, realizar notificações sobre as regras quando houver violações e enviar o canal e ou regras caso algueḿ slicitar atravéz de uma perunta.
4. uma documentação foi criada, com todos os passos de como utilizar ela nos chats e quais palavras provocam tais tipos de ações. ainda ñao completamente atualizado com algumas destas novas funções descritas acima, porém serão incluídas aos poucos nesta mesma página.
5. melhorias na forma dela se expressar. todas as palavras foram trocadas e o método de atender membros sofreu uma alteração, e alguns bugs foram corrigidos. 

## nota:
alguns bugs ainda persistem, que envolve bancos de dados e marcações de ações.

um novo sistema esta em desenvolvimento, e haverá melhorias na forma de capiturar contextos com linguagem natural, e estou criando um container com todos os recursos necessários para rodar a duda (mikosuma), com as dependências de forma mais otimizada e menos trabalhosa o possível. o código será refatorado por completo e sofrerá mais otimizações radicais, possivelmente algumas coisas serão recriadas novamente (funções passadas que foram deletadas por inutilidade), e um novo "motor" de interação será criado para tornar ela mais humana e mais espontânea em chats, sem a necessidade constante de ativações e reações/mensagens/ações ou interações diretas. simulação de dúvidas e possivelmente um certo nível de aprendizado autônomo de palavras e interações novas, assim como o sistema de postagem de conteúdo autônomo, aualmente ele mantém apenas uma plataforma como padrão, mas ele permite a adição de várias outras, o estilo livre ainda não foi adotado pela taxa de erro em buscas e falsos positivos, e a confiabilidade de algumas plataformas.
## obs:
use a duda por sua conta e rísco, fique sempre de olho no algoritmo em execussão. para o sistema de postagens ainda necessita de melhorias em relação a navegação e gerenciamento de pastas. pois o mesmo fica em um servidor remoto dedicado a downloads, linhas comentadas sobre a comunicação ssh com outro servidor estão no arquivo: torrentservice2.sh, onde ele é responsável pela busca do conteúdo online e categorização, filtragem e armazenamento de links de arquivos com amrcações, que se comunica com um servidor remoto para ativar outro algoritmo (analisareupar.sh), que é responsável pelo download, análise do arquivo (se é compactado, se tem várias pastas, os tipos de arquivos e as tags de tópico), e realiza limpeza após a postagem dos conteúdos no canal. lembrando que ele ainda necesista que seja arrumado na hierarquia de pastas, mas serve para estudos. a hierarquia de pastas que você deve criar dentro da pasta do bot é:
´´´baixado > zzanalisar > perigo´´´
onde ela deveria realizar as operações em um servidor remoto, e fiz uma adaptação para unificar em um mesmo ecosistema os rês bots. a duda, o de busca, categorização e comunicação, e o de download, análise, postagem e limpeza.
para ajudar com as melhorias e evoluções (se considerar este projeto útil), me ajude com uma doação, é um projeto que estou desenvolvendo sozinho, com algumas coisas confusas e outras bem feitas e organizadas. pois bem, aproveite :D

## a parte abaixo esta desatualizada

segue alguns exemplos, fluxogramas e pseudocódigo da mikosuma ( nem todos atualizados, fazemos evoluções diárias ):
## fluxograma de funcionamento resumido de algumas funções
![](mikosuma.png)
## pseudocódigo
permite a criação de roteiros de interação de forma fácil, sem a necessidade de saber muito para poder construir interações.
![](pseudomiko.png)

<a href="https://liberapay.com/fabriciocybershell/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a>

# dependências
´´´
jq, imagemagick, ffmpeg, python3, speech_recognition (python), curl, translate-shell.
´´´

