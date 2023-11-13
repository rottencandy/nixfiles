############################################################################
#
#  Nix commands related to the local machine
#
############################################################################

deploy:
	darwin-rebuild switch --flake .

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
