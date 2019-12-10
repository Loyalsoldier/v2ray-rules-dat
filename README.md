# 简介

**v2ray** 加强版规则文件，可代替 v2ray 官方 `geoip.dat` 和 `geosite.dat` 文件。利用 GitHub Actions 每天自动构建，保证最新。

## 下载地址

- **geoip.dat**:`https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/latest/geoip.dat`
- **geosite.dat**:`https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/latest/geosite.dat`

## 规则文件生成方式

### geoip.dat

- 通过仓库 [@ilouiss/geoip](https://github.com/ilouiss/geoip) 生成
- 其中 IP 地址来源于 [MaxMind 免费 IP](https://dev.maxmind.com/geoip/geoip2/geolite2/)
- 此生成方式跟 v2ray 官方 `geoip.dat` 相同
- **优点**：由于项目每天自动构建，所以更新速度比官方 `geoip.dat` 要快得多

### geosite.dat

- 通过仓库 [@v2ray/domain-list-community](https://github.com/v2ray/domain-list-community) 生成
- **加入最新 GFWList**：通过仓库 [@cokebar/gfwlist2dnsmasq](https://github.com/cokebar/gfwlist2dnsmasq) 生成 `gfwlist`
- **加入大量中国大陆域名**：通过仓库 [@felixonmars/dnsmasq-china-list](https://github.com/felixonmars/dnsmasq-china-list) 生成 `chinalist`

## 使用方式

### geoip.dat

跟 v2ray 官方 `geoip.dat` 使用方式相同：

```
{
  "routing": {
    "rules": [
      {
        "type": "field",
        "outboundTag": "Direct",
        "ip": [
          "geoip:cn",
          "geoip:private"
        ]
      }
    ]
  }
}
```

### geosite.dat

跟 v2ray 官方 `geosite.dat` 使用方式相同，不同点在于：新增了 `gfwlist` 和 `chinalist` 两个类别，分别来自 [@cokebar/gfwlist2dnsmasq](https://github.com/cokebar/gfwlist2dnsmasq) 和 [@felixonmars/dnsmasq-china-list](https://github.com/felixonmars/dnsmasq-china-list)

#### 路由 routing

```
{
  "routing": {
    "rules": [
      {
        "type": "field",
        "outboundTag": "Reject",
        "domain": [
          "geosite:category-ads-all"
        ]
      },
      {
        "type": "field",
        "outboundTag": "Proxy",
        "domain": [
          "geosite:geolocation-!cn",
          "geosite:gfwlist"
        ]
      },
      {
        "type": "field",
        "outboundTag": "Direct",
        "domain": [
          "geosite:cn",
          "geosite:chinalist"
        ]
      }
    ]
  }
}
```

#### DNS

```
{
  "dns": {
    "servers": [
      {
        "address": "114.114.114.114",
        "port": 53,
        "domains": [
          "geosite:cn",
          "geosite:chinalist"
        ]
      },
      {
        "address": "1.1.1.1",
        "port": 53,
        "domains": [
          "geosite:geolocation-!cn",
          "geosite:gfwlist"
        ]
      },
      "8.8.8.8",
      "223.5.5.5"
    ]
  }
}
```
