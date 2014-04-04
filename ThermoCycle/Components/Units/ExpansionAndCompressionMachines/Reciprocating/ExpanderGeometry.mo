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
    r_crankshaft=0.02,
    m_conrod=0.35,
    m_crankshaft=0.3,
    m_crank=0.1,
    m_piston=0.35,
    d_inlet=0.05,
    d_outlet=0.05,
    zeta_inout=0.0005,
    d_leak=0.00005,
    zeta_leak=0.5) "Small scale ORC expander";
