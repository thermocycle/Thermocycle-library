within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating;
record StrokeBoreGeometry "Geometry defined by stroke and bore"
  extends BaseClasses.SimpleGeometry(
    l_conrod=0.15,
    stroke=0.10,
    bore=0.06,
    V_tdc=40e-6,
    d_inlet=0.05,
    d_outlet=0.05,
    zeta_inout=0.0005,
    d_leak=0.00005,
    zeta_leak=0.5);
end StrokeBoreGeometry;
