within ThermoCycle.Components.FluidFlow.Pipes;
model Flow1Dim_MD
  "1-D fluid flow model (finite volume discretization - real fluid model) based on the exact integration of the mean volume density"
replaceable package Medium = ThermoCycle.Media.R245fa_CP  constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);

/* Thermal and fluid ports */
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-18},{120,20}})));
  ThermoCycle.Interfaces.HeatTransfer.ThermalPort Wall_int(N=N)
    annotation (Placement(transformation(extent={{-28,40},{32,60}}),
        iconTransformation(extent={{-40,40},{40,60}})));
// Geometric characteristics
  constant Modelica.SIunits.SpecificEnthalpy hzero=1e-3
    "Small value for deltah";
  constant Real pi = Modelica.Constants.pi "pi-greco";
  parameter Integer N(min=1)=10 "Number of cells";
  parameter Integer Nt(min=1)=1 "Number of tubes in parallel";
  parameter Modelica.SIunits.Area A = 16.18
    "Lateral surface of the tube: heat exchange area";
  parameter Modelica.SIunits.Volume V = 0.03781 "Volume of the tube";
  final parameter Modelica.SIunits.Volume Vi=V/N "Volume of a single cell";
  final parameter Modelica.SIunits.Area Ai=A/N
    "Lateral surface of a single cell";
  parameter Modelica.SIunits.MassFlowRate Mdotnom = 0.2588
    "Nominal fluid flow rate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U_nom = 100
    "if HTtype = LiqVap : Heat transfer coefficient, liquid zone ";

/* FLUID INITIAL VALUES */
parameter Modelica.SIunits.Pressure pstart "Fluid pressure start value"
                                     annotation (Dialog(tab="Initialization"));
  parameter Medium.Temperature Tstart_inlet "Inlet temperature start value"
     annotation (Dialog(tab="Initialization"));
  parameter Medium.Temperature Tstart_outlet "Outlet temperature start value"
     annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstart[N+1]=linspace(
        Medium.specificEnthalpy_pT(pstart,Tstart_inlet),Medium.specificEnthalpy_pT(pstart,Tstart_outlet),
        N+1) "Start value of enthalpy vector (initialized by default)"
    annotation (Dialog(tab="Initialization"));
/* NUMERICAL OPTIONS  */
//  import ThermoCycle.Functions.Enumerations.Discretizations;
//  parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
//    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
  parameter Boolean Mdotconst=false
    "Set to yes to assume constant mass flow rate at each node (easier convergence)"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean max_der=false
    "Set to yes to limit the density derivative during phase transitions"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean filter_dMdt=false
    "Set to yes to filter dMdt with a first-order filter"
    annotation (Dialog(tab="Numerical options"));
  parameter Real max_drhodt=100 "Maximum value for the density derivative"
    annotation (Dialog(enable=filter_dMdt, tab="Numerical options"));
  parameter Modelica.SIunits.Time TT=1
    "Integration time of the first-order filter"
    annotation (Dialog(enable=max_der, tab="Numerical options"));
//enable=filter_dMdt,enable=max_der,
  parameter Boolean steadystate=true
    "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
    annotation (Dialog(group="Initialization options", tab="Initialization"));
/* FLUID VARIABLES */
/* Saturation variables */
  Medium.SaturationProperties sat;
  Modelica.SIunits.SpecificEnthalpy h_l "saturated liquid enthalpy";
  Modelica.SIunits.SpecificEnthalpy h_v "saturated vapor enthalpy";
  Medium.Density rho_l;
  Medium.Density rho_v;
  Modelica.SIunits.DerDensityByPressure drldp
    "Bubble point density derivative with respect to pressure";
  Modelica.SIunits.DerDensityByPressure drvdp
    "Dew point density derivative with respect to pressure";
  Modelica.SIunits.DerEnthalpyByPressure dhldp
    "Bubble point enthalpy derivative with respect to pressure";
  Modelica.SIunits.DerEnthalpyByPressure dhvdp
    "Dew point enthalpy derivative with respect to pressure";

