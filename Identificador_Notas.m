% Hugo Mori RA 552607
% Murilo Pereira RA 759530
% Ygor Tobal RA 760942

%-------------- Trabalho Final ------------------
############### Identificador de cédulas ########

close all % fechar todas as janelas
clear % limpar a memória
clc % limpa a tela da Ã¡rea de trabalho
pkg load image

t = cputime; %guarda o tempo de execução da CPU no momento de inicio


exte = '.jpg'; %guarda a extensão dos arquivos de imagem da BD

path_BD = './BD_notas/notas_'; %localização das imagens do BD

identify_image = imread('./Notas_de_teste/Real/r2_f_1.jpg'); %Imagem a ser identificada

identify_image = imresize(identify_image,[190 400]); %redimensiona a imagem a ser identificada

if isrgb(identify_image)==1 %se a imagem a ser identificada for colorida, passa p/cinza
  identify_image_gray = rgb2gray(identify_image); %guarda a imagem cinza
  identify_image_gray = double(identify_image_gray)/255; %aumenta a precisão dos pixels da imagem cinza
end


distint_nota = 1; %contador usado p/trocar as notas frente/verso. Zera a cada 5 acrescimos
index = 1; %indice usado p/armazenar as médias das correlações. Acrescenta a cada 5.

soma = 0; %soma dos indices de correlação


# --------------- Inicio das comparações 
for l = 1:140
  BD_image_number = num2str (l, '%d' ); %passa p/string o número da imagem acessada no BD
  nome_BD_image = [path_BD BD_image_number exte]; %concatena o caminho da imagem do BD, o numero dela e a extensão
  BD_image = imread(nome_BD_image); %abre a imagem do BD e armazena

  BD_image = imresize(BD_image,[190 400]); %redimensiona a imagem do BD
  
  if isrgb(BD_image)==1 %se a imagem do BD for colorida, passa p/cinza
  BD_image_gray = rgb2gray(BD_image); %guarda a imagem cinza
  BD_image_gray = double(BD_image_gray)/255; %aumenta a precisão dos pixels da imagem cinza
  end

  identify_image_gray_copy = identify_image_gray; %copia a imagem, em cinza, a ser identificada

  r1 = corr2 ( identify_image , BD_image); #coef de correlação entre as matrizes da imagem a ser identificada e a imagem do BD
  
  identify_image_gray_copy = histeq(identify_image_gray_copy); %equaliza da imagem, em cinza, a ser identificada
  BD_image_gray=histeq(BD_image_gray); %equaliza a imagem, em cinza, do BD
  
  r2 = corr2 ( BD_image_gray , identify_image_gray_copy); #coef de correlação entre as matrizes das imagens em cinza e equalizadas
  
  BD_image_gray = im2bw (BD_image_gray, graythresh (BD_image_gray, "moments")); %Passa a imagem, em cinza e equalizada, a ser identificada p/BW
  identify_image_gray_copy = im2bw (identify_image_gray_copy, graythresh (identify_image_gray_copy, "moments"));  %Passa a imagem, em cinza e equalizada, do BD p/BW
  
  r3 = corr2 ( BD_image_gray , identify_image_gray_copy); #coef de correlação entre as matrizes das imagens em BW
  
  r = (r1+r2+r3)/3; %média simples dos coef
  
  if(r > 0.66) %gambiarra p/funcionamento melhor de desempate em alguns casos
    r = r*1.15
  end

  vetor_correlacao(l) = r; 
  
  soma = soma + r; %realiza a soma dos coef final de comparação com cada imagem do BD, é zerado a cda 5 imagens
  
  if distint_nota == 5 %se a contagem de imagens for igual a cinco
    media_notas(index) = soma/5; %média simples da soma dos coef
    distint_nota = 0; %zero o contador de nota distinta (frente/verso ou troca de cédula)
    index++; %acrescimo do indice da média de notas
    soma = 0; %zero a soma de coef's
  end
      
##  printf("r: 1 x %d = %.3f\n\n",l,r);

  distint_nota++; %acrescenta a nota distinta

end #Fim do loop ----------------------------
   
  
max_media = 0.0; %para descobrir qual foi a maior média de coef
nota = 0; %armazenar o indice da maior média e descobrir a cédula

