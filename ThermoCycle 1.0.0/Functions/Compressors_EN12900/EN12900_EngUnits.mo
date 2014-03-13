within ThermoCycle.Functions.Compressors_EN12900;
function EN12900_EngUnits
  "Base model for the computation of the compressor performance. Must be redeclared with the coefficients and the swept volume"
input Modelica.SIunits.Temperature T_cd "Condensing temperature";
input Modelica.SIunits.Temperature T_ev "Evaporation temperature";
output Real result[3]
    "Vector with the output flow rate, cp power and swept volume";

//protected
parameter Real  coef[10,4]=
[0,0,0,0;
 0,0,0,0;
 0,0,0,0;
 0,0,0,0;
 0,0,0,0;
 0,0,0,0;
 0,0,0,0;
 0,0,0,0;
 0,0,0,0;
 0,0,0,0]
    "Coefficient matrix. Column1: Capacity. Column2: Power. Column3: Current. Column4: Flow Rate";
parameter Modelica.SIunits.Volume Vs=0 "Compressor Swept Volume";

protected
Modelica.SIunits.MassFlowRate Mdot "Mass Flow Rate";
Modelica.SIunits.Power Wdot "Compressor Power";

algorithm
Wdot := EN12900_polynom(
               (T_cd-273.15)* 9/5 +32,(T_ev-273.15)* 9/5 + 32,coef[:,2]);    // Temperature input is in Fahrenheit
Mdot := 125.9979E-6 * EN12900_polynom(
                             (T_cd-273.15)* 9/5 +32,(T_ev-273.15)* 9/5 + 32,coef[:,4]);    // Temperature input is in Fahrenheit. Output is in lbm/hr

result:={Mdot,Wdot,Vs};

end EN12900_EngUnits;
