# 简介

**V2Ray** 规则文件加强版，可代替 V2Ray 官方 `geoip.dat` 和 `geosite.dat` 规则文件。利用 GitHub Actions 北京时间每天早上 6 点自动构建，保证规则最新。

## 说明

本项目适用于命令行版本 V2Ray 客户端。第三方桌面图形界面版（GUI）V2Ray 客户端一般都有路由规则图形化配置界面，但一般也都支持使用自定义 V2Ray JSON 配置和 dat 规则文件，请自行研究并修改配置。第三方移动设备版 V2Ray 客户端情况比较复杂，大概率不支持使用自定义 V2Ray JSON 配置和 dat 规则文件，请知悉。

## 规则文件生成方式

### geoip.dat

- 通过仓库 [@v2ray/geoip](https://github.com/v2ray/geoip) 生成
- 其中 IP 地址来源于 [MaxMind GeoLite2](https://dev.maxmind.com/geoip/geoip2/geolite2/)

### geosite.dat

- 通过仓库 [@v2ray/domain-list-community](https://github.com/v2ray/domain-list-community) 生成
- **加入大量中国大陆域名、Apple 域名、Google 域名和部分海外 CDN 域名**：
  - [@felixonmars/dnsmasq-china-list/accelerated-domains.china.conf](https://github.com/felixonmars/dnsmasq-china-list/blob/master/accelerated-domains.china.conf) 加入到 `geosite:cn` 类别中
  - [@felixonmars/dnsmasq-china-list/apple.china.conf](https://github.com/felixonmars/dnsmasq-china-list/blob/master/apple.china.conf) 加入到 `geosite:geolocation-!cn` 类别中
  - [@felixonmars/dnsmasq-china-list/google.china.conf](https://github.com/felixonmars/dnsmasq-china-list/blob/master/google.china.conf) 加入到 `geosite:geolocation-!cn` 类别中
- **加入最新 GFWList 域名**：通过仓库 [@cokebar/gfwlist2dnsmasq](https://github.com/cokebar/gfwlist2dnsmasq) 生成并加入到 `geosite:geolocation-!cn` 类别中
- **加入 Greatfire Analyzer 检测到的屏蔽域名**：通过仓库 [@wongsyrone/domain-block-list](https://github.com/wongsyrone/domain-block-list) 获取 [Greatfire Analyzer](https://zh.greatfire.org/analyzer) 检测到的屏蔽域名，并加入到 `geosite:geolocation-!cn` 类别中
- **加入更多代理域名和广告域名**：通过仓库 [@ConnersHua/Profiles](https://github.com/ConnersHua/Profiles/tree/master)、[@GeQ1an/Rules](https://github.com/GeQ1an/Rules/tree/master/QuantumultX) 和 [@lhie1/Rules](https://github.com/lhie1/Rules/tree/master) 获取更多代理域名、广告域名，并分别加入到 `geosite:geolocation-!cn` 和 `geosite:category-ads-all` 类别中
- **加入自定义直连和代理域名**：由于上游域名列表更新缓慢或缺失某些被屏蔽的域名，所以引入自定义域名列表，主要为了解决在 DNS 解析 `A` 和 `AAAA` 记录时的 DNS 泄漏问题。[`hidden 分支`](https://github.com/Loyalsoldier/v2ray-rules-dat/tree/hidden)里的三个文件 `direct.txt`、`proxy.txt` 和 `reject.txt`，分别存放自定义的直连、代理、广告域名，最终分别加入到 `geosite:cn`、`geosite:geolocation-!cn` 和 `geosite:category-ads-all` 类别中

## 规则文件下载及使用方式

**下载地址**：

- **geoip.dat**：[https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat](https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat)
- **geosite.dat**：[https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat](https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat)

**使用方式**：

1. 点击上面下载地址，下载 `geoip.dat` 和 `geosite.dat`
2. 把下载下来的 `geoip.dat` 和 `geosite.dat` 文件放入到 V2Ray 的规则文件目录，替换掉原来的 `geoip.dat` 和 `geosite.dat`
3. 修改 V2Ray 配置文件，配置参考下面 👇👇👇

## 参考配置

### geoip.dat

跟 V2Ray 官方 `geoip.dat` 配置方式相同。

**Routing 配置方式**：

```json
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
```

### geosite.dat

跟 V2Ray 官方 `geosite.dat` 配置方式相同。

**Routing 配置方式**：

```json
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
        "geosite:geolocation-!cn"
      ]
    },
    {
      "type": "field",
      "outboundTag": "Direct",
      "domain": [
        "geosite:cn"
      ]
    }
  ]
}
```

**DNS 配置方式**：

```json
"dns": {
  "servers": [
    {
      "address": "1.1.1.1",
      "port": 53,
      "domains": [
        "geosite:geolocation-!cn"
      ]
    },
    {
      "address": "114.114.114.114",
      "port": 53,
      "domains": [
        "geosite:cn"
      ]
    },
    "8.8.8.8",
    "223.5.5.5"
  ]
}
```

### 自用 V2Ray 客户端完整配置（仅供参考，根据自身需求酌情修改）

下面为自用 V2Ray 客户端完整配置，注意事项：

- 由于下面客户端配置使用了 DoH DNS 功能，所以必须使用 v4.22.0 或更新版本的 [V2Ray](https://github.com/v2ray/v2ray-core/releases)
- 下面客户端配置使 V2Ray 在本机开启 SOCKS 代理（监听 1080 端口）和 HTTP 代理（监听 2080 端口）
- BT 流量统统直连（实测依然会有部分 BT 流量走代理，尚不清楚是不是 V2Ray 的 bug。如果服务商禁止 BT 下载的话，请不要为下载软件设置代理）
- 最后，不命中任何路由规则的请求和流量，统统走代理
- `outbounds` 里的第一个大括号内的配置，即为 V2Ray 代理服务的配置。请根据自身需求进行修改，并参照 V2Ray 官网配置说明中的 [配置文件 > 文件格式 > OutboundObject](https://www.v2fly.org/chapter_02/01_overview.html#outboundobject) 部分进行补全

```json
{
  "log": {
    "loglevel": "warning"
  },
  "dns": {
    "servers": [
      {
        "address": "https://1.1.1.1/dns-query",
        "domains": [
          "geosite:geolocation-!cn",
          "geosite:speedtest"
        ]
      },
      "https://1.1.1.1/dns-query",
      "https://dns.google/dns-query",
      {
        "address": "114.114.114.114",
        "port": 53,
        "domains": [
          "geosite:cn"
        ]
      }
    ]
  },
  "inbounds": [
    {
      "protocol": "socks",
      "listen": "127.0.0.1",
      "port": 1080,
      "tag": "Socks-In",
      "settings": {
        "ip": "127.0.0.1",
        "udp": true,
        "auth": "noauth"
      },
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls"]
      }
    },
    {
      "protocol": "http",
      "listen": "127.0.0.1",
      "port": 2080,
      "tag": "Http-In",
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls"]
      }
    }
  ],
  "outbounds": [
    {
      //下面这行，协议名称为socks、shadowsocks或vmess等（记得删除这行文字说明）
      "protocol": "协议名称",
      "settings": {},
      //下面这行，必须为Proxy，对应Routing里的outboundTag（记得删除这行文字说明）
      "tag": "Proxy",
      "streamSettings": {},
      "mux": {}
    },
    {
      "protocol": "dns",
      "tag": "Dns-Out"
    },
    {
      "protocol": "freedom",
      "tag": "Direct",
      "settings": {
        "domainStrategy": "UseIPv4"
      }
    },
    {
      "protocol": "blackhole",
      "tag": "Reject",
      "settings": {
        "response": {
          "type": "http"
        }
      }
    }
  ],
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "type": "field",
        "outboundTag": "Direct",
        "protocol": ["bittorrent"]
      },
      {
        "type": "field",
        "outboundTag": "Dns-Out",
        "inboundTag": [
          "Socks-In",
          "Http-In"
        ],
        "network": "udp",
        "port": 53
      },
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
          "geosite:speedtest"
        ]
      },
      {
        "type": "field",
        "outboundTag": "Direct",
        "domain": [
          "geosite:cn"
        ]
      },
      {
        "type": "field",
        "outboundTag": "Direct",
        "ip": [
          "223.5.5.5/32",
          "119.29.29.29/32",
          "180.76.76.76/32",
          "114.114.114.114/32"
        ]
      },
      {
        "type": "field",
        "outboundTag": "Proxy",
        "ip": [
          "1.1.1.1/32",
          "1.0.0.1/32",
          "8.8.8.8/32",
          "8.8.4.4/32"
        ]
      },
      {
        "type": "field",
        "outboundTag": "Direct",
        "ip": [
          "geoip:cn",
          "geoip:private"
        ]
      },
      {
        "type": "field",
        "outboundTag": "Proxy",
        "network": "tcp,udp"
      }
    ]
  }
}
```

## 致谢

- [@v2ray/geoip](https://github.com/v2ray/geoip)
- [@v2ray/domain-list-community](https://github.com/v2ray/domain-list-community)
- [@felixonmars/dnsmasq-china-list](https://github.com/felixonmars/dnsmasq-china-list)
- [@gfwlist/gfwlist](https://github.com/gfwlist/gfwlist)
- [@cokebar/gfwlist2dnsmasq](https://github.com/cokebar/gfwlist2dnsmasq)
- [@wongsyrone/domain-block-list](https://github.com/wongsyrone/domain-block-list)
- [@ConnersHua/Profiles](https://github.com/ConnersHua/Profiles/tree/master)
- [@GeQ1an/Rules](https://github.com/GeQ1an/Rules/tree/master/QuantumultX)
- [@lhie1/Rules](https://github.com/lhie1/Rules/tree/master)
- [MaxMind GeoLite2 Free IP Database](https://dev.maxmind.com/geoip/geoip2/geolite2/)
