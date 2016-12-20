/etc/systemd/system/varnish.service.d/customexec.conf:
  file.managed:
    - contents: |
        [Service]
        ExecStart=
        ExecStart=/usr/sbin/varnishd -a {{ salt['pillar.get']('varnish:listen', ':6081')}} -T localhost:6082 -f /etc/varnish/default.vcl -S /etc/varnish/secret -s malloc,1G
    - makedirs: True

varnish-service:
  service.running:
    - name: varnish
    - enable: true
    - reload: true
