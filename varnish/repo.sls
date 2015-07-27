{% from "varnish/map.jinja" import varnish with context -%}

include:
  - varnish

{% if salt['grains.get']('os_family') == 'Debian' -%}
varnish_repo:
  pkgrepo.managed:
    - name: deb http://repo.varnish-cache.org/{{ salt['grains.get']('os')|lower }}/ {{ salt['grains.get']('oscodename')}} {{ varnish.repo.components | join(' ') }}
    - file: /etc/apt/sources.list.d/varnish.list
    - keyid: C4DEFFEB
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: varnish
{% elif salt['grains.get']('os_family') == 'RedHat' -%}
  {% for component in varnish.repo.components %}
varnish_repo_{{ component }}:
  pkgrepo.managed:
    - name: varnish
    - humanname: Varnish for Enterprise Linux el6 - $basearch
    - baseurl: http://repo.varnish-cache.org/redhat/{{ component }}/el6/$basearch
    - gpgcheck: 0
    - require_in:
      - pkg: varnish
  {% endfor %}
{%- endif %}
