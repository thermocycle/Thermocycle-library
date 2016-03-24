within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Condenser.Incompressible;
model CondDryInc
 replaceable package Medium =
      ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium
                                           annotation (choicesAllMatching=true);

 /* Components */
  Cells.OnePhaseInc volumeSH(
    redeclare final package Medium = Medium,
    pstart=pstart,
    Mdotnom=Mdotnom,
    AA=AA,
    alone=false,
    YY=YY,
    eps_NTU=eps_NTU,
    Ltotal=Ltotal,
    subcooled=false,
    Unom=UnomSH,
    hstart=hstartSH,
    lstart=lstartSH,
    Type=false)
    annotation (Placement(transformation(extent={{-36,-8},{-16,12}})));
  Cells.TwoPhase volumeTP(
    redeclare final package Medium = Medium,
    pstart=pstart,
    hstart=hstartTP,
    lstart=lstartTP,
    Mdotnom=Mdotnom,
    Unom=UnomTP,
    AA=AA,
    alone=false,
    YY=YY,
    Ltotal=Ltotal,
    General=false,
    final Type=false,
    VoidFraction=VoidFraction,
    VoidF=VoidF,
    Flooded=false)
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare final package Medium =
               Medium)
    annotation (Placement(transformation(extent={{-112,-8},{-92,12}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow(  redeclare final package Medium
      =                                                                           Medium)
    annotation (Placement(transformation(extent={{68,-10},{88,10}})));

import ThermoCycle.Components.Units.HeatExchangers.MB_HX.Records;

/* Parameters */
final parameter Integer  nCV= 2;
parameter Modelica.SIunits.Area AA = 0.0019 "Channel cross section";
parameter Modelica.SIunits.Length YY = 1.57 "Channel perimeter";
parameter Modelica.SIunits.Length Ltotal=500
    "Total length of the heat exchanger";
parameter Boolean VoidFraction = true
    "Set to true to calculate the void fraction to false to keep it constant";
    parameter Real VoidF = 0.8 "Constantat void fraction" annotation (Dialog(enable= not VoidFraction));

/* Heat transfer */
parameter Modelica.SIunits.MassFlowRate Mdotnom=0 "Nominal fluid flow rate" annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer UnomSH=2500
    "SC - Nominal heat transfer coefficient"                                                  annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer UnomTP=9000
    "TP - Nominal heat transfer coefficient"                                                  annotation (Dialog(group = "Heat transfer"));
parameter Boolean eps_NTU = false "Set to true for eps-NTU heat transfer" annotation (Dialog(group = "Heat transfer"));

  /* Initial values */
  parameter Modelica.SIunits.Pressure pstart=6e6 "Fluid pressure start value"
    annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstartSH=1E5 "SC: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Length lstartSH=1 "SC:Start value of length"
    annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstartTP=1E5 "TP: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Length lstartTP=1 "TP:Start value of length"
    annotation (Dialog(tab="Initialization"));

  Records.Mode mode[nCV];
 /* Summary Class variables */
  Modelica.SIunits.Temperature[6] Temp;
  Modelica.SIunits.Length[6] length;
  Modelica.SIunits.Power[nCV] q_dot;
  Modelica.SIunits.Power qtot;

  Interfaces.MbOut mbOut[nCV]
    annotation (Placement(transformation(extent={{-22,34},{20,50}})));
equation
  volumeSH.mode = mode[nCV-1];
  volumeTP.mode = mode[nCV];

  mode[nCV - 1] = Constants.ModeCompound;
  mode[nCV] = Constants.ModeCompound;
  /* Geometric constraints */
  volumeSH.ll + volumeTP.ll = Ltotal;
  volumeSH.la = 0;
  volumeSH.lb = volumeTP.la;
  /* Equations for  SummaryClass variables*/
for i in 1:3 loop
  Temp[i] =  volumeSH.Temp[i];
  length[i] = volumeSH.length[i];
  end for;
  for i in 4:6 loop
   Temp[i] = volumeTP.Temp[i-3];
   length[i] = volumeTP.length[i-3];
  end for;
   q_dot[1] = volumeSH.q_dot;
   q_dot[2] = volumeTP.q_dot;
   qtot = sum(q_dot[:]);
public
  record SummaryClass
    replaceable Arrays T_profile;
     record Arrays
     Modelica.SIunits.Temperature[6] T_cell;
     end Arrays;
     Modelica.SIunits.Length[6] l_cell;
     Modelica.SIunits.Power[2] Qflow;
     Modelica.SIunits.Power Qtot;
  end SummaryClass;
  SummaryClass Summary(T_profile(T_cell = Temp[:]),l_cell = length[:],Qflow=q_dot[:],Qtot=qtot);

equation
  connect(InFlow, volumeSH.inFlow) annotation (Line(
      points={{-102,2},{-36,2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(volumeSH.outFlow, volumeTP.inFlow) annotation (Line(
      points={{-16,2.1},{2,2.1},{2,0},{32,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(volumeTP.outFlow,OutFlow)  annotation (Line(
      points={{52,0.1},{60,0.1},{60,0},{78,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(volumeSH.mbOut, mbOut[1]) annotation (Line(
      points={{-26,11},{-26,26},{-11.5,26},{-11.5,42}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(volumeTP.mbOut, mbOut[2]) annotation (Line(
      points={{42,9},{42,12},{6,12},{6,42},{9.5,42}},
      color={0,0,0},
      smooth=Smooth.None));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-20},
            {80,40}}),  graphics),Icon(coordinateSystem(extent={{-100,-20},{80,40}},
                   preserveAspectRatio=true),
                                     graphics={
                               Bitmap(extent={{-102,106},{80,-88}}, fileName="modelica://ThermoCycle/Resources/Images/MB/Cond_D_wf.png")}));
end CondDryInc;
