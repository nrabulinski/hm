set -l nix_shell_info (
    if test -n "$IN_NIX_SHELL"
        echo -n "<nix-shell> "
    end
)
set -l last_status $status

echo
prompt_login

echo -n ':'

set_color $fish_color_cwd
echo -n (prompt_pwd)
set_color normal

__terlar_git_prompt
fish_hg_prompt
echo

if not test $last_status -eq 0
    set_color $fish_color_error
end

echo -n "$nix_shell_info➤ "
set_color normal
