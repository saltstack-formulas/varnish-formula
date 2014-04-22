================
varnish-formula
================

A simple saltstack formula to install and configure Varnish.
Currently it supports Debian and RedHat os_family.

.. note::

    See the full `Salt Formulas
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_ doc.

Available states
================

.. contents::
    :local:

``varnish``
------------

Installs the varnish package, and starts the associated varnish service.

``conf``
------------

Configures the varnish package.

``repo``
------------

Adds the varnish official repositories.
