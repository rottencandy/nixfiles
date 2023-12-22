############################################################################
#
#  Nix commands related to the local machine
#
############################################################################

UNAME := $(shell uname -s)

ifeq ($(UNAME),Linux)
	SWITCH_CMD := sudo nixos-rebuild switch --flake .
	CHECK_CMD := sudo nixos-rebuild check --flake .
	GC_CMD := sudo nix store gc
endif
ifeq ($(UNAME),Darwin)
	SWITCH_CMD := darwin-rebuild switch --flake .
	CHECK_CMD := darwin-rebuild check --flake .
	GC_CMD := nix store gc
endif

switch:
	$(SWITCH_CMD)

check:
	$(CHECK_CMD)

debug:
	$(SWITCH_CMD) --show-trace --verbose

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
