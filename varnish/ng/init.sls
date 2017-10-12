# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "varnish/ng/map.jinja" import varnish_settings with context %}

include:
{% if 'install_from_repo' in varnish_settings and varnish_settings.install_from_repo %}
    - varnish.ng.repo
{% endif %}
    - varnish.ng.install
    - varnish.ng.config
    - varnish.ng.service
