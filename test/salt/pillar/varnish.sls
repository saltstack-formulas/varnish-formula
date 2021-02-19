# -*- coding: utf-8 -*-
# vim: ft=yaml
---
varnish:
  ng:
    lookup:
      # At time of providing this, `varnish63` is the latest and could be used
      # However, some of the older platforms are only supported up to `varnish52`
      # `varnish-weekly` works for all platforms, as a useful test
      repo: 'varnish60lts'  # to specify another custom repo than default (varnish40)
    enabled: true  # Optional; useful to disable the service (enabled: false)
    install_from_repo: true  # Without this, varnish is installed from stock-repo

    # Init files configuration
    # (/etc/default/varnish, /etc/sysconfig/varnish or /etc/varnish/varnish.params)
    # can be done either with salt:// uploading the file directly:
    # config_source_path: salt://varnish/ng/files/varnish.jinja

    # or with the options directly (only one must be used)
    # Note, from a Kitchen perspective, this is configured in each suite's test pillar
    config_file: {}

    # VCL templates and pillar values used in them
    vcl:
      version: '4.1'
      backend_default_host: 10.10.10.10
      backend_default_port: 80
      files:
        default:
          path: /etc/varnish/default.vcl
          source_path: salt://varnish/ng/files/default.vcl.jinja
        mobile_detect:
          enabled: false  # Remove that VCL
          path: /etc/varnish/mobile_detect.vcl
          # source_path: salt://testing/mobile_detect.vcl
    varnishncsa:
      enabled: true  # Manage varnishncsa service
