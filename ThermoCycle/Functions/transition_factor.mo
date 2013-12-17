within ThermoCycle.Functions;
function transition_factor
  "Get weighting factor for smooth transition (from 0 to 1)"
  extends Modelica.Icons.Function;
  import Modelica.Constants.pi;
  import Modelica.Constants.e;

  input Real start =    0.25 "start of transition interval";
  input Real stop =     0.75 "end of transition interval";
  input Real position = 0.0 "current position";
  input Integer order = 2 "Smooth up to which derivative?";

  output Real tFactor "weighting factor";

protected
  Real[4] a_map = {-1/2, -2/pi, -3/4, -8/pi} "First parameters";
  Real[4] b_map = {1/2,   1/2,   1/2,  1/2} "Second parameters";

  // Rename variables to match with Richter2008, p.68ff
  Real phi "current phase";
  Real a "multiplier";
  Real b "addition";
  Real x_t "Start of transition";
  Real x "Current position";
  Real DELTAx "Length of transition";

  // Parameters for generalised logistic function
  Real A = 0 "Lower asymptote";
  Real K = 1 "Upper asymptote";
  Real B = 8 "Growth rate";
  Real nu= 1 "Symmetry changes";
  Real Q = nu "Zero correction";
  Real M = nu "Maximum growth for Q = nu";
  Real X = 0;
  Real END =     0;
  Real START =   0;
  Real factor =  0;

algorithm
  assert(order>=0, "This function only supports positive values for the order of smooth derivatives.");
  assert(start<stop, "There is only support for positive differences, please provide start < stop.");

  // 0th to 2nd order
  a      := a_map[order+1];
  b      := b_map[order+1];
  x      := position;
  DELTAx := stop - start;
  x_t    := start + 0.5*DELTAx;
  phi    := (x - x_t) / DELTAx * pi;

  // higher order
  // We need to do some arbitrary scaling:
  END   :=  4.0;
  START := -2.0;
  factor := (END-START) / (stop-start);
  X := START + (position - start) * factor;

  tFactor := 1-smooth(5,noEvent(
  if position < start then
    1
  elseif position > stop then
    0
  else
    if (order == 0) then
      a                      * sin(phi)                                         + b
    elseif (order == 1) then
      a * ( 1/2 * cos(phi)   * sin(phi) + 1/2*phi)                              + b
    elseif (order == 2) then
      a * ( 1/3 * cos(phi)^2 * sin(phi) + 2/3 * sin(phi))                       + b
    else
      1 - (A + ( K-A)  / ( 1 + Q * e^(-B*(X - M)))^(1/nu))));
//     elseif (order == 3) then
//       a * ( 1/4 * cos(phi)^3 * sin(phi) + 3/8 * cos(phi) * sin(phi) + 3/8*phi)  + b

  annotation (smoothOrder=5,Documentation(info="<html>
<p><h4><font color=\"#008000\">DESCRIPTION:</font></h4></p>
<p>This function returns a value between 1 and 0. A smooth transition is achieved by means of defining the <code>position</code> and the transition intervall from <code>start</code> to <code>stop</code> parameter. Outside this intervall, the 1 and the 0 are returned, respectively. This transition function with up to two smooth derivatives was taken from [1]. If you provide an <code>order</code> higher than 2, the generalised logistic function[2] will be used to calculated the transition curve.</p>
<p><h4><font color=\"#008000\">OUTPUT:</font></h4></p>
<p><code>tFactor</code> = smooth transition between 0 and 1 from <code>start</code> to <code>stop</code> [-]</p>
<p>Use <code>tFactor</code> in an equation like this: </p>
<pre>tFactor&nbsp;=&nbsp;transition_factor(start=start,stop=stop,position=position);
smoothed = tFactor*1stValue&nbsp;+&nbsp;(1&nbsp;-&nbsp;tFactor)*2ndValue;</pre>
<p><h4><font color=\"#008000\">REFERENCES:</font></h4></p>
<p>[1] Christoph C Richter, Proposal of New Object-Oriented Equation-Based Model Libraries for Thermodynamic Systems, PhD thesis, Technical University Carolo-Wilhelmina Braunschweig, 2008 </p>
<p>[2] Generalised logistic function on <a href=\"http://en.wikipedia.org/wiki/Generalised_logistic_function\">Wikipedia</a></p>
<p><h4><font color=\"#008000\">IMPLEMENTATION:</font></h4></p>
<p>Implemented in 2012 for Technical University of Denmark, DTU Mechanical Engineering, Kongens Lyngby, Denmark by Jorrit Wronski (jowr@mek.dtu.dk)</p>
</html>", revisions=""));
end transition_factor;
