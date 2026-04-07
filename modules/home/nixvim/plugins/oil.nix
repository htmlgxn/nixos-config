# modules/home/nixvim/plugins/oil.nix
{...}: {
  programs.nixvim.plugins.oil = {
    enable = true;
    settings = {
      default_file_explorer = true;
      columns = ["icon" "permissions" "size" "mtime"];
      view_options.show_hidden = true;
      keymaps = {
        "<C-h>" = false;
        "<C-l>" = false;
        "q" = "actions.close";
      };
    };
  };
}
