within ThermoCycle.Functions;
package Compressors_EN12900
  "Computation of the Compressor performance according to standard EN 12900"

function EN12900_polynom
  input Real T_cd;
  input Real T_ev;
  input Real[10] C;
  output Real result;
algorithm
result:=C[1] + C[2] * T_ev + C[3] * T_cd + C[4] * T_ev^2 + C[5] * T_ev * T_cd + C[6] * T_cd^2 + C[7] * T_ev^3 + C[8] * T_cd * T_ev^2 + C[9] * T_ev * T_cd^2 + C[10] * T_cd^3;
end EN12900_polynom;

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

  function ZRD42KCE_TFD
    "ZRD42KCE-TFD Copeland scroll digital compressor - R407c"
    extends ThermoCycle.Functions.Compressors_EN12900.EN12900_EngUnits(
    Vs=57.17e-6,
    coef=[33042,-176.7,2.012,335.8;
  471.7,-3.463,-0.00118,3.326;
  -353.2,26.72,0.0266,-3.415;
  6.085,0.0757,0.0000295,0.0384;
  0.2325,-0.0189,-0.0000216,0.03363;
  2.368,-0.1319,-0.000202,0.02782;
  0.0225,0.00284,0.00000178,0.0002207;
  -0.0245,-0.00369,-0.00000247,0.00002353;
  -0.00987,0.00186,0.00000166,-0.0001748;
  -0.007331,0.000671,0.00000129,-0.00008385]);

  end ZRD42KCE_TFD;

  function ZH15K4E_TFD "ZH15K4E_TFD Copeland scroll compressor - R134a"
    extends ThermoCycle.Functions.Compressors_EN12900.EN12900_EngUnits(
    Vs=34.03e-6,
    coef=[12441,1720,5.807,139.9;
  249.3,34.27,0.08441,2.698;
  -145.6,-33.24,-0.1042,-1.511;
  2.624,0.184,0.0004788,0.02337;
  -1.379,-0.576,-0.001523,-0.01228;
  1.018,0.3212,0.0009531,0.01348;
  0.007995,0.0006113,0.000002041,0.00008378;
  -0.01179,-0.001543,-0.000004797,-0.00005556;
  0.003018,0.002754,0.000007131,0.000061;
  -0.003083,-0.0007958,-0.000002702,-0.00004292]);

  end ZH15K4E_TFD;

  function ZH21K4E_TFD "ZH21K4E_TFD Copeland scroll compressor - R134a"
    extends ThermoCycle.Functions.Compressors_EN12900.EN12900_EngUnits(
    Vs=46.22e-6,
    coef=[18136,2251,8.564,211.2;
  363.4,44.85,0.1245,4.067;
  -212.2,-43.51,-0.1537,-2.438;
  3.825,0.2409,0.0007062,0.03604;
  -2.011,-0.7539,-0.002246,-0.02097;
  1.484,0.4204,0.001406,0.02207;
  0.01165,0.0008001,0.000003011,0.000128;
  -0.01719,-0.00202,-0.000007075,-0.0001012;
  0.004399,0.003604,0.00001052,0.0001053;
  -0.004494,-0.001042,-0.000003986,-0.0000706]);

  end ZH21K4E_TFD;

  function ZH30K4E_TFD "ZH30K4E_TFD Copeland scroll compressor - R134a"
    extends ThermoCycle.Functions.Compressors_EN12900.EN12900_EngUnits(
    Vs=67.13e-6,
    coef=[18383,792.3,3.449,180.1;
  380.2,16.04,0.004168,3.299;
  -58.51,0.4133,-0.004696,0.5172;
  4.785,0.214,0.0001425,0.03702;
  0.1496,-0.2749,-0.00008595,0.02461;
  -0.2492,0.06766,0.00005733,-0.008214;
  0.02385,0.0004913,-5.786E-07,0.0003157;
  -0.02301,-0.001839,-4.676E-07,-0.0001036;
  -0.00748,0.001867,0.000001048,-0.0001006;
  0.001021,-0.00004148,1.316E-07,0.00002897]);

  end ZH30K4E_TFD;

  function ZH38K4E_TFD "ZH38K4E_TFD Copeland scroll compressor - R134a"
    extends ThermoCycle.Functions.Compressors_EN12900.EN12900_EngUnits(
    Vs=82.61e-6,
    coef=[22283,965,4.264,227;
  460.9,19.53,0.005152,3.669;
  -70.92,0.5034,-0.005804,0.4308;
  5.8,0.2607,0.0001761,0.04077;
  0.1813,-0.3348,-0.0001062,0.03708;
  -0.302,0.08241,0.00007086,-0.008668;
  0.02891,0.0005984,-7.152E-07,0.0003783;
  -0.02789,-0.002239,-5.780E-07,-0.00008704;
  -0.009067,0.002274,0.000001296,-0.0001594;
  0.001238,-0.00005052,1.626E-07,0.00003285]);

  end ZH38K4E_TFD;

  function ZH45K4E_TFD "ZH45K4E_TFD Copeland scroll compressor - R134a"
    extends ThermoCycle.Functions.Compressors_EN12900.EN12900_EngUnits(
    Vs=98.04e-6,
    coef=[26806,1154,5.121,268.3;
  554.4,23.36,0.006188,4.739;
  -85.32,0.602,-0.006971,0.6006;
  6.978,0.3118,0.0002115,0.05334;
  0.2182,-0.4004,-0.0001276,0.03709;
  -0.3633,0.09856,0.00008511,-0.0107;
  0.03478,0.0007157,-8.590E-07,0.0004477;
  -0.03356,-0.002678,-6.942E-07,-0.0001386;
  -0.01091,0.00272,0.000001556,-0.0001516;
  0.001489,-0.00006043,1.953E-07,0.00003889]);

  end ZH45K4E_TFD;
end Compressors_EN12900;
