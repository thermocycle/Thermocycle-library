within ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.Geometry.Schott_SopoNova;
record BaseGeometry
/*****************General Geometries**************************/
constant Real pi = Modelica.Constants.pi;
parameter Modelica.SIunits.Length L= 4.06 "length of tubes";
parameter Modelica.SIunits.Length A_P=5 "Aperture of the parabola";

/******************** Geometries&Properties of the tube  *******************************/
parameter Modelica.SIunits.Length Dext_t = 0.07 "External diameter tube" annotation (Dialog(group="GeometriesAndProperties of the glass envelope", tab="General"));
parameter Modelica.SIunits.Length th_t = 0.004 "tube thickness" annotation (Dialog(group="GeometriesAndProperties of the glass envelope", tab="General"));

final parameter Modelica.SIunits.Area  A_reflector = L*A_P
    "Total areo of the reflector";
final parameter Modelica.SIunits.Length rext_t = Dext_t/2
    " External Radius Glass" annotation (Dialog(group="GeometriesAndProperties of the glass envelope", tab="General"));
final parameter Modelica.SIunits.Length rint_t= rext_t-th_t
    "Internal Radius Glass" annotation (Dialog(group="GeometriesAndProperties of the glass envelope", tab="General"));
final parameter Modelica.SIunits.Area Am_t = (rext_t^2 - rint_t^2)*pi
    "Area of the metal cross section";
final parameter Modelica.SIunits.Length D_int_t= Dext_t - 2*th_t
    "internal diameter of the metal tube";
final parameter Modelica.SIunits.Area A_int_t= L*D_int_t*pi
    "Lateral internal surface of the metal tube";
final parameter Modelica.SIunits.Volume V_tube_int = pi*D_int_t^2/4*L
    "Internal volume of the metal tube";

/***************** Optical parameters *****************/
parameter Real rho_cl = 0.89 "Mirror reflectivity";
parameter Real Alpha_t=0.97 "Tube Absorptivity";
parameter Real tau_g=0.91 "Glass transmissivity: from Soponova data sheet";

/******************** Parameters for longitudinal incidence angle modifier  *******************************/
parameter Real A0 = 4.05;
parameter Real A1 = 0.247;
parameter Real A2 = -0.00146;
parameter Real A3 = 5.65E-6;
parameter Real A4 = 7.62E-8;
parameter Real A5 = -1.7;
parameter Real A6 = 0.0125;

end BaseGeometry;
