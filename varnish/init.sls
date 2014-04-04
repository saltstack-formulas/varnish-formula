{% from "varnish/map.jinja" import varnish with context %}


varnish:
  pkg:
    - installed
    - name: {{ varnish.pkg }}
  service:
    - running
    - name: {{ varnish.service }}
    - enable: True
    - reload: True
    - require:
      - pkg: varnish
