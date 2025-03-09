# Manual Para Customização Dos Níveis

Na pasta `levels_json/` existem três arquivos no formato JSON (JavaScript Object Notation): `level_1.json`, `level_2.json` e `level_3.json`. Esse formato de arquivo armazena informações em forma de texto estrutarado, facilitando a compreensão e troca de informações. No caso do nosso jogo, esses  arquivos estão armazenando toda a programação de destinos e tipos de rotas em cada fase de cada nível. Portanto, para alterar as fases, basta você editar esses arquivos JSON de acordo com a sua preferência seguindo as instruções abaixo.

## Estrutura dos arquivos JSON

Os arquivos JSON possuem a seguinte estrutura:

```json
{
	"level_no": 1,
	"phases": [
		[
			{
				"planet_name": "marte",
				"mode": 0
			}
		]
	]
}
```
<p align="center"><em>Código 1: Exemplo de um arquivo JSON para o nível 1.</em></p>


Tudo que está dentro de um par de chaves `{}` é um objeto JSON. Um objeto JSON é composto por pares de chave-valor, onde a chave é uma string (um texto entre aspas duplas, como `"Olá mundo!"`) e o valor pode ser qualquer tipo de dado que o JSON suporta (número, string, boolean, array, objeto, etc). A sintaxe de um objeto JSON é a seguinte:

```json
{
	"chave1": valor1,
	"chave2": valor2,
	"chave3": valor3
}
```
<p align="center"><em>Código 2: Sintaxe de um objeto JSON.</em></p>

No _Código 1_, temos um objeto JSON com duas chaves: `level_no` e `phases`. A chave `level_no` armazena o número do nível que está sendo customizado. A chave `phases` armazena um array contendo as fases do nível. Cada fase, por sua vez, é outro array contendo objetos JSON com as informações do(s) destino(s).

As informações de cada destino em uma fase são apenas duas: o nome do planeta (`planet_name`) e o tipo de rota que o jogador deve criar para o foguete chegar até o planeta de destino (`mode`). O tipo de rota é um número inteiro que pode ser 0, 1 ou 2. O significado de cada número será explicado mais adiante.

## Arrays e Objetos JSON

Vamos por partes. Já entendemos o que é um objeto, agora vamos entender o que é um array. Um array (ou vetor, em português) é uma coleção de dados do mesmo tipo que são armazenados sequencialmente. A sintaxe de um array em JSON é a seguinte:

```json
[
	valor1,
	valor2,
	valor3
]
```
<p align="center"><em>Código 3: Sintaxe de um array JSON.</em></p>

O array é delimitado por colchetes `[]` e os valores são separados por vírgula. Esses valores podem ser qualquer tipo de dado que o JSON suporta, incluindo outros arrays e objetos JSON. Abaixo, temos um exemplo de array JSON que armazena três números:

```json
[1, 3, 5]
```
<p align="center"><em>Código 4: Exemplo de um array JSON com três números.</em></p>

No _Código 1_ que apresentamos anteriormente, vimos que `phases` é um array que armazena as fases do nível. Talvez fique melhor se você visualizar isso assim:

```json
{
	"level_no": 1, // Nível 1
	"phases": [
		[...], // Fase 1
		[...], // Fase 2
		[...]  // Fase 3
	]
}
```
<p align="center"><em>Código 5: Visualização das fases de um nível como um array de arrays.</em></p>

Cada fase é representada por um array JSON que armazena os destinos. E cada destino é um objeto JSON que armazena o nome do planeta e o tipo de rota. Podemos visualizar isso assim:

```json
{
	"level_no": 1,
	"phases": [
		[ // Fase 1
			{...}, // Destino 1
			{...}, // Destino 2
			{...}  // Destino 3
		],
		[ // Fase 2
			{...}, // Destino 1
			{...}, // Destino 2
			{...}  // Destino 3
		],
		[ // Fase 3
			{...}, // Destino 1
			{...}, // Destino 2
			{...}  // Destino 3
		]
	]
}
```
<p align="center"><em>Código 6: Visualização dos destinos de cada fase como objetos JSON em um array de fases.</em></p>

Como podemos ver, `phases` é um array de arrays. Mas talvez você esteja se perguntando: "Por que vocês usaram um array de arrays para armazenar as fases? Não era mais fácil só usar um array de destinos?". A resposta é simples: cada fase pode ter mais de um destino (rotas compostas).

Por exemplo, na fase 1 do nível 1, o jogador deve criar uma rota para o planeta Marte. Mas e se quiséssemos que o jogador criasse uma rota para Vênus passando por Marte? Nesse caso, a fase 1 do nível 1 teria que ter dois destinos: Marte e Vênus. E é para isso que serve o array. Veja como fica a fase 1 do nível 1 com esses dois destinos:

```json
{
	"level_no": 1,
	"phases": 
	[ // Esse é o vetor de fases
		
		[ // Esse é o vetor que representa a fase 1
			{
				"planet_name": "marte", // Destino 1 - Marte
				"mode": 0
			},
			{
				"planet_name": "venus", // Destino 2 - Vênus
				"mode": 0
			}
		]
	]
}
```
<p align="center"><em>Código 7: Exemplo de uma fase com dois destinos (Marte e Vênus).</em></p>

## Tipos de rotas

Existem três tipos de rotas que o jogador pode criar para o foguete chegar ao planeta de destino. Cada tipo de rota é representado por um número inteiro. Abaixo, temos a descrição de cada tipo de rota:

