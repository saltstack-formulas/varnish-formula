{% from "varnish/map.jinja" import varnish with context -%}


include:
  - varnish


{% if salt['grains.get']('os_family') == 'Debian' %}
varnish_repo_curl:
  pkg:
    - installed
    - name: curl


varnish_repo:
  # Import varnish repo GPG key
  cmd:
    - run
    - name: /usr/bin/curl http://repo.varnish-cache.org/{{ salt['grains.get']('os')|lower }}/GPG-key.txt | sudo apt-key add -
    - unless: /usr/bin/apt-key adv --list-key C4DEFFEB
    - require:
      - pkg: varnish_repo_curl
# NOTE: pkgrepo state module requires "require_in" in order to play nice with
# the pkg state module.
  pkgrepo:
    - managed
    - name: deb http://repo.varnish-cache.org/{{ salt['grains.get']('os')|lower }}/ {{ salt['grains.get']('oscodename')}} {{ varnish.repo.components | join(' ') }}
    - file: /etc/apt/sources.list.d/varnish.list
    - require:
      - cmd: varnish_repo
    - require_in:
      - pkg: varnish


{% elif salt['grains.get']('os_family') == 'RedHat' %}
  {% for component in varnish.repo.components %}
varnish_repo_{{ component }}:
  pkgrepo:
    - managed
    - name: varnish
    - humanname: Varnish for Enterprise Linux el6 - $basearch
    - baseurl: http://repo.varnish-cache.org/redhat/{{ component }}/el6/$basearch
    - gpgcheck: 0
    - require_in:
      - pkg: varnish
  {% endfor %}
{% endif %}
