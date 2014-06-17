within ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer;
model Annand1963 "Recip ICE correlation of Annand 1963"
  extends
    ThermoCycle.Components.Units.ExpansionAndCompressionMachines.Reciprocating.HeatTransfer.RePrHeatTransfer(
    final a=0.575,
    final b=0.700,
    final c=0.000);

equation
  for i in 1:n loop
    Lambda[i] = c_m;
    Gamma[i]  = bore;
  end for;

  annotation(Documentation(info="<html>
<body>
<h4>Reference: </h4>
<dl>
<dt><a name=\"Annand1963\">(Annand1963)</a></dt>
<dd>Annand, W.</dd>
<dd><i>Heat transfer in cylinders of reciprocating internal combustion engines</i></dd>
<dd>Proceedings of the Institution of Mechanical Engineers, <b>1963</b>, Vol. 177(36), pp. 973-996</dd>
</dl>
<h4>Implementation: </h4>
<p>2013 for Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark by Jorrit Wronski (jowr@mek.dtu.dk) </p>
</body>
</html>
"));
end Annand1963;
