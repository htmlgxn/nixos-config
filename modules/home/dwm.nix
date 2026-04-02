# dwm window manager configuration for aarch64 Jetson (L4T/Ubuntu + standalone HM).
# Builds a theme-patched dwm via overrideAttrs and manages xsession startup.
{
  config,
  pkgs,
  lib,
  ...
}: let
  theme = config.my.guiThemeData.sway.colors;
  # term = config.my.terminal;

  dwmConfig = pkgs.writeText "config.h" ''
    /* appearance */
    static const unsigned int borderpx  = 2;
    static const unsigned int snap      = 32;
    static const int showbar            = 1;
    static const int topbar             = 1;
    static const char *fonts[]          = { "Roboto Mono:size=10" };
    static const char dmenufont[]       = "Roboto Mono:size=10";
    static const char col_normfg[]      = "${theme.unfocused.text}";
    static const char col_normbg[]      = "${theme.unfocused.background}";
    static const char col_normborder[]  = "${theme.unfocused.border}";
    static const char col_selfg[]       = "${theme.focused.text}";
    static const char col_selbg[]       = "${theme.focused.background}";
    static const char col_selborder[]   = "${theme.focused.border}";
    static const char *colors[][3]      = {
        /*               fg              bg              border          */
        [SchemeNorm] = { col_normfg,     col_normbg,     col_normborder },
        [SchemeSel]  = { col_selfg,      col_selbg,      col_selborder  },
    };

    /* tagging */
    static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

    static const Rule rules[] = {
        /* class      instance    title       tags mask     isfloating   monitor */
        { "Gimp",     NULL,       NULL,       0,            1,           -1 },
    };

    /* layout(s) */
    static const float mfact            = 0.55;
    static const int nmaster            = 1;
    static const int resizehints        = 1;
    static const int lockfullscreen     = 1;

    static const Layout layouts[] = {
        /* symbol     arrange function */
        { "[]=",      tile },
        { "><>",      NULL },
        { "[M]",      monocle },
    };

    /* key definitions */
    #define MODKEY Mod4Mask
    #define TAGKEYS(KEY,TAG) \
        { MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
        { MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
        { MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
        { MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

    #define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

    /* commands */
    static char dmenumon[2] = "0";
    static const char *dmenucmd[] = { "rofi", "-show", "drun", NULL };
    static const char *termcmd[]  = { "${term}", NULL };

    static const Key keys[] = {
        /* modifier                     key        function        argument */
        { MODKEY,                       XK_space,  spawn,          {.v = dmenucmd } },
        { MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
        { MODKEY,                       XK_b,      togglebar,      {0} },
        { MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
        { MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
        { MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
        { MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
        { MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
        { MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
        { MODKEY|ShiftMask,             XK_Return, zoom,           {0} },
        { MODKEY,                       XK_Tab,    view,           {0} },
        { MODKEY,                       XK_q,      killclient,     {0} },
        { MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
        { MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
        { MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
        { MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
        { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
        { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
        { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
        { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
        { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
        { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
        TAGKEYS(                        XK_1,                      0)
        TAGKEYS(                        XK_2,                      1)
        TAGKEYS(                        XK_3,                      2)
        TAGKEYS(                        XK_4,                      3)
        TAGKEYS(                        XK_5,                      4)
        TAGKEYS(                        XK_6,                      5)
        TAGKEYS(                        XK_7,                      6)
        TAGKEYS(                        XK_8,                      7)
        TAGKEYS(                        XK_9,                      8)
        { MODKEY|ShiftMask,             XK_q,      quit,           {0} },
    };

    /* button definitions */
    static const Button buttons[] = {
        /* click                event mask      button          function        argument */
        { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
        { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
        { ClkWinTitle,          0,              Button2,        zoom,           {0} },
        { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
        { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
        { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
        { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
        { ClkTagBar,            0,              Button1,        view,           {0} },
        { ClkTagBar,            0,              Button2,        toggleview,     {0} },
        { ClkTagBar,            0,              Button3,        view,           {0} },
    };
  '';

  customDwm = pkgs.dwm.overrideAttrs (_: {
    postPatch = ''
      cp ${dwmConfig} config.h
    '';
  });
in {
  imports = [./x11-base.nix];

  home.packages = [customDwm];

  xsession = {
    windowManager.command = "${customDwm}/bin/dwm";
    initExtra = ''
      feh --bg-fill ${config.my.wallpaper} &
      picom -b &
      dunst &
      nm-applet &
      xsetroot -name "dwm" &
    '';
  };
}
