
TOFS: A pattern for using Saltstack
===================================

All that follows is a proposal based on my experience with `Saltstack <http://www.saltstack.com/>`_. The good thing of a piece of software like this is that you can "bend it" to suit your needs in many possible ways, and this is one of them. All the recommendations and thoughts are given "as it is" with no warranty of any type.  

Usage of values in pillar vs templates in file_roots
----------------------------------------------------

Among other functions, the *master* (or *salt-master*\ ) serves files to the *minions* (or *salt-minions*\ ). The `file_roots <http://docs.saltstack.com/en/latest/ref/file_server/file_roots.html>`_ is the list of directories used in sequence to find a file when a minion requires it: the first match is served to the minion. Those files could be `state files <http://docs.saltstack.com/en/latest/topics/tutorials/starting_states.html>`_ or configuration templates, among others.  

Using Saltstack is a simple and effective way to implement configuration management, but even in a `non multitenant <http://en.wikipedia.org/wiki/Multitenancy>`_ scenario, it's not a good idea to generally accesible some data (e.g. the database password in our `Zabbix <http://www.zabbix.com/>`_ server configuration file or the private key of our `Nginx <http://nginx.org/en/>`_ TLS certificate).

To avoid this situation we can use the `pillar mechanism <http://docs.saltstack.com/en/latest/topics/pillar/>`_\ , which is designed to provide a controlled access to data from the minions based on some selection rules. As pillar data could be easily integrated in the `Jinja <http://docs.saltstack.com/en/latest/topics/tutorials/pillar.html>`_ templates, it's a good mechanism to store values to be used in the final render of state files and templates.

There are a variety of approaches on usage of pillar and templates seen in `saltstack-formulas <https://github.com/saltstack-formulas>`_ repositories. `Some <https://github.com/saltstack-formulas/nginx-formula/pull/18>`_ `developments <https://github.com/saltstack-formulas/php-formula/pull/14>`_ stress the initial purpose of pillar data into an storage for most of possible variables for a determined system configuration. This, in my opinion, shifting too much load from the original template files approach. Adding up some `non-trivial Jinja <https://github.com/spsoit/nginx-formula/blob/81de880fe0276dd9488ffa15bc78944c0fc2b919/nginx/ng/files/nginx.conf>`_ code as essential part of composing the state file definitely makes Saltstack state files (hence formulas) more difficult to read. The extreme of this approach is that we could end up with a new render mechanism, implemented in Jinja, storing everything needed in pillar data to compose configurations. Additionally, we are establishing a strong dependency with the Jinja renderer. 

In opposition to the *put the code in file_roots and the data in pillars* approach, there is the *pillar as a store for a set of key-values* approach. A full-blown configuration file abstracted in pillar and jinja is complicated to develop, understand and maintain. I think a better and simpler approach is to keep a configuration file templated using just a basic (non-extensive but extensible) set of pillar values.

On reusability of Saltstack state files
---------------------------------------

There's a brilliant initiative of the Saltstack community called `salt-formulas <https://github.com/saltstack-formulas>`_. The goal is to provide state files, pillar examples and configuration templates ready to be used for provisioning. I'm a contributor or two small ones: `zabbix-formula <https://github.com/saltstack-formulas/zabbix-formula>`_ and `varnish-formula <https://github.com/saltstack-formulas/varnish-formula>`_.

The `design guidelines <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_ for formulas are clear in many aspects and it's a recommended reading for anyone willing to write state files, even non-formulaic ones.

In the next section I'm going to describe my proposal to extend even further the reusability of formulas, suggesting some patterns of usage.

The Template Override and Files Switch (TOFS) pattern
-----------------------------------------------------

I understand a formula as a **complete, independent set of Saltstack state and configuration template files sufficient to configure a system**. A system could be something as simple as a ntp server or some other much more complex service that requires many state and configuration template files.

The customization of a formula should be done mainly by providing pillar data used later to render either the state or the configuration template files. 

Let's work with the NTP example. A basic formula that follows the `design guidelines <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_ has the following files and directories tree:

.. code-block:: console

   /srv/saltstack/salt-formulas/ntp-saltstack-formula/
     ntp/
       map.jinja
       init.sls
       conf.sls
       files/
         default/
           etc/
             ntp.conf.jinja

In order to use it, let's assume a `masterless configuration <http://docs.saltstack.com/en/latest/topics/tutorials/quickstart.html>`_ and this relevant section of ``/etc/salt/minion``\ :

.. code-block:: yaml

   pillar_roots:
     base:
       - /srv/saltstack/pillar
   file_client: local
   file_roots:
     base:
       - /srv/saltstack/salt
       - /srv/saltstack/salt-formulas/ntp-saltstack-formula