/* Fluid variables */
  Medium.ThermodynamicState  fluidState[N+1];
  //Medium.Temperature T_sat "Saturation temperature";
  Medium.AbsolutePressure p(start=pstart);
  Modelica.SIunits.MassFlowRate M_dot_su;
  Medium.SpecificEnthalpy h[N] "Fluid specific enthalpy at the center cells";
   Modelica.SIunits.SpecificEnthalpy h_node[N + 1](start=hstart)
    "Enthalpy state variables at each node";
  Medium.Temperature T[N];//(start=Tstart) "Fluid temperatureat the center of the cell";
  Medium.Temperature T_node[N+1] "Fluid temperature at the nodes";
  Modelica.SIunits.Temperature T_wall[N] "Internal wall temperature";
  Medium.Density rho[N] "Fluid cell density at center cell";
  Medium.Density rho_node[N+1] "Fluid cell density at the nodes";

  Modelica.SIunits.DerDensityByEnthalpy drdh_node[N+1]
    "Derivative of density by enthalpy at each node";
  Modelica.SIunits.DerDensityByEnthalpy drdh1[N]
    "Derivative of average density by left enthalpy";
  Modelica.SIunits.DerDensityByEnthalpy drdh2[N]
    "Derivative of average density by right enthalpy";
  //Modelica.SIunits.DerDensityByEnthalpy drdh[N]
  //  "Derivative of density by enthalpy at center cell"; // It will be eliminated!!!!

  Modelica.SIunits.DerDensityByPressure drdp_node[N+1]
    "Derivative of density by pressure at each node";
  Modelica.SIunits.DerDensityByPressure drdp[N]
    "Derivative of density by pressure at center cell";

  Real dMdt[N] "Time derivative of mass in each cell between two nodes";
  Modelica.SIunits.HeatFlux qdot[N] "heat flux in each cell between two nodes";
  Modelica.SIunits.MassFlowRate Mdot_node[N + 1](each start=Mdotnom/Nt, each min=0);
  Modelica.SIunits.MassFlowRate Mdot[N](each start=Mdotnom/Nt, each min=0);
  //Modelica.SIunits.CoefficientOfHeatTransfer U[N]
  //  "Heat transfer coefficient between wall and working fluid";
  Real x_node[N+1] "Vapor quality at each node";

  Modelica.SIunits.Power Q_tot "Total heat flux exchanged by the thermal port";
  Modelica.SIunits.Mass M_tot "Total mass of the fluid in the component";

 Real AA "Variable for the calculation of the mean density derivative";
 Real BB "Variable for the calculation of the mean density derivative";
equation
  Mdot_node[1] = M_dot_su;
  //Saturation
  sat = Medium.setSat_p(p);
  h_v = Medium.dewEnthalpy(sat);
  h_l = Medium.bubbleEnthalpy(sat);
  rho_l = Medium.bubbleDensity(sat);
  rho_v = Medium.dewDensity(sat);
  drldp = Medium.dBubbleDensity_dPressure(sat)
    "Bubble point density derivative with respect to pressure";
  drvdp = Medium.dDewDensity_dPressure(sat)
    "Dew point density derivative with respect to pressure";
  dhldp = Medium.dBubbleEnthalpy_dPressure(sat)
    "Bubble point specific enthalpy derivative with respect to pressure";
  dhvdp = Medium.dDewEnthalpy_dPressure(sat)
    "Dew point specific enthalpy derivative with respect to pressure";

AA =  (h_v - h_l)*rho_v*rho_l/(rho_l - rho_v);
BB = ((dhvdp - dhldp)*(rho_l - rho_v)*rho_l*rho_v
          - (h_v - h_l)*(rho_v^2*drldp - rho_l^2*drvdp))/(rho_l - rho_v)^2;

for j in 1:N+1 loop
  /* Fluid Properties at each node */
  fluidState[j] = Medium.setState_ph(p,h_node[j]);
  rho_node[j] = Medium.density(fluidState[j]);
  T_node [j] = Medium.temperature(fluidState[j]);
  x_node[j] = noEvent(if h_node[j]<=h_l then 0 else
              if h_node[j]>=h_v then 1 else (h_node[j]-h_l)/(h_v-h_l));

if max_der then
      drdp_node[j] = min(max_drhodt/10^5, Medium.density_derp_h(fluidState[j]));
      drdh_node[j] = max(max_drhodt/(-4000), Medium.density_derh_p(fluidState[j]));
  else
     drdp_node[j] = Medium.density_derp_h(fluidState[j]);
     drdh_node[j] = Medium.density_derh_p(fluidState[j]);
  end if;
end for;

for j in 1:N loop
/* Upwind discretization*/
  h_node[j + 1] = h[j];
/* Center cell temperature */
 T[j] = T_node[j+1];

/* Mass flow at the center of the cell */
Mdot[j] = M_dot_su -  sum(dMdt[1:j - 1]) - dMdt[j]/2;

