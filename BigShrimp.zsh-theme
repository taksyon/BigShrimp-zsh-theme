# NOTE: Only the 8 basic terminal colors are used to ensure TTY compatibility. If more advanced colors are used such as 256, 
#     the colors will not be applied in TTY.
# If you want to edit, def recommend associating '*.zsh-theme' file extension with bash syntax highlighting in your editor

# Define ANSI color codes
blue="%B%F{blue}"
green="%b%F{green}"
grey="%B%F{black}"
mgnta="%b%F{magenta}"
yellow="%B%F{yellow}"
reset="%b%f"

# Function to get the relative path starting at local repo directory
function git_rel_path() {
  # Get the root path of the repo
  local root=$(git rev-parse --show-toplevel 2> /dev/null)
  
  if [[ -n $root ]]; then
    # Extract the repo directory name
    local repo_dir=$(basename "$root")
    
    # Replace the root path with the repo directory name
    local relative_path=${PWD/$root/$repo_dir}
    
    # Trim leading slash if present
    relative_path="${relative_path#/}"
    
    echo -n "$relative_path"
  else
    echo -n ""
  fi
}

# PS1
PS1='$(branch=$(git_current_branch); path=$(git_rel_path); \
if [ -n "${branch}" ]; then echo "${blue}┌─(%n@%m)──[git:${green}${branch}${grey}/${path}${blue}]"; \
else echo "${blue}┌─(%n@%m)──[${grey}%~${blue}]"; fi)
└${reset}%B$%b '

# PS2
PS2=' %B~%b '

# Color code list: https://robotmoon.com/256-colors/
