within ThermoCycle.Functions;
function correlation_open_expander_epsilon_s
  input Real N_rot;
  input Real rho;
  input Real log_rp;
  output Real epsilon_s;
algorithm
  epsilon_s := -2.16329421E+00 + 6.78008871E-04*N_rot - 5.54407717E-07*
    N_rot^2 + 8.03956432E-11*N_rot^3 - 2.24146877E-15*N_rot^4 +
    2.91161840E-03*rho + 1.12613000E-06*rho^2 + 8.49777454E-08*rho^3 -
    4.50090810E-10*rho^4 + 4.67781024E+00*log_rp - 3.55789871E+00*log_rp^2
     + 1.16705018E+00*log_rp^3 - 1.38101959E-01*log_rp^4 + 2.37728921E-07*
    N_rot*rho - 3.25174455E-09*N_rot*rho^2 + 7.85764846E-12*N_rot*rho^3 -
    6.05137025E-04*N_rot*log_rp + 4.49229123E-04*N_rot*log_rp^2 -
    9.99328287E-05*N_rot*log_rp^3 + 3.75965704E-11*N_rot^2*rho +
    4.39606024E-13*N_rot^2*rho^2 - 8.61198734E-16*N_rot^2*rho^3 +
    6.95577624E-07*N_rot^2*log_rp - 4.20590506E-07*N_rot^2*log_rp^2 +
    8.24820738E-08*N_rot^2*log_rp^3 + 3.34903471E-15*N_rot^3*rho -
    7.54325941E-17*N_rot^3*rho^2 + 8.13185576E-20*N_rot^3*rho^3 -
    9.33650022E-11*N_rot^3*log_rp + 5.77554418E-11*N_rot^3*log_rp^2 -
    1.14741098E-11*N_rot^3*log_rp^3 + 7.45493269E-03*rho*log_rp -
    5.32817717E-03*rho*log_rp^2 + 9.48009166E-04*rho*log_rp^3 -
    9.67639285E-05*rho^2*log_rp + 5.34409340E-05*rho^2*log_rp^2 -
    8.76813140E-06*rho^2*log_rp^3 + 2.69821471E-07*rho^3*log_rp -
    1.37299471E-07*rho^3*log_rp^2 + 2.18231218E-08*rho^3*log_rp^3;
  epsilon_s := min(0.79, epsilon_s);
  epsilon_s := max(0, epsilon_s);
  annotation (smoothOrder=1);
end correlation_open_expander_epsilon_s;
