# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "varnish/ng/map.jinja" import varnish_settings with context %}

{% if 'config_source_path' in varnish_settings %}
{% set varnish_conf = varnish_settings.config_source_path %}
{% else %}
{% set varnish_conf = 'salt://varnish/ng/files/varnish.jinja' %}
{% endif %}

# This state doesn't execute a restart of the varnish for precaution
# because it can be dangerous.
# It must be done manually with: salt 'host1' service.restart varnish
varnish.config.{{ varnish_settings.config }}:
    file.managed:
        - name: {{ varnish_settings.config }}
        - source: {{ varnish_conf }}
        - template: jinja
        - require:
            - pkg: varnish.install
        - require_in:
            - service: varnish.service

{% for file,file_options in varnish_settings.vcl.files.items() %}
{% if ( 'enabled' in file_options and file_options.enabled ) or 'enabled' not in file_options %}

varnish.vcl.enable.{{ file_options.path }}:
    file.managed:
        - name: {{ file_options.path }}
        - makedirs: true
        - source: {{ file_options.source_path  }}
        - template: jinja
        - require:
            - pkg: varnish.install
        - watch_in:
            - service: varnish.service

{% elif 'enabled' in file_options and not file_options.enabled %}

varnish.vcl.delete.{{ file_options.path }}:
    file.absent:
        - name: {{ file_options.path }}
        - require:
            - pkg: varnish.install
        - watch_in:
            - service: varnish.service

{% endif %}
{% endfor %}
