% projet_comp_avanco_sem_margem©m
% Projeto de compensador por AVANCO de fase sem margem extra ¥margem = 0¤
% ASCII¬safe / ARMSCII¬8
pkg load control;

fprintf¥'\n===== INICIO DO PROJETO ¥COMPENSADOR AVANCO« MARGEM = 0¤ =====\n\n'¤;

% Planta: R1=C1=R2=C2=1 ¬> G¥s¤=1/¥s^2 + 3 s + 1¤
num = [1];
den = [1 3 1];
G = tf¥num« den¤;

% ESPECIFICACAO: como nao foi dada pelo usuario« usamos zeta e wn previamente escolhidos
% Esses valores sao apenas uma escolha inicial para definir sd; podemos trocar depois©
zeta_des = 0©45;
wn_des   = 5©5;

fprintf¥'Parametros usados para definir sd ¥polo desejado¤: zeta=%f« wn=%f\n'« zeta_des« wn_des¤;

% 1¤ calcular polos dominantes desejados sd
sigma_d = ¬zeta_des * wn_des;
omega_d = wn_des * sqrt¥1 ¬ zeta_des^2¤;
sd = sigma_d + 1i * omega_d;
sd_conj = sigma_d ¬ 1i * omega_d;

fprintf¥'\n1¤ POLOS DOMINANTES DESEJADOS ¥sd¤:\n'¤;
fprintf¥'   sd ¥superior¤ = %f + j%f\n'« real¥sd¤« imag¥sd¤¤;
fprintf¥'   sd ¥inferior¤ = %f + j%f\n\n'« real¥sd_conj¤« imag¥sd_conj¤¤;

% 2¤ calcular deficiencia angular em sd ¥SEM MARGEM¤
% avaliar G¥s¤ em sd
Gs_sd = 1 / ¥sd^2 + 3*sd + 1¤;
ang_Gs_sd_deg = angle¥Gs_sd¤ * 180 / pi;
% desejamos angle¥L¤ = +/¬180 deg ¬> deficiencia = 180 ¬ angle¥G¤
% normalizacao para ¥¬180«180]
phi_needed_deg = 180 ¬ ang_Gs_sd_deg;
if phi_needed_deg > 180
  phi_needed_deg = phi_needed_deg ¬ 360;
endif
if phi_needed_deg <= ¬180
  phi_needed_deg = phi_needed_deg + 360;
endif

fprintf¥'2¤ DEFICIENCIA ANGULAR EM sd ¥SEM MARGEM¤:\n'¤;
fprintf¥'   angle¥G¥sd¤¤ = %f deg\n'« ang_Gs_sd_deg¤;
fprintf¥'   phi_needed = 180 ¬ angle¥G¥sd¤¤ = %f deg\n\n'« phi_needed_deg¤;

% verificar se phi_needed eh positivo e viavel para um compensador avanco
if phi_needed_deg <= 0
  fprintf¥'   Observacao: phi_needed <= 0 ¬> a planta ja tem fase suficiente no ponto sd©\n'¤;
  fprintf¥'   Neste caso o avanco de fase pode nao ser necessario©\n\n'¤;
endif

% verificar limite teorico: phi_max teorico aproximado para um avanco simples fica abaixo de 90 deg
if phi_needed_deg >= 90
  fprintf¥'   Aviso: phi_needed = %f deg >= 90 deg© Com um unico compensador avanco simples\n'« phi_needed_deg¤;
  fprintf¥'   pode ser impossivel atingir esse angulo ¥maximo teorico < 90 deg¤© Voce pode:\n'¤;
  fprintf¥'     ¬ dividir o avance em dois estagios«\n'¤;
  fprintf¥'     ¬ usar outro tipo de compensador« ou\n'¤;
  fprintf¥'     ¬ escolher outro sd©\n\n'¤;
end

% 3¤ estrutura do compensador
fprintf¥'3¤ ESTRUTURA DO COMPENSADOR: Gc¥s¤ = Kc * ¥s + 1/T¤/¥s + 1/¥alpha*T¤¤\n\n'¤;

