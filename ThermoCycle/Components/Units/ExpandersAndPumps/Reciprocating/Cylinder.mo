within ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating;
model Cylinder
  "SweptVolume from Modelica.Fluid with initialisation algorihtm and default Medium"
  extends Modelica.Fluid.Machines.SweptVolume(final clearance=0,HeatTransfer(crankshaftAngle=angle_in_internal,pistonCrossArea = pistonCrossArea));
  parameter Boolean use_angle_in = false
    "Enable input connector for crankshaft angle"
    annotation (Dialog(tab="Assumptions", group="Heat transfer"));
//     parameter Real stroke = 0
//     "Assume a sine-like piston movement"
//     annotation (Evaluate = true,
//                 Dialog(tab="Assumptions", group="Heat transfer",enable = not use_angle_in));
  Modelica.Blocks.Interfaces.RealInput angle_in if use_angle_in annotation (Placement(
        transformation(extent={{120,-20},{80,20}}), iconTransformation(extent={{
            120,-20},{80,20}})));
protected
    Modelica.Blocks.Interfaces.RealInput angle_in_internal;
initial algorithm
//   if use_T_start then
//   medium.state :=Medium.setState_pTX(
//       p_start,
//       T_start,
//       X_start);
//   else
//     medium.state :=Medium.setState_phX(
//       p_start,
//       h_start,
//       X_start);
//   end if;
  m := medium.d*V;
  U := m*(medium.h - p_start / medium.d);
// equation
//   test = heatTransfer(crankshaftAngle=5);
equation
    connect(angle_in, angle_in_internal);
  if noEvent(not use_angle_in) then
    angle_in_internal = 0;
  end if;
  annotation (Icon(graphics), Diagram(graphics));
end Cylinder;
