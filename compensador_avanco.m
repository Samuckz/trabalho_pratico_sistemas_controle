% projet_comp_avanco_ascii©m
% Projeto de compensador por avanco de fase ¥ASCII¬safe / ARMSCII¬8¤
pkg load control;

% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
% 0¤ Parametros iniciais
% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
% planta: R1=C1=R2=C2=1 ¬> G¥s¤=1/¥s^2 + 3 s + 1¤
num = [1];
den = [1 3 1];
G = tf¥num« den¤;

% especificacoes de desempenho ¥pode alterar¤
zeta_des = 0©45;
wn_des   = 5©5;

% margem de seguranca de fase ¥em graus¤ para robustez
fase_margem_deg = 5;

fprintf¥'\n===== INICIO DO LOG DO PROJETO ¥COMPENSADOR AVANCO¤ =====\n\n'¤;

% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
% 1¤ localizar polos dominantes desejados ¥sd¤
% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
sigma_d = ¬zeta_des * wn_des;
omega_d = wn_des * sqrt¥1 ¬ zeta_des^2¤;
sd = sigma_d + 1i * omega_d;
sd_conj = sigma_d ¬ 1i * omega_d;

fprintf¥'1¤ POLOS DOMINANTES DESEJADOS ¥sd¤:\n'¤;
fprintf¥'   zeta_des = %f« wn_des = %f\n'« zeta_des« wn_des¤;
fprintf¥'   sd ¥up¤   = %f + j%f\n'« real¥sd¤« imag¥sd¤¤;
fprintf¥'   sd ¥down¤ = %f + j%f\n\n'« real¥sd_conj¤« imag¥sd_conj¤¤;

% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
% 2¤ calculo da deficiencia angular
% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
% Avaliar G¥s¤ em sd
Gs_sd = 1 / ¥sd^2 + 3*sd + 1¤;
ang_Gs_sd_rad = angle¥Gs_sd¤;           % rad
ang_Gs_sd_deg = ang_Gs_sd_rad * 180 / pi;

% condicao do root locus: angle¥L¤ = ¥2k+1¤*180 deg ¬> adotamos 180 deg
% deficiencia = 180deg ¬ angle¥G¤
phi_needed_deg = 180 ¬ ang_Gs_sd_deg;
% normalizar para intervalo ¥¬180«180]
if phi_needed_deg > 180
  phi_needed_deg = phi_needed_deg ¬ 360;
endif
if phi_needed_deg <= ¬180
  phi_needed_deg = phi_needed_deg + 360;
endif

fprintf¥'2¤ DEFICIENCIA ANGULAR NO PONTO sd:\n'¤;
fprintf¥'   angle¥G¥sd¤¤ = %f deg\n'« ang_Gs_sd_deg¤;
fprintf¥'   fase necessaria ¥ideal¤ phi_needed = %f deg\n'« phi_needed_deg¤;

% adicionar margem de fase para robustez
phi_max_deg = phi_needed_deg + fase_margem_deg;
fprintf¥'   aplicando margem de fase de %d deg ¬> phi_max = %f deg\n\n'« fase_margem_deg« phi_max_deg¤;

% converter para rad
phi_max_rad = phi_max_deg * pi / 180;

% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
% 3¤ estrutura do compensador
% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
% Gc¥s¤ = Kc * ¥s + 1/T¤ / ¥s + 1/¥alpha*T¤¤
% alpha entre 0 e 1 ¥alpha < 1 para avanco¤
fprintf¥'3¤ ESTRUTURA DO COMPENSADOR:\n'¤;
fprintf¥'   Gc¥s¤ = Kc * ¥s + 1/T¤ / ¥s + 1/¥alpha*T¤¤\n\n'¤;

% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
% 4¤ determinar alpha« T ¥zero e polo¤ para fornecer phi_max
% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
% relacao padrao: phi_max = asin¥¥1¬alpha¤/¥1+alpha¤¤
% => alpha = ¥1 ¬ sin¥phi_max¤¤ / ¥1 + sin¥phi_max¤¤
sin_phi = sin¥phi_max_rad¤;
alpha = ¥1 ¬ sin_phi¤ / ¥1 + sin_phi¤;

