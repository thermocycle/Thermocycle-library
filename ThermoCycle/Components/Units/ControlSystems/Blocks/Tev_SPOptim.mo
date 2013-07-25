within ThermoCycle.Components.Units.ControlSystems.Blocks;
model Tev_SPOptim
 // Calculate the superheating with the temperature and the pressure as inputs
Modelica.Blocks.Interfaces.RealInput p_cd "measured pressure" annotation (Placement(transformation(extent={{-112,54},
            {-88,78}},                                                                                                    rotation=0),
        iconTransformation(extent={{-112,54},{-88,78}})));
Modelica.Blocks.Interfaces.RealInput Mdot "measured"
                                                   annotation (Placement(transformation(extent={{-112,
            -54},{-88,-30}},                                                                                                  rotation=0)));
Modelica.Blocks.Interfaces.RealOutput Tev    annotation (Placement(
        transformation(extent={{92,-2},{130,36}}),  iconTransformation(extent={{96,2},{
            116,22}})));
Modelica.Blocks.Interfaces.RealInput T_hf_su "measured pressure"
                                                              annotation (Placement(transformation(extent={{-112,6},
            {-88,30}},                                                                                                    rotation=0),
        iconTransformation(extent={{-112,0},{-88,24}})));
equation
Tev=273.15+7.75856713E+01+4.93382415E-05*p_cd+2.38081717E+01*log(Mdot)+7.65402193E+00*log(T_hf_su-273.15);
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics={Rectangle(
          extent={{-98,90},{102,-78}},
          lineColor={0,0,0},
          lineThickness=0.5), Text(
          extent={{-76,50},{92,-32}},
          lineColor={0,0,0},
          textString="Tev_SP      ")}));
end Tev_SPOptim;
