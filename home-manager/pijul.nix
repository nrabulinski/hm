{pkgs, ...}: {
  home.packages = [pkgs.pijul];

  xdg.configFile."pijul/config.toml".source = (pkgs.formats.toml {}).generate "pijul-config" {
    author = {
      name = "nrabulinski";
      full_name = "Nikodem Rabuliński";
      email = "nikodem@rabulinski.com";
    };
  };
}
