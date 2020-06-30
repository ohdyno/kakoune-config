source "%val{config}/plugins/plug.kak/rc/plug.kak"

plug "andreyorst/fzf.kak"

# Enable Language Server Client (needs brew install ul/kak-lsp/kak-lsp)
eval %sh{kak-lsp --kakoune -s $kak_session}
# output debug logs for kak-lsp
nop %sh{
    (kak-lsp -s $kak_session -vvv ) > /tmp/lsp_"$(date +%F-%T-%N)"_kak-lsp_log 2>&1 < /dev/null &
}

hook global WinSetOption filetype=elixir %{
    lsp-enable-window
    map window normal <a-,> ':enter-user-mode<space>lsp<ret>'
}

plug "TeddyDD/kakoune-selenized" theme

colorscheme selenized-light
add-highlighter global/ number-lines

# show information on all key presses
set-option global autoinfo command|onkey|normal

# auto formatting
hook global WinSetOption filetype=markdown %{
    set-option window formatcmd 'prettier --parser markdown'
    hook buffer BufWritePre .* %{format}
}

hook global WinSetOption filetype=css %{
    set-option window formatcmd 'prettier --parser css'

    hook buffer BufWritePre .* %{format}
}

hook global WinSetOption filetype=html %{
    set-option window formatcmd 'prettier --parser html'

    hook buffer BufWritePre .* %{format}
}

# Soft wrap
addhl global/ wrap -width 80

# global key maps
hook global RawKey Y %{ set-register @ ":%reg{:}<ret>" }
map global normal <c-n> ":<up><ret>"

define-command -docstring "Zettelkasten Link" zk %{
    info -title %val(selection) %sh{
        zk -f "$kak_selection"
        }
    }
