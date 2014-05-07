within ThermoCycle.Components.Units.Solar;
model SolarField_Forristal
  "Solar field model with collectors based on Forristal model"
replaceable package Medium1 = ThermoCycle.Media.R245fa_CPRP
                                           constrainedby
    Modelica.Media.Interfaces.PartialMedium                                                      annotation (choicesAllMatching = true);

/*********************** PARAMETERS ****************************/

constant Real  pi = Modelica.Constants.pi;
/*********************** Optical Parameter Values give an eta_opt = 0.7263 ***********************/
parameter Real eps1 = 0.9754 "HCE Shadowing"
                                            annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real eps2 = 0.994 "Tracking error"
                                            annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real eps3 = 0.98 "Geometry error"
                                           annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real rho_cl = 0.935 "Mirror reflectivity"
                                                   annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real eps4 = 0.962566845 "Dirt on Mirrors"
                                                   annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real eps5 = 0.981283422 "Dirt on HCE"
                                               annotation (Dialog(group="Optical Properties", tab="General"));
parameter Real eps6 = 0.96 "Unaccounted FORSE DA LEVARE"
                                                        annotation (Dialog(group="Optical Properties", tab="General"));

/*****************General Geometries**************************/
parameter Integer N(min=1) = 10 "Number of cells per tube";
parameter Integer Ns(min=1) = 2 "Number of tube in series";
parameter Integer Nt(min=1) = 1 "Number of tubes in parallel";
parameter Modelica.SIunits.Length L = 8 "Length of tube";
parameter Modelica.SIunits.Length A_P = 5 "Aperture of the parabola";

final parameter Modelica.SIunits.Length D_int_t= Dext_t - 2*th_t
    "internal diameter of the metal tube";
final parameter Modelica.SIunits.Area A_lateral= L*D_int_t*pi*Nt
    "Lateral internal surface of the metal tube";
final parameter Modelica.SIunits.Volume V_tube_int = pi*D_int_t^2/4*L*Nt
    "Internal volume of the metal tube";

/*********************** GLASS PROPERTIES ***********************/
parameter Modelica.SIunits.Density rho_g = 2400 "Glass density"
                                                              annotation (Dialog(group="Properties of the glass envelope", tab="General"));
parameter Modelica.SIunits.SpecificHeatCapacity Cp_g = 753
    "Specific heat capacity of the glass"
                                         annotation (Dialog(group="Properties of the glass envelope", tab="General"));
parameter Modelica.SIunits.ThermalConductivity lambda_g = 1.05
    "Thermal conductivity of the glass"
                                       annotation (Dialog(group="Properties of the glass envelope", tab="General"));
parameter Modelica.SIunits.Length Dext_g = 0.12 "External glass diameter"
                                                                         annotation (Dialog(group="Properties of the glass envelope", tab="General"));
parameter Modelica.SIunits.Length th_g = 0.0025 "Glass thickness"
                                                                 annotation (Dialog(group="Properties of the glass envelope", tab="General"));

/***********************  TUBE PROPERTIES ***********************/
parameter Modelica.SIunits.Length Dext_t =  0.07 "External diameter tube"
                                                                         annotation (Dialog(group="Properties of the metal envelope", tab="General"));
                              //if PTR then 0.07 elseif UVAC then 0.056 else 0.056
parameter Modelica.SIunits.Length th_t =  0.002 "tube thickness"
                                                                annotation (Dialog(group="Properties of the metal envelope", tab="General"));
                      //if PTR then 0.0025 elseif UVAC then 0.003 else 0.003
parameter Modelica.SIunits.Density rho_t = 8000 "tube density"
                                                             annotation (Dialog(group="Properties of the metal envelope", tab="General"));
parameter Modelica.SIunits.SpecificHeatCapacity Cp_t = 500
    "Specific heat capacity of the tube"
                                        annotation (Dialog(group="Properties of the metal envelope", tab="General"));
parameter Modelica.SIunits.ThermalConductivity lambda_t = 54
    "Thermal conductivity of the tube"
                                      annotation (Dialog(group="Properties of the metal envelope", tab="General"));

