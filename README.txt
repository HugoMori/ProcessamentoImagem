Hugo Mori RA 552607
Murilo Pereira RA 759530
Ygor Tobal RA 760942

------- Tema do Projeto ------

Identificação do valor monetário das cédulas de real e, 
possivelmente, de outras.

------- Funcionamento --------

O programa, escrito através do octave, identifica a cédula
através da porcentagem de semelhança entre as matrizes das
imagens. Essa porcentagem é estipulada através da função corr2,
disponível na biblioteca 'image' do octave. Com ela, dada duas 
imagens, é possível estipular a porcentagem de correlação entre
ambas as matrizes, desde que as mesmas tenham o mesmo tamanho. 
A resposta da função corr2 é um valor de 0 a 1, sendo que quanto
mais próximo de 1, mais semelhante elas são, sendo que o valor é 
para casos em que as matrizes são totalmente iguais.
Para realizar a identificação foi feito um banco de dados contendo
10 imagens de cada cédula, sendo 5 imagens para parte da frente e 5
imagens para parte de trás da mesma. Ao todo foram utilizadas 140
imagens, sendo elas de notas de dólar, das últimas duas gerações, 
e de real, sendo essas notas da última geração apenas.
As imagens das cédulas presentes no banco de imagens, foram
redimensionadas para o tamanho 190x400, para agilizar as análises. 
O redimensionamento foi realizado analisando se as imagens não eram
prejudicadas quanto as comparações, o qual foi percebido que pouco 
era mexido na porcentagem de comparação e que não era suficiente 
para modificar o resultado.
Para tentativa de um resultado mais conclusivo é realizado a correlação
entre as imagens de 3 formas, sendo elas:
1) As imagens originais, apenas redimensionadas.
2) As imagens redimensionadas, convertidas para escalas de cinza e
equalizadas através da função 'histeq'.
3) As modificadas presentes no passo 2) e passadas para preto e branco
com auxílio da função 'graytresh', que calcula o limite global da imagem
em tons de cinza. Para o método, utilizado na função graythresh, foi 
escolhido a 'moments'.
As porcentagens de correlação de cada passo são somadas e feitas uma 
média simples. Esse resultado é utilizado como indicador de correlação
oficial.
Obtido a porcentagem de correlação, é realizada a soma das mesmas 
que serão utilizados para fazer a média de porcentagem de cada nota.
É realizada uma nova média a cada 5 imagens, correspondendo as imagens
frente e verso, onde é guardada em um vetor de média, que é utilizado
para identificação de qual nota é a passada na imagem a ser comparada.
É realizado a média a cada 5 imagens, e não 10, pois as versões frente e 
verso destoam muito uma as outras, o que prejudicaria a média e por 
consequente a identificação.

------- Instruções -----------

Abra o programa 'Identificador_Notas'.
Para a execução da identificação você pode optar por utilizar uma nova
imagem ou uma imagem presente na pasta 'Notas_de_teste', onde tem presente
6 imagens para cada nota, sendo 3 de frente e 3 de verso. Se for optador a escolha 
de uma nova imagem, certifique-se de que ela se enquadre nas notas que podem
ser identificadas, já mencionadas em 'Funcionamento', e de que sua imagem
tenha o recorte apenas da cédula ou o mais próximo dela, para uma identificação 
mais precisa. Após, especifique o caminho, da imagem da cédula a ser comparada, 
na variavel A = imread('Especifique_o_caminho').
Caso opte por uma imagem da pasta de testes, escolha a pasta referente a
cada tipo de cédula, 'Real' ou 'Dollar' e especifique o caminho da imagem a ser
comparada, ex: A = imread('./Notas de teste/Real/r100_t_3.jpg').
Após é só rodar o programa.

------- Observações ----------

As imagens das cédulas de real, especificamente as frentes, por apresentarem uma 
proximidade aparente grande, apresentam mais dificuldades em serem identificadas.