% escolher omega_m ¥frequencia onde compensador fornece max fase¤
% normalmente omega_m ~ imag¥sd¤
omega_m = abs¥imag¥sd¤¤;
T = 1 / ¥omega_m * sqrt¥alpha¤¤;

% determinar zero e polo do compensador
z_c = ¬1 / T;           % zero em s = ¬1/T
p_c = ¬1 / ¥alpha * T¤; % polo em s = ¬1/¥alpha T¤

fprintf¥'4¤ DETERMINACAO DE alpha« T« ZERO E POLO DO COMPENSADOR:\n'¤;
fprintf¥'   phi_max ¥com margem¤ = %f deg\n'« phi_max_deg¤;
fprintf¥'   alpha = %f\n'« alpha¤;
fprintf¥'   omega_m ¥aprox¤ = %f rad/s\n'« omega_m¤;
fprintf¥'   T = %f\n'« T¤;
fprintf¥'   zero do Gc: zc = %f\n'« z_c¤;
fprintf¥'   polo do Gc: pc = %f\n\n'« p_c¤;

% construir Gc sem ganho Kc ¥so forma de avanco¤
Gc_noK = tf¥[1 ¥1/T¤]« [1 ¥1/¥alpha*T¤¤]¤;

% calcular a contribuicao angular do Gc em sd
Gc_sd = ¥sd + 1/T¤ / ¥sd + 1/¥alpha*T¤¤;
ang_Gc_sd_deg = angle¥Gc_sd¤ * 180 / pi;
fprintf¥'   contribuicao angular aproximada de Gc em sd = %f deg\n\n'« ang_Gc_sd_deg¤;

% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
% 5¤ determinar Kc pela condicao de modulo
% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
% condicao: |G¥sd¤ * Gc¥sd¤ * Kc| = 1 ¬> Kc = 1 / ¥|G¥sd¤| * |Gc_noK¥sd¤|¤
mag_Gs_sd = abs¥Gs_sd¤;
mag_Gc_noK_sd = abs¥Gc_sd¤;
Kc = 1 / ¥mag_Gs_sd * mag_Gc_noK_sd¤;

fprintf¥'5¤ DETERMINACAO DE Kc ¥CONDICAO DE MODULO¤:\n'¤;
fprintf¥'   |G¥sd¤| = %e\n'« mag_Gs_sd¤;
fprintf¥'   |Gc_noK¥sd¤| = %e\n'« mag_Gc_noK_sd¤;
fprintf¥'   Kc = %f\n\n'« Kc¤;

% formar compensador completo
Gc = Kc * Gc_noK;

% checagem de angulo total em sd
L_sd = Gs_sd * ¥ ¥sd + 1/T¤ / ¥sd + 1/¥alpha*T¤¤ ¤ * Kc;
ang_L_sd_deg = angle¥L_sd¤ * 180 / pi;
fprintf¥'CHECAGEM: angulo total de L¥sd¤ = %f deg ¥deveria ser aproximadamente +/¬180¤\n'« ang_L_sd_deg¤;
fprintf¥'   diferenca para ¬180 deg = %f deg\n\n'« ang_L_sd_deg + 180¤;

% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
% Plotagens solicitadas
% ¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
fprintf¥'GERANDO GRAFICOS: root locus planta« root locus compensado« marca sd« e resposta ao degrau©\n\n'¤;

% 1¤ root locus da planta com limites solicitados
figure¥1¤;
rlocus¥G¤;
hold on;
% ajustar eixos de ¬5 a 5 ambos
xlim¥[¬5 5]¤;
ylim¥[¬5 5]¤;
grid on;
title¥'Root Locus ¬ Planta G¥s¤ = 1/¥s^2 + 3 s + 1¤'¤;
xlabel¥'Parte Real'¤;
ylabel¥'Parte Imaginaria'¤;

