within ThermoCycle.Components.FluidFlow.Sensors;
model SensTp "Temperature sensor for working fluid"
  extends ThermoCycle.Icons.Water.SensThrough;
replaceable package Medium = ThermoCycle.Media.DummyFluid
                                          constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium Model" annotation (choicesAllMatching = true);

 /********************* CONNECTORS *********************/
  Modelica.Blocks.Interfaces.RealOutput T annotation (Placement(
        transformation(extent={{60,46},{100,86}}, rotation=0),
        iconTransformation(extent={{60,46},{100,86}})));

  Modelica.Blocks.Interfaces.RealOutput p annotation (Placement(
        transformation(extent={{-60,40},{-100,80}}, rotation=0)));

  Interfaces.Fluid.FlangeA InFlow( redeclare package Medium = Medium, m_flow(min= 0))
    annotation (Placement(transformation(extent={{-80,-58},{-60,-38}})));
  Interfaces.Fluid.FlangeB OutFlow(redeclare package Medium = Medium, m_flow(min= 0))
    annotation (Placement(transformation(extent={{60,-58},{80,-38}})));

Modelica.Blocks.Interfaces.RealOutput Tsat annotation (Placement(
        transformation(extent={{60,4},{100,44}},  rotation=0),
        iconTransformation(extent={{60,4},{100,44}})));

parameter Boolean ComputeSat=false
    "Can be disabled if There is no need to calculate the saturation properties";

/********************* VARIABLES *********************/
//Medium.SaturationProperties  sat_in(ddldp=0,ddvdp=0,dhldp=0,dhvdp=0,dTp=0,hl=0,hv=1E5,sigma=0,sl=0,sv=0,dl=0,dv=0,psat=0,Tsat=300);
Real[14] sat_in= {0,0,0,0,0,0,1E5,0,0,0,0,0,0,300};
Modelica.SIunits.SpecificEnthalpy h "Specific Enthalpy of the fluid";
Medium.ThermodynamicState fluidState "Thermodynamic state of the fluid";
Medium.SaturationProperties sat "Saturation state";

equation
  //Saturation
  if ComputeSat then
    sat = Medium.setSat_p(p);
  else
    sat.ddldp = sat_in[1];
    sat.ddvdp = sat_in[2];
    sat.dhldp = sat_in[3];
    sat.dhvdp = sat_in[4];
    sat.dTp = sat_in[5];
    sat.hl = sat_in[6];
    sat.hv = sat_in[7];
    sat.sigma = sat_in[8];
    sat.sl = sat_in[9];
    sat.sv = sat_in[10];
    sat.dl = sat_in[11];
    sat.dv = sat_in[12];
    sat.psat = sat_in[13];
    sat.Tsat = sat_in[14];
  end if;

  // Set fluid properties
  h = actualStream(InFlow.h_outflow);
  fluidState = Medium.setState_ph(InFlow.p,h);
  T = Medium.temperature(fluidState);
  InFlow.p =p;
  Tsat = sat.Tsat;

  InFlow.m_flow + OutFlow.m_flow = 0 "Mass balance";
  InFlow.p = OutFlow.p "No pressure drop";
  // Boundary conditions
  InFlow.h_outflow = inStream(OutFlow.h_outflow);
  inStream(InFlow.h_outflow) = OutFlow.h_outflow;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}),     graphics),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
                    graphics={Text(
          extent={{-40,84},{38,34}},
          lineColor={0,0,0},
          textString="p,T"), Line(points={{-60,60},{-40,60}}),
        Text(
          extent={{64,8},{108,-14}},
          lineColor={0,0,255},
          textString="Tsat")}),
    Documentation(info="<HTML>
<p><big> Model <b>SensTp</b> represents an temperature and pressure sensor.
<p><b><big>Modelling options</b></p>
<p><big> <li> ComputeSat: if false saturation properties are not computed in the fluid model and they can be passed as a parameter.
</html>"));
end SensTp;
