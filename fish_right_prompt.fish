function _git_branch_name
  echo (command git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||') | awk -v len=20 '{ if (length($0) > len) print substr($0, 1, len-1) "…"; else print; }'
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2>/dev/null)
end

function fish_right_prompt
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l normal (set_color normal)
  set -l green (set_color -o green)
  set -l cwd $cyan(prompt_pwd)

  # output the prompt, left to right

  # Display directory
  echo -n -s $cwd $normal

  # Show git branch and dirty state
  if [ (_git_branch_name) ]
    echo -n '⋅'
    set -l git_branch (_git_branch_name)

    if [ (_is_git_dirty) ]
      echo -n -s $red $git_branch
    else
      echo -n -s $green $git_branch
    end
    set_color normal
  end

  # Display (venvname) if in a virtualenv
  if set -q VIRTUAL_ENV
      echo -n -s '(' (basename "$VIRTUAL_ENV") ')'
  end

  if set -q GO_ENV
      echo -n -s '(' (basename "$GO_ENV") ')'
  end

  # Display current time
  set -l ctime (date +"%H:%M")
  echo -n -s ' ⎨' $ctime $normal
end
