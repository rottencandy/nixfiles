############################################################################
#
#  Nix commands related to the local machine
#
############################################################################

UNAME := $(shell uname -s)

ifeq ($(UNAME),Linux)
	SWITCH_CMD := sudo nixos-rebuild switch --flake .
endif
ifeq ($(UNAME),Darwin)
	SWITCH_CMD := darwin-rebuild switch --flake .
endif

switch:
	$(SWITCH_CMD)

debug:
	darwin-rebuild switch --flake . --show-trace --verbose

update:
	nix flake update

history:
	nix profile history --profile /nix/var/nix/profiles/system

gc:
	# remove all generations older than 7 days
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

	# garbage collect all unused nix store entries
	nix store gc
