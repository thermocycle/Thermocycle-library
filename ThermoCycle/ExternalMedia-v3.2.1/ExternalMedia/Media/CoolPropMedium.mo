within ExternalMedia.Media;
package CoolPropMedium "Medium package accessing the CoolProp solver"
  extends BaseClasses.ExternalTwoPhaseMedium(
    final libraryName = "CoolProp",
    final substanceName = ExternalMedia.Common.CheckCoolPropOptions(substanceNames[1],debug=false));

  redeclare replaceable function isentropicEnthalpy
    input AbsolutePressure p_downstream "downstream pressure";
    input ThermodynamicState refState "reference state for entropy";
    output SpecificEnthalpy h_is "Isentropic enthalpy";
  protected
    SpecificEntropy s_ideal;
    ThermodynamicState state_ideal;
  algorithm
    s_ideal := specificEntropy(refState);
    state_ideal := setState_psX(p_downstream, s_ideal);
    h_is := specificEnthalpy(state_ideal);
  end isentropicEnthalpy;

  redeclare replaceable function setBubbleState
    "Set the thermodynamic state on the bubble line"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "saturation point";
    input FixedPhase phase=0 "phase flag";
    output ThermodynamicState state "complete thermodynamic state info";
    // Standard definition
  external"C" TwoPhaseMedium_setBubbleState_C_impl(
        sat,
        phase,
        state,
        mediumName,
        libraryName,
        substanceName)
      annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
    annotation (Inline=true);
  end setBubbleState;

  redeclare replaceable function setDewState
    "Set the thermodynamic state on the dew line"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "saturation point";
    input FixedPhase phase=0 "phase flag";
    output ThermodynamicState state "complete thermodynamic state info";
    // Standard definition
  external"C" TwoPhaseMedium_setDewState_C_impl(
        sat,
        phase,
        state,
        mediumName,
        libraryName,
        substanceName)
      annotation(Include="#include \"externalmedialib.h\"", Library="ExternalMediaLib", IncludeDirectory="modelica://ExternalMedia/Resources/Include", LibraryDirectory="modelica://ExternalMedia/Resources/Library");
    annotation (Inline=true);
  end setDewState;

  redeclare function bubbleEntropy "Return bubble point specific entropy"
    input SaturationProperties sat "saturation property record";
    output SI.SpecificEntropy sl "boiling curve specific entropy";
  algorithm
    sl := specificEntropy(setBubbleState(sat));
  end bubbleEntropy;

  redeclare function dewEntropy "Return dew point specific entropy"
    input SaturationProperties sat "saturation property record";
    output SI.SpecificEntropy sv "dew curve specific entropy";
  algorithm
    sv := specificEntropy(setDewState(sat));
  end dewEntropy;

  redeclare function surfaceTension
    extends Modelica.Icons.Function;
    input SaturationProperties sat "saturation property record";
    output SurfaceTension sigma "Surface tension sigma in the two phase region";
  algorithm
    assert(false, "The CoolProp solver does not provide surface tension");
  end surfaceTension;

end CoolPropMedium;