/* Loop for the MEAN DENSITY FUNCTION */
if noEvent((h_node[j] < h_l and h_node[j + 1] < h_l) or (h_node[j] > h_v and h_node[j + 1] >
        h_v) or abs(h_node[j + 1] - h_node[j]) < hzero) then
  // 1-phase or almost uniform properties
rho[j] =  (rho_node[j] + rho_node[j+1])/2;
drdp[j] = (drdp_node[j] + drdp_node[j+1]) /2;
drdh1[j] = drdh_node[j]/2;
drdh2[j] =  drdh_node[j+1]/2;
elseif noEvent(h_node[j] >= h_l and h_node[j] <= h_v and h_node[j + 1] >= h_l and h_node[j + 1]<= h_v) then
      // 2-phase
      rho[j] = AA*log(rho_node[j]/rho_node[j+1]) / (h_node[j+1] - h_node[j]);
      drdp[j] = (BB*log(rho_node[j]/rho_node[j+1]) +
                  AA*(1/rho_node[j] * drdp_node[j] - 1/rho_node[j+1] * drdp_node[j+1])) /
                 (h_node[j+1] - h_node[j]);
      drdh1[j] = (rho[j] - rho_node[j]) / (h_node[j+1] - h_node[j]);
      drdh2[j] = (rho_node[j+1] - rho[j]) / (h_node[j+1] - h_node[j]);
elseif noEvent(h_node[j] < h_l and h_node[j + 1] >= h_l and h_node[j + 1] <= h_v) then
      // liquid/2-phase
      rho[j] = ((rho_node[j] + rho_l)*(h_l - h_node[j])/2 + AA*log(rho_l/rho_node[j+1])) /
                  (h_node[j+1] - h_node[j]);
      drdp[j] = ((drdp_node[j] + drldp)*(h_l - h_node[j])/2 + (rho_node[j]+rho_l)/2 * dhldp +
                   BB*log(rho_l/rho_node[j+1]) +
                   AA*(1/rho_l * drldp - 1/rho_node[j+1] * drdp_node[j+1])) / (h_node[j+1] - h_node[j]);
      drdh1[j] = (rho[j] - (rho_node[j]+rho_l)/2 + drdh_node[j]*(h_l-h_node[j])/2) / (h_node[j+1] - h_node[j]);
      drdh2[j] = (rho_node[j+1] - rho[j]) / (h_node[j+1] - h_node[j]);
elseif noEvent(h_node[j] >= h_l and h_node[j] <= h_v and h_node[j + 1] > h_v) then
      // 2-phase/vapor
      rho[j] = (AA*log(rho_node[j]/rho_v) + (rho_v + rho_node[j+1])*(h_node[j+1] - h_v)/2) /
                  (h_node[j+1] - h_node[j]);
      drdp[j] = (BB*log(rho_node[j]/rho_v) +
                  AA*(1/rho_node[j] * drdp_node[j] - 1/rho_v *drvdp) +
                  (drvdp + drdp_node[j+1])*(h_node[j+1] - h_v)/2 - (rho_v+rho_node[j+1])/2 * dhvdp) /
                 (h_node[j + 1] - h_node[j]);
      drdh1[j] = (rho[j] - rho_node[j]) / (h_node[j+1] - h_node[j]);
      drdh2[j] = ((rho_v+rho_node[j+1])/2 - rho[j] + drdh_node[j+1]*(h_node[j+1]-h_v)/2)/(h_node[j+1] - h_node[j]);
elseif noEvent(h_node[j] < h_l and h_node[j + 1] > h_v) then
      // liquid/2-phase/vapour
      rho[j] = ((rho_node[j] + rho_l)*(h_l - h_node[j])/2 + AA*log(rho_l/rho_v) +
                   (rho_v + rho_node[j+1])*(h_node[j+1] - h_v)/2) / (h_node[j+1] - h_node[j]);
      drdp[j] = ((drdp_node[j] + drldp)*(h_l - h_node[j])/2 + (rho_node[j]+rho_l)/2 * dhldp +
                  BB*log(rho_l/rho_v) + AA*(1/rho_l * drldp - 1/rho_v * drvdp) +
                  (drvdp + drdp_node[j+1])*(h_node[j+1] - h_v)/2 - (rho_v+rho_node[j+1])/2 * dhvdp) /
                 (h_node[j+1] - h_node[j]);
      drdh1[j] = (rho[j] - (rho_node[j]+rho_l)/2 + drdh_node[j]*(h_l-h_node[j])/2) / (h_node[j+1] - h_node[j]);
      drdh2[j] = ((rho_v+rho_node[j+1])/2 - rho[j] + drdh_node[j+1]*(h_node[j+1]-h_v)/2) / (h_node[j+1] - h_node[j]);
