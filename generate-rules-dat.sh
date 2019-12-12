#!/usr/bin/env bash

set -e

GREEN='\033[0;32m'
NC='\033[0m' # no color

export GOPATH=${GITHUB_WORKSPACE}
V2RAY_FOLDER="$GOPATH/v2ray"

mkdir -p $V2RAY_FOLDER

GEOIP_REPO="github.com/ilouiss/geoip"
GEOSITE_REPO="github.com/v2ray/domain-list-community"
getGFWLIST_SCRIPT="https://raw.githubusercontent.com/cokebar/gfwlist2dnsmasq/master/gfwlist2dnsmasq.sh"
CHINA_DOMAINS_URL="https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf"

echo -e "${GREEN}>>> downloading $GEOIP_REPO...${NC}"
go get -insecure -v -u -d $GEOIP_REPO
cd $GOPATH/src/$GEOIP_REPO
echo -e "${GREEN}>>> building geoip.dat file...${NC}"
go run main.go
mv geoip.dat $V2RAY_FOLDER/geoip.dat
echo -e "${GREEN}>>> Finished geoip.dat ${NC}"

echo -e "${GREEN}>>> downloading $GEOSITE_REPO...${NC}"
go get -insecure -v -u -d $GEOSITE_REPO
cd $GOPATH/src/$GEOSITE_REPO

echo -e "${GREEN}>>> generating GFWList...${NC}"
curl -sSL $getGFWLIST_SCRIPT \
  | bash -s -- -l -o ./data/gfwlist
echo "include:gfwlist" >> ./data/geolocation-!cn
echo -e "${GREEN}>>> Finished GFWList ${NC}"

echo -e "${GREEN}>>> generating Chinese domains list...${NC}"
curl -sSL $CHINA_DOMAINS_URL \
  | awk -F '/' '{print $2}' \
  > ./data/chinalist
echo "include:chinalist" >> ./data/cn
echo -e "${GREEN}>>> Finished Chinalist ${NC}"

echo -e "${GREEN}>>> building geosite.dat file...${NC}"
go run main.go
mv dlc.dat $V2RAY_FOLDER/geosite.dat
echo -e "${GREEN}>>> Finished geosite.dat ${NC}"

echo ">>>>>>>>>>>>>>>>>>>>>>>>"
ls -lah ./data
echo ">>>>>>>>>>>>>>>>>>>>>>>>"
ls -lah $V2RAY_FOLDER
echo ">>>>>>>>>>>>>>>>>>>>>>>>"

echo -e "${GREEN}完成啦！🌈${NC}"
