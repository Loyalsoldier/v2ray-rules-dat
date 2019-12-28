# 简介

**v2ray** 加强版规则文件，可代替 v2ray 官方 `geoip.dat` 和 `geosite.dat` 规则文件。利用 GitHub Actions 北京时间每天早上 6 点自动构建，保证规则最新。

## 规则文件生成方式

### geoip.dat

- 通过仓库 [@v2ray/geoip](https://github.com/v2ray/geoip) 生成
- 其中 IP 地址来源于 [MaxMind 免费 IP](https://dev.maxmind.com/geoip/geoip2/geolite2/)
- **优点**：由于项目每天自动构建，所以更新速度比官方 `geoip.dat` 要快得多

### geosite.dat

- 通过仓库 [@v2ray/domain-list-community](https://github.com/v2ray/domain-list-community) 生成
- **加入大量中国大陆域名**：通过仓库 [@felixonmars/dnsmasq-china-list](https://github.com/felixonmars/dnsmasq-china-list) 生成并加入到 `geosite:cn` 类别中
- **加入最新 GFWList 域名**：通过仓库 [@cokebar/gfwlist2dnsmasq](https://github.com/cokebar/gfwlist2dnsmasq) 生成并加入到 `geosite:geolocation-!cn` 类别中
- **加入 Greatfire.org 检测到的屏蔽域名**：通过仓库 [@wongsyrone/domain-block-list](https://github.com/wongsyrone/domain-block-list) 获取 greatfire.org 检测到的屏蔽域名，并加入到 `geosite:geolocation-!cn` 类别中
- **加入更多直连、代理、广告域名**：通过仓库 [@ConnersHua/Profiles](https://github.com/ConnersHua/Profiles/tree/master) 获取更多直连、代理、广告域名，并分别加入到 `geosite:cn`、`geosite:geolocation-!cn` 和 `geosite:category-ads-all` 类别中
- **加入自定义直连和代理域名**：由于上游域名列表更新缓慢或缺失某些被屏蔽的域名，所以引入自定义域名列表，主要为了解决在 DNS 解析 `A` 和 `AAAA` 记录时的 DNS 泄漏问题。[`hidden` 分支](https://github.com/Loyalsoldier/v2ray-rules-dat/tree/hidden)里有两个文件 `direct.txt` 和 `proxy.txt`，分别放置自定义的直连、代理域名，最终分别加入到 `geosite:cn` 和 `geosite:geolocation-!cn` 类别中
- **优点**：
  - 由于项目每天自动构建，所以更新速度比官方 `geosite.dat` 要快得多
  - 对从上述仓库和文件中获取的直连、代理域名进行简单去重，尽量减小规则文件体积

## 规则文件下载及使用方式

**下载地址**：

- **geoip.dat**：[https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat](https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat)
- **geosite.dat**：[https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat](https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat)

**使用方式**：

1. 通过上面下载地址或[点击进入规则文件发布页面](https://github.com/Loyalsoldier/v2ray-rules-dat/releases)，下载 `geoip.dat` 和 `geosite.dat`
2. 把下载下来的 `geoip.dat` 和 `geosite.dat` 文件放入到 v2ray 软件的规则文件目录，替换掉原来的 `geoip.dat` 和 `geosite.dat`
3. 修改 v2ray 配置文件，配置参考下面 👇👇👇

## 参考配置

### geoip.dat

跟 v2ray 官方 `geoip.dat` 配置方式相同。

**Routing 配置方式**：

```json
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

跟 v2ray 官方 `geosite.dat` 配置方式相同。

**Routing 配置方式**：

```json
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
}
```

**DNS 配置方式**：

```json
{
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
}
```
