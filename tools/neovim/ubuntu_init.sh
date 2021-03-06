#!/bin/bash

function ycm_ins(){
    ! (grep -F 'YouCompleteMe' ~/.config/nvim/init.vim &>/dev/null ) && \
    sed -i "/plug#begin/aPlug 'Valloric/YouCompleteMe'"  ~/.config/nvim/init.vim 

    if [ ! -f ~/.config/nvim/ycm.cpp.py ] ; then
        wget https://raw.githubusercontent.com/zhouzheng12/newycm_extra_conf.py/master/ycm.c.py
        wget https://raw.githubusercontent.com/zhouzheng12/newycm_extra_conf.py/master/ycm.cpp.py
        mkdir -p ~/.config/nvim
        cp ycm.c.py ~/.config/nvim/ycm.c.py
        cp ycm.cpp.py ~/.config/nvim/ycm.cpp.py
        rm -f ycm.c.py ycm.cpp.py
    fi
    if [ ! -f ~/.local/share/nvim/plugged/YouCompleteMe/third_party/ycmd/ycm_core.so ] ; then
        bash ~/.config/nvim/add_swap.sh
        pxy python2  ~/.local/share/nvim/plugged/YouCompleteMe/install.py --clang-completer
        bash ~/.config/nvim/del_swap.sh
        rm -rf  ~/.local/share/nvim/plugged/YouCompleteMe/third_party/ycmd/clang_archives
    fi
}

function c_ins(){
    ! (grep -F 'nvim-gdb' ~/.config/nvim/init.vim &>/dev/null ) && \
    sed -i "/plug#begin/aPlug 'vim-scripts/a.vim'" ~/.config/nvim/init.vim && \
    sed -i "/plug#begin/aPlug 'rhysd/vim-clang-format'" ~/.config/nvim/init.vim && \
    sed -i "/plug#begin/aPlug 'sakhnik/nvim-gdb' , { 'branch': 'legacy' }" ~/.config/nvim/init.vim
}
function leetcode_ins(){
    ! (grep -F 'leetcode' ~/.config/nvim/init.vim &>/dev/null ) && \
    pip3 install requests beautifulsoup4 && \
    sed -i "/plug#begin/aPlug 'ianding1/leetcode.vim'" ~/.config/nvim/init.vim
}

function python_ins(){
    ! (grep -F 'deoplete-jedi' ~/.config/nvim/init.vim &>/dev/null ) && \
    sed -i "/plug#begin/aPlug 'zchee/deoplete-jedi'" ~/.config/nvim/init.vim
}
function java_ins(){
    ! (grep -F 'vim-javacomplete2' ~/.config/nvim/init.vim &>/dev/null ) && \
    sed -i "/plug#begin/aPlug 'artur-shaik/vim-javacomplete2'" ~/.config/nvim/init.vim
}

function go_ins(){
    ! (grep -F 'deoplete-go' ~/.config/nvim/init.vim &>/dev/null ) && \
    sed -i "/plug#begin/aPlug 'fatih/vim-go'" ~/.config/nvim/init.vim &&\
    sed -i "/plug#begin/aPlug 'zchee/deoplete-go', { 'do': 'make'}" ~/.config/nvim/init.vim &&\
    sed -i "/plug#begin/aPlug 'sebdah/vim-delve'" ~/.config/nvim/init.vim
    if which go;then
        pxy nvim +'GoInstallBinaries' +qall
        pxy go get -u github.com/derekparker/delve/cmd/dlv
        pxy go get -u github.com/mdempsky/gocode
    fi
}

function php_ins(){
    ! (grep -F 'arnaud-lb/vim-php-namespace' ~/.config/nvim/init.vim &>/dev/null ) && \
    sed -i "/plug#begin/aPlug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer install' }" ~/.config/nvim/init.vim && \
    sed -i "/plug#begin/aPlug 'arnaud-lb/vim-php-namespace'" ~/.config/nvim/init.vim &&\
    sed -i "/plug#begin/aPlug 'stephpy/vim-php-cs-fixer'" ~/.config/nvim/init.vim && \
    sed -i "/plug#begin/aPlug 'vim-vdebug/vdebug'" ~/.config/nvim/init.vim
    cat > /usr/local/bin/phpxd <<END
    #!/bin/zsh
    export XDEBUG_CONFIG="idekey=xdebug remote_host=localhost"
    php "\$@"
END
    chmod u+x  /usr/local/bin/phpxd
}