for i = 1:28
  if(media_notas(i) > max_media)
    max_media = media_notas(i);
    nota = i;
  end
##  printf("Nota %d:\tMedia: %.3f\n",i,media_notas(i));
end


#Descobrir qual a nota ----------------------------
%de acordo com o indice das médias, guardado na variavel nota
%Como são 140 notas, sendo 10 imagens p/cada cédula, e dessas 10 imagens, 5 são frente
%e 5 são verso, temos então 28 "tipos" de imagem, portanto 28 indices

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

# Informações a serem exbidas na tela ----------------------------------

titulo = ['Valor da nota: ' valor];
 
if max_media >= 0.6 %se a imagem tiver média maior, ou igual, que 60% de acerto, as chances de a imagem ser identificada é ótima

  figure,
  subplot(1,1,1), subimage(identify_image),  title ({titulo;nacionalidade}, "fontsize", 16); %plota a imagem original a ser identificada
  percents = num2str (max_media*100, '%.3f' ); %passa a porcentagem da média de indentificação p/string
  percents = ['Valor identificado com: ' percents '% de acerto.']; %elabora uma string de identificação
  xlabel(percents); %exibe a string de identificação abaixo da imagem
  
else #Se não conseguir identificar com exatidão, vai dizer qual tem maior %
 
  if max_media >= 0.5 %se a imagem tiver média maior, ou igual, a 50% de acerto, as chances de a imagem ser identificada é boa.
 
    percents = num2str (max_media*100, '%.3f' );
    label = ['Boas chances de identificação : ' percents '% de acerto.']; 
     
    figure,
    subplot(1,1,1), subimage(identify_image),  title ({titulo; nacionalidade}, "fontsize", 16); 
    xlabel(label);
    ylabel('Uma imagem um pouco melhor poderia ajudar (mais informações na Janela de Comandos).');
 
  else
  
    if max_media >= 0.4 %se a imagem tiver média maior, ou igual, a 40% e menor que 50% de acerto, as chances de a imagem ser identificada é média
     percents = num2str (max_media*100, '%.3f' );
     label = ['Possivelmente identificado o valor da nota: ' percents '% de acerto.']; 
     
     figure,
      subplot(1,1,1), subimage(identify_image),  title ({titulo; nacionalidade}, "fontsize", 16); 
      xlabel(label);
      ylabel('Uma imagem melhor, ou com melhor recorte, poderia ajudar (mais informações na Janela de Comandos).');
    else %se a imagem tiver média menor que 40% de acerto, as chances de a imagem não ser identificada é grande
     percents = num2str (max_media*100, '%.3f' );
     label = ['Não foi possível identificar com exatidão o valor da nota: ' percents '% de acerto.']; 
     
     figure,
      subplot(1,1,1), subimage(identify_image),  title ({titulo; nacionalidade}, "fontsize", 16); 
      xlabel(label);
      ylabel('Tente novamente com uma nota melhor (mais informações na Janela de Comandos).');
    end 
    
  end
   
end  

printf('**********'); printf('\tInformações\t'); printf('**********\n');

printf('%s\n',titulo);
printf('%s\n',nacionalidade);
printf('Porcentagem de chance de identificação: %.3f%%\n',max_media*100);
printf('\n----------\n');

r_max = max(vetor_correlacao);
indice = find(vetor_correlacao == max(vetor_correlacao));

printf('Maior coeficiente de correlação: %.3f\n', r_max);
printf('Índice da nota com maior coeficiente: %d\n', indice);
printf('Nome da imagem no BD: notas_%d\n\n',indice);
printf('----------\n');

if max_media < 0.6
  printf("Dicas para melhorar a identificação:\n");
  printf("1) Recorte da imagem mais rente a ela\n");
  printf("2) Uma imagem melhor, de maior resolução, facilita a identificação\n");
  printf("3) observe se na imagem não há outros elementos prejudicando a identificação, como mãos, angulo da imagem, etc..\n");
end

printf('\n******************************************\n');

printf('Tempo de execução do programa: %.2f seconds\n', cputime-t); %Tempo total de execução do programa