/*********************** PRESSURE VACUUM ***********************/
parameter Modelica.SIunits.Pressure Pvacuum = 0.013332237
    "Vacuum Pressure [Pa]"                                                      annotation (Dialog(group="Vacuum properties: between metal and glass envelope", tab="General"));

/*********************** Parameter for coefficient of heat transfer air ***********************/
parameter Real Pr= 0.72 "Prandt number"
                                       annotation (Dialog(group="Atmospheric characteristic", tab="General"));
parameter Modelica.SIunits.Pressure Patm = 1e5 "Atmosphere Pressure [Pa]"
                                                                        annotation (Dialog(group="Atmospheric characteristic", tab="General"));

/*********************** TEMPERATURE INITIALIZATION GLASS AND METAL WALL ***********************/
parameter Modelica.SIunits.Temperature T_g_start_in = 42 + 273.15
    "Temperature at the inlet of the glass"
                                           annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature T_g_start_out = 54 + 273.15
    "Temperature at the outlet of the glass"
                                            annotation (Dialog(tab="Initialization"));

final parameter Modelica.SIunits.Temperature[Ns] T_g_start_inlet_collector =  ThermoCycle.Functions.Solar.T_start_inlet(T_start_inlet=T_g_start_in,T_start_outlet=T_g_start_out,Ns=Ns);

final parameter Modelica.SIunits.Temperature[Ns] T_g_start_outlet_collector = ThermoCycle.Functions.Solar.T_start_outlet(T_start_inlet=T_g_start_in,T_start_outlet=T_g_start_out,Ns=Ns);

parameter Modelica.SIunits.Temperature T_t_start_in = 195 + 273.15
    "Temperature at the inlet of the tube"
                                          annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature T_t_start_out = 305 + 273.15
    "Temperature at the outlet of the tube"
                                           annotation (Dialog(tab="Initialization"));

final parameter Modelica.SIunits.Temperature[Ns] T_t_start_inlet_collector =  ThermoCycle.Functions.Solar.T_start_inlet(T_start_inlet=T_t_start_in,T_start_outlet=T_t_start_out,Ns=Ns);

final parameter Modelica.SIunits.Temperature[Ns] T_t_start_outlet_collector = ThermoCycle.Functions.Solar.T_start_outlet(T_start_inlet=T_t_start_in,T_start_outlet=T_t_start_out,Ns=Ns);

parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_l=300
    "if HTtype = LiqVap: heat transfer coefficient, liquid zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp=700
    "if HTtype = LiqVap: heat transfer coefficient, two-phase zone" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_v=400
    "if HTtype = LiqVap: heat transfer coefficient, vapor zone" annotation (Dialog(group="Heat transfer", tab="General"));
//parameter Real kw "Exponent of the mass flow rate in the h.t.c. correlation";
parameter Modelica.SIunits.MassFlowRate Mdotnom= 0.5 "Total nominal Mass flow";
// Fluid initial values
parameter Modelica.SIunits.Temperature Tstart_inlet
    "Temperature of the fluid at the inlet of the collector"
                                                            annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature Tstart_outlet
    "Temperature of the fluid at the outlet of the collector"
                                                             annotation (Dialog(tab="Initialization"));

final parameter Modelica.SIunits.Temperature[Ns] Tstart_inlet_collector =  ThermoCycle.Functions.Solar.T_start_inlet(T_start_inlet=Tstart_inlet,T_start_outlet=Tstart_outlet,Ns=Ns);

final parameter Modelica.SIunits.Temperature[Ns] Tstart_outlet_collector = ThermoCycle.Functions.Solar.T_start_outlet(T_start_inlet=Tstart_inlet,T_start_outlet=Tstart_outlet,Ns=Ns);

parameter Modelica.SIunits.Pressure pstart
    "Temperature of the fluid at the inlet of the collector"
                                                            annotation (Dialog(tab="Initialization"));
/*steady state */
 parameter Boolean steadystate_T_fl=false
    "if true, sets the derivative of the fluid Temperature in each cell to zero during Initialization"
                                                                                                      annotation (Dialog(group="Intialization options", tab="Initialization"));

