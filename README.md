varnish-formula
===============

A simple saltstack formula to install and configure Varnish.

This formula has been developed distributing id and state declarations in
different files to make it usable in most situations. It should be useful in
scenarios ranging from a simple install of the packages (without any special
configuration) to a more complex set-up.

General customization strategies
================================

First, **see if providing pillar data is enough for your customization needs**
That's the recommended way and should be enough for most cases. See that
sometimes there's a key named `extra_conf` that's used to add arbitrary
configuration lines in the templates provided.

When providing pillar data is not enough for your needs, you can apply the
_Template Override and Files Switch_ (TOFS) pattern as described in the
documentation file `TOFS_pattern.md`.

.. note::

    Currently this formula supports Debian and RedHat os_family.

    See the full `Salt Formulas
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_ doc.

Available states
================

* [varnish](#varnish)
* [varnish.conf](#varnish.conf)
* [varnish.repo](#varnish.repo)

``varnish``
-----------

Installs the varnish package, and starts the associated varnish service.

``varnish.conf``
----------------

Configures the varnish package.

``varnish.repo``
----------------

Adds the varnish official repositories.

Next-generation, alternate approach
===================================
The following states provide an alternate approach to managing Varnish. Tested in Ubuntu 14/16 and CentOS 6/7.

* [varnish.ng](#varnish.ng)
* [varnish.ng.install](#varnish.ng.install)
* [varnish.ng.repo](#varnish.ng.repo)
* [varnish.ng.config](#varnish.ng.config)
* [varnish.ng.service](#varnish.ng.service)

``varnish.ng``
--------------
Meta-state for inclusion of all ng states.

``varnish.ng.install``
----------------------
Install varnish itself from custom-repo or stock-repo.

``varnish.ng.repo``
-------------------
Install the packagecloud.io varnish repo. Repos available can be found in [packagecloud.io](https://packagecloud.io/varnishcache)

``varnish.ng.config``
----------
Configure varnish (vcls and init files).

``varnish.ng.service``
-----------
Manage varnish and varnishncsa service.

Varnish NG considerations
=========================
Because of the different OSes with different init programs (ubuntu14 - init, ubuntu 16 - systemd, centos 6 - init, centos 7 - systemd), the following considerations must be taken into account:

* VCL files must be copied to minions using `salt://` (see [pillar.example](pillar.example) vcl section):

```yaml
varnish:
  ng:
    vcl:
      files:
        default:
          path: /etc/varnish/default.vcl
          source_path: salt://hostname/default.vcl.jinja
        mobile_detect:
          enabled: False
          path: /etc/varnish/mobile_detect.vcl
          source_path: salt://hostname/mobile_detect.vcl

```


* Config files (`/etc/default/varnish`, `/etc/sysconfig/varnish` or `/etc/varnish/varnish.params`) can be copied with `salt://` or just creating the variables in the `config_file` option:

```yaml
varnish:
  ng:
    config_source_path: salt://hostname/varnish.jinja
```

or

```yaml
varnish:
  ng:
    config_file:
      NFILES: "131072"
      MEMLOCK: "82000"
      NPROCS: "unlimited"
      RELOAD_VCL: "1"
      VARNISH_VCL_CONF: "/etc/varnish/default.vcl"
      VARNISH_LISTEN_PORT: "6081"
      VARNISH_ADMIN_LISTEN_ADDRESS: "127.0.0.1"
      VARNISH_ADMIN_LISTEN_PORT: "6082"
      VARNISH_SECRET_FILE: "/etc/varnish/secret"
      VARNISH_MIN_THREADS: "50"
      VARNISH_MAX_THREADS: "1000"
      VARNISH_STORAGE_SIZE: "100M"
      VARNISH_STORAGE: "malloc,${VARNISH_STORAGE_SIZE}"
      VARNISH_TTL: "120"
      DAEMON_OPTS: "-a ${VARNISH_LISTEN_ADDRESS}:${VARNISH_LISTEN_PORT} -f ${VARNISH_VCL_CONF} -T ${VARNISH_ADMIN_LISTEN_ADDRESS}:${VARNISH_ADMIN_LISTEN_PORT} -p thread_pool_min=${VARNISH_MIN_THREADS} -p thread_pool_max=${VARNISH_MAX_THREADS} -S ${VARNISH_SECRET_FILE} -s ${VARNISH_STORAGE}"
```

* In CentOS 6, it must be explicitely defined the `install_from_repo` option because in the CentOS 6 repos it is the 2 version:

```yaml
varnish:
  ng:
    lookup:
      repo: 'varnish41'
    install_from_repo: True
```

* For the Ubuntu 16 there is a problem regarding the usage of the systemd; there is no other way than editing the systemd varnish unit file to modify the init options (CentOS 7 has also systemd but there is the `varnish.params` to bypass the edition of the unit file directly). A little trick to automate this, is using the following pillar:

```yaml
varnish:
  ng:
    lookup:
      repo: 'varnish41'
      config: /etc/systemd/system/varnish.service
    config_source_path: salt://hostname/varnish-systemd
```

Being `varnish-systemd` the varnish systemd unit file:

```
[Unit]
Description=Varnish Cache, a high-performance HTTP accelerator

[Service]
Type=forking

# Maximum number of open files (for ulimit -n)
LimitNOFILE=131072

# Locked shared memory - should suffice to lock the shared memory log
# (varnishd -l argument)
# Default log size is 80MB vsl + 1M vsm + header -> 82MB
# unit is bytes
LimitMEMLOCK=85983232

# On systemd >= 228 enable this to avoid "fork failed" on reload.
#TasksMax=infinity

# Maximum size of the corefile.
LimitCORE=infinity

# Set WARMUP_TIME to force a delay in reload-vcl between vcl.load and vcl.use
# This is useful when backend probe definitions need some time before declaring
# configured backends healthy, to avoid routing traffic to a non-healthy backend.
#WARMUP_TIME=0

ExecStart=/usr/sbin/varnishd -a :6081 -T localhost:6082 -f /etc/varnish/default.vcl -S /etc/varnish/secret -s malloc,120m
ExecReload=/usr/share/varnish/reload-vcl

[Install]
WantedBy=multi-user.target
```

So you can edit and have the file managed by salt.
