#!/bin/sh
sudo modprobe af_key

mkdir -p etc/ipsec.d
mkdir -p etc/ppp
mkdir -p etc/xl2tpd

touch etc/ppp/chap-secrets
touch etc/ppp/options.xl2tpd
touch etc/ipsec.d/passwd
touch etc/ipsec.secrets
touch etc/ipsec.conf
touch etc/xl2tpd/xl2tpd.conf

EXTRA_ARGS=
if [ -f etc/pre-up.sh ]; then
    EXTRA_ARGS="-v $PWD/etc/pre-up.sh:/pre-up.sh"
fi

docker run \
    --name ipsec-vpn-server \
    -p 500:500/udp \
    -p 4500:4500/udp \
    -v /lib/modules:/lib/modules:ro \
    -v "$PWD/etc/ppp/chap-secrets:/etc/ppp/chap-secrets" \
    -v "$PWD/etc/ppp/options.xl2tpd:/etc/ppp/options.xl2tpd" \
    -v "$PWD/etc/ipsec.d/passwd:/etc/ipsec.d/passwd" \
    -v "$PWD/etc/ipsec.secrets:/etc/ipsec.secrets" \
    -v "$PWD/etc/ipsec.conf:/etc/ipsec.conf" \
    -v "$PWD/etc/xl2tpd/xl2tpd.conf:/etc/xl2tpd/xl2tpd.conf" \
    $EXTRA_ARGS \
    -v /lib/modules:/lib/modules:ro \
    -d --privileged \
    --restart=always \
    strandsalz/docker-ipsec-vpn-server
