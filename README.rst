===============
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

.. contents::
    :local:

``varnish``
-----------

Installs the varnish package, and starts the associated varnish service.

``varnish.conf``
----------------

Configures the varnish package.

``varnish.systemd``
-------------------

Customizes systemd for changing the port varnish listens on.


``varnish.repo``
----------------

Adds the varnish official repositories.
