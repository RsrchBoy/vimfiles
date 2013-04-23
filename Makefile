# Makefile -- install and otherwise manipulate our vim configuration
#
# Chris Weyl <cweyl@alumni.drew.edu> 2013

fonts::
	@ echo '# ensuring fonts...'
	mkdir ~/.fonts ||:
	cd ~/.fonts && test -e Inconsolata-dz-Powerline.otf || ln -s ../.vim/powerline/fonts/Inconsolata-dz-Powerline.otf

dotfiles::
	@echo '# setting up dotfiles...'
	cd && test -e .gitconfig || ln -s .vim/dotfiles/gitconfig .gitconfig
	cd && touch .gitconfig.local && chmod 0600 .gitconfig.local

install:: fonts dotfiles
	@echo '# Setting up .vimrc, etc....'
	cd && test -e .vimrc || ln -s .vim/vimrc .vimrc
	touch ~/.vimrc.local
	chmod 0600 ~/.vimrc.local