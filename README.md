# GEO ASSETS

Generate custom geosite and geoip based on [Loyalsoldier](https://github.com/Loyalsoldier/v2ray-rules-dat) with addtional list.

## GEOSITE.DAT

- Same as Original but with addtional list:
  - `geosite:oisd-full`
  - `geosite:oisd-small`
  - `geosite:oisd-nsfw`
  - `geosite:rule-ads`
  - `geosite:rule-doh`
  - `geosite:rule-gaming`
  - `geosite:rule-indo`
  - `geosite:rule-playstore`
  - `geosite:rule-sosmed`
  - `geosite:rule-streaming`
  - `geosite:rule-umum`
  - `geosite:rule-ipcheck`
  - `geosite:videoconference`
  - `geosite:rule-malicious`
  - `geosite:urltest`

> More details for addtional [list](https://github.com/malikshi/v2ray-rules-dat/blob/b3f67d1c2cc83bb2a84ea117b1e0caa340f7a130/.github/workflows/run.yml#L20)


## GEOIP.DAT

- Generated via repository [@Loyalsoldier/geoip](https://github.com/Loyalsoldier/geoip)
- The global IP addresses (IPv4 and IPv6) come from [MaxMind GeoLite2](https://dev.maxmind.com/geoip/geoip2/geolite2/), and the IPv4 addresses under the `CN` (Mainland China) category come from [ipip .net](https://github.com/17mon/china_ip_list)
- New categories (convenient for users with special needs):
  - `geoip:cloudflare`
  - `geoip:cloudfront`
  - `geoip:facebook`
  - `geoip:fastly`
  - `geoip:google`
  - `geoip:netflix`
  - `geoip:telegram`
  - `geoip:twitter`
  - `geoip:malicious`