#读取参数
# install neovim
if [ ! -f /usr/local/bin/vim ];then
	if [ ! -f nvim.appimage ];then
	    wget https://github.com/neovim/neovim/releases/download/v0.3.4/nvim.appimage
	fi
    sudo chmod u+x nvim.appimage && sudo ./nvim.appimage --appimage-extract
	mkdir -p ~/opt/soft
    sudo mv squashfs-root ~/opt/soft/nvim
    rm -f /usr/local/bin/vim
	sudo ln -s  ~/opt/soft/nvim/squashfs-root/usr/bin/nvim /usr/local/bin/vim
    rm -f /usr/local/bin/nvim
	sudo ln -s  ~/opt/soft/nvim/squashfs-root/usr/bin/nvim /usr/local/bin/nvim
	rm -rf nvim.appimage
fi
pip3 install neovim --upgrade
pip2 install neovim --upgrade

#-------------------------------------------------------------------------------
# install vim-plug
#-------------------------------------------------------------------------------
if  [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ] ; then
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

#-------------------------------------------------------------------------------
# copy init.vim to home dir, and install from command line
#-------------------------------------------------------------------------------
if [ ! -f ~/.vim/c_cnt.sh ] ; then
    mkdir -p  ~/.config/nvim
	cp tools/neovim/c_cnt.sh  ~/.config/nvim/c_cnt.sh
	cp tools/neovim/add_swap.sh  ~/.config/nvim/add_swap.sh
	cp tools/neovim/del_swap.sh  ~/.config/nvim/del_swap.sh
fi
rm -f ~/.config/nvim/init.vim
#common config
mkdir -p ~/.config/nvim
cp tools/neovim/init.vim ~/.config/nvim/init.vim
# copy
if nmap localhost -p 8377 | grep open 2>/dev/null;then
    sed -in 's#NCHOST#localhost#g' ~/.config/nvim/init.vim
else
    sed -in 's#NCHOST#host.docker.internal#g' ~/.config/nvim/init.vim
fi

if [ "$sys_os" == "ubuntu" ];then
    sed -in 's#NCCOMMAND#nc -q 1#g'  ~/.config/nvim/init.vim
else
    sed -in 's#NCCOMMAND#nc -c#g' ~/.config/nvim/init.vim
fi

#language

if [ "Y$OPT_VIM_GO" == "Yyes" ];then
	go_ins
fi

if [ "Y$OPT_VIM_PHP" == "Yyes" ];then
	php_ins
fi

if [ "Y$OPT_VIM_C" == "Yyes" ];then
	c_ins
fi

if [ "Y$OPT_VIM_YCM" == "Yyes" ];then
	ycm_ins
fi

if [ "Y$OPT_LUA" == "Yyes" ];then
	lua_ins
fi

if [ "Y$OPT_JAVA" == "Yyes" ];then
	java_ins
fi
if [ "Y$OPT_PYTHON" == "Yyes" ];then
	python_ins
fi
if [ "Y$OPT_LEETCODE" == "Yyes" ];then
	leetcode_ins
fi

#language end

export shell=/bin/bash
nvim +'PlugInstall --sync' +qall
! which ctags >/dev/null && \
    git clone https://github.com/universal-ctags/ctags.git &&\
    cd ctags && ./autogen.sh && ./configure && make && make install &&\
    cd .. && rm -rf ctags

! ( grep -F "color onedark" ~/.config/nvim/init.vim ) && \
    echo "color onedark" >> ~/.config/nvim/init.vim && \
    echo "highlight Normal ctermbg=None" >> ~/.config/nvim/init.vim

! ( grep -F "cus_ini_vim" ~/.config/nvim/init.vim ) && \
    cat tools/neovim/cfg.ini >> ~/.config/nvim/init.vim
! ( grep -F "cus_ini_env" ~/.env ) && \
    cat tools/neovim/env.ini >> ~/.env
[ ! -f /usr/local/bin/genUrl ] &&\
    cp tools/neovim/genUrl.sh /usr/local/bin/genUrl && chmod u+x /usr/local/bin/genUrl
[ ! -d /usr/local/vimsplain ] &&\
    git clone https://github.com/pafcu/vimsplain.git  /usr/local/vimsplain
rm -rf  ~/.gdbinit  && cp tools/neovim/gdbinit ~/.gdbinit


! ( grep -F "defx_icons_directory_icon" ~/.config/nvim/init.vim ) && \
cat >> ~/.config/nvim/init.vim <<END
"defx config
call defx#custom#column('size','')
call defx#custom#column('filename', {
    \ 'directory_icon': '▸',
    \ 'opened_icon': '▾',
    \ 'root_icon': ' ',
    \ 'min_width': 30,
    \ 'max_width': 30,
    \ })
