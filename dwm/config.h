/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int gappx     = 8;        /* gaps between windows */
static const unsigned int snap      = 15;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "JetBrainsMono Nerd Font Mono:size=11" };
static const char dmenufont[]	    = "JetBrainsMono Nerd Font Mono:size=11";

#include "colors/green.h"

/* tagging */
static const char *tags[] = { "", "", "󰈔" ,"", "󰊯", "󰭹", "󰊴"};

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",    	 NULL,       NULL,       1 << 1,       0,           -1 },
	{ "vlc",      	 NULL,       NULL,       1 << 1,       0,           -1 },
	{ "calibre", 	 NULL,       NULL,       1 << 1,       0,           -1 },
	{ "Nemo",  	 NULL,       NULL,       1 << 2,       0,           -1 },
	{ "easyeffects", NULL,       NULL,       1 << 1,       0,           -1 },
	{ "pulsemixer",  NULL,       NULL,       1 << 1,       0,           -1 },
	{ "spotatui",	 NULL,       NULL,       1 << 2,       0,           -1 },
	{ "blender", 	 NULL,       NULL,       1 << 1,       0,           -1 },
	{ "Firefox", 	 NULL,       NULL,       1 << 3,       0,           -1 },
	{ "helium", 	 NULL,       NULL,       1 << 4,       0,           -1 },
	{ "kitty",   	 NULL,       NULL,       0,            0,           -1 },
	{ "vesktop", 	 NULL,       NULL,       1 << 5,       0,           -1 },
	{ "Element",   	 NULL,       NULL,       1 << 5,       0,           -1 },
	{ "signal",  	 NULL,       NULL,       1 << 5,       0,           -1 },
	{ "steam",   	 NULL,       NULL,       1 << 6,       0,           -1 },
	{ "retroarch",	 NULL,       NULL,       1 << 6,       0,           -1 },
	{ "Modrinth",	 NULL,       NULL,       1 << 6,       0,           -1 },
	{ "sober",   	 NULL,       NULL,       1 << 6,       0,           -1 },
	{ "zed",     	 NULL,       NULL,       1,            0,           -1 },
	{ "btop",    	 NULL,       NULL,       0,            0,           -1 },
	{ "impala",  	 NULL,       NULL,       0,            1,           -1 },

};

/* layout(s) */
static const float mfact     = 0.6; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */
static const int refreshrate = 120;  /* refresh rate (per second) for client move/resize */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "||",      tile },    /* first entry is default */
	{ "||",      NULL },    /* no layout function means floating behavior */
	{ "|M|",    monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define ALTKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

#define STATUSBAR "dwmblocks"

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col6, "-nf", col2, "-sb", col2, "-sf", col6, NULL };

//APPS
static const char *termcmd[] = { "kitty", NULL };
static const char *vesk[] = { "/home/fierzza/.local/opt/vesktop/vesktop", NULL };
static const char *audio[] = { "kitty", "--class", "pulsemixer", "-e", "pulsemixer", NULL };
static const char *firefox[] = { "firefox", NULL };
static const char *steam[] = { "steam", NULL };
static const char *helium[] = { "helium", NULL };
static const char *qute[] = { "qutebrowser", NULL };
static const char *gimp[] = { "gimp", NULL };
static const char *sober[] = { "sober", NULL };
static const char *zed[] = { "/home/fierzza/.local/bin/zed", NULL };
static const char *thunar[] = { "nemo", NULL };
static const char *neovim[] = { "kitty", "--class", "nvim", "-e", "nvim", NULL };

