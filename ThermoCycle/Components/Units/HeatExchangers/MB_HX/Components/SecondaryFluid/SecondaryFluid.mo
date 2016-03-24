within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.SecondaryFluid;
model SecondaryFluid

 parameter Integer n= 1 "Number of CV";
  ThermoCycle.Components.Units.HeatExchangers.MB_HX.Interfaces.MbIn mbIn[n]
    annotation (Placement(transformation(extent={{-20,-70},{20,-50}})));
  ThermoCycle.Interfaces.Fluid.Flange_Cdot InFlow_sf
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

parameter Modelica.SIunits.CoefficientOfHeatTransfer Usf
    "Secondary fluid Heat transfer coefficient sub-cooled side";
constant Real pi = Modelica.Constants.pi;
parameter Modelica.SIunits.Area AA "Channel cross section";
parameter Modelica.SIunits.Length YY "Channel perimeter";
parameter Modelica.SIunits.Length L_total "Channel total length";
parameter Boolean eps_NTU = false "Set true to for eps-NTU relation";
parameter Modelica.SIunits.Temperature Tstart
    "Start value for average temperature of inlet cell";
parameter Modelica.SIunits.Temperature DTstart
    "Delta T to initialize second and third volume average temperature";
final parameter Modelica.SIunits.Temperature Tsf_start[n] = {Tstart - DTstart*i for i in 1:n}
    "Initial temperature of the secondary fluid";
/******* Secondary fluid  ****************/
Modelica.SIunits.SpecificHeatCapacity cp_sf
    "Specific heat capacity of the secondary fluid at the inlet";
    Modelica.SIunits.Temperature T_sfA[n]
    "Temperature at the inlet of the volume";
    Modelica.SIunits.Temperature T_sf[n](start = Tsf_start)
    "Temperature at the center of the volume";
Modelica.SIunits.Temperature T_sfB[n] "Temperature at the outlet of the volume";

Modelica.SIunits.Power Qsf[n] "Heat from the secondary side";

Modelica.SIunits.MassFlowRate Mdot_sf "Mass flow rate of the secondary fluid";
Modelica.SIunits.Density rho_sf "Density of the secondary fluid";
/******* Heat transfer coefficient  ****************/
Real epsilon[n] "Epsilon Sub-cooled secondary fluid - wall Side";
Real NTU[n] "NTU Sub-cooled secondary fluid-Wall side";
Real Cdot_wf[n] "Thermal energy capacity rate of the working fluid [J/k]";
Real  Cdot_sf "Thermal energy capacity rate of the secondary fluid [J/k]";
/* Variable for the summary case */
Modelica.SIunits.Temperature Temp[n*3] "Fluid temperature for SummaryClass";
Modelica.SIunits.Power qtot "Total thermal energy transfer from/into the fluid";
  ThermoCycle.Interfaces.Fluid.Flange_ex_Cdot OutFlow_sf
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
equation
  /* Cell One */
  Cdot_sf = Mdot_sf*cp_sf;
  if eps_NTU then
  for i in 1:n loop
   NTU[i] =   Usf*YY*mbIn[i].ll/(Cdot_sf);
  epsilon[i] = 1 - exp(-NTU[i]);
  T_sf[i] = (T_sfA[i] + T_sfB[i])/2;
  Qsf[i] = Mdot_sf*cp_sf*(T_sfA[i] - T_sfB[i]);
  Qsf[i] = cp_sf*Mdot_sf*epsilon[i]*(T_sfA[i] - mbIn[i].T);
  end for;
  else
    for i in 1:n loop
  NTU[i] =   Usf*YY*mbIn[i].ll/(Cdot_sf);
  epsilon[i] = 1 - exp(-NTU[i]);
  T_sf[i] = (T_sfA[i] + T_sfB[i])/2;
  Qsf[i] = Mdot_sf*cp_sf*(T_sfA[i] - T_sfB[i]);
  Qsf[i] = Usf*YY*mbIn[i].ll*(T_sf[i] - mbIn[i].T);
  end for;
  end if;
 for i in 1:n-1 loop
   T_sfB[i] = T_sfA[i+1];
 end for;

  /* Equations to set variables for the Summary*/
  if n == 1 then
 Temp = {T_sfA[1],T_sf[1],T_sfB[1]};
  elseif n == 2 then
    Temp = {T_sfA[1],T_sf[1],T_sfB[1],T_sfA[2],T_sf[2],T_sfB[2]};
  else
    Temp = {T_sfA[1],T_sf[1],T_sfB[1],T_sfA[2],T_sf[2],T_sfB[2],T_sfA[3],T_sf[3],T_sfB[3]};
  end if;

  qtot = sum(Qsf[:]);

/* Connector */
InFlow_sf.cp = cp_sf;
InFlow_sf.rho = rho_sf;
InFlow_sf.Mdot = Mdot_sf;
InFlow_sf.T = T_sfA[1];

OutFlow_sf.cp = cp_sf;
OutFlow_sf.rho = rho_sf;
OutFlow_sf.Mdot = Mdot_sf;
OutFlow_sf.T = T_sfB[n];

  mbIn.Q_flow = -Qsf;
  mbIn.Cdot = Cdot_wf;

public
  record SummaryClass
    replaceable Arrays T_profile;
     record Arrays
       parameter Integer n;
     Modelica.SIunits.Temperature[n*3] T_cell;
     end Arrays;
     parameter Integer n;
     Modelica.SIunits.Power[n] Qflow;
     Modelica.SIunits.Power Qtot;
  end SummaryClass;
  SummaryClass Summary(T_profile(n=n,T_cell = Temp[:]),n=n, Qflow = Qsf[:], Qtot = qtot);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -60},{100,60}}),   graphics), Icon(coordinateSystem(extent={{-100,
            -60},{100,60}})));
end SecondaryFluid;
