within ThermoCycle.Obsolete;
model SolarCollectorIncSchott_1808
replaceable package Medium1 =
      ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66                         constrainedby
    Modelica.Media.Interfaces.PartialMedium                                                      annotation (choicesAllMatching = true);
// PARAMETERS //
constant Real  pi = Modelica.Constants.pi;
//FOCUS
parameter Boolean PTR = true "Set true to use the 2008 PTR collector";
//parameter Boolean UVAC "Choose type of collector";
// Optical Parameter Values give an eta_opt = 0.7263 //
parameter Real eps1 = 0.9754 "HCE Shadowing";
parameter Real eps2 = 0.994 "Tracking error";
parameter Real eps3 = 0.98 "Geometry error";
parameter Real rho_cl = 0.935 "Mirror reflectivity";
parameter Real eps4 = 0.962566845 "Dirt on Mirrors";
parameter Real eps5 = 0.981283422 "Dirt on HCE";
parameter Real eps6 = 0.96 "Unaccounted FORSE DA LEVARE";
// Parameter for coefficient of heat transfer air
parameter Modelica.SIunits.Pressure Patm= 100000 "Atmosphere Pressure [bar]";
//GEOMETRIES
parameter Integer N = 2 "Number of nodes";
parameter Integer Nt = 1 "Number of tubes";
parameter Modelica.SIunits.Length L "Length of tube";
final parameter Modelica.SIunits.Length D_int_t= Dext_t - 2*th_t
    "internal diameter of the metal tube";
final parameter Modelica.SIunits.Area A_lateral= L*D_int_t*pi
    "Lateral internal surface of the metal tube";
final parameter Modelica.SIunits.Volume V_tube_int = pi*D_int_t^2/4*L
    "Internal volume of the metal tube";
parameter Modelica.SIunits.Length A_P "Aperture of the parabola";
// TUBE PROPERTIES
parameter Modelica.SIunits.Length Dext_t =  0.07 "External diameter tube";
                              //if PTR then 0.07 elseif UVAC then 0.056 else 0.056
parameter Modelica.SIunits.Length th_t =  0.0025 "tube thickness";
                      //if PTR then 0.0025 elseif UVAC then 0.003 else 0.003
// Parameters for convective heat transfer in the fluid //
  import ThermoCycle.Functions.Enumerations.HT_sf;
parameter HT_sf HTtype=HT_sf.Const
    "Working fluid: Choose heat transfer coeff. type. Set LiqVap with Unom_l=Unom_tp=Unom_v to have a Const HT"
                                                                                                        annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom
    "Nominal heat transfer coefficient" annotation (Dialog(group="Heat transfer", tab="General"));
parameter Modelica.SIunits.MassFlowRate Mdotnom "Total nominal Mass flow";
/* Initialization values */
parameter Modelica.SIunits.Temperature Tstart_inlet
    "Temperature of the fluid at the inlet of the collector" annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Temperature Tstart_outlet
    "Temperature of the fluid at the outlet of the collector" annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Pressure pstart
    "Temperature of the fluid at the inlet of the collector" annotation (Dialog(tab="Initialization"));
/*steady state */
 parameter Boolean steadystate_T_fl=false
    "if true, sets the derivative of the fluid Temperature in each cell to zero during Initialization"
                                                                                                      annotation (Dialog(group="Initialization options", tab="Initialization"));
//NUMERICAL OPTION
  import ThermoCycle.Functions.Enumerations.Discretizations;
 parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
  Obsolete.Flow1DimInc_130702            SolarTube(redeclare package Medium = Medium1,
    N=N,
    A=A_lateral,
    V=V_tube_int,
    Unom=Unom,
    pstart=pstart,
    Tstart_inlet=Tstart_inlet,
    Tstart_outlet=Tstart_outlet,
    Mdotnom=Mdotnom,
    steadystate=steadystate_T_fl,
    HTtype=HTtype,
    Discretization=Discretization)
    annotation (Placement(transformation(extent={{-27,-21},{27,21}},
        rotation=90,
        origin={47,21})));
 ThermoCycle.Obsolete.AbsorberSchott_24_01_2014 absorberSchott(
    eps1=eps1,
    eps2=eps2,
    eps3=eps3,
    rho_cl=rho_cl,
    eps4=eps4,
    eps5=eps5,
    eps6=eps6,
    N=N,
    L=L,
    A_P=A_P,
    Dext_t=Dext_t,
    th_t=th_t,
    PTR=PTR)
    annotation (Placement(transformation(extent={{-10,4},{20,34}})));
  Modelica.Blocks.Interfaces.RealInput v_wind
    annotation (Placement(transformation(extent={{-86,60},{-46,100}}),
        iconTransformation(extent={{-72,60},{-32,100}})));
  Modelica.Blocks.Interfaces.RealInput Theta
    annotation (Placement(transformation(extent={{-88,20},{-48,60}}),
        iconTransformation(extent={{-72,10},{-32,50}})));
  Modelica.Blocks.Interfaces.RealInput Tamb
    annotation (Placement(transformation(extent={{-90,-6},{-50,34}}),
        iconTransformation(extent={{-72,-38},{-32,2}})));
  Modelica.Blocks.Interfaces.RealInput DNI
    annotation (Placement(transformation(extent={{-86,-46},{-46,-6}}),
        iconTransformation(extent={{-72,-94},{-32,-54}})));
  Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));
  Interfaces.Fluid.FlangeB OutFlow( redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-10,80},{10,100}}),
        iconTransformation(extent={{-10,92},{10,112}})));
equation
  connect(OutFlow, SolarTube.OutFlow) annotation (Line(
      points={{0,90},{46.79,90},{46.79,48}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(InFlow, SolarTube.InFlow) annotation (Line(
      points={{0,-90},{47,-90},{47,-6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(absorberSchott.wall_int, SolarTube.Wall_int) annotation (Line(
      points={{18.5,19},{23.5,19},{23.5,21},{36.5,21}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Theta, absorberSchott.Theta) annotation (Line(
      points={{-68,40},{-52,40},{-52,38},{-42,38},{-42,23.95},{-8.65,23.95}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(v_wind, absorberSchott.v_wind) annotation (Line(
      points={{-66,80},{-50,80},{-50,78},{-36,78},{-36,31.75},{-8.35,31.75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DNI, absorberSchott.DNI) annotation (Line(
      points={{-66,-26},{-50,-26},{-50,-10},{-32,-10},{-32,8.65},{-8.65,
          8.65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tamb, absorberSchott.Tamb) annotation (Line(
      points={{-70,14},{-40,14},{-40,16},{-8.8,16}},
      color={0,0,127},
      smooth=Smooth.None));
                                                                                                      annotation (Dialog(group="Heat transfer", tab="General"),
              Diagram(coordinateSystem(extent={{-60,-100},{60,100}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-60,-100},{
            60,100}},
          preserveAspectRatio=true),  graphics={Rectangle(
          extent={{-60,100},{60,-100}},
          lineColor={0,0,0},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid), Text(
          extent={{-32,60},{40,-44}},
          lineColor={0,0,0},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          textString="Schott-
Inc")}));
end SolarCollectorIncSchott_1808;
