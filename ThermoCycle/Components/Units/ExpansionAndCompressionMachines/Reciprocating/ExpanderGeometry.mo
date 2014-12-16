within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating;
record ExpanderGeometry =
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.BaseGeometry
    (
    conrod(height=0.15),
    d_ppin=0.001,
    crankArm(height=0.05),
    piston(radius=0.05,height=0.05),
    V_tdc=50e-6,
    d_inlet=0.05,
    d_outlet=0.05,
    zeta_inout=0.0005,
    d_leak=0.00005,
    zeta_leak=0.5,
    crankShaft(height=0.2)) "Small scale ORC expander";
