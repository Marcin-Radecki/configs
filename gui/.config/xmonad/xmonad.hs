import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Actions.SpawnOn
import XMonad.Layout.NoBorders

import XMonad.Util.EZConfig
import XMonad.Util.Loggers
-- NOTE: Importing XMonad.Util.Ungrab is only necessary for versions
-- < 0.18.0! For 0.18.0 and up, this is already included in the
-- XMonad import and will generate a warning instead!
-- import XMonad.Util.Ungrab

import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns

import XMonad.Hooks.EwmhDesktops


main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     $ myConfig

myConfig = def
    { modMask    = mod4Mask      -- Rebind Mod to the Super key
    , layoutHook = myLayout      -- Use custom layouts
    , manageHook = manageSpawn <+> myManageHook  -- Match on certain windows
    , terminal = "alacritty"
    , startupHook = myStartupHook
    , borderWidth = 3
    }
  `additionalKeysP`
    [ ("M-S-z", spawn "xscreensaver-command -lock")
    , ("M-C-s", unGrab *> spawn "scrot -s"        )
    , ("M-f"  , spawn "firefox"                   )
    ]

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    , isDialog            --> doFloat
    ]

myLayout = modify (tiled ||| Mirror tiled ||| Full ||| threeCol)
  where
    modify =  avoidStruts
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes

myStartupHook :: X ()
myStartupHook = do
  spawnOn "1" "~/.config/polybar/launch.sh"
  spawnOn "2" "~/.config/polybar/launch.sh"
  spawnOn "3" "~/.config/polybar/launch.sh"
  spawnOn "4" "~/.config/polybar/launch.sh"
  spawnOnce "~/.Xclients"