//Commands
static const char *impalacmd[] = { "kitty", "--class", "impala", "-e", "impala", NULL };
static const char *spotify[] = { "kitty", "--class", "spotatui", "-e", "spotatui", NULL };
static const char *yazi[] = { "kitty", "--class", "yazi", "-e", "yazi", NULL };
static const char *btoppp[] = { "kitty", "--class", "btop", "-e", "btop", NULL };
static const char *screenshot[] = { "/home/fierzza/.local/bin/screenshot", NULL };
static const char *screenshotregion[] = { "/home/fierzza/.local/bin/screenshot-region", NULL };
static const char *colorpckr[] = {"sh", "-c","xcolor -s clipboard",NULL};
static const char *screenrecord[] = { "/home/fierzza/.local/bin/screenrecord", NULL };

//ROFI
static const char *rofi[]={"rofi", "-show", "drun"};
static const char *powermenu[] = { "/home/fierzza/.local/bin/powermenu", NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */
    //Menus and Comands
	{ MODKEY|ShiftMask,             XK_space,  spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_space,  spawn,          {.v = rofi } },
	{ MODKEY,                       XK_p,      spawn,          {.v = screenshot } },
	{ MODKEY|ALTKEY,                XK_p,      spawn,          {.v = screenshotregion } },
	{ MODKEY|ShiftMask,             XK_p,      spawn,          {.v = colorpckr } },
	{ MODKEY|ALTKEY,                XK_space,   spawn,         {.v = impalacmd } },
	{ MODKEY,                       XK_y,      spawn,          {.v = screenrecord } },
	{ MODKEY|ControlMask|ShiftMask, XK_w,      spawn,  	       {.v = powermenu } },

    //Spawn Applications
	{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY|ShiftMask,             XK_v,      spawn,          {.v = audio } },
	{ MODKEY,		                XK_f,      spawn,          {.v = firefox } },
	{ MODKEY,		                XK_q,      spawn,          {.v = qute } },
	{ MODKEY,		                XK_s,      spawn,          {.v = steam } },
	{ MODKEY|ShiftMask,	            XK_s,      spawn,          {.v = spotify } },
	{ MODKEY|ControlMask,           XK_s,      spawn,          {.v = sober } },
	{ MODKEY|ControlMask,           XK_v,      spawn,          {.v = vesk } },
	{ MODKEY,                       XK_h,      spawn,          {.v = helium } },
	{ MODKEY,                       XK_z,      spawn,          {.v = zed } },
	{ MODKEY,                       XK_g,      spawn,          {.v = gimp } },
	{ MODKEY,                       XK_n,      spawn,          {.v = neovim } },
	{ MODKEY,    	 		        XK_e,      spawn,          {.v = thunar } },
	{ MODKEY|ShiftMask, 	        XK_e,      spawn,          {.v = yazi } },
	{ MODKEY,    	 		        XK_b,      spawn,          {.v = btoppp } },
	

	{ MODKEY,                       XK_m,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_u,      incnmaster,     {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_u,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_i,      zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY,                       XK_w,      killclient,     {0} },
	{ MODKEY,                       XK_x,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY|ShiftMask,             XK_x,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY|ControlMask,           XK_x,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_t,      setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY|ShiftMask,             XK_f,      togglefullscr,  {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY,                       XK_Left,   shiftview,      {.i = -1 } },
	{ MODKEY,                       XK_Right,  shiftview,      {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	{ MODKEY|ShiftMask,             XK_w,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button1,        sigstatusbar,   {.i = 1} },
	{ ClkStatusText,        0,              Button2,        sigstatusbar,   {.i = 2} },
	{ ClkStatusText,        0,              Button3,        sigstatusbar,   {.i = 3} },
	{ ClkStatusText,        0,              Button4,        sigstatusbar,   {.i = 4} },
	{ ClkStatusText,        0,              Button5,        sigstatusbar,   {.i = 5} },
	{ ClkStatusText,        0,              6,              sigstatusbar,   {.i = 6} },
	{ ClkStatusText,        0,              7,              sigstatusbar,   {.i = 7} },
	{ ClkStatusText,        0,              8,              sigstatusbar,   {.i = 8} },
	{ ClkStatusText,        0,              9,              sigstatusbar,   {.i = 9} },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

