# 入力メソッド（IBus）設定

export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
[ -x /opt/Obsidian/obsidian ] && alias obsidian="ibus-daemon -drx && /opt/Obsidian/obsidian --disable-gpu --no-sandbox"
[ -f ~/.bashrc_im ] && source ~/.bashrc_im
