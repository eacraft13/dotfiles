#!/bin/bash

# XCode
xcode-select --install

# Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Brew
brew upgrade && brew cleanup && brew doctor
brew install openssl

# Zsh
brew install zsh zsh-completion
cp -r $HOME/Projects/dotfiles/zsh $HOME/.zsh
for file in "$HOME/.zsh/^(README.md|zshrc)"; do
    ln -s "$file" "$HOME/.${file:t}"
done

# Prezto
zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "$HOME/.zprezto/runcoms/^README.md(.N)"; do
    ln -s "$rcfile" "$HOME/.${rcfile:t}"
done
chsh -s /bin/zsh
cat $HOME/.zsh/zshrc >> $HOME/.zshrc

# Git
brew install git
cp -r $HOME/Projects/dotfiles/git $HOME/.git
setopt EXTENDED_GLOB
for file in "$HOME/.git/^README.md"; do
    ln -s "$file" "$HOME/.${file:t}"
done

# Vim
brew install vim
cp -r $HOME/Projects/dotfiles/vim $HOME/.vim
mkdir $HOME/.vim/tmp
setopt EXTENDED_GLOB
for file in "$HOME/.vim/^README.md"; do
    ln -s "$file" "$HOME/.${file:t}"
done
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
# TODO: fix solarized install (it fails on very first attempt)

# Lint
cp -r $HOME/Projects/dotfiles/lint $HOME/.lint
setopt EXTENDED_GLOB
for file in "$HOME/.lint/^README.md"; do
    ln -s "$file" "$HOME/.${file:t}"
done

# Rvm & Ruby
curl -sSL https://get.rvm.io | bash -s stable --ruby --with-openssl-dir=`brew --prefix openssl`
# If previous command doesn't work (note: change ruby version to the installed version)
# curl -sSL https://get.rvm.io | bash -s stable --ruby
# rvm reinstall 2.4.0 --with-openssl-dir=`brew --prefix openssl`
source $HOME/.rvm/scripts/rvm
rvm requirements

# Nvm & Node
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node

# Composer
brew install composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
cat <<EOT >> $HOME/.bashrc

export PATH=$PATH:$HOME/.composer/vendor/bin # Add composer to path
EOT
source $HOME/.bashrc

# Npm Packages
npm install --global grunt-cli gulp-cli bower eslint

# Gem Packages
rvm @global do gem install sass

# Composer Packages
composer global require "phpunit/phpunit:4.8.*"
composer global require "squizlabs/php_codesniffer=*"
