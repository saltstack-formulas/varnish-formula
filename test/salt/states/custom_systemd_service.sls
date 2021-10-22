# This state is used to prepare the environment for formula testing

# Currently only required on Arch Linux, ensure the service starts without
# failure, by removing `localhost` from `localhost:8443` in the `ExecStart`

{%- set sls_config_file = 'varnish.ng.config' %}
{%- set service_file = {
      'Arch':   '/usr/lib/systemd/system/varnish.service',
    }.get(grains.os, '') %}

test-salt-states-custom-systemd-service-file-replace:
  file.replace:
    - name: {{ service_file }}
    - pattern: '-a localhost:8443,PROXY'
    - repl: '-a :8443,PROXY'
    - show_changes: True
    - require:
      - sls: {{ sls_config_file }}

test-salt-states-custom-systemd-service-cmd-wait:
  cmd.wait:
    - name: systemctl daemon-reload
    - runas: root
    - watch:
      - file: test-salt-states-custom-systemd-service-file-replace
    - require_in:
      - service: varnish.service
