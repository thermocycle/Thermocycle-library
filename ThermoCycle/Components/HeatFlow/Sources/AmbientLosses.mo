within ThermoCycle.Components.HeatFlow.Sources;
model AmbientLosses

parameter Integer N = 1;
parameter Modelica.SIunits.CoefficientOfHeatTransfer Uloss = 100;
Modelica.SIunits.HeatFlux Phi_loss[N];
Modelica.SIunits.Temperature T[N];

  Modelica.Blocks.Interfaces.RealInput T_input annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,72}), iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=-90,
        origin={-3,95})));
  ThermoCycle.Interfaces.HeatTransfer.ThermalPort ThermalPort_ext(final N=N) annotation (Placement(transformation(extent={{-10,
            -106},{10,-86}}), iconTransformation(extent={{-10,-106},{10,-86}})));

equation
  for i in 1:N loop
    T[i] = ThermalPort_ext.T[i];
    Phi_loss[i] = if (T_input < 0) then 0 else Uloss*(T[i]-T_input);
    ThermalPort_ext.phi[i] = Phi_loss[i];
  end for;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                         Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-56,54},{72,-52}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="AmbientLosses")}));
end AmbientLosses;
