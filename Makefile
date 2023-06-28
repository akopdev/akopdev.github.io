.NOTPARALLEL: ;          # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell
.PHONY: all 			 			 # All targets are accessible for user
.DEFAULT: help 			 		 # Running Make will run the help target

# -------------------------------------------------------------------------------------------------
# help: @ List available tasks on this project
# -------------------------------------------------------------------------------------------------
help:
	@grep -oE '^#.[a-zA-Z0-9]+:.*?@ .*$$' $(MAKEFILE_LIST) | tr -d '#' |\
	awk 'BEGIN {FS = ":.*?@ "}; {printf "  make%-10s%s\n", $$1, $$2}'

init:
	@git submodule update --init --recursive

# -------------------------------------------------------------------------------------------------
# update @ Update theme and all dependencies
# -------------------------------------------------------------------------------------------------
update: init
	@git submodule update --recursive --remote
	 
# -------------------------------------------------------------------------------------------------
# server: @ Run a high performance webserver with example site
# -------------------------------------------------------------------------------------------------
server: init
	@hugo server --disableFastRender