/***************************    NUMERICAL OPTION    *****************************************************/

  import ThermoCycle.Functions.Enumerations.Discretizations;
 parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
/*Working fluid*/
  parameter Boolean Mdotconst=false
    "Set to yes to assume constant mass flow rate of primary fluid at each node (easier convergence)"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean max_der=false
    "Set to yes to limit the density derivative of primary fluid during phase transitions"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean filter_dMdt=false
    "Set to yes to filter dMdt of primary fluid with a first-order filter"
    annotation (Dialog(tab="Numerical options"));
  parameter Real max_drhodt=100
    "Maximum value for the density derivative of primary fluid"
    annotation (Dialog(enable=max_der_wf, tab="Numerical options"));
   parameter Modelica.SIunits.Time TT=1
    "Integration time of the first-order filter"
    annotation (Dialog(enable=filter_dMdt, tab="Numerical options"));

   /*******************************   HEAT TRANSFER MODEL    **************************************/

replaceable model FluidHeatTransferModel =
      ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.MassFlowDependence
constrainedby
    ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.BaseClasses.PartialConvectiveCorrelation
    "Fluid heat transfer model" annotation (Dialog(group="Heat transfer", tab="General"),choicesAllMatching=true);

 /******************************* COMPONENTS ***********************************/
    Components.HeatFlow.Walls.SolarAbsorber.SolAbsForristal[ Ns] solAbs(
    each eps1=eps1,
    each eps2=eps2,
    each eps3=eps3,
    each rho_cl=rho_cl,
    each eps4=eps4,
    each eps5=eps5,
    each eps6=eps6,
    each N=N,
    each Nt=Nt,
    each L=L,
    each A_P=A_P,
    each rho_g=rho_g,
    each Cp_g=Cp_g,
    each lambda_g=lambda_g,
    each rho_t=rho_t,
    each Cp_t=Cp_t,
    each lambda_t=lambda_t,
    each Patm=Patm,
    each Pr=Pr,
    each Pvacuum=Pvacuum,
     T_g_start_in=T_g_start_inlet_collector,
     T_g_start_out=T_g_start_inlet_collector,
     T_t_start_in=T_t_start_inlet_collector,
     T_t_start_out=T_t_start_outlet_collector,
    each Dext_g=Dext_g,
    each th_g=th_g,
    each Dext_t=Dext_t,
    each th_t=th_t)
    annotation (Placement(transformation(extent={{-30,-16},{14,34}})));
  Components.FluidFlow.Pipes.Flow1Dim[Ns] flow1Dim(redeclare each package
      Medium =                                                                     Medium1,
  redeclare each final model Flow1DimHeatTransferModel = FluidHeatTransferModel,
    each N=N,
     each A=A_lateral,
    each V=V_tube_int,
    each Mdotnom=Mdotnom,
    each Unom_l=Unom_l,
    each Unom_tp=Unom_tp,
    each Unom_v=Unom_v,
    each pstart=pstart,
    Tstart_inlet=Tstart_inlet_collector,
    Tstart_outlet=Tstart_outlet_collector,
    each Mdotconst=Mdotconst,
    each max_der=max_der,
    each filter_dMdt=filter_dMdt,
    each max_drhodt=max_drhodt,
    each TT=TT,
    each steadystate=steadystate_T_fl,
    each Discretization=Discretization)
                                  annotation (Placement(transformation(
        extent={{-27.5,-31.5},{27.5,31.5}},
        rotation=90,
        origin={34.5,7.5})));
  Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-96,2},{-76,22}}),
        iconTransformation(extent={{-96,2},{-76,22}})));
  Interfaces.Fluid.FlangeB OutFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{94,0},{114,20}}),
        iconTransformation(extent={{94,0},{114,20}})));
  Modelica.Blocks.Interfaces.RealInput v_wind
    annotation (Placement(transformation(extent={{-90,38},{-50,78}}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-70,98})));
  Modelica.Blocks.Interfaces.RealInput Theta
    annotation (Placement(transformation(extent={{-90,4},{-50,44}}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-24,98})));
  Modelica.Blocks.Interfaces.RealInput Tamb
    annotation (Placement(transformation(extent={{-90,-38},{-50,2}}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={24,98})));
  Modelica.Blocks.Interfaces.RealInput DNI
    annotation (Placement(transformation(extent={{-90,-76},{-50,-36}}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={80,98})));

   /**************************************************** SUMMARY ********************************************/
