within ExternalMedia.Media;
partial package IncompressibleCoolPropMedium
  "External incompressible medium with up to two components using CoolProp"
  extends Modelica.Media.Interfaces.PartialMedium(
    mediumName =  "ExternalMedium",
    singleState = true,
    reducedX =    true);
  import ExternalMedia.Common.InputChoiceIncompressible;
  constant String libraryName = "CoolProp"
    "Name of the external fluid property computation library";
  constant String substanceName = ExternalMedia.Common.CheckCoolPropOptions(substanceNames[1],debug=false)
    "Only one substance can be specified, predefined mixture in CoolProp";
  redeclare record extends FluidConstants "external fluid constants"
    MolarMass molarMass "molecular mass";
    Temperature criticalTemperature "critical temperature";
    AbsolutePressure criticalPressure "critical pressure";
    MolarVolume criticalMolarVolume "critical molar Volume";
  end FluidConstants;
  constant InputChoiceIncompressible inputChoice=InputChoiceIncompressible.pTX
    "Default choice of input variables for property computations, incompressibles are in p,T";
  redeclare replaceable record ThermodynamicState =
  ExternalMedia.Media.BaseClasses.ExternalTwoPhaseMedium.ThermodynamicState;

  redeclare replaceable model extends BaseProperties(
    p(stateSelect = if preferredMediumStates and
                       (basePropertiesInputChoice == InputChoiceIncompressible.phX or
                        basePropertiesInputChoice == InputChoiceIncompressible.pTX or
                        basePropertiesInputChoice == InputChoiceIncompressible.ph or
                        basePropertiesInputChoice == InputChoiceIncompressible.pT) then
                            StateSelect.prefer else StateSelect.default),
    T(stateSelect = if preferredMediumStates and
                       (basePropertiesInputChoice == InputChoiceIncompressible.pTX or
                        basePropertiesInputChoice == InputChoiceIncompressible.pT) then
                         StateSelect.prefer else StateSelect.default),
    h(stateSelect = if preferredMediumStates and
                       (basePropertiesInputChoice == InputChoiceIncompressible.phX or
                        basePropertiesInputChoice == InputChoiceIncompressible.ph) then
                         StateSelect.prefer else StateSelect.default))
    import ExternalMedia.Common.InputChoiceIncompressible;
    parameter InputChoiceIncompressible basePropertiesInputChoice=inputChoice
      "Choice of input variables for property computations";
    Integer phaseInput
      "Phase input for property computation functions, 2 for two-phase, 1 for one-phase, 0 if not known";
    Integer phaseOutput
      "Phase output for medium, 2 for two-phase, 1 for one-phase";
    SpecificEntropy s "Specific entropy";
    //SaturationProperties sat "saturation property record";
  equation
    phaseInput = 1 "Force one-phase property computation";
    R  = Modelica.Constants.small "Gas constant (of mixture if applicable)";
    MM = 0.001 "Molar mass (of mixture or single fluid)";
    if (basePropertiesInputChoice == InputChoiceIncompressible.phX or
        basePropertiesInputChoice == InputChoiceIncompressible.ph) then
      state = setState_phX(p, h, Xi, phaseInput);
      d = density_phX(p, h, Xi, phaseInput);
      s = specificEntropy_phX(p, h, Xi, phaseInput);
      T = temperature_phX(p, h, Xi, phaseInput);
    elseif (basePropertiesInputChoice == InputChoiceIncompressible.pTX or
            basePropertiesInputChoice == InputChoiceIncompressible.pT) then
      state = setState_pTX(p, T, Xi, phaseInput);
      d = density_pTX(p, T, Xi, phaseInput);
      h = specificEnthalpy_pTX(p, T, Xi, phaseInput);
      s = specificEntropy_pTX(p, T, Xi, phaseInput);
    end if;
    // Compute the internal energy
    u = h - p/d;
    // Compute the saturation properties record
    //sat = setSat_p_state(state);
    // No phase boundary crossing
    phaseOutput = 1;
  end BaseProperties;

  replaceable function setState_ph
    "Return thermodynamic state record from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "pressure";
    input SpecificEnthalpy h "specific enthalpy";
    input Integer phase = 1 "2 for two-phase, 1 for one-phase, 0 if not known";
    output ThermodynamicState state;
  protected
    String name;
  algorithm
  state := setState_ph_library(p, h, phase, substanceName);
  end setState_ph;

  redeclare replaceable function setState_phX
    "Return thermodynamic state record from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "pressure";
    input SpecificEnthalpy h "specific enthalpy";
    input MassFraction X[nX] "Mass fractions";
    input Integer phase = 1 "2 for two-phase, 1 for one-phase, 0 if not known";
    output ThermodynamicState state;
  protected
    String name;
  algorithm
  name := ExternalMedia.Common.XtoName(substanceName,X);
  state := setState_ph_library(p, h, phase, name);
  end setState_phX;

  function setState_ph_library "Return thermodynamic state record from p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "pressure";
    input SpecificEnthalpy h "specific enthalpy";
    input Integer phase = 1 "2 for two-phase, 1 for one-phase, 0 if not known";
    input String name "name and mass fractions";
    output ThermodynamicState state;
  external "C" TwoPhaseMedium_setState_ph_C_impl(p, h, phase, state, mediumName, libraryName, name)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
  end setState_ph_library;

  replaceable function setState_pT
    "Return thermodynamic state record from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "pressure";
    input Temperature T "temperature";
    input Integer phase = 1 "2 for two-phase, 1 for one-phase, 0 if not known";
    output ThermodynamicState state;
  protected
    String name;
  algorithm
  state := setState_pT_library(p, T, phase, substanceName);
  end setState_pT;

  redeclare replaceable function setState_pTX
    "Return thermodynamic state record from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "pressure";
    input Temperature T "temperature";
    input MassFraction X[:] "Mass fractions";
    input Integer phase = 1 "2 for two-phase, 1 for one-phase, 0 if not known";
    output ThermodynamicState state;
  protected
    String name;
  algorithm
  name := ExternalMedia.Common.XtoName(substanceName,X);
  state := setState_pT_library(p, T, phase, name);
  end setState_pTX;

  function setState_pT_library "Return thermodynamic state record from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "pressure";
    input Temperature T "temperature";
    input Integer phase = 1 "2 for two-phase, 1 for one-phase, 0 if not known";
    input String name "name and mass fractions";
    output ThermodynamicState state;
  external "C" TwoPhaseMedium_setState_pT_C_impl(p, T, state, mediumName, libraryName, name)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
  end setState_pT_library;

  redeclare replaceable function setState_psX
    "Return thermodynamic state record from p and s"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "pressure";
    input SpecificEntropy s "specific entropy";
    input MassFraction X[nX] "Mass fractions";
    input Integer phase = 1 "2 for two-phase, 1 for one-phase, 0 if not known";
    output ThermodynamicState state;
  protected
    String in1 = ExternalMedia.Common.XtoName(substanceName,X);
    //assert(false, "Incompressibles only support pT and ph as inputs!", level=AssertionLevel.error);
  external "C" TwoPhaseMedium_setState_ps_C_impl(p, s, phase, state, mediumName, libraryName, in1)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
  end setState_psX;

  redeclare function density_phX "returns density for given p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Enthalpy";
    input MassFraction X[nX] "Mass fractions";
    input Integer phase=1 "2 for two-phase, 1 for one-phase, 0 if not known";
  //input ThermodynamicState state;
    output Density d "density";
  algorithm
    d := density_phX_state(p=p, h=h, X=X, state=setState_phX(p=p, h=h, X=X, phase=phase));
  annotation (
    Inline=true);
  end density_phX;

  function density_phX_state "returns density for given p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Enthalpy";
    input MassFraction X[nX] "Mass fractions";
    input ThermodynamicState state;
    output Density d "density";
  algorithm
    d := density(state);
  annotation (
    Inline=false,
    LateInline=true,
    derivative(noDerivative=state,noDerivative=X)=density_phX_der);
  end density_phX_state;

  replaceable function density_phX_der "Total derivative of density_ph"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[nX] "Mass fractions";
    input ThermodynamicState state;
    input Real p_der "time derivative of pressure";
    input Real h_der "time derivative of specific enthalpy";
    output Real d_der "time derivative of density";
  algorithm
    d_der := p_der*density_derp_h(state=state)
           + h_der*density_derh_p(state=state);
  annotation (Inline=true);
  end density_phX_der;

  redeclare replaceable function extends density_derh_p
    "Return derivative of density wrt enthalpy at constant pressure from state"
    // Standard definition
  algorithm
    ddhp := state.ddhp;
    annotation(Inline = true);
  end density_derh_p;

  redeclare replaceable function extends density_derp_h
    "Return derivative of density wrt pressure at constant enthalpy from state"
    // Standard definition
  algorithm
    ddph := state.ddph;
    annotation(Inline = true);
  end density_derp_h;

  redeclare function temperature_phX "returns temperature for given p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Enthalpy";
    input MassFraction X[nX] "Mass fractions";
    input Integer phase=1 "2 for two-phase, 1 for one-phase, 0 if not known";
    output Temperature T "Temperature";
  algorithm
    T := temperature_phX_state(p=p, h=h, X=X, state=setState_phX(p=p, h=h, X=X, phase=phase));
  annotation (
    Inline=true,
    inverse(h=specificEnthalpy_pTX(p=p, T=T, X=X, phase=phase)));
  end temperature_phX;

  function temperature_phX_state "returns temperature for given p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Enthalpy";
    input MassFraction X[nX] "Mass fractions";
    input ThermodynamicState state;
    output Temperature T "Temperature";
  algorithm
    T := temperature(state);
  annotation (
    Inline=false,
    LateInline=true,
    inverse(h=specificEnthalpy_pTX_state(p=p, T=T, X=X, state=state)));
  end temperature_phX_state;

    function specificEntropy_phX "returns specific entropy for a given p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific Enthalpy";
    input MassFraction X[nX] "Mass fractions";
    input Integer phase=1 "2 for two-phase, 1 for one-phase, 0 if not known";
    output SpecificEntropy s "Specific Entropy";
    algorithm
    s := specificEntropy_phX_state(p=p, h=h, X=X, state=setState_phX(p=p, h=h, X=X, phase=phase));
    annotation (
    Inline=true);
    end specificEntropy_phX;

  function specificEntropy_phX_state
    "returns specific entropy for a given p and h"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific Enthalpy";
    input MassFraction X[nX] "Mass fractions";
    input ThermodynamicState state;
    output SpecificEntropy s "Specific Entropy";
  algorithm
    s := specificEntropy(state);
  annotation (
    Inline=false,
    LateInline=true,
    derivative(noDerivative=state,noDerivative=X)=specificEntropy_phX_der);
  end specificEntropy_phX_state;

  function specificEntropy_phX_der "time derivative of specificEntropy_phX"
    extends Modelica.Icons.Function;
    input AbsolutePressure p;
    input SpecificEnthalpy h;
    input MassFraction X[nX] "Mass fractions";
    input ThermodynamicState state;
    input Real p_der "time derivative of pressure";
    input Real h_der "time derivative of specific enthalpy";
    output Real s_der "time derivative of specific entropy";
  algorithm
    s_der := p_der*(-1.0/(state.d*state.T))
           + h_der*( 1.0/state.T);
  annotation (
    Inline=true);
  end specificEntropy_phX_der;

  redeclare function density_pTX "Return density from p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[nX] "Mass fractions";
    input Integer phase=1 "2 for two-phase, 1 for one-phase, 0 if not known";
    output Density d "Density";
  algorithm
    d := density_pTX_state(p=p, T=T, X=X, state=setState_pTX(p=p, T=T, X=X, phase=phase));
  annotation (
    Inline=true);
  end density_pTX;

  function density_pTX_state
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[nX] "Mass fractions";
    input ThermodynamicState state;
    output Density d "Density";
  algorithm
    d := density(state);
  annotation (
    Inline=false,
    LateInline=true);
  end density_pTX_state;

  redeclare function specificEnthalpy_pTX
    "returns specific enthalpy for given p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[nX] "Mass fractions";
    input Integer phase=1 "2 for two-phase, 1 for one-phase, 0 if not known";
    output SpecificEnthalpy h "specific enthalpy";
  algorithm
    h := specificEnthalpy_pTX_state(p=p, T=T, X=X, state=setState_pTX(p=p, T=T, X=X, phase=phase));
  annotation (
    Inline=true,
    inverse(T=temperature_phX(p=p, h=h, X=X, phase=phase)));
  end specificEnthalpy_pTX;

  function specificEnthalpy_pTX_state
    "returns specific enthalpy for given p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[nX] "Mass fractions";
    input ThermodynamicState state;
    output SpecificEnthalpy h "specific enthalpy";
  algorithm
    h := specificEnthalpy(state);
  annotation (
    Inline=false,
    LateInline=true,
    inverse(T=temperature_phX_state(p=p, h=h, X=X, state=state)));
  end specificEnthalpy_pTX_state;

  redeclare function specificEntropy_pTX
    "returns specific entropy for a given p and T"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  input MassFraction X[nX] "Mass fractions";
  input Integer phase=1 "2 for two-phase, 1 for one-phase, 0 if not known";
  output SpecificEntropy s "Specific Entropy";
  algorithm
  s := specificEntropy_pTX_state(p=p, T=T, X=X, state=setState_pTX(p=p, T=T, X=X, phase=phase));
    annotation (
      Inline=true);
  end specificEntropy_pTX;

  function specificEntropy_pTX_state
    "returns specific entropy for a given p and T"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[nX] "Mass fractions";
    input ThermodynamicState state;
    output SpecificEntropy s "Specific Entropy";
  algorithm
    s := specificEntropy(state);
  annotation (
    Inline=false,
    LateInline=true);
  end specificEntropy_pTX_state;

  redeclare replaceable function extends density "Return density from state"
    // Standard definition
  algorithm
    d := state.d;
    annotation(Inline = true);
  end density;

  redeclare replaceable function extends pressure "Return pressure from state"
    // Standard definition
  algorithm
    p := state.p;
    /*  // If special definition in "C"
  external "C" p=  TwoPhaseMedium_pressure_(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end pressure;

  redeclare replaceable function extends specificEnthalpy
    "Return specific enthalpy from state"
    // Standard definition
  algorithm
    h := state.h;
    annotation(Inline = true);
  end specificEnthalpy;

  redeclare replaceable function extends specificEntropy
    "Return specific entropy from state"
    // Standard definition
  algorithm
    s := state.s;
    annotation(Inline = true);
  end specificEntropy;

  redeclare replaceable function extends temperature
    "Return temperature from state"
    // Standard definition
  algorithm
    T := state.T;
    annotation(Inline = true);
  end temperature;

  redeclare function extends prandtlNumber
    /*  // If special definition in "C"
  external "C" T=  TwoPhaseMedium_prandtlNumber_(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end prandtlNumber;

  redeclare replaceable function extends velocityOfSound
    "Return velocity of sound from state"
    // Standard definition
  algorithm
    a := state.a;
    /*  // If special definition in "C"
  external "C" a=  TwoPhaseMedium_velocityOfSound_(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end velocityOfSound;

  redeclare replaceable function extends specificHeatCapacityCp
    "Return specific heat capacity cp from state"
    // Standard definition
  algorithm
    cp := state.cp;
    /*  // If special definition in "C"
  external "C" cp=  TwoPhaseMedium_specificHeatCapacityCp_(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end specificHeatCapacityCp;

  redeclare replaceable function extends specificHeatCapacityCv
    "Return specific heat capacity cv from state"
    // Standard definition
  algorithm
    cv := state.cv;
    /*  // If special definition in "C"
  external "C" cv=  TwoPhaseMedium_specificHeatCapacityCv_(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end specificHeatCapacityCv;

  redeclare replaceable function extends dynamicViscosity
    "Return dynamic viscosity from state"
    // Standard definition
  algorithm
    eta := state.eta;
    /*  // If special definition in "C"
  external "C" eta=  TwoPhaseMedium_dynamicViscosity_(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end dynamicViscosity;

  redeclare replaceable function extends thermalConductivity
    "Return thermal conductivity from state"
    // Standard definition
  algorithm
    lambda := state.lambda;
    /*  // If special definition in "C"
  external "C" lambda=  TwoPhaseMedium_thermalConductivity_(state, mediumName, libraryName, substanceName)
    annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
*/
    annotation(Inline = true);
  end thermalConductivity;
end IncompressibleCoolPropMedium;
