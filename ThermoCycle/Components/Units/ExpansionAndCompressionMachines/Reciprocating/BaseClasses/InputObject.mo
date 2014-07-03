within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses;
record InputObject "A base object for the mechanical design"
  extends Modelica.Icons.Record;

  parameter Integer kind = 1 "Type"
    annotation (Evaluate=true,Dialog(group="Geometry"),
      choices(choice=1 "Filled cylinder", choice=2 "Squared block"));
  parameter Modelica.SIunits.Length height(displayUnit="mm") "Height of object"
    annotation (Dialog(group="Geometry",enable = true));
  parameter Modelica.SIunits.Length width(displayUnit="mm") = 0.1*height
    "Width of object"
    annotation (Dialog(group="Geometry",enable = (kind==1)));
  parameter Modelica.SIunits.Length radius(displayUnit="mm") = 0.05*height
    "Radius of object"
    annotation (Dialog(group="Geometry",enable = (kind==2)));

  parameter Boolean use_dens = true "Enable density input"
    annotation (Evaluate=true,Dialog(group="Mass"));
  parameter Modelica.SIunits.Density dens = 0 "Material density"
    annotation (Evaluate=true,Dialog(group="Mass",enable = use_dens),
      choices(
        choice=7700 "Steel (7700 kg/m3)",
        choice=2700 "Aluminium (2700 kg/m3)",
        choice=Modelica.Constants.small "Custom input"));

  parameter Modelica.SIunits.Mass mass=if (kind==1) then
      dens*Modelica.Constants.pi*height*radius*radius
    else
      dens*height*width*width
    annotation (Evaluate=true,Dialog(group="Mass",enable = not use_dens));

  final parameter Modelica.SIunits.Density rho = if (kind==1) then mass/Modelica.Constants.pi/height/radius/radius else
      mass/height/width/width;

end InputObject;
