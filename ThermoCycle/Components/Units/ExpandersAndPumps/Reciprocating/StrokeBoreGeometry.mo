within ThermoCycle.Components.Units.ExpandersAndPumps.Reciprocating;
record StrokeBoreGeometry "Geometry defined by stroke and bore"
  extends BaseClasses.SimpleGeometry(
    l_conrod=0.15,
    stroke=0.10,
    bore=0.06,
    V_tdc=40e-6);
end StrokeBoreGeometry;
