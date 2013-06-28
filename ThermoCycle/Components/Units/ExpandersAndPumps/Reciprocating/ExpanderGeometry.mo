within ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating;
record ExpanderGeometry =
    ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating.BaseClasses.BaseGeometry
    (
    l_conrod=0.15,
    d_ppin=0.001,
    r_crank=0.05,
    r_piston=0.05,
    V_tdc=50e-6,
    h_piston=0.05) "Small scale ORC expander";
