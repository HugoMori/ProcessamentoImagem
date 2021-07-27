% Hugo Mori RA 552607
% Murilo Pereira RA 759530
% Ygor Tobal RA 760942

%-------------- Trabalho Final ------------------
############### Identificador de c�dulas ########

close all % fechar todas as janelas
clear % limpar a mem�ria
clc % limpa a tela da área de trabalho
pkg load image

t = cputime; %guarda o tempo de execu��o da CPU no momento de inicio


exte = '.jpg'; %guarda a extens�o dos arquivos de imagem da BD

path_BD = './BD_notas/notas_'; %localiza��o das imagens do BD

identify_image = imread('./Notas_de_teste/Real/r2_f_1.jpg'); %Imagem a ser identificada

identify_image = imresize(identify_image,[190 400]); %redimensiona a imagem a ser identificada

if isrgb(identify_image)==1 %se a imagem a ser identificada for colorida, passa p/cinza
  identify_image_gray = rgb2gray(identify_image); %guarda a imagem cinza
  identify_image_gray = double(identify_image_gray)/255; %aumenta a precis�o dos pixels da imagem cinza
end


distint_nota = 1; %contador usado p/trocar as notas frente/verso. Zera a cada 5 acrescimos
index = 1; %indice usado p/armazenar as m�dias das correla��es. Acrescenta a cada 5.

soma = 0; %soma dos indices de correla��o


# --------------- Inicio das compara��es 
for l = 1:140
  BD_image_number = num2str (l, '%d' ); %passa p/string o n�mero da imagem acessada no BD
  nome_BD_image = [path_BD BD_image_number exte]; %concatena o caminho da imagem do BD, o numero dela e a extens�o
  BD_image = imread(nome_BD_image); %abre a imagem do BD e armazena

  BD_image = imresize(BD_image,[190 400]); %redimensiona a imagem do BD
  
  if isrgb(BD_image)==1 %se a imagem do BD for colorida, passa p/cinza
  BD_image_gray = rgb2gray(BD_image); %guarda a imagem cinza
  BD_image_gray = double(BD_image_gray)/255; %aumenta a precis�o dos pixels da imagem cinza
  end

  identify_image_gray_copy = identify_image_gray; %copia a imagem, em cinza, a ser identificada

  r1 = corr2 ( identify_image , BD_image); #coef de correla��o entre as matrizes da imagem a ser identificada e a imagem do BD
  
  identify_image_gray_copy = histeq(identify_image_gray_copy); %equaliza da imagem, em cinza, a ser identificada
  BD_image_gray=histeq(BD_image_gray); %equaliza a imagem, em cinza, do BD
  
  r2 = corr2 ( BD_image_gray , identify_image_gray_copy); #coef de correla��o entre as matrizes das imagens em cinza e equalizadas
  
  BD_image_gray = im2bw (BD_image_gray, graythresh (BD_image_gray, "moments")); %Passa a imagem, em cinza e equalizada, a ser identificada p/BW
  identify_image_gray_copy = im2bw (identify_image_gray_copy, graythresh (identify_image_gray_copy, "moments"));  %Passa a imagem, em cinza e equalizada, do BD p/BW
  
  r3 = corr2 ( BD_image_gray , identify_image_gray_copy); #coef de correla��o entre as matrizes das imagens em BW
  
  r = (r1+r2+r3)/3; %m�dia simples dos coef
  
  if(r > 0.66) %gambiarra p/funcionamento melhor de desempate em alguns casos
    r = r*1.15
  end

  vetor_correlacao(l) = r; 
  
  soma = soma + r; %realiza a soma dos coef final de compara��o com cada imagem do BD, � zerado a cda 5 imagens
  
  if distint_nota == 5 %se a contagem de imagens for igual a cinco
    media_notas(index) = soma/5; %m�dia simples da soma dos coef
    distint_nota = 0; %zero o contador de nota distinta (frente/verso ou troca de c�dula)
    index++; %acrescimo do indice da m�dia de notas
    soma = 0; %zero a soma de coef's
  end
      
##  printf("r: 1 x %d = %.3f\n\n",l,r);

  distint_nota++; %acrescenta a nota distinta

end #Fim do loop ----------------------------
   
  
max_media = 0.0; %para descobrir qual foi a maior m�dia de coef
nota = 0; %armazenar o indice da maior m�dia e descobrir a c�dula

for i = 1:28
  if(media_notas(i) > max_media)
    max_media = media_notas(i);
    nota = i;
  end
##  printf("Nota %d:\tMedia: %.3f\n",i,media_notas(i));
end


#Descobrir qual a nota ----------------------------
%de acordo com o indice das m�dias, guardado na variavel nota
%Como s�o 140 notas, sendo 10 imagens p/cada c�dula, e dessas 10 imagens, 5 s�o frente
%e 5 s�o verso, temos ent�o 28 "tipos" de imagem, portanto 28 indices

