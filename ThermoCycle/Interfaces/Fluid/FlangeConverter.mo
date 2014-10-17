within ThermoCycle.Interfaces.Fluid;
model FlangeConverter
  "Flange state variables converter from ph to pT and vice versa"
replaceable package Medium = ThermoCycle.Media.DummyFluid  constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model" annotation (choicesAllMatching = true);
  ThermoCycle.Interfaces.Fluid.Flange flange_ph(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}}),
        iconTransformation(extent={{-56,-6},{-46,4}})));
 ThermoCycle.Interfaces.Fluid.Flange_pT flange_pT(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{40,-10},{60,10}}),
        iconTransformation(extent={{44,-6},{54,4}})));

equation
  flange_ph.m_flow = -flange_pT.m_flow;
  flange_ph.p = flange_pT.p;
  flange_ph.Xi_outflow = flange_pT.Xi_outflow;
  flange_ph.C_outflow = flange_pT.C_outflow;
  flange_pT.T_outflow = Medium.temperature(Medium.setState_ph(flange_ph.p,inStream(flange_ph.h_outflow)));
  flange_ph.h_outflow = Medium.specificEnthalpy(Medium.setState_pT(flange_pT.p,inStream(flange_pT.T_outflow)));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,40},{100,-40}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{29,20},{69,-20}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,127,0}),
        Rectangle(
          extent={{-71,20},{-31,-20}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
                     Text(extent={{-80,66},{-22,24}},
          textString="ph",
          lineColor={0,0,0}),
                     Text(extent={{20,66},{78,24}},
          lineColor={0,0,0},
          textString="pT")}));
end FlangeConverter;
