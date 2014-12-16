within ThermoCycle.Components.Units.Tanks;
package FillerMaterial
  record Alluminium
  extends ThermoCycle.Components.Units.Tanks.FillerMaterial.MaterialBase;
  end Alluminium;

  record Brick
  extends ThermoCycle.Components.Units.Tanks.FillerMaterial.MaterialBase(
      rho_sol=2710,
      cp_sol=750,
      k_sol=0.69);
  end Brick;

  record BrickBrickMagnesia
  extends ThermoCycle.Components.Units.Tanks.FillerMaterial.MaterialBase(
      rho_sol=3000,
      cp_sol=1130,
      k_sol=5.07);
  end BrickBrickMagnesia;

  record CastIron
  extends ThermoCycle.Components.Units.Tanks.FillerMaterial.MaterialBase(
      rho_sol=7900,
      cp_sol=837,
      k_sol=29.3);
  end CastIron;

  record Concrete
  extends ThermoCycle.Components.Units.Tanks.FillerMaterial.MaterialBase(
      rho_sol=2240,
      cp_sol=1130,
      k_sol=1.3);
  end Concrete;

  record Copper
  extends ThermoCycle.Components.Units.Tanks.FillerMaterial.MaterialBase(
      rho_sol=8954,
      cp_sol=383,
      k_sol=385);
  end Copper;

  record Earth_dry
  extends ThermoCycle.Components.Units.Tanks.FillerMaterial.MaterialBase(
      rho_sol=1260,
      cp_sol=795,
      k_sol=0.25);
  end Earth_dry;

  record Earth_wet
  extends ThermoCycle.Components.Units.Tanks.FillerMaterial.MaterialBase(
      rho_sol=1700,
      cp_sol=2093,
      k_sol=2.51);
  end Earth_wet;

  record MaterialBase
    "Solid media properties of sensible heat storage materials from {Atear OE. Storage of Thermal Energy. Encyclopedia of Life support systems (EOLSS); 2008}"
  parameter Modelica.SIunits.Density rho_sol = 2707
      "Density of the filler material";
  parameter Modelica.SIunits.SpecificHeatCapacity cp_sol = 896
      "Specific heat capacity of the filler material";
  parameter Modelica.SIunits.ThermalConductivity k_sol = 204
      "Thermal conductivity of the filler material";
  end MaterialBase;

  record PureIron
  extends ThermoCycle.Components.Units.Tanks.FillerMaterial.MaterialBase(
      rho_sol=7897,
      cp_sol=452,
      k_sol=73);
  end PureIron;

  record Stone_granite
  extends ThermoCycle.Components.Units.Tanks.FillerMaterial.MaterialBase(
      rho_sol=2640,
      cp_sol=820,
      k_sol=3.98);
  end Stone_granite;

  record Stone_limestone
  extends ThermoCycle.Components.Units.Tanks.FillerMaterial.MaterialBase(
      rho_sol=2500,
      cp_sol=900,
      k_sol=1.33);
  end Stone_limestone;

  record Stone_marble
  extends ThermoCycle.Components.Units.Tanks.FillerMaterial.MaterialBase(
      rho_sol=2600,
      cp_sol=800,
      k_sol=2.94);
  end Stone_marble;

  record Stone_sandstone
  extends ThermoCycle.Components.Units.Tanks.FillerMaterial.MaterialBase(
      rho_sol=2200,
      cp_sol=710,
      k_sol=1.83);
  end Stone_sandstone;

  record Quartzite
  extends ThermoCycle.Components.Units.Tanks.FillerMaterial.MaterialBase(
      rho_sol=2500,
      cp_sol=830,
      k_sol=5);
  end Quartzite;
end FillerMaterial;