elseif noEvent(h_node[j] >= h_l and h[j] <= h_v and h_node[j + 1] < h_l) then
      // 2-phase/liquid
      rho[j] = (AA*log(rho_node[j]/rho_l) + (rho_l + rho_node[j+1])*(h_node[j+1] - h_l)/2) /
                  (h_node[j+1] - h_node[j]);
      drdp[j] = (BB*log(rho_node[j]/rho_l) +
                  AA*(1/rho_node[j] * drdp_node[j] - 1/rho_l * drldp) +
                  (drldp + drdp_node[j+1])*(h_node[j+1] - h_l)/2 - (rho_l + rho_node[j+1])/2 * dhldp) /
                 (h_node[j + 1] - h_node[j]);
      drdh1[j] = (rho[j] - rho_node[j]) / (h_node[j+1] - h_node[j]);
      drdh2[j] = ((rho_l+rho_node[j+1])/2 - rho[j] + drdh_node[j+1]*(h_node[j+1]-h_l)/2) / (h_node[j+1] - h_node[j]);
  elseif noEvent(h_node[j] > h_v and h_node[j + 1] < h_l) then
      // vapour/2-phase/liquid
      rho[j] = ((rho_node[j] + rho_v)*(h_v - h_node[j])/2 + AA*log(rho_v/rho_l) +
                   (rho_l + rho_node[j+1])*(h_node[j+1] - h_l)/2) / (h_node[j+1] - h_node[j]);
      drdp[j] = ((drdp_node[j] + drvdp)*(h_v - h_node[j])/2 + (rho_node[j]+rho_v)/2 * dhvdp +
                  BB*log(rho_v/rho_l) +
                  AA*(1/rho_v * drvdp - 1/rho_l * drldp) +
                  (drldp + drdp_node[j+1])*(h_node[j+1] - h_l)/2 - (rho_l+rho_node[j+1])/2 * dhldp) /
                 (h_node[j+1] - h_node[j]);
      drdh1[j] = (rho[j] - (rho_node[j]+rho_v)/2 + drdh_node[j]*(h_v-h_node[j])/2) / (h_node[j+1] - h_node[j]);
      drdh2[j] = ((rho_l+rho_node[j+1])/2 - rho[j] + drdh_node[j+1]*(h_node[j+1]-h_l)/2) / (h_node[j+1] - h_node[j]);
    else
      // vapour/2-phase
      rho[j] = ((rho_node[j] + rho_v)*(h_v - h_node[j])/2 + AA*log(rho_v/rho_node[j+1])) / (h_node[j+1] - h_node[j]);
      drdp[j] = ((drdp_node[j] + drvdp)*(h_v - h_node[j])/2 + (rho_node[j]+rho_v)/2 * dhvdp +
                  BB*log(rho_v/rho_node[j+1]) + AA*(1/rho_v * drvdp - 1/rho_node[j+1] * drdp_node[j+1])) /
                 (h_node[j + 1] - h_node[j]);
      drdh1[j] = (rho[j] - (rho_node[j]+rho_v)/2 + drdh_node[j]*(h_v-h_node[j])/2) / (h_node[j+1] - h_node[j]);
      drdh2[j] = (rho_node[j+1] - rho[j]) / (h_node[j+1] - h_node[j]);
    end if;

/* ENERGY BALANCE */
Vi*rho[j]*der(h[j]) + Mdot[j]*(h_node[j + 1] - h_node[j])- Vi*der(p) = Ai*qdot[j];

//(h_node[j + 1] - h[j]) - Mdot[j]*(h_node[j] - h[j]) - Vi*der(p) = Ai*qdot[j]
//      "Energy balance";
  qdot[j] = (U_nom)*(T_wall[j] - T[j]);

/* MASS BALANCE */
  if filter_dMdt then
      der(dMdt[j]) = (Vi*(drdh1[j]*der(h[j]) + drdh2[j]*der(h[j]) + drdp[j]*der(p)) - dMdt[j])/TT
        "Mass derivative for each volume";
       else
      dMdt[j] = Vi*(drdh1[j]*der(h[j]) + drdh2[j]*der(h[j]) + drdp[j]*der(p));
  end if;

