#-*- mode: makefile; -*-

MANAGED_FILES = \
    Makefile.txt \
    git.mk \
    help.mk \
    update.mk \
    upgrade.mk \
    version.mk \
    perl.mk \
    release-notes.mk \
    modulino.tmpl

BOOTSTRAPPER_DIST_DIR := $(shell perl -MFile::ShareDir=dist_dir \
    -e 'print dist_dir(q{CPAN-Maker-Bootstrapper})' 2>/dev/null)

.PHONY: update

INCLUDES_DIR = .includes

update: ## update managed project files from the installed bootstrapper
	@mkdir -p $(INCLUDES_DIR); \
	for f in $(MANAGED_FILES); do \
	  src="$(BOOTSTRAPPER_DIST_DIR)/$$f"; \
	  test -e "$$src" || continue; \
	  cp "$$src" "$(INCLUDES_DIR)/$$f"; \
	  chmod -w "$(INCLUDES_DIR)/$$f"; \
	done; \
	cp "$(BOOTSTRAPPER_DIST_DIR)/Makefile.txt" Makefile.txt; \
	mv Makefile.txt Makefile; \
	echo "Files updated. Review changes with: git diff"
