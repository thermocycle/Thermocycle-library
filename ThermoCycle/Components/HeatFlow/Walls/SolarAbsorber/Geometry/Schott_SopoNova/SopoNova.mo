within ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.Geometry.Schott_SopoNova;
record SopoNova "MicroCSP collector based on Soponova Sopogy data sheet"
extends
    ThermoCycle.Components.HeatFlow.Walls.SolarAbsorber.Geometry.Schott_SopoNova.BaseGeometry(
     L= 3.657,
    A_P=1.425,
    Dext_t = 0.0254,
    th_t = 0.001055,
    rho_cl = 0.89,
    Alpha_t=0.95,
    tau_g=0.91,
    A0 = 11.8,
 A1 = 1.35,
 A2 = 7.50E-04,
 A3 = 4.07E-06,
  A4 = 5.85E-08,
A5 =  -4.48,
 A6 = 0.285);

end SopoNova;
