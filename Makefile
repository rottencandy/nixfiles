############################################################################
#
#  Nix commands related to the local machine
#
############################################################################

UNAME := $(shell uname -s)

ifeq ($(UNAME),Linux)
	REBUILD_CMD := sudo nixos-rebuild
	GC_CMD := sudo nix store gc
endif
ifeq ($(UNAME),Darwin)
	REBUILD_CMD := darwin-rebuild
	GC_CMD := nix store gc
endif

switch:
	$(REBUILD_CMD) switch --flake .

check:
	$(REBUILD_CMD) check --flake .

debug:
	$(REBUILD_CMD) switch --flake . --show-trace --verbose

update:
	nix flake update

history:
	nix profile history --profile /nix/var/nix/profiles/system

optimise:
	nix store optimise

gc:
	# remove all generations older than 7 days
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

	# garbage collect all unused nix store entries
	$(GC_CMD)

	# sudo nix-collect-garbage -d
	# nix-collect-garbage -d
