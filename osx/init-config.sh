
for arg in "$@"; do
    if [ "$arg" == "git" ]; then
        GIT="y"
    elif [ "$arg" == "sublime" ]; then
        SUBLIME="y"
    elif [ "$arg" == "pip" ]; then
        PIP="y"
    elif [ "$arg" == "npm" ]; then
        NPM="y"
    elif [ "$arg" == "v2ray" ]; then
        V2RAY="y"
    elif [ "$arg" == "privoxy" ]; then
        PRIVOXY="y"
    elif [ "$arg" == "ss" ]; then
        SS="y"
    elif [ "$arg" == "ansible" ]; then
        ANSIBLE="y"
    elif [ "$arg" == "m2" ]; then
        M2="y"
    fi
done


[ "$ANSIBLE" = "y" ] && echo "create .ansible.cfg" && cat <<EOF > ~/.ansible.cfg
[defaults]
private_key_file = ~/.ssh/id_rsa
host_key_checking = False
;remote_user = root
EOF


[ "$GIT" = "y" ] && echo "create .gitconfig" && cat <<'EOF' > ~/.gitconfig
[user]
        name = YOURNAME
        email = YOURNAME@COMPANY.com
[difftool "sourcetree"]
        cmd = /usr/local/bin/bcomp $LOCAL $REMOTE
        path = -ro
[mergetool "sourcetree"]
        cmd = /usr/local/bin/bcomp $LOCAL $REMOTE $BASE $MERGED
        trustExitCode = true
[diff]
        submodule = log
[status]
        submodulesummary = 1
[push]
        default = simple
EOF


[ "$PIP" = "y" ] && mkdir -p ~/.pip && echo "create .pip/pip.conf" && cat <<'EOF' > ~/.pip/pip.conf
[global]
cache-dir = /tmp/cache-pip
index-url = http://mirrors.aliyun.com/pypi/simple/
trusted-host = mirrors.aliyun.com
EOF


[ "$NPM" = "y" ] && echo "create .npmrc" && cat <<EOF > ~/.npmrc
registry=https://registry.npm.taobao.org
EOF


[ "$M2" = "y" ] && mkdir -p ~/.m2 && echo "create .m2/settings.xml" && touch ~/.m2/settings.xml


# "PAC Mode"不进行代理（不影响正常使用）；指定浏览器的代理配置(always.js)后才生效
[ "$V2RAY" = "y" ] && [ -d ~/Library/Application\ Support/V2RayX/pac ] && \
[ ! -f ~/Library/Application\ Support/V2RayX/pac/pac.pac ] && echo "backup pac.js" && \
cp ~/Library/Application\ Support/V2RayX/pac/pac.js ~/Library/Application\ Support/V2RayX/pac/pac.pac && \
cat <<EOF > ~/Library/Application\ Support/V2RayX/pac/pac.js
function FindProxyForURL(url, host) {
    return 'DIRECT;';
}
EOF


# “自动/全局模式”都不进行代理（不影响正常使用）；指定浏览器的代理配置(always.js)后才生效
[ "$SS" = "y" ] && [ -f ~/.ShadowsocksX/gfwlist.js ] && \
[ ! -f ~/.ShadowsocksX/gfwlist.pac ] && echo "backup gfwlist.js" && \
cp ~/.ShadowsocksX/gfwlist.js ~/.ShadowsocksX/gfwlist.pac && \
cat <<EOF > ~/.ShadowsocksX/gfwlist.js
function FindProxyForURL(url, host) {
    return 'DIRECT;';
}
EOF


# 指定浏览器配置 always.js 代理后，所有流量都从 ss/v2ray 走
[ "$SS" = "y" -o "$V2RAY" = "y" ] && echo "create always.js" && cat <<EOF > /Users/Shared/always.js
// file:///Users/Shared/always.js
function FindProxyForURL(url, host) {
    return "PROXY 127.0.0.1:1088;SOCKS5 127.0.0.1:1080;SOCKS 127.0.0.1:1080;";
}
EOF


[ "$PRIVOXY" = "y" ] && [ -d /usr/local/etc/privoxy ] && \
[ ! -f /usr/local/etc/privoxy/config.default ] && echo "backup and rewrite confif" && \
cp /usr/local/etc/privoxy/config /usr/local/etc/privoxy/config.default && \
cat <<EOF > /usr/local/etc/privoxy/config
confdir /usr/local/etc/privoxy
logdir /usr/local/var/log/privoxy

listen-address   127.0.0.1:1088
forward-socks5 / 127.0.0.1:1080 .
EOF


[ "$SUBLIME" = "y" ] && echo "create sublime-settings" && \
cat <<EOF > ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings
{
    "font_face": "Inconsolata",
    "font_size": 26,
    "translate_tabs_to_spaces": true,
    "ignored_packages":
    [
        "Vintage"
    ]
}
EOF