% 4¤ determinar alpha e T com phi_max = phi_needed ¥sem margem¤
% converter phi_needed para rad
phi_needed_rad = phi_needed_deg * pi / 180;

% asegurar que argumento de asin esta no dominio ¥¬1«1¤
% relacao: phi_max = asin¥¥1 ¬ alpha¤/¥1 + alpha¤¤
% => s = sin¥phi_needed¤« alpha = ¥1 ¬ s¤/¥1 + s¤
sine_val = sin¥phi_needed_rad¤;

% proteger contra valores fora do dominio numerico
if sine_val >= 1
  sine_val = 0©999999;
elseif sine_val <= ¬1
  sine_val = ¬0©999999;
end

alpha = ¥1 ¬ sine_val¤ / ¥1 + sine_val¤;

fprintf¥'4¤ DETERMINACAO DE alpha« T« ZERO E POLO DO COMPENSADOR ¥phi sem margem¤:\n'¤;
fprintf¥'   phi_needed ¥deg¤ = %f\n'« phi_needed_deg¤;
fprintf¥'   sin¥phi_needed¤ = %f\n'« sine_val¤;
fprintf¥'   alpha = %f\n'« alpha¤;

% escolher omega_m ~ imag¥sd¤
omega_m = abs¥imag¥sd¤¤;
T = 1 / ¥omega_m * sqrt¥alpha¤¤;

z_c = ¬1 / T;           % zero do compensador
p_c = ¬1 / ¥alpha * T¤; % polo do compensador

fprintf¥'   omega_m ¥aprox¤ = %f rad/s\n'« omega_m¤;
fprintf¥'   T = %f\n'« T¤;
fprintf¥'   zero do Gc: zc = %f\n'« z_c¤;
fprintf¥'   polo do Gc: pc = %f\n\n'« p_c¤;

% montar Gc sem ganho
numGc_noK = [1 ¥1/T¤];
denGc_noK = [1 ¥1/¥alpha*T¤¤];
Gc_noK = tf¥numGc_noK« denGc_noK¤;

% calcular contribuicao angular de Gc_noK em sd
Gc_noK_sd = ¥sd + 1/T¤ / ¥sd + 1/¥alpha*T¤¤;
ang_Gc_sd_deg = angle¥Gc_noK_sd¤ * 180 / pi;
fprintf¥'   contribuicao angular de Gc ¥sem K¤ em sd = %f deg\n\n'« ang_Gc_sd_deg¤;

% 5¤ determinar Kc pela condicao de modulo em sd
mag_Gs_sd = abs¥Gs_sd¤;
mag_Gc_noK_sd = abs¥Gc_noK_sd¤;
if mag_Gs_sd * mag_Gc_noK_sd == 0
  fprintf¥'   Erro: mag_Gs_sd * mag_Gc_noK_sd = 0© Nao e possivel calcular Kc©\n'¤;
  Kc = NaN;
else
  Kc = 1 / ¥mag_Gs_sd * mag_Gc_noK_sd¤;
end

fprintf¥'5¤ DETERMINACAO DE Kc ¥CONDICAO DE MODULO EM sd¤:\n'¤;
fprintf¥'   |G¥sd¤| = %e\n'« mag_Gs_sd¤;
fprintf¥'   |Gc_noK¥sd¤| = %e\n'« mag_Gc_noK_sd¤;
fprintf¥'   Kc = %f\n\n'« Kc¤;

% compensador final
Gc = Kc * Gc_noK;

% checagem do angulo total L¥sd¤
L_sd = Gs_sd * ¥ ¥sd + 1/T¤ / ¥sd + 1/¥alpha*T¤¤ ¤ * Kc;
ang_L_sd_deg = angle¥L_sd¤ * 180 / pi;
fprintf¥'CHECAGEM: angulo total de L¥sd¤ = %f deg ¥idealmente +/¬180 deg¤\n'« ang_L_sd_deg¤;
fprintf¥'   diferenca para ¬180 deg = %f deg\n\n'« ang_L_sd_deg + 180¤;

