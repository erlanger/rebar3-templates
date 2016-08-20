.PHONY: test compile rel clean doc run vmargs

compile:
	@rebar3 compile

test:
	@rebar3 as test clean,compile
	@erl -pa _build/test/lib/**/ebin -cwd "`pwd`" -eval \
		"case 'ltest-runner':all() of ok -> halt(0); _ -> halt(127) end" \
		-noshell

rel:
	@if [ -d .git ]; then \
		rebar3 release; \
	else \
		echo "Release needs git repo to get version"; \
	fi

clean:
	@rebar3 clean

doc:
	@rebar3 lfe lodox

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

