===============
varnish-formula
===============

A simple saltstack formula to install and configure Varnish.
Currently it supports Debian and RedHat os_family.

This formula has been developed distributing id and state declarations in
different files to make it usable in most situations. It should be useful from
scenarios with a simple install of the package (without any special
configuration) to a more complex set-up.

Any special needs could be addressed forking the formula repo, even in-place at
the server acting as master. I'm trying to keep this as general as possible and
further general improvements would be added.

The ``files`` directory is structured using a ``default`` root and
optional ``<minion-id>`` directories:

.. code:: asciidoc

    files
      |-- default
      |        |-- etc
      |        |    |-- foo.conf
      |        |    `-- bar.conf
      |        `-- usr/share/thingy/*
      `-- <minion-id>
              |-- etc
              |    |-- foo.conf
              |    `-- bar.conf
              `-- usr/share/thingy/*

This way we have certain flexibility to use different files for different
minions. **It's not designed to substitute pillar data**. Remember that
pillar has to be used for info that it's essential to be only known for a
certain set of minions (i.e. passwords, private keys and such).

.. note::

    See the full `Salt Formulas
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_ doc.

Available states
================

.. contents::
    :local:

``varnish``
-----------

Installs the varnish package, and starts the associated varnish service.

``varnish.conf``
----------------

Configures the varnish package.

``varnish.repo``
----------------

Adds the varnish official repositories.