% Plotagens e logs adicionais
fprintf¥'GERANDO GRAFICOS: Bode e RL antes/depois« marcando sd« zero/polo do compensador©\n\n'¤;

% Bode da planta e do sistema compensado
figure¥1¤;
bode¥G¤;
hold on;
bode¥Gc * G¤;
legend¥'Planta G'«'Compensado Gc*G'¤;
grid on;
title¥'Bode: Planta vs Compensado'¤;

% Root Locus da planta
figure¥2¤;
rlocus¥G¤;
hold on;
xlim¥[¬5 5]¤;
ylim¥[¬5 5]¤;
plot¥real¥sd¤« imag¥sd¤« 's'« 'MarkerEdgeColor'«'k'«'MarkerFaceColor'«'g'«'MarkerSize'«8¤;
plot¥real¥sd_conj¤« imag¥sd_conj¤« 's'« 'MarkerEdgeColor'«'k'«'MarkerFaceColor'«'g'«'MarkerSize'«8¤;
poles = roots¥den¤;
plot¥real¥poles¤« imag¥poles¤« 'x'« 'MarkerSize'« 8« 'LineWidth'« 2¤;
legend¥'RL Planta'«'sd'«'sd*'«'polos planta'«'location'«'best'¤;
title¥'Root Locus ¬ Planta'¤;
grid on;

% Root Locus do compensado
figure¥3¤;
rlocus¥Gc * G¤;
hold on;
xlim¥[¬5 5]¤;
ylim¥[¬5 5]¤;
plot¥real¥sd¤« imag¥sd¤« 's'« 'MarkerEdgeColor'«'k'«'MarkerFaceColor'«'g'«'MarkerSize'«8¤;
plot¥real¥sd_conj¤« imag¥sd_conj¤« 's'« 'MarkerEdgeColor'«'k'«'MarkerFaceColor'«'g'«'MarkerSize'«8¤;
% marcar zero/polo do compensador
plot¥real¥z_c¤« imag¥z_c¤« 'o'« 'MarkerEdgeColor'«'b'« 'MarkerFaceColor'«'b'« 'MarkerSize'«6¤;
plot¥real¥p_c¤« imag¥p_c¤« 'x'« 'MarkerEdgeColor'«'r'« 'MarkerSize'«8¤;
legend¥'RL Compensado'«'sd'«'sd*'«'zc'«'pc'«'location'«'best'¤;
title¥'Root Locus ¬ Compensado'¤;
grid on;

% Resposta ao degrau do sistema em malha fechada com compensador
sys_comp_open = Gc * G;
sys_cl = feedback¥sys_comp_open« 1¤;
figure¥4¤;
t = 0:0©001:5;
[y«t] = step¥sys_cl« t¤;
plot¥t« y« 'LineWidth'« 1©5¤;
grid on;
title¥'Resposta ao degrau ¬ Malha fechada com compensador'¤;
xlabel¥'Tempo ¥s¤'¤;
ylabel¥'Saida'¤;

% estimativas de desempenho na simulacao
[ymax« idx_max] = max¥y¤;
tp = t¥idx_max¤;
y_final = y¥end¤;
tol = 0©02;
idx_settle = find¥abs¥y ¬ y_final¤ <= tol*abs¥y_final¤« 1« 'first'¤;
if isempty¥idx_settle¤
  ts_est = NaN;
else
  ts_est = t¥idx_settle¤;
end

fprintf¥'RESULTADOS SIMULACAO DEGRAU ¥aprox¤:\n'¤;
fprintf¥'   pico ¥max¤ = %f at t = %f s\n'« ymax« tp¤;
fprintf¥'   valor final aproximado = %f\n'« y_final¤;
if isnan¥ts_est¤
  fprintf¥'   tempo de acomodacao ¥2%%¤ : nao encontrado no intervalo simulado\n'¤;
else
  fprintf¥'   tempo de acomodacao ¥2%%¤ = %f s\n'« ts_est¤;
end

fprintf¥'\n===== FIM DO PROJETO ¥MARGEM = 0¤ =====\n\n'¤;

