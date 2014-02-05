function FCT_THEME1()
{
#theme blue '${theme_bdo}' '${theme_btn}'
theme_bdo="./pxls-blue.png"
theme_btn="multisystem-drop-blue"
}
function FCT_THEME2()
{
#theme red
theme_bdo="./pxls-red.png"
theme_btn="multisystem-drop-red"
}
function FCT_THEME3()
{
#theme green
theme_bdo="./pxls.png"
theme_btn="multisystem-drop"
}

if [ ! "$(cat "${HOME}"/.multisystem-theme 2>/dev/null)"  ]; then
echo green >"${HOME}"/.multisystem-theme
fi

if [ "$(cat "${HOME}"/.multisystem-theme 2>/dev/null)" = "blue" ]; then
FCT_THEME1
elif [ "$(cat "${HOME}"/.multisystem-theme 2>/dev/null)" = "red" ]; then
FCT_THEME2
elif [ "$(cat "${HOME}"/.multisystem-theme 2>/dev/null)" = "green" ]; then
FCT_THEME3
else
FCT_THEME3
fi
#echo "blue" | tee "${HOME}"/.multisystem-theme
#echo "red" | tee "${HOME}"/.multisystem-theme
#echo "green" | tee "${HOME}"/.multisystem-theme







