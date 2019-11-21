# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "varnish/ng/map.jinja" import varnish_settings with context %}

{% set initsystem = salt['grains.get']('init') %}
{% set version = varnish_settings.version | default('0') %}

{% if initsystem == 'systemd' and version >= '6' %}

{% if grains['os_family'] == 'RedHat' %}

varnish.systemd_varnish_params:
    file.managed:
        - name: /etc/systemd/system/varnish.service.d/override.conf
        - makedirs: True
        - user: root
        - group: root
        - mode: '644'
        - contents: |
            [Service]
            EnvironmentFile=/etc/varnish/varnish.params
            ExecStart=
            ExecStart=/usr/sbin/varnishd \
                    -P /var/run/varnish.pid \
                    -f ${VARNISH_VCL_CONF} \
                    -a ${VARNISH_LISTEN_ADDRESS}:${VARNISH_LISTEN_PORT} \
                    -T ${VARNISH_ADMIN_LISTEN_ADDRESS}:${VARNISH_ADMIN_LISTEN_PORT} \
                    -S ${VARNISH_SECRET_FILE} \
                    -s ${VARNISH_STORAGE} \
                    $DAEMON_OPTS
    module.run:
        - name: service.systemctl_reload
        - onchanges:
            - file: /etc/systemd/system/varnish.service.d/override.conf

{% endif %}

varnish.varnish_secret:
    cmd.run:
        - name: uuidgen > /etc/varnish/secret
        - unless: test -f /etc/varnish/secret

{% endif %}

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

{% if 'varnishncsa' in varnish_settings and varnish_settings.varnishncsa_service %}
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
        - watch:
            - service: varnish.service
{% endif %}
