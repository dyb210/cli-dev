which brew
if ! which brew;then
    /usr/bin/ruby -e \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

apps="wget fzf ripgrep autojump"
for app in $apps
do
    ! brew list | grep $app && brew install $app
done

! brew list | grep gnu-sed && brew install gnu-sed --with-default-names
! brew list | grep python && brew install python3
! brew list | grep python@2 && brew install python2
! ls /Library/Fonts | grep Fura &&
wget https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/FiraCode/Retina/complete/Fura%20Code%20Retina%20Nerd%20Font%20Complete%20Mono.ttf && \
mv Fura*Mono.ttf /Library/Fonts