public
  record SummaryBase
     replaceable Arrays T_profile;
     record Arrays
      parameter Integer n;
      parameter Integer Ns;
      Modelica.SIunits.Temperature[Ns,n] T_fluid;
      Modelica.SIunits.Temperature[Ns,n] T_int_t;
      Modelica.SIunits.Temperature[Ns,n] T_t;
      Modelica.SIunits.Temperature[Ns,n] T_ext_t;
      Modelica.SIunits.Temperature[Ns,n] T_int_g;
      Modelica.SIunits.Temperature[Ns,n] T_g;
      Modelica.SIunits.Temperature[Ns,n] T_ext_g;
     end Arrays;
        Real Eta_solarCollector "Total efficiency of solar collector";
        Modelica.SIunits.HeatFlux Philoss "Heat Flux lost to the environment";
         Modelica.SIunits.Power Q_htf
      "Total heat through the termal heat transfer fluid flowing in the solar collector";
  end SummaryBase;
   replaceable record SummaryClass = SummaryBase;
   SummaryClass Summary( T_profile( n=N,Ns=Ns, T_fluid = T_fluid_,   T_int_t=T_int_t_,  T_t=T_t_, T_ext_t=T_ext_t_,  T_int_g=T_int_g_,  T_g=T_g_, T_ext_g=T_ext_g_), Eta_solarCollector=Eta_solarCollector_,Philoss=Philoss_,Q_htf=Q_htf_);
protected
  Modelica.SIunits.Temperature T_fluid_[Ns,N];
  Modelica.SIunits.Temperature T_int_t_[Ns,N];
      Modelica.SIunits.Temperature T_t_[Ns,N];
      Modelica.SIunits.Temperature T_ext_t_[Ns,N];
      Modelica.SIunits.Temperature T_int_g_[Ns,N];
      Modelica.SIunits.Temperature T_g_[Ns,N];
      Modelica.SIunits.Temperature T_ext_g_[Ns,N];
Real Eta_solarCollector_;
Modelica.SIunits.HeatFlux Philoss_;
Modelica.SIunits.Power Q_htf_;
equation
         for i in 1:Ns loop
    for k in 1:N loop
      /* temperature profile of the working fluid*/
    T_fluid_[i,k] = flow1Dim[i].Cells[k].T;

    /* temperature profile of the metal tube */
    T_int_t_[i,k] = solAbs[i].T_int_t[k];
    T_t_[i,k] = solAbs[i].T_t[k];
    T_ext_t_[i,k] = solAbs[i].T_ext_t[k];

    /* temperature profile of the glass envelope */
    T_int_g_[i,k] = solAbs[i].T_int_g[k];
    T_g_[i,k] = solAbs[i].T_g[k];
    T_ext_g_[i,k] = solAbs[i].T_ext_g[k];
    end for;
  end for;