call defx#custom#column('mark', {
    \ 'readonly_icon': '',
    \ 'selected_icon': '',
    \ })
call defx#custom#option('_',{
    \ 'columns'   : 'git:mark:filename:icons',
    \ 'show_ignored_files': 0,
    \ 'buffer_name': '',
    \ 'toggle': 1,
    \ 'resume': 1,
    \ })
"defx-git config
let g:defx_git#indicators = {
  \ 'Modified'  : '✹',
  \ 'Staged'    : '✚',
  \ 'Untracked' : '✭',
  \ 'Renamed'   : '➜',
  \ 'Unmerged'  : '═',
  \ 'Ignored'   : '☒',
  \ 'Deleted'   : '✖',
  \ 'Unknown'   : '?',
  \ }

let g:defx_git#column_length = 1
let g:defx_git#raw_mode = 1
" defx-icons config
let g:defx_icons_enable_syntax_highlight = 1
let g:defx_icons_column_length = 2
let g:defx_icons_directory_icon = ''
let g:defx_icons_mark_icon = '*'
let g:defx_icons_parent_icon = ''
let g:defx_icons_default_icon = ''
let g:defx_icons_directory_symlink_icon = ''
" Options below are applicable only when using "tree" feature
let g:defx_icons_root_opened_tree_icon = ''
let g:defx_icons_nested_opened_tree_icon = ''
let g:defx_icons_nested_closed_tree_icon = ''


autocmd FileType defx call s:defx_my_settings()
    function! s:defx_my_settings() abort
     " Define mappings
     nnoremap <silent><buffer><expr> <CR>
     \ defx#do_action('open')
     nnoremap <silent><buffer><expr> c
     \ defx#do_action('copy')
     nnoremap <silent><buffer><expr> m
     \ defx#do_action('move')
     nnoremap <silent><buffer><expr> p
     \ defx#do_action('paste')
     nnoremap <silent><buffer><expr> l
     \ defx#do_action('open')
     nnoremap <silent><buffer><expr> E
     \ defx#do_action('open', 'vsplit')
     nnoremap <silent><buffer><expr> P
     \ defx#do_action('open', 'pedit')
     nnoremap <silent><buffer><expr> o
     \ defx#do_action('open_or_close_tree')
     nnoremap <silent><buffer><expr> K
     \ defx#do_action('new_directory')
     nnoremap <silent><buffer><expr> N
     \ defx#do_action('new_file')
     nnoremap <silent><buffer><expr> M
     \ defx#do_action('new_multiple_files')
     nnoremap <silent><buffer><expr> C
     \ defx#do_action('toggle_columns',
     \                'mark:filename:type:size:time')
     nnoremap <silent><buffer><expr> S
     \ defx#do_action('toggle_sort', 'time')
     nnoremap <silent><buffer><expr> d
     \ defx#do_action('remove')
     nnoremap <silent><buffer><expr> r
     \ defx#do_action('rename')
     nnoremap <silent><buffer><expr> !
     \ defx#do_action('execute_command')
     nnoremap <silent><buffer><expr> x
     \ defx#do_action('execute_system')
     nnoremap <silent><buffer><expr> yy
     \ defx#do_action('yank_path')
     nnoremap <silent><buffer><expr> .
     \ defx#do_action('toggle_ignored_files')
     nnoremap <silent><buffer><expr> ;
     \ defx#do_action('repeat')
     nnoremap <silent><buffer><expr> h
     \ defx#do_action('cd', ['..'])
     nnoremap <silent><buffer><expr> ~
     \ defx#do_action('cd')
     nnoremap <silent><buffer><expr> q
     \ defx#do_action('quit')
     nnoremap <silent><buffer><expr> <Space>
     \ defx#do_action('toggle_select') . 'j'
     nnoremap <silent><buffer><expr> *
     \ defx#do_action('toggle_select_all')
     nnoremap <silent><buffer><expr> j
     \ line('.') == line('$') ? 'gg' : 'j'
     nnoremap <silent><buffer><expr> k
     \ line('.') == 1 ? 'G' : 'k'
     nnoremap <silent><buffer><expr> <C-l>
     \ defx#do_action('redraw')
     nnoremap <silent><buffer><expr> <C-g>
     \ defx#do_action('print')
     nnoremap <silent><buffer><expr> cd
     \ defx#do_action('change_vim_cwd')
endfunction
augroup defx
    au!
    au VimEnter * sil! au! FileExplorer *
    au BufEnter * if s:isdir(expand('%')) | bd | exe 'Defx' | endif
augroup END
END
