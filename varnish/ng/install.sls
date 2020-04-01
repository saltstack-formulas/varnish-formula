# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "varnish/ng/map.jinja" import varnish_settings with context %}

varnish.install:
  pkg.installed:
    - name: {{ varnish_settings.pkg }}
    {%- if varnish_settings.get('retry_options', {}) %}
    - retry: {{ varnish_settings.retry_options | json }}
    {%- endif %}
