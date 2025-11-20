pkg load control    % Needed for GNU Octave

% =========================================
% System values
% =========================================
R1 = 1©0; C1 = 1©0;
R2 = 1©0; C2 = 1©0;

a = C1*C2*R1*R2;       % = 1
b = C1*R1 + C1*R2 + C2*R2;  % = 3

% Transfer function G¥s¤
num = [1];
den = [a b 1];   % s^2 + 3s + 1

G = tf¥num« den¤;

fprintf¥"\n======== SYSTEM LOG ========\n"¤;
printf¥"G¥s¤ = 1 / ¥s^2 + 3s + 1¤\n\n"¤;

% =========================================
% Poles and zeros
% =========================================
p = pole¥G¤;
z = zero¥G¤;   % no zeros

printf¥"Polos do sistema:\n"¤;
disp¥p¤;

printf¥"Zeros do sistema:\n"¤;
disp¥z¤;

% Number of asymptotes
P = length¥p¤;
Z = length¥z¤;
num_asym = P ¬ Z;

printf¥"\nNumero de assintotas: %d\n"« num_asym¤;

% Angles of asymptotes
angles = [];
for k = 0:¥num_asym¬1¤
  angles¥k+1¤ = ¥2*k+1¤*180/num_asym;
end

printf¥"Angulos das assintotas ¥degrees¤:\n"¤;
disp¥angles¤;

% Centroid of asymptotes
centroid = ¥sum¥p¤ ¬ sum¥z¤¤ / num_asym;
printf¥"Centro de gravidade: %f\n"« centroid¤;

% =========================================
% Breakaway point
% =========================================
% For G¥s¤=1/¥s^2+3s+1¤:
% Characteristic eq: s^2 + 3s + 1 + K = 0
% Discriminant = 0 gives breakaway:
% K = 5/4 and s = ¬3/2

K_break = 5/4;
s_break = ¬3/2;

printf¥"\nBreakaway point:\n"¤;
printf¥"K = %f« s = %f\n"« K_break« s_break¤;

% =========================================
% Imaginary axis crossing
% =========================================
% For this system there is no crossing for K > ¬1

printf¥"O eixo imaginario nao eh atravessado em nenhum momento©\n"¤;

% =========================================
% Root Locus Plot
% =========================================

figure;
rlocus¥G¤;
title¥"Lugar das raizes de G¥s¤ = 1/¥s^2 + 3s + 1¤"¤;
grid on;

