.PHONY: test compile rel clean doc run vmargs

compile: apptemplates
	@rebar3 compile

test: apptemplates
	@rebar3 as test clean,compile,eunit

rel: apptemplates
	@if [ -d .git ]; then \
		rebar3 release; \
	else \
		echo "Release needs git repo to get version"; \
	fi

run: apptemplates vmargs
	@rebar3 run


clean:
	@rebar3 clean
	@find . -name '*~' -printf " '%30P' deleted\n" -delete
	@rm -f rebar3.crashdump

apptemplates: apps/{{name}}be/rebar.config apps/{{name}}fe/rebar.config


vmargs:
	@IPADDR=`ip addr show | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | \
		       grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`; \
				 if grep -q '127.0.0.1' config/vm.args; then \
				    sed -ie "s/@127.0.0.1/@$$IPADDR/" config/vm.args; \
					 echo "-------------------------------------------------";\
					 echo "Updated config/vm.args with ip addr $$IPADDR"; \
					 echo "-------------------------------------------------";\
					 sleep 3; \
				 fi

apps/{{name}}be/rebar.config:
		cd apps && rebar3 new lfeapp name={{name}}be

apps/{{name}}fe/rebar.config:
		cd apps && rebar3 new nitrogen name={{name}}fe

