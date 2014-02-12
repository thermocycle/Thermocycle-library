within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating;
record ExpanderGeometry =
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.BaseClasses.BaseGeometry
    (
    l_conrod=0.15,
    d_ppin=0.001,
    r_crank=0.05,
    r_piston=0.05,
    V_tdc=50e-6,
    h_piston=0.05,
    d_inlet=0.01,
    d_outlet=0.03) "Small scale ORC expander";
