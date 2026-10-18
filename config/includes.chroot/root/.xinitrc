xset s off
xset -dpms
xset s noblank
export WEBKIT_DISABLE_SANDBOX_THIS_IS_DANGEROUS=1
exec dbus-launch --exit-with-session openbox-session
