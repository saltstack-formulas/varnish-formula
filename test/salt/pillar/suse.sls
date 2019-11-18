# -*- coding: utf-8 -*-
# vim: ft=yaml
---
varnish:
  ng:
    config_file:
      VARNISHD_PARAMS: >-
        -j unix,user=varnish
        -f /etc/varnish/default.vcl
        -T:6082
        -s file,/var/cache/varnish,1M
      VARNISHLOG_PARAMS: "-a -w /var/log/varnish/varnish.log"
