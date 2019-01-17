nvm current 1>/dev/null 2>&1

function __check_nvm --on-variable PWD -d 'Setup nvm on directory change'
  status --is-command-substitution
  and return

  set -l cwd $PWD
  while true
    if contains $cwd "" $HOME "/"

      if test "$__nvm_current" != "default"
        nvm use default 1>/dev/null 2>&1 &
        set -g -x __nvm_current "default"
      end

      break
    else
      set -l nvmrc "$cwd/.nvmrc"

      if test -s $nvmrc
          set -l current (cat $nvmrc)

        if test "$__nvm_current" != "$current"
          nvm use $current 1>/dev/null 2>&1 &
          set -g -x __nvm_current $current
        end

        break
      else
        set cwd (dirname "$cwd")
      end
    end
  end
  set -e cwd
end

# Check on open new session
__check_nvm