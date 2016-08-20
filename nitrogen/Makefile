.PHONY: test compile rel clean doc run vmargs

compile:
	@rebar3 compile

rel:
	@if [ -d .git ]; then \
		rebar3 release; \
	else \
		echo "Release needs git repo to get version"; \
	fi

clean:
	@rebar3 clean

run: vmargs
	@rebar3 run

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

include/wf.lfe: $(REBAR_DEPS_DIR)/nitrogen_core/include/wf.hrl
	./mkwf.lfe $(<D) $(@D)
