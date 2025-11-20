% ¬¬¬ SCRIPT UNIFICADO E CORRIGIDO PARA ANALISE DE SISTEMA DE CONTROLE ¬¬¬
%
% Este script realiza duas analises sequenciais:
% 1© Simula a relacao entrada¬saida usando o modelo de Funcao de Transferencia©
% 2© Converte o modelo para Espaco de Estados e analisa o comportamento
%    das variaveis de estado internas©
%
% Autor: Gemini 2©5 Pro
% Data:  30 de Setembro de 2025
% Correcao: Substituida a funcao 'sgtitle' por um metodo compativel com Octave©

% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
% ¬¬¬ CONFIGURACAO INICIAL E DEFINICAO DO SISTEMA ¬¬¬
% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬

% Limpa a area de trabalho« fecha todas as figuras e limpa o console
clear all;
close all;
clc;

% Carrega o pacote de controle« necessario para as funcoes de simulacao
pkg load control;

% ¬¬¬ Definicao dos Parametros do Sistema ¬¬¬
R1 = 1©0; C1 = 1©0; R2 = 1©0; C2 = 1©0; % Valores assumidos

% ¬¬¬ Criacao do Modelo de Funcao de Transferencia ¥TF¤ ¬¬¬
num_Gs = [1];
den_Gs = [R1*C1*R2*C2« ¥R1*C1 + R2*C2 + R2*C1¤« 1];
Gs = tf¥num_Gs« den_Gs¤;

% Define o vetor de tempo para todas as simulacoes
t = 0:0©1:20;

% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
% ¬¬¬ PARTE 1: ANALISE COM FUNCAO DE TRANSFERENCIA ¥ENTRADA¬SAIDA¤ ¬¬¬
% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬

printf¥"¬¬¬ INICIO DA PARTE 1: ANALISE COM FUNCAO DE TRANSFERENCIA ¬¬¬\n\n"¤;
printf¥"Funcao de Transferencia G¥s¤ utilizada:\n"¤;
disp¥Gs¤;

% Criacao da figura para os graficos de saida
figure¥1¤;
% ¬¬¬ WORKAROUND PARA 'sgtitle' ¬¬¬
% Cria um eixo invisivel e coloca um titulo nele para centralizar na figura©
h = axes¥'visible'« 'off'« 'title'« 'PARTE 1: Respostas de Saida do Sistema ¥Modelo TF¤'¤;
set¥h« 'position'« [0 0 1 1]¤; % Garante que o eixo ocupe a figura toda

% 1©1 Resposta ao Impulso
subplot¥2« 2« 1¤;
[y_impulse« t_impulse] = impulse¥Gs¤;
plot¥t_impulse« y_impulse« 'b¬'« 'LineWidth'« 1©5¤;
title¥'Resposta ao Impulso'¤;
xlabel¥'Tempo ¥s¤'¤;
ylabel¥'Saida y¥t¤'¤;
grid on;

% 1©2 Resposta ao Degrau
subplot¥2« 2« 2¤;
[y_step« t_step] = step¥Gs« t¤;
plot¥t_step« y_step« 'r¬'« 'LineWidth'« 1©5¤;
title¥'Resposta ao Degrau'¤;
xlabel¥'Tempo ¥s¤'¤;
ylabel¥'Saida y¥t¤'¤;
grid on;

% 1©3 Resposta a Rampa
subplot¥2« 2« 3¤;
u_ramp = t;
[y_ramp« t_out_ramp] = lsim¥Gs« u_ramp« t¤;
plot¥t_out_ramp« y_ramp« 'g¬'« 'LineWidth'« 1©5¤;
hold on;
plot¥t_out_ramp« u_ramp« 'k¬¬'« 'LineWidth'« 1©0¤;
title¥'Resposta a Rampa'¤;
xlabel¥'Tempo ¥s¤'¤;
ylabel¥'Amplitude'¤;
legend¥'Saida'« 'Entrada'« 'Location'« 'northwest'¤;
grid on;
hold off;

