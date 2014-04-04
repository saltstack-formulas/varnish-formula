{% from "varnish/map.jinja" import varnish with context %}


include:
  - varnish


{%if salt['grains.get']('os_family') == 'Debian' %}
varnish_curl:
  pkg:
    - installed
    - name: curl


varnish_repo:
  # Import varnish repo GPG key
  cmd.run:
    - name: /usr/bin/curl http://repo.varnish-cache.org/debian/GPG-key.txt | sudo apt-key add -
    - unless: /usr/bin/apt-key adv --list-key C4DEFFEB
    - require:
      - pkg: curl
# NOTE: pkgrepo state module requires "require_in" in order to play nice with
# the pkg state module.
  pkgrepo.managed:
    - name: deb http://repo.varnish-cache.org/ubuntu/ {{ grains['oscodename']}} varnish-3.0
    - file: /etc/apt/sources.list.d/varnish.list
    - require:
      - cmd: varnish_repo
    - require_in:
      - pkg: varnish
{% endif %}
