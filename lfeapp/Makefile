.PHONY: test compile rel clean doc

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



