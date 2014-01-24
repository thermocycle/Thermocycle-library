within ThermoCycle.Interfaces.HeatTransfer;
model ThermalPortMultiplier "Convert single thermal port into one multi-port"
  parameter Integer N = 10;
  ThermoCycle.Interfaces.HeatTransfer.ThermalPort multi(final N=N)
    annotation (Placement(transformation(extent={{-36,28},{36,42}})));
  ThermoCycle.Interfaces.HeatTransfer.ThermalPortL single
     annotation (Placement(transformation(extent={{-36,-48},{36,-34}})));
equation
  //single.T = sum(multi.T[])/N;
  single.phi = sum(-multi.phi);

  for i in 1:N loop
    single.T = multi.T[i];
    //single.phi = -multi.phi[i];
  end for;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Text(
          extent={{-34,-20},{34,-34}},
          lineColor={0,0,255},
          textString="Single"), Text(
          extent={{-34,26},{34,12}},
          lineColor={0,0,255},
          textString="Multi")}));
end ThermalPortMultiplier;
