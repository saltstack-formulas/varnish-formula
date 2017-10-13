# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "varnish/ng/map.jinja" import varnish_settings with context %}

varnish.service:
{% if ( 'enabled' in varnish_settings and varnish_settings.enabled ) or ('enabled' not in varnish_settings ) %}
  service.running:
    - name: {{ varnish_settings.service }}
    - enable: True
    - reload: True
    - require:
      - pkg: varnish
{% elif 'enabled' in varnish_settings and not varnish_settings.enabled %}
    service.dead:
        - name: {{ varnish_settings.service }}
        - enable: False
{% endif %}

{% if 'varnishncsa' in varnish_settings %}
varnish.varnishncsa.service:
{% if varnish_settings.varnishncsa.enabled %}
    service.running:
        - name: {{ varnish_settings.varnishncsa_service }}
        - enable: True
{% else %}
    service.dead:
        - name: {{ varnish_settings.varnishncsa_service }}
        - enable: False
{% endif %}
{% endif %}