.. code-block:: jinja

   ## /srv/saltstack/salt-formulas/ntp-saltstack-formula/ntp/map.jinja
   {% set ntp = salt['grains.filter_by']({
     'default': {
       'pkg': 'ntp',
       'service': 'ntp'
       'config': '/etc/ntp.conf'
     }
   }, merge=salt['pillar.get']('ntp:lookup')) %}

In ``init.sls`` we have the minimal states required to have NTP configured. In many cases ``init.sls`` is almost equivalent to a ``apt-get install`` or a ``yum install`` of the package.

.. code-block:: sls

   ## /srv/saltstack/salt-formulas/ntp-saltstack-formula/ntp/init.sls
   ntp:
     pkg:
       - installed
       - name: {{ ntp.pkg }}
     service:
       - running
       - name: {{ ntp.service }}
       - enabled: True
       - require:
         - pkg: ntp

In ``conf.sls`` we have the configuration states. In most cases that is just managing configuration file templates and making them be watched by the service.

.. code-block:: sls

   ## /srv/saltstack/salt-formulas/ntp-saltstack-formula/ntp/conf.sls
   include:
     - ntp

   {{ ntp.conf }}:
     file:
       - managed
       - template jinja
       - source: salt://ntp/files/default/etc/ntp.conf.jinja
       - watch_in:
         - service: ntp
       - require:
         - pkg: ntp

Under ``files/default`` there's an structure that mimics the one in the minion in order to avoid clashes and confusion on where to put the needed templates. There you can find a mostly standard template for configuration file.

.. code-block:: jinja

   ## /srv/saltstack/salt-formulas/ntp-saltstack-formula/ntp/files/default/etc/ntp.conf.jinja
   # Managed by saltstack
   # Edit pillars or override this template in saltstack if you need customization
   {% set settings = salt['pillar.get']('ntp', {}) %}
   {% set default_servers = ['0.ubuntu.pool.ntp.org',
                             '1.ubuntu.pool.ntp.org',
                             '2.ubuntu.pool.ntp.org',
                             '3.ubuntu.pool.ntp.org']}

   driftfile /var/lib/ntp/ntp.drift
   statistics loopstats peerstats clockstats
   filegen loopstats file loopstats type day enable
   filegen peerstats file peerstats type day enable
   filegen clockstats file clockstats type day enable

   {% for server in settings.get('servers', default_servers) %}
   server {{ server }}
   {% endfor %}

   restrict -4 default kod notrap nomodify nopeer noquery
   restrict -6 default kod notrap nomodify nopeer noquery

   restrict 127.0.0.1
   restrict ::1

With all this, it's easy to install and configure a simple NTP server just running ``salt-call state.sls ntp.conf``\ : the package will be installed, the service will be running and the configuration should be correct for most of cases, even without pillar data.

Alternatively you can define a highstate in ``/srv/saltstack/salt/top.sls`` and run ``salt-call state.highstate``.

.. code-block:: sls

   ## /srv/saltstack/salt/top.sls
   base:
     '*':
       - ntp.conf

**Customizing the formula just with pillar data** we have the option to define the NTP servers.

.. code-block:: sls

   ## /srv/saltstack/pillar/top.sls
   base:
     '*':
       - ntp

.. code-block:: sls

   ## /srv/saltstack/pillar/ntp.sls
   ntp:
     servers:
       - 0.ch.pool.ntp.org
       - 1.ch.pool.ntp.org
       - 2.ch.pool.ntp.org
       - 3.ch.pool.ntp.org

Template Override
^^^^^^^^^^^^^^^^^

If the customization based on pillar data is not enough, we can override the template creating a new one in ``/srv/saltstack/salt/ntp/files/default/etc/ntp.conf.jinja``

.. code-block:: jinja

   ## /srv/saltstack/salt/ntp/files/default/etc/ntp.conf.jinja
   # Managed by saltstack
   # Edit pillars or override this template in saltstack if you need customization

   # Some bizarre configurations here
   # ... 

   {% for server in settings.get('servers', default_servers) %}
   server {{ server }}
   {% endfor %}

This way we are localy **overriding the template files** offered by the formula in order to make a more complex adaptation. Of course, this could be applied as well to any of the files, including the state files.

Files Switch
^^^^^^^^^^^^

To bring some order into the set of template files included in a formula, as we commented, we suggest have a similar structure to a normal final file system under ``files/default``.

We can make coexist different templates for different minions, classified by any `grain <http://docs.saltstack.com/en/latest/topics/targeting/grains.html>`_ value, just creating new directories under ``files``. This mechanism is based in **using values of some grains as a switch for the directories under ``files/``\ **.

