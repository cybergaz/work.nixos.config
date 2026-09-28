{ pkgs, inputs, lib, ... }:
let
  # One Hyprland for the whole machine, and it has to be the one the session actually runs.
  # modules/desktop.nix sets `programs.hyprland.enable`, which installs `pkgs.hyprland` and
  # writes the wayland-session entry ly launches -- so that is the package home-manager
  # configures and, critically, the package hyprscape below is compiled against.
  #
  # This used to be a separate `inputs.hyprland` pinned to v0.55.4 while nixpkgs sat on
  # 0.56.2. Home Manager configured the pin, the system ran nixpkgs, and hyprscape was built
  # against the pin -- so its .so asked the running compositor for
  # `CMonitor::changeWorkspace(...)`, which 0.56 had renamed to `Monitor::CMonitor::...`.
  # dlopen failed, the plugin never initialised, none of its `plugin:hyprscape:*` keys were
  # ever registered, and 80-plugins.lua reported all 37 of them as unknown config keys.
  # Hyprland says none of this out loud: `debug:disable_logs` defaults on, the failure
  # notification expires in five seconds, and CPluginSystem::updateConfigPlugins early-returns
  # unless the plugin *list* changes, so no reload ever retries. `hyprctl plugin list` saying
  # "no plugins loaded" is the tell.
  #
  # So: never introduce a second Hyprland here. If nixpkgs bumps Hyprland's minor version,
  # hyprscape needs porting to it -- see SUPPORTED_HYPRLAND in its Makefile.
  hyprland = pkgs.hyprland;

  # hyprscape has to be built against the very same Hyprland this session runs, so it takes
  # the package rather than shipping its own pinned copy.
  hyprscape = inputs.hyprscape.lib.mkHyprscape {
    inherit pkgs hyprland;
  };

  # Every ./hypr/*.lua file becomes $XDG_CONFIG_HOME/hypr/<name>.lua.
  # All of them are `require`d from the generated hyprland.lua, in sorted
  # order, except 00-vars which is a helper module the others import.
  luaModules = lib.mapAttrs' (
    file: _:
    lib.nameValuePair (lib.removeSuffix ".lua" file) {
      content = ./hypr/${file};
      autoLoad = file != "00-vars.lua";
    }
  ) (lib.filterAttrs (n: t: t == "regular" && lib.hasSuffix ".lua" n) (builtins.readDir ./hypr));
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;

    # Hyprland 0.55 added a Lua config front-end alongside hyprlang, and
    # prefers hyprland.lua over hyprland.conf when both exist. Home Manager
    # writes the Lua entrypoint and the module files, and emits a
    # `hl.plugin.load(...)` call per plugin at the top of it -- which is the
    # native load the old `plugin = ` keyword used to give us, so plugin
    # dispatchers exist before the rest of the config is evaluated.
    configType = "lua";

    plugins = [ hyprscape ];

    extraLuaFiles = luaModules;
  };
}