- $${\color{cyan}0}$$: Rota simples. O jogador deve criar uma rota do foguete até o planeta de destino. A rota pode ser de qualquer tamanho.
- $${\color{cyan}1}$$: Rota de caminho mínimo. O jogador deve criar uma rota do foguete até o planeta de destino usando a menor quantidade de movimentos possível.
- $${\color{cyan}2}$$: Rota inversa. O jogador deverá inverter a última rota criada para o foguete retornar ao destino anterior.

Estes tipos de rotas podem ser combinados em uma mesma fase ou ao longo dos níveis. Por exemplo, podemos ter uma fase onde o jogador deve criar uma rota simples para o planeta Marte e uma rota de caminho mínimo para o planeta Vênus. Veja como ficaria a fase 1 do nível 1 com esses dois destinos:

```json
{
	"level_no": 1,
	"phases": 
	[ // Esse é o vetor de fases
		
		[ // Esse é o vetor que representa a fase 1
			{
				"planet_name": "marte", // Destino 1 - Marte
				"mode": 0 // Rota simples
			},
			{
				"planet_name": "venus", // Destino 2 - Vênus
				"mode": 1 // Rota de caminho mínimo
			}
		]
	]
}
```
<p align="center"><em>Código 8: Exemplo de uma fase com dois destinos (Marte e Vênus) e tipos de rotas diferentes.</em></p>

Esses recursos permitem que você crie fases mais desafiadoras e interessantes para os jogadores. Você pode criar fases com rotas simples, rotas de caminho mínimo, rotas inversas ou combinações desses tipos de rotas. Além disso, você pode criar fases com mais de um destino, permitindo que o jogador crie rotas compostas para alcançar os planetas de destino.

## Alguns cuidados!

Todas as fases iniciam com o foguete na Terra. Portanto, não é necessário adicionar a Terra como o primeiro destino de um nível - o foguete já estará lá. Se você fizer isso, o jogo vai ignorar e pular para o próximo destino.

O nome dos planetas deve ser escrito em letras minúsculas e sem acentos. Os nomes dos planetas disponíveis são: `mercurio`, `venus`, `terra`, `marte`, `jupiter`, `saturno`, `urano`, `netuno` e `plutao`. Se você escrever o nome de um planeta que não existe ou de uma forma diferente, o jogo não vai reconhecer e esse destino será ignorado.

Rotas com `mode` igual a 2 (rota inversa) vão sempre retornar para o destino anterior. Portanto, se você deseja adicionar uma rota inversa, certifique-se de colocar o planeta de destino da rota inversa como o planeta que o jogador deve retornar. Veja esse exemplo:

```json
{
	"level_no": 1,
	"phases": 
	[
		
		[
			{
				"planet_name": "marte", // Destino 1 - Marte
				"mode": 0 // Rota simples
			},
			{
				"planet_name": "terra", // Destino 2 - Terra
				"mode": 2 // Rota inversa
			}
		]
	]
}
```
<p align="center"><em>Código 9: Exemplo de uma fase com uma rota simples para Marte e uma rota inversa para a Terra.</em></p>

O nível 1 mostrado no _Código 9_ inicia com o foguete na terra (isso é padrão em todos os níveis) e o jogador deve criar uma rota simples para Marte. Após chegar em Marte, o jogador deve inverter a rota para retornar à Terra. Se colocarmos o nome de outro planeta que não seja a Terra no segundo destino com rota reversa, o jogo não vai reconhecer que o aluno chegou ao destino e a fase nunca será concluída. Outro cuidado importante é que como a rota reversa sempre retorna para o planeta anterior, ela não pode ser o primeiro destino de um nível. Se isso acontecer, o jogo vai ignorar a rota reversa e pular para o próximo destino.

Última coisa: **NÃO ALTERE O NOME DAS CHAVES E NEM DOS ARQUIVOS**. Se você alterar o nome de uma chave ou de um arquivo, o jogo não vai conseguir ler as informações corretamente e vai apresentar erros. Portanto, mantenha a estrutura dos arquivos JSON como ela está e apenas altere os _valores_ das chaves `planet_name` e `mode` de acordo com a sua customização.

## Dicas

Se você ainda possuir alguma dúvida sobre como arquivos JSON funcionam, este [tutorial](https://www.devmedia.com.br/json-tutorial/25275) pode te ajudar a entender melhor o funcionamento desse formato de arquivo.

Para editar os arquivos JSON, você pode usar qualquer editor de texto simples, como o próprio Bloco de Notas do Windows. No entanto, é recomendável usar um editor de texto voltado para programação, como o [Visual Studio Code](https://code.visualstudio.com/), o [Notepad++](https://notepad-plus-plus.org/), o [Sublime Text](https://www.sublimetext.com/) ou até mesmo o [Atom](https://atom-editor.cc/). Esses editores possuem recursos que facilitam a edição de arquivos JSON, como formatação automática, realce de sintaxe e validação de código. Todas essas opções são gratuitas e estão disponíveis para Windows, macOS e Linux.

Além disso, você pode usar um validador de JSON online para verificar se o seu arquivo JSON está correto. Basta copiar e colar o conteúdo do arquivo no validador e ele irá verificar se o JSON está bem formatado e sem erros. Aqui estão alguns validadores de JSON online que você pode usar:

- [JSONLint](https://jsonlint.com/)
- [JSON Formatter & Validator](https://jsonformatter.curiousconcept.com/)
- [JSON Validator](https://www.freeformatter.com/json-validator.html)
