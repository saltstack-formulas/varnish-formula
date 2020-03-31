# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "varnish/ng/map.jinja" import varnish_settings with context %}

{% if salt['grains.get']('os_family') == 'Debian' %}

{%   set pkg_dep_pyver = '3' if grains.pythonversion[0] == 3 else '' %}
varnish.repo.dependencies:
    pkg.installed:
        - pkgs:
            - apt-transport-https
            - python{{ pkg_dep_pyver }}-apt
        {%- if varnish_settings.get('retry_options', {}) %}
        - retry: {{ varnish_settings.retry_options | json }}
        {%- endif %}
        - require_in:
            - pkgrepo: varnish.repo.{{ varnish_settings.repo }}
            - pkgrepo: varnish.repo.{{ varnish_settings.repo }}_src

varnish.repo.{{ varnish_settings.repo }}:
    pkgrepo.managed:
        - name: {{ 'deb https://packagecloud.io/varnishcache/{0}/{1}/ {2} main'.format(
                        varnish_settings.repo,
                        salt['grains.get']('os')|lower,
                        salt['grains.get']('oscodename'),
                ) }}
        - file: /etc/apt/sources.list.d/{{ varnish_settings.repo }}.list
        - gpgcheck: 1
        - key_url: https://packagecloud.io/varnishcache/{{ varnish_settings.repo }}/gpgkey

varnish.repo.{{ varnish_settings.repo }}_src:
    pkgrepo.managed:
        - name: {{ 'deb-src https://packagecloud.io/varnishcache/{0}/{1}/ {2} main'.format(
                        varnish_settings.repo,
                        salt['grains.get']('os')|lower,
                        salt['grains.get']('oscodename'),
                ) }}
        - file: /etc/apt/sources.list.d/{{ varnish_settings.repo }}.list
        - gpgcheck: 1
        - key_url: https://packagecloud.io/varnishcache/{{ varnish_settings.repo }}/gpgkey

{% elif salt['grains.get']('os_family') == 'RedHat' %}

{%   if salt['grains.get']('osfinger', '') not in ['CentOS Linux-8', 'Fedora-31'] %}
varnish.repo.dependencies:
    pkg.installed:
        - pkgs:
            {% if salt['grains.get']('osfinger', '') not in ['Fedora-30'] %}
            - pygpgme
            {% endif %}
            - yum-utils
        {%- if varnish_settings.get('retry_options', {}) %}
        - retry: {{ varnish_settings.retry_options | json }}
        {%- endif %}
        - require_in:
            {% if salt['grains.get']('osfinger', '') in ['CentOS Linux-7', 'Amazon Linux-2'] %}
            - pkgrepo: varnish_epel_repo
            {% endif %}
            - pkgrepo: varnish.repo.{{ varnish_settings.repo }}
            - pkgrepo: varnish.repo.{{ varnish_settings.repo }}_source
{%   endif %}

{%   if salt['grains.get']('osfinger', '') in ['CentOS Linux-7', 'Amazon Linux-2'] %}
varnish_epel_repo:
    pkgrepo.managed:
        - name: epel
        - humanname: Extra Packages for Enterprise Linux 7 - $basearch
        - mirrorlist: https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
        - enabled: 1
        - gpgcheck: 1
        - gpgkey: https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
        - failovermethod: priority
{%   endif %}

{%   set osmajorrelease = 7 if salt['grains.get']('osfinger', '') == 'Amazon Linux-2' else salt['grains.get']('osmajorrelease') %}
varnish.repo.{{ varnish_settings.repo }}:
    pkgrepo.managed:
        - name: {{ varnish_settings.repo }}
        - humanname: {{ varnish_settings.repo }}
        - baseurl: https://packagecloud.io/varnishcache/{{ varnish_settings.repo }}/el/{{ osmajorrelease }}/$basearch
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
        - baseurl: https://packagecloud.io/varnishcache/{{ varnish_settings.repo }}/el/{{ osmajorrelease }}/SRPMS
        - enabled: 1
        - gpgcheck: 0
        - repo_gpgcheck: 1
        - gpgkey: https://packagecloud.io/varnishcache/{{ varnish_settings.repo }}/gpgkey
        - sslverify: 1
        - sslcacert: /etc/pki/tls/certs/ca-bundle.crt
        - metadata_expire: 300

{% endif %}