Eta_solarCollector_ = sum(solAbs[:].Eta_TOT);
Philoss_ = sum(solAbs[:].Phi_loss);
Q_htf_ = sum(flow1Dim[:].Q_tot) "Total power absorbed by the fluid";

  for i in 1:Ns loop
      connect(solAbs[i].wall_int, flow1Dim[i].Wall_int) annotation (Line(
      points={{11.8,9},{20.45,9},{20.45,7.5},{21.375,7.5}},
      color={255,0,0},
      smooth=Smooth.None));
        connect(DNI, solAbs[i].DNI) annotation (Line(
      points={{-70,-56},{-36,-56},{-36,-10},{-27.36,-10}},
      color={0,0,127},
      smooth=Smooth.None));

       connect(v_wind, solAbs[i].v_wind) annotation (Line(
      points={{-70,58},{-34,58},{-34,30},{-26.92,30}},
      color={0,0,127},
      smooth=Smooth.None));

        connect(Tamb, solAbs[i].Tamb) annotation (Line(
      points={{-70,-18},{-46,-18},{-46,2.5},{-26.92,2.5}},
      color={0,0,127},
      smooth=Smooth.None));

        connect(Theta, solAbs[i].Theta) annotation (Line(
      points={{-70,24},{-38,24},{-38,12},{-26.92,12},{-26.92,14.5}},
      color={0,0,127},
      smooth=Smooth.None));

  end for;

    for i in 1:Ns-1 loop
  connect(flow1Dim[i].OutFlow,flow1Dim[i+1].InFlow);

  end for;
  connect(OutFlow, flow1Dim[Ns].OutFlow);
connect(InFlow, flow1Dim[1].InFlow);

                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),
              Diagram(coordinateSystem(extent={{-80,-100},{100,100}},
          preserveAspectRatio=true),
                      graphics={Line(
          points={{-86,0},{-86,-88},{36,-88},{36,-22}},
          color={0,0,255},
          smooth=Smooth.None), Line(
          points={{34,36},{34,54},{104,54},{104,22}},
          color={0,0,255},
          smooth=Smooth.None)}), Icon(coordinateSystem(extent={{-80,-100},{100,100}},
                      preserveAspectRatio=true),
                                      graphics={
        Rectangle(
          extent={{-80,84},{100,-86}},
          pattern=LinePattern.Dot,
          lineColor={0,0,0},
          fillColor={239,239,239},
          fillPattern=FillPattern.Solid), Text(
          extent={{-34,-52},{50,-80}},
          lineColor={0,0,0},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Ellipse(
          extent={{-58,60},{-28,28}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-42,60},{-4,28}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{16,56},{46,24}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{32,56},{70,24}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-56,-4},{-26,-36}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-42,-4},{-4,-36}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{18,-8},{48,-40}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{32,-8},{70,-40}},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{78,42},{78,-22},{72,-22},{72,-22}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-66,42},{78,42}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-66,42},{-66,-22},{-60,-22},{-60,-22}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-80,12},{-66,12},{-66,12}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-66,-22},{76,-22}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{78,10},{90,10},{98,10}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=0.5),
        Text(
          extent={{-24,78},{2,70}},
          lineColor={0,0,0},
          textString="Tamb[K]"),
        Text(
          extent={{-72,76},{-42,66}},
          lineColor={0,0,0},
          textString="DNI"),
        Text(
          extent={{12,78},{62,70}},
          lineColor={0,0,0},
          textString="Theta[rad]"),
        Text(
          extent={{54,76},{98,66}},
          lineColor={0,0,0},
          textString="v_wind [m/s]")}),
     Documentation(info="<HTML>

<p><big>The <b>SolarField_Forristal</b> model represents the solar field, composed by
  a loop of parabolic collectors, based on <a href=\"http://www.nrel.gov/csp/troughnet/pdfs/34169.pdf\">Forristal model</a>. The large ratio between diameter
  and length allows a 1-D discretization of the absorber tube.
   The model is composed by two sub-components: the <a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim\">Flow1Dim</a> and the <a href=\"modelica://ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.SolAbsForristal\">SolAbsForristal</a> components.
They are connected together through a thermal port.
</p>

<p><big>The <a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim\">Flow1Dim</a> models the fluid flow in the heat collector element.
<p><big>The <a href=\"modelica://ThermoCycle.Components.HeatFlow.Walls.SolAbs\">SolAbs</a> represents the dynamic one-dimensional radial energy balance around the heat collector element.

<p><big> The inputs to the model representing the ambient conditions are:</p>
<p><big><ul><li>DNI: Direct Normal Radiation [W/m2]
 <li>Theta: Incidence angle [rad]
 <li>T_amb: ambient temperature [K]
 <li>v_wind: wind velocity [m/s]
</ul>


</HTML>"));
end SolarField_Forristal;
