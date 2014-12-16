within ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.Geometry.Soltigua;
record BaseGeometry
/*****************General Geometries**************************/
constant Real pi = Modelica.Constants.pi;
parameter Modelica.SIunits.Area S_net=41 "Net Collecting Surface";
parameter Modelica.SIunits.Length A_P=2.37 "Aperture of the parabola";
parameter Modelica.SIunits.Length Dext_t=0.0424 "External diameter tube";
parameter Modelica.SIunits.Length th_t = 0.002 "tube thickness";

final parameter Modelica.SIunits.Length L=S_net/A_P "length of tubes";
final parameter Modelica.SIunits.Area A_ext_t=pi*Dext_t*L
    "Lateral external area of the tube";
final parameter Modelica.SIunits.Area S_ext_t=Dext_t*L
    "target surface of incoming radiation from the sun (Cross section without concentration)";
final parameter Modelica.SIunits.Length D_int_t= Dext_t - 2*th_t
    "internal diameter of the metal tube";
final parameter Modelica.SIunits.Area A_int_t= L*D_int_t*pi
    "Lateral internal surface of the metal tube";
final parameter Modelica.SIunits.Volume V_tube_int = pi*D_int_t^2/4*L
    "Internal volume of the metal tube";
/******************** Parameters for longitudinal incidence angle modifier  *******************************/
parameter Real A_0 = 1;
parameter Real A_1 = 5.00396825E-04;
parameter Real A_2 = -1.65000000E-04;
parameter Real A_3 = -2-6.94444444E-07;

end BaseGeometry;
