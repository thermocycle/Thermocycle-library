within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating;
model RecipMachine_Flange "Model of single cylinder with a flange connector"
  extends
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.PartialRecipMachine;
public
  Modelica.Mechanics.Translational.Interfaces.Flange_a flange_a
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
equation
  connect(flange_a, slider.axis) annotation (Line(
      points={{0,180},{0,180},{0,168},{40,168},{40,123},{9,123}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-180,-180},
            {180,180}}), graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-180,-180},{180,180}}), graphics));
end RecipMachine_Flange;
