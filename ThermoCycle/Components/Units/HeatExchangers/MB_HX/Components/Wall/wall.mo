within ThermoCycle.Components.Units.HeatExchangers.MB_HX.Components.Wall;
model wall "Moving-boundary wall model"
  import Modelica.Constants;

 parameter Integer n = 3 "number of volumes";
parameter Modelica.SIunits.SpecificHeatCapacity cp_w
    "Specific heat capacity (constant)"                                                       annotation(Dialog(group="Specific heat capacity",enable=cpw_sel==1,__Dymola_label="Constant value:"));
 parameter Modelica.SIunits.Length L_total "Total length of the Hx";
 parameter Modelica.SIunits.Mass M_w "Total mass flow of the wall";
 parameter Modelica.SIunits.Temperature TstartWall[n]
    "Start temperature of the wall";
 Modelica.SIunits.Length ll[n] = {QmbIn[i].ll for i in 1:n};
 Modelica.SIunits.Length la[n] "Left boundary of segment length";
 Modelica.SIunits.Length lb[n] "Right boundary of segment length";
 Modelica.SIunits.Temperature Tw[n]( start = TstartWall)
    "Inner wall temperature";

 Modelica.SIunits.Temperature Twa[n] "Left boundary temperature";
 Modelica.SIunits.Temperature Twb[n] "Right boundary temperature";
/* Variable for the summary case */
Modelica.SIunits.Temperature Temp[n*3] "Fluid temperature for SummaryClass";
Modelica.SIunits.Power Q_totIn "Total thermal power in";
Modelica.SIunits.Power Q_totOut "Total thermal power out";
Modelica.SIunits.HeatFlowRate dUdt[n] "Rate of energy change";
public
  ThermoCycle.Components.Units.HeatExchangers.MB_HX.Interfaces.MbIn QmbIn[n]
    annotation (Placement(transformation(extent={{-20,-32},{20,-12}})));

  ThermoCycle.Components.Units.HeatExchangers.MB_HX.Interfaces.MbOut QmbOut[n]
    annotation (Placement(transformation(extent={{-20,16},{20,34}})));
equation

/*******  WallEnergyBalance SUB-COOLED **********/
if n ==1 then
la[1] = 0;
lb[1] = ll[1];
elseif n ==2 then
la[1] = 0;
lb[1] = ll[1];
la[n] = ll[1];
lb[n] = L_total;
elseif n ==3 then
la[1] = 0;
lb[1] = ll[1];
la[2] = ll[1];
lb[2] = ll[1]+ll[2];
la[n] = ll[1]+ll[2];
lb[n] = L_total;
else
end if;

/* First and last boundary temperatures */
 Twa[1] = 0;
 Twb[n] = 0;

/* Wall Left boundary temperatures */
for i in 2:n loop
   Twa[i] = Tw[i-1]*ll[i]/(ll[i-1]+ll[i]) + Tw[i]*ll[i-1]/(ll[i-1]+ll[i]);
end for;

/* Wall Right boundary temperatures */
for i in 1:n-1 loop
   Twb[i] = Tw[i]*ll[i+1]/(ll[i]+ll[i+1]) + Tw[i+1]*ll[i]/(ll[i]+ll[i+1]);
end for;

/* Wall energy balance */
if n == 1 then
   der(Tw[1]) = ((QmbIn[1].Q_flow + QmbOut[1].Q_flow)*L_total/(M_w*cp_w*ll[1]));
   dUdt[1] = (QmbIn[1].Q_flow + QmbOut[1].Q_flow);
   else
for i in 1:n loop
     der(Tw[i]) = ((QmbIn[i].Q_flow + QmbOut[i].Q_flow)*L_total/(M_w*cp_w*ll[i])) -  (((Tw[i]-Twb[i])/ll[i])*der(lb[i]) + ((Twa[i]-Tw[i])/ll[i])*der(la[i])); //- (((Tw[i]-Twb[i])/Li[i])*der(Lb[i])
     dUdt[i] = (QmbIn[i].Q_flow + QmbOut[i].Q_flow);
end for;
end if;

/* Equations to set variables for the Summary*/
  if n == 1 then
 Temp = {Twa[1],Tw[1],Twb[1]};
  elseif n == 2 then
    Temp = {Twa[1],Tw[1],Twb[1],Twa[2],Tw[2],Twb[2]};
  else
    Temp = {Twa[1],Tw[1],Twb[1],Twa[2],Tw[2],Twb[2],Twa[3],Tw[3],Twb[3]};
  end if;

/* Connect In and Out Connectors length */
 for i in 1:n loop
   QmbIn[i].ll = QmbOut[i].ll;
 end for;

 QmbOut.T = Tw;
 QmbIn.T = Tw;
 QmbIn.Cdot = QmbOut.Cdot;

 Q_totIn = sum(QmbIn.Q_flow);
 Q_totOut = sum(QmbOut.Q_flow);
public
  record SummaryClass
    replaceable Arrays T_profile;
     record Arrays
       parameter Integer n;
     Modelica.SIunits.Temperature[n*3] T_cell;
     end Arrays;
  end SummaryClass;
  SummaryClass Summary(T_profile(n=n,T_cell = Temp[:]));
 annotation (Icon(coordinateSystem(extent={{-100,-20},{100,20}}),
                  graphics={
       Rectangle(
         extent={{-100,20},{100,-20}},
         lineColor={0,0,0},
         pattern=LinePattern.None,
         fillPattern=FillPattern.Solid,
         fillColor={175,175,175})}),    Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-20},{100,20}}),
                                                graphics={
       Text(
         extent={{36,34},{48,18}},
         lineColor={255,0,0},
         lineThickness=0.5,
         fillColor={85,255,255},
         fillPattern=FillPattern.Solid,
         textString=
              "qa"),
       Text(
         extent={{32,-18},{44,-34}},
         lineColor={255,0,0},
         lineThickness=0.5,
         fillColor={85,255,255},
         fillPattern=FillPattern.Solid,
         textString=
              "qb"),
       Rectangle(
         extent={{-100,20},{100,-20}},
         lineColor={0,0,0},
         pattern=LinePattern.None,
         fillPattern=FillPattern.HorizontalCylinder,
         fillColor={175,175,175})}),Documentation(info="<HTML>
         <p><big> Model <b>Wall</b> simulate a moving boundary 1-dimensional tube of solid material. The assumptions of the model are:
<ul><li> Wall thermal resistance is neglected (i.e. No temperature gradient in the wall)
<li> Longitudinal thermal energy conduction is neglected
<li> Thermal energy accumulation is accounted for.

         
         
         </HTML>"));
end wall;
