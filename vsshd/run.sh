#!/bin/sh
set -e

VER=$(wget -qO- https://api.github.com/repos/v2ray/v2ray-core/releases/latest | awk -F'"' '/tag_name/ {print $4}')
wget -qO- https://github.com/v2ray/v2ray-core/releases/download/$VER/v2ray-linux-64.zip | unzip - -q -d / v2ray v2ctl
chmod +x /v2ctl /v2ray

cat << EOF > /config.json
{
  "log": {
    "loglevel": "none"
  },
  "inbounds": [{
    "port": ${PORT:-80},
    "protocol": "vmess",
    "settings": {
      "clients": [{
        "id": "${UUID:-35d169dc-ae92-f3bf-d84e-c23f4d197b1e}"
      }]
    },
    "streamSettings": {
      "network": "ws"
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }]
}
EOF

if [ -n "${AUTHORIZED_KEYS}" ]; then
	mkdir -p /root/.ssh && chmod 700 /root/.ssh
	echo "${AUTHORIZED_KEYS}" > /root/.ssh/authorized_keys
	chmod 600 /root/.ssh/authorized_keys
fi

/usr/bin/ssh-keygen -A
/usr/sbin/sshd -e -o LogLevel=DEBUG3 -o ListenAddress=127.0.0.1 -o PermitRootLogin=without-password -o AuthenticationMethods=publickey
cat /config.json
/v2ray -config /config.json
