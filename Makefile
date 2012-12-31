all: lint stats

lint:
	@find bin install.sh -type f -exec egrep -l '^#!/.+(bash|sh)' {} \; \
		| while read file ; do \
			echo "linting $$file" ; \
			bash -n $$file || exit 1; \
		done

stats:
	@echo && ruby contrib/stats.rb '{bin/**/*,install.sh}'
