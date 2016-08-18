.PHONY: test compile rel clean doc

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

run:
	@rebar3 run

include/wf.lfe: $(REBAR_DEPS_DIR)/nitrogen_core/include/wf.hrl
	./mkwf.lfe $(<D) $(@D)