If we decide that we want ``os_family`` as switch, then we could provide with the formula template variants for ``RedHat`` and ``Debian`` families.

.. code-block:: console

   /srv/saltstack/salt-formulas/ntp-saltstack-formula/ntp/files/
     default/
       etc/
         ntp.conf.jinja
     RedHat/
       etc/
         ntp.conf.jinja
     Debian/
       etc/
         ntp.conf.jinja

To make this work we need a ``conf.sls`` state file that takes a list of possible files as configuration template.

.. code-block:: sls

   ## /srv/saltstack/salt-formulas/ntp-saltstack-formula/ntp/conf.sls
   include:
     - ntp

   {{ ntp.conf }}:
     file:
       - managed
       - template jinja
       - source: 
         - salt://ntp/files/{{ grains.get('os_family', 'default') }}/etc/ntp.conf.jinja
         - salt://ntp/files/default/etc/ntp.conf.jinja
       - watch_in:
         - service: ntp
       - require:
         - pkg: ntp

If we want to cover the possibility of a special template for a minion identified by ``node01`` then we could have a specific template in ``/srv/saltstack/salt/ntp/files/node01/etc/ntp.conf.jinja``.

.. code-block:: jinja

   ## /srv/saltstack/salt/ntp/files/node01/etc/ntp.conf.jinja
   # Managed by saltstack
   # Edit pillars or override this template in saltstack if you need customization

   # Some crazy configurations here for node01
   # ...

To make this work we could write a specially crafted ``conf.sls``.

.. code-block:: sls

   ## /srv/saltstack/salt-formulas/ntp-saltstack-formula/ntp/conf.sls
   include:
     - ntp

   {{ ntp.conf }}:
     file:
       - managed
       - template jinja
       - source: 
         - salt://ntp/files/{{ grains.get('id') }}/etc/ntp.conf.jinja
         - salt://ntp/files/{{ grains.get('os_family') }}/etc/ntp.conf.jinja
         - salt://ntp/files/default/etc/ntp.conf.jinja
       - watch_in:
         - service: ntp
       - require:
         - pkg: ntp

The generalization of this comes with the usage of the macro ``files_switch`` in all ``source`` parameters for the ``file.managed`` function.

.. code-block:: jinja

   ## /srv/saltstack/salt-formulas/ntp-saltstack-formula/ntp/macros.jinja
   {%- macro files_switch(prefix, 
                          files,
                          default_files_switch=['id', 'os_family'],
                          indent_width=6) %}
     {#
       Returns a valid value for the "source" parameter of a "file.managed"
       state function. This makes easier the usage of the Template Override and
       Files Switch (TOFS) pattern.

       Params:
         * prefix: basename of the formula to be used as directory prefix
         * files: ordered list of files to look for, with full path
         * default_files_switch: if there's no pillar 'prefix:files_switch'
           this is the ordered list of grains to use as selector switch of the
           directories under "prefix/files"
         * indent_witdh: indentation of the result value to conform to YAML

       Example:

       If we have a state:

         /etc/xxx/xxx.conf:
           file:
             - managed
             - source: {{ files_switch('xxx', ['/etc/xxx/xxx.conf',
                                               '/etc/xxx/xxx.conf.jinja']) }}
             - template: jinja

       In a minion with id=theminion and os_family=RedHat, it's going to be
       rendered as:

         /etc/xxx/xxx.conf:
           file:
             - managed
             - source:
               - salt://xxx/files/theminion/etc/xxx/xxx.conf
               - salt://xxx/files/theminion/etc/xxx/xxx.conf.jinja
               - salt://xxx/files/RedHat/etc/xxx/xxx.conf
               - salt://xxx/files/RedHat/etc/xxx/xxx.conf.jinja
               - salt://xxx/files/default/etc/xxx/xxx.conf
               - salt://xxx/files/default/etc/xxx/xxx.conf.jinja
     #}
     {%- set files_switch_list = salt['pillar.get'](prefix ~ ':files_switch',
                                              default_files_switch) %}
     {%- for grain in files_switch_list if grains.get(grain) is defined %}
       {%- for file in files %}
       {%- set url = '- salt://' ~ prefix ~ '/files/' ~
                     grains.get(grain) ~ file %}
   {{ url | indent(indent_width, true) }}
       {%- endfor %}  
     {%- endfor %}
       {%- for file in files %}
       {%- set url = '- salt://' ~ prefix ~ '/files/default' ~ file %}
   {{ url | indent(indent_width, true) }}
       {%- endfor %}  
   {%- endmacro %}
