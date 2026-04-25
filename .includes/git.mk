#-*- mode: makefile; -*-

PERL_MODULES_IN = $(PERL_MODULES:.pm=.pm.in)
BIN_FILES_IN = $(BIN_FILES:=.in)

RECOMMENDED_ARTIFACTS = \
     Makefile \
     $(PERL_MODULES_IN) \
     $(BIN_FILES_IN) \
     $(TESTS) \
     ChangeLog \
     buildspec.yml \
     VERSION \
     requires \
     test-requires \
     .gitignore \
     .includes/ \
     .prompts/

.PHONY: git
git: ## initializes a git repository and commits the recommended artifacts
	git init -b main; \
	for f in $(RECOMMENDED_ARTIFACTS); do \
	  if test -e "$$f" || test -d "$$f"; then \
	    git add "$$f"; \
	  fi; \
	done; \
	git commit -m 'BigBang'

