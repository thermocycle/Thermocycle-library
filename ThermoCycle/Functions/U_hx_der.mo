within ThermoCycle.Functions;
function U_hx_der
  "Returns the heat transfer coefficient depending on the fluid state"
  input Real Unom_tp;
  input Real Unom_l;
  input Real Unom_v;
  constant Real width=0.1;
  input Real x;
  input Real Unom_tp_der;
  input Real Unom_l_der;
  input Real Unom_v_der;
  input Real x_der;
  output Real y_der;
algorithm
  y_der :=
if x < -width/2
  then 0
 elseif
       x < width/2
  then (Unom_tp - Unom_l)*Modelica.Constants.pi/width * cos(x*Modelica.Constants.pi/width)/2 * x_der
 elseif
       x < 1 - width/2
  then 0
 elseif
       x < 1 + width/2
  then (Unom_v - Unom_tp)* Modelica.Constants.pi/width * cos((x - 1)*Modelica.Constants.pi/width)/2 * x_der
 else
     0;
  annotation ();
end U_hx_der;
