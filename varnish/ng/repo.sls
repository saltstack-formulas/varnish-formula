# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "varnish/ng/map.jinja" import varnish_settings with context %}

{% if salt['grains.get']('os_family') == 'Debian' %}

varnish.repo.dependencies:
    pkg.installed:
        - pkgs:
            - apt-transport-https

varnish.repo.{{ varnish_settings.repo }}:
    pkgrepo.managed:
        - name: deb https://packagecloud.io/varnishcache/{{ varnish_settings.repo }}/{{ salt['grains.get']('os')|lower }}/ {{ salt['grains.get']('oscodename') }} main
        - file: /etc/apt/sources.list.d/{{ varnish_settings.repo }}.list
        - gpgcheck: 1
        - key_url: https://packagecloud.io/varnishcache/{{ varnish_settings.repo }}/gpgkey

varnish.repo.{{ varnish_settings.repo }}_src:
    pkgrepo.managed:
        - name: deb-src https://packagecloud.io/varnishcache/{{ varnish_settings.repo }}/{{ salt['grains.get']('os')|lower }}/ {{ salt['grains.get']('oscodename') }} main
        - file: /etc/apt/sources.list.d/{{ varnish_settings.repo }}.list
        - gpgcheck: 1
        - key_url: https://packagecloud.io/varnishcache/{{ varnish_settings.repo }}/gpgkey
    
{% elif salt['grains.get']('os_family') == 'RedHat' %}

include:
    - epel

varnish.repo.dependencies:
    pkg.installed:
        - pkgs:
            - pygpgme
            - yum-utils

varnish.repo.{{ varnish_settings.repo }}:
    pkgrepo.managed:
        - name: {{ varnish_settings.repo }}
        - humanname: {{ varnish_settings.repo }}
        - baseurl: https://packagecloud.io/varnishcache/{{ varnish_settings.repo }}/el/{{ salt['grains.get']('osmajorrelease') }}/$basearch
        - enabled: 1
        - gpgcheck: 0
        - repo_gpgcheck: 1
        - gpgkey: https://packagecloud.io/varnishcache/{{ varnish_settings.repo }}/gpgkey
        - sslverify: 1
        - sslcacert: /etc/pki/tls/certs/ca-bundle.crt
        - metadata_expire: 300

varnish.repo.{{ varnish_settings.repo }}_source:
    pkgrepo.managed:
        - name: {{ varnish_settings.repo }}-source
        - humanname: {{ varnish_settings.repo }}-source
        - baseurl: https://packagecloud.io/varnishcache/{{ varnish_settings.repo }}/el/{{ salt['grains.get']('osmajorrelease') }}/SRPMS
        - enabled: 1
        - gpgcheck: 0
        - repo_gpgcheck: 1
        - gpgkey: https://packagecloud.io/varnishcache/{{ varnish_settings.repo }}/gpgkey
        - sslverify: 1
        - sslcacert: /etc/pki/tls/certs/ca-bundle.crt
        - metadata_expire: 300

{% endif %}
