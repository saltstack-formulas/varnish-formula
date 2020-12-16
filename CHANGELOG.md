# Changelog

## [0.4.1](https://github.com/saltstack-formulas/varnish-formula/compare/v0.4.0...v0.4.1) (2020-12-16)


### Continuous Integration

* **gemfile.lock:** add to repo with updated `Gemfile` [skip ci] ([aa44607](https://github.com/saltstack-formulas/varnish-formula/commit/aa44607c746bf34dbe0acdfc3c92677fa5830b9c))
* **gitlab-ci:** use GitLab CI as Travis CI replacement ([e3f575e](https://github.com/saltstack-formulas/varnish-formula/commit/e3f575e5bdd86d836ab987b3d852ddcfb799f298))
* **kitchen:** use `saltimages` Docker Hub where available [skip ci] ([54cb631](https://github.com/saltstack-formulas/varnish-formula/commit/54cb631ff2ee17e7f9fac5b7d787a321a6da8036))
* **kitchen+travis:** add new platforms [skip ci] ([31346ee](https://github.com/saltstack-formulas/varnish-formula/commit/31346ee139840f1f87e0b08eb3a927b4c5e41538))
* **kitchen+travis:** adjust matrix to add `3000.2` & remove `2018.3` [skip ci] ([cb7c4be](https://github.com/saltstack-formulas/varnish-formula/commit/cb7c4be885eabe3445c89bab5be13ff31c02ddb6))
* **kitchen+travis:** adjust matrix to add `3000.3` [skip ci] ([66bdad3](https://github.com/saltstack-formulas/varnish-formula/commit/66bdad362704f445da917e4c0c5065a42ce4277e))
* **kitchen+travis:** adjust matrix to update `3000` to `3000.1` [skip ci] ([7a36cb1](https://github.com/saltstack-formulas/varnish-formula/commit/7a36cb10f83f235de351fdb7cb20b4de56ea379c))
* **kitchen+travis:** remove `master-py2-arch-base-latest` [skip ci] ([5899312](https://github.com/saltstack-formulas/varnish-formula/commit/589931284b5b0e3e4dc48fb01e85a35bd3a4b684))
* **pre-commit:** add to formula [skip ci] ([67c5b5a](https://github.com/saltstack-formulas/varnish-formula/commit/67c5b5a721bad0f0b5e889be1050d829b9a2b42e))
* **pre-commit:** enable/disable `rstcheck` as relevant [skip ci] ([a96852d](https://github.com/saltstack-formulas/varnish-formula/commit/a96852d95f0e363293a529efcc1a5097daf320ed))
* **pre-commit:** finalise `rstcheck` configuration [skip ci] ([ea962cf](https://github.com/saltstack-formulas/varnish-formula/commit/ea962cf93a65a501f218389d16d60c29c2db1fc1))
* **travis:** add notifications => zulip [skip ci] ([fd320d6](https://github.com/saltstack-formulas/varnish-formula/commit/fd320d64bf4ff53f7c6b611cd8277c61a5e8f732))
* **workflows/commitlint:** add to repo [skip ci] ([5288992](https://github.com/saltstack-formulas/varnish-formula/commit/5288992aa7b7bc4d467d52a561b1688e94533aaf))


### Documentation

* **readme:** fix `rstcheck` violation [skip ci] ([e829357](https://github.com/saltstack-formulas/varnish-formula/commit/e829357313727f80a7a061994d6396283538fe47)), closes [/travis-ci.org/github/myii/varnish-formula/builds/731609027#L259](https://github.com//travis-ci.org/github/myii/varnish-formula/builds/731609027/issues/L259)

# [0.4.0](https://github.com/saltstack-formulas/varnish-formula/compare/v0.3.0...v0.4.0) (2020-04-01)


### Continuous Integration

* **gemfile:** restrict `train` gem version until upstream fix [skip ci] ([b94e9c2](https://github.com/saltstack-formulas/varnish-formula/commit/b94e9c21087ace76489710fd4ddfc89c59b9064c))
* **kitchen:** avoid using bootstrap for `master` instances [skip ci] ([788dd7b](https://github.com/saltstack-formulas/varnish-formula/commit/788dd7bc3ae0192d1adaddb729915344918cc638))
* **kitchen+travis:** adjust matrix to add `3000` & remove `2017.7` ([3ebb354](https://github.com/saltstack-formulas/varnish-formula/commit/3ebb3542cb7d597358fbacd936dbd1514472948d))
* **travis:** quote pathspecs used with `git ls-files` [skip ci] ([bcbf380](https://github.com/saltstack-formulas/varnish-formula/commit/bcbf380bf415e29ebee1071530641c133aec1041))
* **travis:** run `shellcheck` during lint job [skip ci] ([729e850](https://github.com/saltstack-formulas/varnish-formula/commit/729e85013cbc4d7dc4b09952f4ea77f27fac6b52))
* **travis:** use `major.minor` for `semantic-release` version [skip ci] ([4b8c25b](https://github.com/saltstack-formulas/varnish-formula/commit/4b8c25bbdd2ef64a3ed193096e4763f7c276457f))


### Features

* **ng:** add `retry_options` to fix installation on `centos-8` ([90bd91c](https://github.com/saltstack-formulas/varnish-formula/commit/90bd91c43f98a82df025fb73a34c12c2f6c26b1e))

# [0.3.0](https://github.com/saltstack-formulas/varnish-formula/compare/v0.2.0...v0.3.0) (2019-11-25)


### Bug Fixes

* **ng:** fix config for Amazon Linux 2 ([98a176c](https://github.com/saltstack-formulas/varnish-formula/commit/98a176c96872bd1abe448b9ca6c8c85d33415cfe))
* **ng:** fix config for Arch Linux ([aac3789](https://github.com/saltstack-formulas/varnish-formula/commit/aac37897a897e63df65e1d94e452e78387b90cbb))
* **ng:** fix config for CentOS 8 ([faf6958](https://github.com/saltstack-formulas/varnish-formula/commit/faf695887affe497fa1edce318707564d0a2931c))
* **ng:** fix config for Fedora 30 & 31 ([9ddbcd5](https://github.com/saltstack-formulas/varnish-formula/commit/9ddbcd5944d02cee4b6ad07c9d8e58d6e50f5378))
* **ng:** fix config for OpenSuse Leap 15.1 ([ca8797c](https://github.com/saltstack-formulas/varnish-formula/commit/ca8797c811aadc3f8d059b9895f0ae48a2a861a8))
* **ng/default.vcl:** add new template for `ng` ([a3ed404](https://github.com/saltstack-formulas/varnish-formula/commit/a3ed40478c900db640c50a8b39391f0cd30e97b9))
* **ng/repo.sls:** add inline EPEL repo configuration ([e593d92](https://github.com/saltstack-formulas/varnish-formula/commit/e593d9231d769d63043b5e2fd996a3f77bdf16b0))
* **ng/repo.sls:** ensure required Debian packages are installed ([c5fb7fe](https://github.com/saltstack-formulas/varnish-formula/commit/c5fb7feaf20d80d2d10de0e0c3fddd0f800451a1))
* **ng/services.sls:** ensure logging service waits for main service ([c30dccf](https://github.com/saltstack-formulas/varnish-formula/commit/c30dccf76d971654893f3ad870cda7008ecac1cf))
* **salt-lint:** fix all errors ([b0df59d](https://github.com/saltstack-formulas/varnish-formula/commit/b0df59d5a9500b769e209e3d7eb4276dd27af260))
* **yamllint:** fix all errors ([79ed36b](https://github.com/saltstack-formulas/varnish-formula/commit/79ed36b2e947bf0acb3e496211fe84d67a26fa18))


### Documentation

* **readme:** convert from `md` => `rst` ([de88a39](https://github.com/saltstack-formulas/varnish-formula/commit/de88a39fd3b3d6180508eda2a9848364b5826484))
* **readme:** modify according to standard structure ([0f954ce](https://github.com/saltstack-formulas/varnish-formula/commit/0f954cec93ce3521894d0088ae5e653a01f95c7d))
* move `README` and `TOFS_pattern` to `docs` sub-directory ([2d38bb5](https://github.com/saltstack-formulas/varnish-formula/commit/2d38bb5bea6077d9539ec109362605681e3069da))


### Features

* **semantic-release:** implement for this formula ([f6edbba](https://github.com/saltstack-formulas/varnish-formula/commit/f6edbba42156a858da219d8fe6348879ce7b0029))


### Tests

* **pillars:** provide test pillars and updated `pillar.example` ([63881e8](https://github.com/saltstack-formulas/varnish-formula/commit/63881e8645f4285b69586996f6850c5ccb550868))
