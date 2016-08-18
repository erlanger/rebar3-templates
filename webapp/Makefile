.PHONY: test compile rel clean doc

compile: apptemplates
	@rebar3 compile

test:
	@rebar3 as test clean,compile,eunit

rel: apptemplates
	@if [ -d .git ]; then \
		rebar3 release; \
	else \
		echo "Release needs git repo to get version"; \
	fi

clean:
	@rebar3 clean

apptemplates: apps/{{name}}be/rebar.config apps/{{name}}fe/rebar.config


apps/{{name}}be/rebar.config:
		cd apps && rebar3 new lfeapp name={{name}}be

apps/{{name}}fe/rebar.config:
		cd apps && rebar3 new nitrogen name={{name}}fe

