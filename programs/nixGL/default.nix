{ nixgl, ... }:

{
  targets.genericLinux.nixGL.packages = nixgl.packages;
  targets.genericLinux.nixGL.defaultWrapper = "mesa";
  targets.genericLinux.nixGL.offloadWrapper = "mesa";
  targets.genericLinux.nixGL.installScripts = [ "mesa" ];
}
