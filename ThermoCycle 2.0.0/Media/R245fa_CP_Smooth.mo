within ThermoCycle.Media;
package R245fa_CP_Smooth "R245fa - Coolprop  smooth density, TTSE - TC"
  extends ExternalMedia.Media.CoolPropMedium(
  mediumName="R245fa",
  substanceNames={"R245fa|calc_transport=0|debug=1|rho_smoothing_xend=0.15|enable_TTSE=1"});

end R245fa_CP_Smooth;
