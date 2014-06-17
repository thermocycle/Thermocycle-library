within ThermoCycle.Components.Units.ExpansionAndCompressionMachines;
model ElectricDrive
  "Motor/Generator model with prescribed rotational speed (Active power only)"
  import Modelica.SIunits.Conversions.NonSIunits.*;
  parameter Real eta=1 "Conversion efficiency";
  parameter Modelica.SIunits.MomentOfInertia J=0 "Moment of inertia";
  parameter Integer Np=2 "Number of electrical poles";
  parameter Modelica.SIunits.Frequency fstart=50
    "Start value of the electrical frequency"
    annotation (Dialog(tab="Initialization"));
  Modelica.SIunits.Power Pe "Electrical Power";
protected
  Modelica.SIunits.Power Pm "Mechanical power";
  Modelica.SIunits.Power Ploss "Inertial power Loss";
  Modelica.SIunits.Torque tau "Torque at shaft";
  Modelica.SIunits.AngularVelocity omega_m(start=2*Modelica.Constants.pi*
        fstart/Np) "Angular velocity of the shaft [rad/s] ";
  Modelica.SIunits.AngularVelocity omega_e
    "Angular velocity of the e.m.f. rotating frame [rad/s]";
  AngularVelocity_rpm n "Rotational speed [rpm]";
public
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation (
      Placement(transformation(extent={{-100,-14},{-72,14}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput f(start=50) "Electrical frequency"
    annotation (Placement(transformation(
        extent={{16,16},{-16,-16}},
        rotation=90,
        origin={4,94})));
equation
  omega_m = der(shaft.phi) "Mechanical boundary condition";
  omega_e = omega_m*Np;
  f = omega_e/(2*Modelica.Constants.pi) "Electrical frequency";
  n = Modelica.SIunits.Conversions.to_rpm(omega_m) "Rotational speed in rpm";
  Pm = omega_m*tau;
  if J > 0 then
    Ploss = J*der(omega_m)*omega_m;
  else
    Ploss = 0;
  end if annotation (Diagram);
  Pm = Pe/eta + Ploss "Energy balance";
  tau = shaft.tau;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-72,6},{-48,-8}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={160,160,164}),
        Ellipse(
          extent={{50,-50},{-50,50}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-34,18},{0,-18}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          lineThickness=0.5),
        Ellipse(
          extent={{0,20},{34,-16}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          lineThickness=0.5),
        Rectangle(
          extent={{-36,0},{0,-30}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,26},{34,4}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{34,20},{38,2}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(extent={{-100,-50},{100,-84}}, textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics),
    Documentation(info="<html>
<p>This model describes the conversion between mechanical power and electrical power in an ideal synchronous generator. 
The frequency in the electrical connector is the e.m.f. of generator.
<p>It is possible to consider the generator inertia in the model, by setting the parameter <tt>J > 0</tt>. 
</html>"));
end ElectricDrive;
