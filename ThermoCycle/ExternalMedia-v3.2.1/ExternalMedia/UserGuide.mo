within ExternalMedia;
package UserGuide "User's Guide"
  extends Modelica.Icons.Information;
  class Overview "Overview"
    extends Modelica.Icons.Information;
    annotation (Documentation(info="<html>
<p>The <b>ExternalMedia</b> library provides a framework for interfacing external codes computing fluid properties to Modelica.Media-compatible component models. The library has been designed with two main goals: maximizing the efficiency of the code, while minimizing the amount of extra code required to interface existing external codes to the library.</p>
<p>The library provides medium packages covering pure fluids models, possibly two-phase, which are 100&percnt; compatible with the <a href=\"modelica://Modelica.Media.Interfaces.PartialTwoPhaseMedium\">Modelica.Media.Interfaces.PartialTwoPhaseMedium</a> interface. </p>
<p>Two external sofwares for fluid property computation are currently suppored by the ExternalMedia library:</p>
<ul>
<li><a href=\"http://www.fluidprop.com\">FluidProp</a>, formerly developed at TU Delft and currently devloped and maintained by Asimptote</li>
<li><a href=\"http://coolprop.org\">CoolProp</a>, developed at the University of Liege and at the Technical University of Denmark (DTU)</li>
</ul>
</html>"));
  end Overview;

  package Usage "Using the ExternalMedia Library"
    extends Modelica.Icons.Information;
    class FluidProp "FluidProp medium models"
      extends Modelica.Icons.Information;
      annotation (Documentation(info="<html>
<p>Pure (or pseudo-pure) medium models from all the libraries in FluidProp can be accessed by extending the <a href=\"modelica://ExternalMedia.Media.FluidPropMedium\">ExternalMedia.Media.FluidPropMedium</a> package. You need to download and install FluidProp on your computer for these models to work: ExternalMedia accesses them through a COM interface.</p>
<p>Set libraryName to &QUOT;FluidProp.RefProp&QUOT;, &QUOT;FluidProp.StanMix&QUOT;, &QUOT;FluidProp.TPSI&QUOT;, &QUOT;FluidProp.IF97&QUOT;, or &QUOT;FluidProp.GasMix&QUOT; (only single-component), depending on the specific library you need to use. Set substanceNames to a single-element string array containing the name of the specific medium, as specified by the FluidProp documentation. Set mediumName to a string that describes the medium (this only used for documentation purposes but has no effect in selecting the medium model).</p>
<p>See <a href=\"modelica://ExternalMedia.Examples\">ExternalMedia.Examples</a> for examples.</p>
<p>Please note that the medium models IF97 and GasMix are already available natively in Modelica.Media as <a href=\"modelica://Modelica.Media.Water.StandardWater\">Water.StandardWater</a> and <a href=\"modelica://Modelica.Media.IdealGases.MixtureGases\">IdealGases.MixtureGases</a>, and are included here for comparison purposes. It is recommended to use the Modelica.Media models instead, since they are much faster to compute. </p>
</html>"));
    end FluidProp;

    class CoolProp "CoolProp medium models"
      extends Modelica.Icons.Information;
      annotation (Documentation(info="<html>
<p>Pure (or pseudo-pure) medium models in CoolProp can be accessed by extending the <a href=\"modelica://ExternalMedia.Media.FluidPropMedium\">ExternalMedia.Media.CoolPropMedium</a> package.</p>
<p>Set substanceNames to a single-element string array containing the name of the specific medium, as specified by the CoolProp documentation. Set mediumName to a string that describes the medium (this only used for documentation purposes but has no effect in selecting the medium model).</p>
<p>See <a href=\"modelica://ExternalMedia.Examples\">ExternalMedia.Examples</a> for examples.</p>
</html>"));
    end CoolProp;
  end Usage;

  class Contact "Contact information"
    extends Modelica.Icons.Contact;
    annotation (Documentation(info="<html>
<p>For suggestions and enquiries regarding the library development and the support of more tools, operating systems and external codes, please contact the main developer:</p>
<p>Francesco Casella
<br>Dipartimento di Elettronica, Informazione e Bioingegneria
<br>Politecnico di Milano
<br>Via Ponzio 34/5
<br>I-20133 Milano ITALY<br>
<a href=\"mailto:francesco.casella@polimi.it\">francesco.casella@polimi.it</a></p>
<p>Submit bug reports to <a href=\"https://trac.modelica.org/Modelica/newticket?component=_ExternalMedia\">
https://trac.modelica.org/Modelica/newticket?component=_ExternalMedia</p>
</html>"));
  end Contact;
  annotation(DocumentationClass = true);
end UserGuide;
