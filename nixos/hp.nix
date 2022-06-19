{
  pkgs,
  user,
  ...
}: {
  users.users.${user}.extraGroups = ["scanner" "lp"];

  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.hplipWithPlugin];
  };

  services.printing = {
    enable = true;
    drivers = [pkgs.hplipWithPlugin];
  };
}