switch (nota)
  case { 1, 2 }
      valor = '2 Reais';
      nacionalidade = 'Nacionalidade: Brasileira'; 
   case { 3, 4 }
      valor = '5 Reais';
      nacionalidade = 'Nacionalidade: Brasileira';
  case { 5, 6 }
      valor = '10 Reais';
      nacionalidade = 'Nacionalidade: Brasileira'; 
   case { 7, 8 }
      valor = '20 Reais';
      nacionalidade = 'Nacionalidade: Brasileira';
  case { 9, 10 }
      valor = '50 Reais';
      nacionalidade = 'Nacionalidade: Brasileira';  
  case { 11, 12 }
      valor = '100 Reais';
      nacionalidade = 'Nacionalidade: Brasileira'; 
  case { 13, 14 }
      valor = '200 Reais';
      nacionalidade = 'Nacionalidade: Brasileira';
  case { 15, 16 }
      valor = '1 Dollar';
      nacionalidade = 'Nacionalidade: Estadunidense';
  case { 17, 18 }
      valor = '2 Dollars';
      nacionalidade = 'Nacionalidade: Estadunidense'; 
   case { 19, 20 }
      valor = '5 Dollars';
      nacionalidade = 'Nacionalidade: Estadunidense';
  case { 21, 22 }
      valor = '10 Dollars';
      nacionalidade = 'Nacionalidade: Estadunidense'; 
   case { 23, 24 }
      valor = '20 Dollars';
      nacionalidade = 'Nacionalidade: Estadunidense';
  case { 25, 26 }
      valor = '50 Dollars';
      nacionalidade = 'Nacionalidade: Estadunidense'; 
  case { 27, 28 }
      valor = '100 Dollar';
      nacionalidade = 'Nacionalidade: Estadunidense';
endswitch 

# Informa��es a serem exbidas na tela ----------------------------------

titulo = ['Valor da nota: ' valor];
 
if max_media >= 0.6 %se a imagem tiver m�dia maior, ou igual, que 60% de acerto, as chances de a imagem ser identificada � �tima

  figure,
  subplot(1,1,1), subimage(identify_image),  title ({titulo;nacionalidade}, "fontsize", 16); %plota a imagem original a ser identificada
  percents = num2str (max_media*100, '%.3f' ); %passa a porcentagem da m�dia de indentifica��o p/string
  percents = ['Valor identificado com: ' percents '% de acerto.']; %elabora uma string de identifica��o
  xlabel(percents); %exibe a string de identifica��o abaixo da imagem
  
else #Se n�o conseguir identificar com exatid�o, vai dizer qual tem maior %
 
  if max_media >= 0.5 %se a imagem tiver m�dia maior, ou igual, a 50% de acerto, as chances de a imagem ser identificada � boa.
 
    percents = num2str (max_media*100, '%.3f' );
    label = ['Boas chances de identifica��o : ' percents '% de acerto.']; 
     
    figure,
    subplot(1,1,1), subimage(identify_image),  title ({titulo; nacionalidade}, "fontsize", 16); 
    xlabel(label);
    ylabel('Uma imagem um pouco melhor poderia ajudar (mais informa��es na Janela de Comandos).');
 
  else
  
    if max_media >= 0.4 %se a imagem tiver m�dia maior, ou igual, a 40% e menor que 50% de acerto, as chances de a imagem ser identificada � m�dia
     percents = num2str (max_media*100, '%.3f' );
     label = ['Possivelmente identificado o valor da nota: ' percents '% de acerto.']; 
     
     figure,
      subplot(1,1,1), subimage(identify_image),  title ({titulo; nacionalidade}, "fontsize", 16); 
      xlabel(label);
      ylabel('Uma imagem melhor, ou com melhor recorte, poderia ajudar (mais informa��es na Janela de Comandos).');
    else %se a imagem tiver m�dia menor que 40% de acerto, as chances de a imagem n�o ser identificada � grande
     percents = num2str (max_media*100, '%.3f' );
     label = ['N�o foi poss�vel identificar com exatid�o o valor da nota: ' percents '% de acerto.']; 
     
     figure,
      subplot(1,1,1), subimage(identify_image),  title ({titulo; nacionalidade}, "fontsize", 16); 
      xlabel(label);
      ylabel('Tente novamente com uma nota melhor (mais informa��es na Janela de Comandos).');
    end 
    
  end
   
end  

printf('**********'); printf('\tInforma��es\t'); printf('**********\n');

printf('%s\n',titulo);
printf('%s\n',nacionalidade);
printf('Porcentagem de chance de identifica��o: %.3f%%\n',max_media*100);
printf('\n----------\n');

r_max = max(vetor_correlacao);
indice = find(vetor_correlacao == max(vetor_correlacao));

printf('Maior coeficiente de correla��o: %.3f\n', r_max);
printf('�ndice da nota com maior coeficiente: %d\n', indice);
printf('Nome da imagem no BD: notas_%d\n\n',indice);
printf('----------\n');

if max_media < 0.6
  printf("Dicas para melhorar a identifica��o:\n");
  printf("1) Recorte da imagem mais rente a ela\n");
  printf("2) Uma imagem melhor, de maior resolu��o, facilita a identifica��o\n");
  printf("3) observe se na imagem n�o h� outros elementos prejudicando a identifica��o, como m�os, angulo da imagem, etc..\n");
end

printf('\n******************************************\n');

printf('Tempo de execu��o do programa: %.2f seconds\n', cputime-t); %Tempo total de execu��o do programa