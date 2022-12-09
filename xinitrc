# Here is a good place to run xrandr for whatever your monitor config is, e.g. for rostam the lab computer:
# xrandr --output DisplayPort-5 --set TearFree on --auto --output DisplayPort-1-8 --auto --right-of DisplayPort-5 --set TearFree on
setxkbmap -option ctrl:nocaps
xrdb -merge ~/.Xresources
xscreensaver --no-splash &
exec awesome
