within ThermoCycle.Media.Incompressible;
package TableBased
  import Poly = Modelica.Media.Incompressible.TableBased.Polynomials_Temp;

extends Modelica.Media.Incompressible.TableBased;
// equation
//
//   drdh := density_derh_p(T);
//   state.T = T;

 redeclare function extends density_derh_p
    "returns derivative of density wrt enthalpy"

 algorithm
    ddhp := Poly.derivativeValue(poly_rho, if TinK then state.T else
      Modelica.SIunits.Conversions.to_degC(state.T))*(1/(Poly.evaluate(
      poly_Cp, if TinK then state.T else
      Modelica.SIunits.Conversions.to_degC(state.T)) + Poly.derivativeValue(
       poly_Cp, if TinK then state.T else
      Modelica.SIunits.Conversions.to_degC(state.T))*(state.T - T0)));
 end density_derh_p;

end TableBased;
