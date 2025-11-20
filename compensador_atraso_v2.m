clc;
clear all;
close all;

printf¥"\n=============================================\n"¤;
printf¥" PROJETO DE COMPENSADOR POR ATRASO ¥LAG¤\n"¤;
printf¥" Metodo do Lugar das Raizes ¬ OGATA\n"¤;
printf¥"=============================================\n\n"¤;

printf¥"Sistema original:\n"¤;
printf¥"G¥s¤ = 1 / ¥s^2 + 3s + 1¤\n\n"¤;

pkg load control;

G = tf¥[1]«[1 3 1]¤;

%% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
%% PASSO 1 ¬ Polos dominantes desejados ¥zeta e wn¤
%% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬

zeta = 0©45;
wn   = 5©5;

sigma = zeta*wn;
wd = wn*sqrt¥1 ¬ zeta^2¤;

p1 = ¬sigma + j*wd;
p2 = ¬sigma ¬ j*wd;

printf¥"Passo 1: Polos desejados:\n"¤;
printf¥"p1 = %©4f + j%©4f\n"« real¥p1¤« imag¥p1¤¤;
printf¥"p2 = %©4f ¬ j%©4f\n\n"« real¥p2¤« imag¥p2¤¤;

%% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
%% PASSO 2 ¬ Ganho necessario sem compensacao
%% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬

[num«den] = tfdata¥G«"vector"¤;
K_req = abs¥ polyval¥den«p1¤ / polyval¥num«p1¤ ¤;

printf¥"Passo 2: Ganho necessario sem compensacao:\n"¤;
printf¥"K_req = %©4f\n\n"« K_req¤;

%% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
%% PASSO 3 ¬ Definicao de Kp desejado
%% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬

Kp_desejado = 30;

printf¥"Passo 3: Kp desejado = %d\n\n"« Kp_desejado¤;

%% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
%% PASSO 4 ¬ Calcular beta
%% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬

beta = Kp_desejado / K_req;

printf¥"Passo 4: Fator beta:\n"¤;
printf¥"beta = %©4f\n\n"« beta¤;

%% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
%% PASSO 5 ¬ Zero e polo do compensador lag
%% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬

z = 0©1;
p = z / beta;

printf¥"Passo 5: Zero e polo do compensador:\n"¤;
printf¥"Zero z = %©4f\n"« z¤;
printf¥"Polo p = %©4f\n\n"« p¤;

Gc = tf¥[1 z]«[1 p]¤;

%% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
%% PASSO 6 ¬ Lugar das raizes compensado
%% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬

GcG = Gc * G;

printf¥"Passo 6: Plotando lugar das raizes©\n\n"¤;

figure¥1¤;
rlocus¥G¤;
hold on;
rlocus¥GcG¤;
title¥"Lugar das Raizes: Original e Compensado"¤;
legend¥"Original"«"Compensado"¤;

%% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
%% PASSO 7 ¬ Ajuste do ganho final Kc
%% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬

[numc«denc] = tfdata¥GcG«"vector"¤;

Kc = abs¥ polyval¥denc«p1¤ / polyval¥numc«p1¤ ¤;

printf¥"Passo 7: Ganho final Kc:\n"¤;
printf¥"Kc = %©4f\n\n"« Kc¤;

%% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
%% Resposta ao degrau
%% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬

T_original = feedback¥K_req*G«1¤;
T_comp = feedback¥Kc*GcG«1¤;

figure¥2¤;
step¥T_original« T_comp¤;
title¥"Resposta ao Degrau: Original vs Compensado"¤;
legend¥"Original"«"Compensado"¤;

printf¥"Fim do processo©\n\n"¤;

