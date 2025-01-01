# NOTE: Only the 8 basic terminal colors are used to ensure TTY compatibility. If more advanced colors are used such as 256, 
#     the colors will not be applied in TTY.
# If you want to edit, def recommend associating '*.zsh-theme' file extension with bash syntax highlighting in your editor

# Define ANSI color codes
blue="%F{blue}"
cyan="%F{cyan}"
green="%F{green}"
grey="%F{black}"
mgnta="%F{magenta}"
yellow="%F{yellow}"
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

# Function to integrate venv indicator when activating python virtual environment.
# Recommend disabling the global one with 'export VIRTUAL_ENV_DISABLE_PROMPT=1'
function venv_name() {
  if [[ -n $VIRTUAL_ENV ]]; then
    echo -n "${cyan}─<$(basename "${VIRTUAL_ENV}")>─"
  else
    echo -n ""
  fi
}

# PS1
PS1='$(venv=$(venv_name); branch=$(git_current_branch); path=$(git_rel_path); \
if [ -n "${branch}" ]; then echo "${green}┌─(${blue}%n@%m${green})${venv} ${yellow}git${blue}:${branch}${reset}/${path}${green}"; \
else echo "${green}┌─(${blue}%n@%m${green})${venv} ${reset}%~${green}"; fi)
└${reset}%B$%b '
# PS2
PS2=' %B~%b '
