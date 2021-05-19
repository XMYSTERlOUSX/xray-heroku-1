#!/bin/sh

openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" \
    -keyout xray.key  -out xray.crt
chmod 777 xray.key
mkdir /etc/xray
cp xray.key /etc/xray/
cp xray.crt /etc/xray/
cat << EOF > /etc/config.json
{
    "log": {
        "loglevel": "none"
    },
    "inbounds": [
        {
            "port": $PORT,
            "protocol": "$PROTOCOL",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "level": 0,
                        "email": "love@example.com"
                    }
                ],
                "decryption": "none",
                "fallbacks": [
                    {
                        "dest": 80
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "tls",
                "tlsSettings": {
                    "alpn": [
                        "http/1.1"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "/etc/xray/xray.crt",
                            "keyFile": "/etc/xray/xray.key"
                        }
                    ]
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

# run xray
/usr/bin/xray run -config /etc/config.json
