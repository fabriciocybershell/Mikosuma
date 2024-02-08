# Security Policy

## Supported Versions
falhas de segurança encontradas que estão a ser investigadas: falta de proteções em algumas strings, e expansão de parâmetros
que podem possibilitar interpretação direta de strings na linha de comando aberta, as falhas foram relatadas, e ainda serão
investigadas.

os programas utilizados que possam vir a ter alguma falha são externas ao código da duda: curl, jq, sox e pdf2text.

as atualizações saem de forma não definida, pois ela é desenvolvida na medida que eu vou
encontrando brechas de tempo no meu dia a dia. isso sem falar em outros projetos pessoais
que andam ocorrendo ao mesmo tempo, sendo a duda uma delas, porém ela é atualizada bem aos
poucos, em off no meu sistema, e sendo atualizada em tempo real em um servidor remoto onde
ela está hospedada.

as atualizações são enviadas aqui de tempos em tempos, podendo ser extremamente longos, ou
as vezes mega curtos, podendo ser de hora em hora. na maioria das vezes, é de tempos em tempos,
pode-se dizer que seria quase 1 vez a cada 4 mêses ou mais. conforme vou conseguindo tempo, as
atualizações podem ir aumentando gradualmente.

## Reporting a Vulnerability

para me relatar uma vulnerabilidade na duda, seja ela qual for,
descreva de forma completa como você fez para encontrar a falha,
e quais passos eu devo seguir para avaliar o mesmo. a possível linha
ou localização do código que possua esta vulnerabilidade, e se souber
uma forma de como contornar, será bem vinda também.

nada tão completo como um mega relatório, apenas dizer como posso reproduzir,
onde estaria a suposta falha, e apenas se possível, como posso fazer a correção.
