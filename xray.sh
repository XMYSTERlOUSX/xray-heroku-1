#!/bin/sh
#xray config
cat << EOF > /etc/config.json
{
  "inbounds":[
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
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": { 
                    "path": "/websocket"
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
