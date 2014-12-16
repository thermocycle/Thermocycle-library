within ThermoCycle.Functions.Compressors_EN12900;
function EN12900_polynom
  input Real T_cd;
  input Real T_ev;
  input Real[10] C;
  output Real result;
algorithm
result:=C[1] + C[2] * T_ev + C[3] * T_cd + C[4] * T_ev^2 + C[5] * T_ev * T_cd + C[6] * T_cd^2 + C[7] * T_ev^3 + C[8] * T_cd * T_ev^2 + C[9] * T_ev * T_cd^2 + C[10] * T_cd^3;
end EN12900_polynom;
