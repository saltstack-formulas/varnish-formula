{% from "varnish/map.jinja" import varnish with context %}


include:
  - varnish


# This state ID is going to have just a "require" instead of a "watch"
# statement because of:
# a) the varnish service is defined as reload=true and to apply changes in
# this config file it's necessary a restart
# b) restart is potentually dangerous because it's deletes de cache, so it's
# preferrable to trigger an explicit restart
#
# As you probbaly know, to run a restart of the service you could use something
# like: salt 'varnish-node*' service.varnish restart
{{ varnish.config }}:
  file:
    - managed
    - source:
      - salt://varnish/files/{{ grains['id'] }}/etc/default/varnish.jinja
      - salt://varnish/files/default/etc/default/varnish.jinja
    - template: jinja
    - require:
      - pkg: varnish
    - require_in:
      - service: varnish


# Below we deploy the vcl files and we trigger a reload of varnish
{% for file in salt['pillar.get']('varnish:vcl:files', ['default.vcl']) %}
/etc/varnish/{{ file }}:
  file:
    - managed
    - source:
      - salt://varnish/files/{{ grains['id'] }}/etc/varnish/{{ file }}.jinja
      - salt://varnish/files/default/etc/varnish/{{ file }}.jinja
    - template: jinja
    - require:
      - pkg: varnish
    - watch_in:
      - service: varnish
{% endfor %}


# Below we delete the "absent" vcl files and we trigger a reload of varnish
{% for file in salt['pillar.get']('varnish:vcl:files_absent', []) %}
/etc/varnish/{{ file }}:
  file:
    - absent
    - require:
      - pkg: varnish
    - watch_in:
      - service: varnish
{% endfor %}