% 1©4 Resposta a Senoide
subplot¥2« 2« 4¤;
u_sin = sin¥t¤;
[y_sin« t_out_sin] = lsim¥Gs« u_sin« t¤;
plot¥t_out_sin« y_sin« 'm¬'« 'LineWidth'« 1©5¤;
hold on;
plot¥t_out_sin« u_sin« 'k¬¬'« 'LineWidth'« 1©0¤;
title¥'Resposta a Senoide'¤;
xlabel¥'Tempo ¥s¤'¤;
ylabel¥'Amplitude'¤;
legend¥'Saida'« 'Entrada'« 'Location'« 'northwest'¤;
grid on;
hold off;

printf¥"\n¬¬¬ FIM DA PARTE 1: Graficos de saida gerados na Figura 1© ¬¬¬\n\n"¤;
pause¥2¤; % Pausa para o usuario observar o resultado antes de continuar

% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
% ¬¬¬ PARTE 2: ANALISE NO ESPACO DE ESTADOS ¥DINAMICA INTERNA¤ ¬¬¬
% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬

printf¥"¬¬¬ INICIO DA PARTE 2: ANALISE NO ESPACO DE ESTADOS ¬¬¬\n\n"¤;

% ¬¬¬ Conversao do modelo TF para Espaco de Estados ¥SS¤ ¬¬¬
sys_ss = ss¥Gs¤;

printf¥"Modelo convertido para Espaco de Estados ¥Matrizes A« B« C« D¤:\n"¤;
printf¥"¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬\n"¤;
disp¥"Matriz de Estados ¥A¤:"¤« disp¥sys_ss©a¤;
disp¥"Matriz de Entrada ¥B¤:"¤« disp¥sys_ss©b¤;
disp¥"Matriz de Saida ¥C¤:"¤« disp¥sys_ss©c¤;
disp¥"Matriz de Transmissao Direta ¥D¤:"¤« disp¥sys_ss©d¤;
printf¥"\nGerando graficos das variaveis de estado©©©\n"¤;

% Criacao da figura para os graficos das variaveis de estado
figure¥2¤;
% ¬¬¬ WORKAROUND PARA 'sgtitle' ¬¬¬
h2 = axes¥'visible'« 'off'« 'title'« 'PARTE 2: Comportamento das Variaveis de Estado ¥Modelo SS¤'¤;
set¥h2« 'position'« [0 0 1 1]¤;

% 2©1 Estados para Entrada Impulso
subplot¥2« 2« 1¤;
[~« t_impulse_ss« x_impulse_ss] = impulse¥sys_ss¤;
plot¥t_impulse_ss« x_impulse_ss« 'LineWidth'« 1©5¤;
title¥'Estados para Entrada Impulso'¤;
xlabel¥'Tempo ¥s¤'¤;
ylabel¥'Estados x¥t¤'¤;
legend¥'x1'« 'x2'« 'Location'« 'southeast'¤;
grid on;

% 2©2 Estados para Entrada Degrau
subplot¥2« 2« 2¤;
[~« t_step_ss« x_step_ss] = step¥sys_ss« t¤;
plot¥t_step_ss« x_step_ss« 'LineWidth'« 1©5¤;
title¥'Estados para Entrada Degrau'¤;
xlabel¥'Tempo ¥s¤'¤;
ylabel¥'Estados x¥t¤'¤;
legend¥'x1'« 'x2'¤;
grid on;

% 2©3 Estados para Entrada Rampa
subplot¥2« 2« 3¤;
[~« ~« x_ramp_ss] = lsim¥sys_ss« u_ramp« t¤;
plot¥t« x_ramp_ss« 'LineWidth'« 1©5¤;
title¥'Estados para Entrada Rampa'¤;
xlabel¥'Tempo ¥s¤'¤;
ylabel¥'Estados x¥t¤'¤;
legend¥'x1'« 'x2'¤;
grid on;

% 2©4 Estados para Entrada Senoide
subplot¥2« 2« 4¤;
[~« ~« x_sin_ss] = lsim¥sys_ss« u_sin« t¤;
plot¥t« x_sin_ss« 'LineWidth'« 1©5¤;
title¥'Estados para Entrada Senoide'¤;
xlabel¥'Tempo ¥s¤'¤;
ylabel¥'Estados x¥t¤'¤;
legend¥'x1'« 'x2'¤;
grid on;

printf¥"\n¬¬¬ FIM DA PARTE 2: Graficos de estados gerados na Figura 2© ¬¬¬\n"¤;
printf¥"\n¬¬¬ SCRIPT CONCLUIDO© ¬¬¬\n"¤;
