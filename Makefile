# a couple targets to assist in maintaining my vim setup
#
# Chris Weyl <cweyl@alumni.drew.edu> 2017

.PHONY: bootstrap

bootstrap:
	git -c log.showSignature=false subtree pull --prefix=bootstrap/vim-plug --squash https://github.com/junegunn/vim-plug.git master

