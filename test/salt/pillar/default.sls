# -*- coding: utf-8 -*-
# vim: ft=yaml
---
varnish:
  ng:
    config_file:
      START: "yes"
      NFILES: "131072"
      MEMLOCK: "82000"
      DAEMON_OPTS: >-
        -a :6081
        -T localhost:6082
        -f /etc/varnish/default.vcl
        -S /etc/varnish/secret
        -s malloc,100m