% marcar polos da planta e centro de assintotas
poles = roots¥den¤;
plot¥real¥poles¤« imag¥poles¤« 'x'« 'MarkerSize'« 8« 'LineWidth'« 2¤;
% centro de gravidade das assintotas ¥sigma¤
n_poles = length¥poles¤;
n_zeros = 0;
n_asym = n_poles ¬ n_zeros;
sigma = ¥sum¥poles¤ ¬ 0¤ / n_asym;
plot¥real¥sigma¤« 0« 'o'« 'MarkerSize'« 6« 'LineWidth'« 2¤;

% marcar sd no grafico
plot¥real¥sd¤« imag¥sd¤« 's'« 'MarkerEdgeColor'«'k'«'MarkerFaceColor'«'g'«'MarkerSize'«8¤;
plot¥real¥sd_conj¤« imag¥sd_conj¤« 's'« 'MarkerEdgeColor'«'k'«'MarkerFaceColor'«'g'«'MarkerSize'«8¤;

legend¥'RL ¬ planta'«'polos planta'«'centro assintotas'«'sd ¥polos desejados¤'«'location'«'northeast'¤;

hold off;

% 2¤ root locus do sistema compensado
figure¥2¤;
rlocus¥Gc * G¤;
hold on;
xlim¥[¬5 5]¤;
ylim¥[¬5 5]¤;
grid on;
title¥'Root Locus ¬ Sistema Compensado Gc¥s¤*G¥s¤'¤;
xlabel¥'Parte Real'¤;
ylabel¥'Parte Imaginaria'¤;

% marcar sd e zero/polo do compensador
plot¥real¥sd¤« imag¥sd¤« 's'« 'MarkerEdgeColor'«'k'«'MarkerFaceColor'«'g'«'MarkerSize'«8¤;
plot¥real¥sd_conj¤« imag¥sd_conj¤« 's'« 'MarkerEdgeColor'«'k'«'MarkerFaceColor'«'g'«'MarkerSize'«8¤;

% zeros/polos do compensador
zGc = ¬1 / T;
pGc = ¬1 / ¥alpha * T¤;
plot¥real¥zGc¤« imag¥zGc¤« 'o'« 'MarkerEdgeColor'«'b'« 'MarkerFaceColor'«'b'« 'MarkerSize'«6¤;
plot¥real¥pGc¤« imag¥pGc¤« 'x'« 'MarkerEdgeColor'«'r'« 'MarkerSize'«8¤;

legend¥'RL ¬ compensado'«'sd'«'zc ¥zero Gc¤'«'pc ¥polo Gc¤'«'location'«'northeast'¤;

hold off;

% 3¤ resposta ao degrau do sistema em malha fechada com compensador
sys_comp_open = Gc * G;
sys_cl = feedback¥sys_comp_open« 1¤; % realimentacao unitario

figure¥3¤;
t = 0:0©001:5; % vetor tempo para simulacao
[y«t] = step¥sys_cl« t¤;
plot¥t« y« 'LineWidth'« 1©5¤;
grid on;
title¥'Resposta ao degrau ¬ Malha fechada com compensador'¤;
xlabel¥'Tempo ¥s¤'¤;
ylabel¥'Saida'¤;
% marcar caracteristicas importantes: pico e tempo de acomodacao aproximado
[ymax« idx_max] = max¥y¤;
tp = t¥idx_max¤;
% estimativa de settling time ¥2% criterio¤ ¬ aproxima
y_final = y¥end¤;
tol = 0©02;
idx_settle = find¥abs¥y ¬ y_final¤ <= tol*abs¥y_final¤« 1« 'first'¤;
if isempty¥idx_settle¤
  ts_est = NaN;
else
  ts_est = t¥idx_settle¤;
endif

fprintf¥'RESULTADOS DA SIMULACAO DE DEGRAU ¥aprox¤:\n'¤;
fprintf¥'   pico ¥max¤ = %f at t = %f s\n'« ymax« tp¤;
fprintf¥'   valor final aproximado = %f\n'« y_final¤;
if isnan¥ts_est¤
  fprintf¥'   tempo de acomodacao ¥2%%¤ : nao encontrado no intervalo simulado\n'¤;
else
  fprintf¥'   tempo de acomodacao ¥2%%¤ = %f s\n'« ts_est¤;
endif

fprintf¥'\n===== FIM DO LOG DO PROJETO =====\n'¤;