if Mdotconst then
      Mdot_node[j + 1] = Mdot_node[j];
   else
      dMdt[j] = -Mdot_node[j + 1] + Mdot_node[j];
end if;
end for;

Q_tot = A*sum(qdot)*Nt "Total heat flow through the thermal port";
M_tot = V*sum(rho);

//* BOUNDARY CONDITIONS *//

/* Enthalpies */
 inStream(InFlow.h_outflow) = h_node[1];
 h_node[1] = InFlow.h_outflow;
 OutFlow.h_outflow = h_node[N + 1];

/* pressures */
 p = OutFlow.p;
 InFlow.p = p;

/*Mass Flow*/
 M_dot_su = InFlow.m_flow/Nt;
 if Mdotconst then
   OutFlow.m_flow/Nt = - M_dot_su + sum(dMdt);
 else
   OutFlow.m_flow/Nt = -Mdot_node[N+1];
 end if;

// InFlow.Xi_outflow = inStream(OutFlow.Xi_outflow);
// OutFlow.Xi_outflow = inStream(InFlow.Xi_outflow);

/* Thermal port boundary condition */
/*Temperatures */

 for j in 1:N loop
 Wall_int.T[j] = T_wall[j];
 end for;
 /*Heat flow */
 for j in 1:N loop
  Wall_int.phi[j] = qdot[j];
 end for;

public
 record SummaryClass
   replaceable Arrays T_profile;
    record Arrays
    parameter Integer n;
    Modelica.SIunits.Temperature[n] T_cell;
    Modelica.SIunits.Temperature[n+1] T_node;
    end Arrays;
    parameter Integer n;
    Modelica.SIunits.SpecificEnthalpy[n] h;
    Modelica.SIunits.SpecificEnthalpy[n+1] hnode;
    Modelica.SIunits.Density[n] rho;
    Modelica.SIunits.MassFlowRate[n+1] Mdot;
    Real[n+1] x;
   Modelica.SIunits.Pressure p;
 end SummaryClass;
 SummaryClass Summary(  T_profile( n=N,T_cell = T, T_node = T_node), n=N, h = h, hnode = h_node, rho = rho, Mdot = Mdot_node, x = x_node, p = p);

initial equation
  if steadystate then
    der(h) = zeros(N);
      end if;
  if filter_dMdt then
    der(dMdt) = zeros(N);
    end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{
            -120,-120},{120,120}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
                  extent={{-120,-120},{120,120}}),
                                      graphics={Rectangle(
          extent={{-92,40},{88,-40}},
          lineColor={0,0,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid)}),Documentation(info="<HTML>
          <p><big>Model <b>Flow1Dim_2ph</b> describes the flow of fluid through a discretized one dimensional tube.</p> 
          <p><big>Enthalpy and pressure are selected as state variable</p>
          <p><big> In the model the node variables are characterized by the following syntax: <b>_node</b>.
          <p><big>The model is discretized using the collocated grid method: the nodes variable are the state variables and the cell variable are deduced</p>.
          <p><big> UpWind discretization is considered i.e. h_node[j+1] = h_node[j].
          
          
          <p><b><big>Numerical options</b></p>
<p><big> In this tab several options are available to make the model more robust:
<ul><li> Mdotconst: assume constant mass flow rate at each node.
<li> max_der: if true the density derivative is truncated during phase change
<li> filter_dMdt: if true a first order filter is applied to the fast variations of the density with respect to time
<li> max_drhodt: it represents the maximum value of the density derivative. It activates when using max_der is set to true
<li> TT: it represents the integration time of the first order filter. It activates when filter_dMdt is set to true
</ul>         
          <p><big> The model is characterized by a SummaryClass that provide a quick access to the following variables once the model is simulated:
           <ul>
           <li>  Temperature at the center of each cell
           <li>  Temperature at each node
           <li> Enthalpy at each node
           <li>  Enthalpy at the center of each cell
           <li> Density at the center of each cell
           <li> Massflow at each nodes
           <li> Vapor quality at each nodes
           <li> Pressure in the tube
           </ul>
 <p><big>The model is based on:</p>
 <p><big> <i>Casella, F. Object-oriented modelling of two-phase fluid flows by the finite volume method.
Proceedings 5th Mathmod Vienna, Austria, Sep 2006, p. 68.  </i>       
       </HTML>"));
end Flow1Dim_MD;
