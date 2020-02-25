BASEDIR = $(shell pwd)
REBAR = rebar3
RELPATH = _build/default/rel/messenger
PRODRELPATH = _build/prod/rel/messenger
DEV1RELPATH = _build/dev1/rel/messenger
DEV2RELPATH = _build/dev2/rel/messenger
DEV3RELPATH = _build/dev3/rel/messenger
APPNAME = messenger
SHELL = /bin/bash

release:
	$(REBAR) release
	mkdir -p $(RELPATH)/../messenger_config
	[ -f $(RELPATH)/../messenger_config/messenger.conf ] || cp $(RELPATH)/etc/messenger.conf  $(RELPATH)/../messenger_config/messenger.conf
	[ -f $(RELPATH)/../messenger_config/advanced.config ] || cp $(RELPATH)/etc/advanced.config  $(RELPATH)/../messenger_config/advanced.config

console:
	cd $(RELPATH) && ./bin/messenger console

prod-release:
	$(REBAR) as prod release
	mkdir -p $(PRODRELPATH)/../messenger_config
	[ -f $(PRODRELPATH)/../messenger_config/messenger.conf ] || cp $(PRODRELPATH)/etc/messenger.conf  $(PRODRELPATH)/../messenger_config/messenger.conf
	[ -f $(PRODRELPATH)/../messenger_config/advanced.config ] || cp $(PRODRELPATH)/etc/advanced.config  $(PRODRELPATH)/../messenger_config/advanced.config

prod-console:
	cd $(PRODRELPATH) && ./bin/messenger console

compile:
	$(REBAR) compile

clean:
	$(REBAR) clean

test:
	$(REBAR) ct

devrel1:
	$(REBAR) as dev1 release
	mkdir -p $(DEV1RELPATH)/../messenger_config
	[ -f $(DEV1RELPATH)/../messenger_config/messenger.conf ] || cp $(DEV1RELPATH)/etc/messenger.conf  $(DEV1RELPATH)/../messenger_config/messenger.conf
	[ -f $(DEV1RELPATH)/../messenger_config/advanced.config ] || cp $(DEV1RELPATH)/etc/advanced.config  $(DEV1RELPATH)/../messenger_config/advanced.config

devrel2:
	$(REBAR) as dev2 release
	mkdir -p $(DEV2RELPATH)/../messenger_config
	[ -f $(DEV2RELPATH)/../messenger_config/messenger.conf ] || cp $(DEV2RELPATH)/etc/messenger.conf  $(DEV2RELPATH)/../messenger_config/messenger.conf
	[ -f $(DEV2RELPATH)/../messenger_config/advanced.config ] || cp $(DEV2RELPATH)/etc/advanced.config  $(DEV2RELPATH)/../messenger_config/advanced.config

devrel3:
	$(REBAR) as dev3 release
	mkdir -p $(DEV3RELPATH)/../messenger_config
	[ -f $(DEV3RELPATH)/../messenger_config/messenger.conf ] || cp $(DEV3RELPATH)/etc/messenger.conf  $(DEV3RELPATH)/../messenger_config/messenger.conf
	[ -f $(DEV3RELPATH)/../messenger_config/advanced.config ] || cp $(DEV3RELPATH)/etc/advanced.config  $(DEV3RELPATH)/../messenger_config/advanced.config

devrel: devrel1 devrel2 devrel3

dev1-attach:
	$(BASEDIR)/_build/dev1/rel/messenger/bin/$(APPNAME) attach

dev2-attach:
	$(BASEDIR)/_build/dev2/rel/messenger/bin/$(APPNAME) attach

dev3-attach:
	$(BASEDIR)/_build/dev3/rel/messenger/bin/$(APPNAME) attach

dev1-console:
	$(BASEDIR)/_build/dev1/rel/messenger/bin/$(APPNAME) console

dev2-console:
	$(BASEDIR)/_build/dev2/rel/messenger/bin/$(APPNAME) console

dev3-console:
	$(BASEDIR)/_build/dev3/rel/messenger/bin/$(APPNAME) console

devrel-clean:
	rm -rf _build/dev*/rel

devrel-start:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/messenger/bin/$(APPNAME) start; done

devrel-join:
	for d in $(BASEDIR)/_build/dev{2,3}; do $$d/rel/messenger/bin/$(APPNAME)-admin cluster join messenger1@127.0.0.1; done

devrel-cluster-plan:
	$(BASEDIR)/_build/dev1/rel/messenger/bin/$(APPNAME)-admin cluster plan

devrel-cluster-commit:
	$(BASEDIR)/_build/dev1/rel/messenger/bin/$(APPNAME)-admin cluster commit

devrel-status:
	$(BASEDIR)/_build/dev1/rel/messenger/bin/$(APPNAME)-admin member-status

devrel-ping:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/messenger/bin/$(APPNAME) ping; true; done

devrel-stop:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/messenger/bin/$(APPNAME) stop; true; done

start:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) start

stop:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) stop

attach:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) attach

