within ThermoCycle.Functions;
function U_hx
  "Returns the heat transfer coefficient depending on the fluid state"
  input Real Unom_tp;
  input Real Unom_l;
  input Real Unom_v;
  constant Real width=0.1;
  //input Real Mdot;
  input Real x;
  output Real y;
algorithm
  y := smooth(1,noEvent(
if x < -width/2
  then Unom_l
 elseif
       x < width/2
  then Unom_l + (Unom_tp - Unom_l)*(1 + sin(x*Modelica.Constants.pi/width))/2
 elseif
       x < 1 - width/2
  then Unom_tp
 elseif
       x < 1 + width/2
  then Unom_tp + (Unom_v - Unom_tp)*(1 + sin((x - 1)*Modelica.Constants.pi
    /width))/2
 else
     Unom_v));
  annotation (derivative = U_hx_der,Inline = true);
end U_hx;
