# NOTE: Only the 8 basic terminal colors are used to ensure TTY compatibility. If more advanced colors are used such as 256, 
#     the colors will not be applied in TTY.
# If you want to edit, def recommend associating '*.zsh-theme' file extension with bash syntax highlighting in your editor

# Styling
ital="%{\x1b[3m%}"

# Define ANSI color codes
blue="%F{blue}"
cyan="%F{cyan}"
red="%F{red}"
green="%F{green}"
grey="%F{black}"
mgnta="%F{magenta}"
yellow="%F{yellow}"

# %{...%} tells zsh "These are non-printing sequences, ignore them for prompt length calculations"
# \x1b is the ESC character in octal or hex notation for ANSI escape codes

crim=$'%{\x1b[38;2;197;48;48m%}'  # Wrap the escape with %{...%}
ash=$'%{\x1b[38;2;176;176;176m%}'
teal=$'%{\x1b[38;2;102;140;139m%}'
smldr=$'%{\x1b[38;2;229;167;42m%}'
fresh=$'%{\x1b[38;2;98;156;125m%}'
glow=$'%{\x1b[38;2;30;111;84m%}'

reset=$'%{\x1b[0m%}' # or "%b%f" inside %{...%}, but \x1b[0m resets all attributes




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

# IMPORTANT: in your .zshrc, the following env variable should be set:
# export VIRTUAL_ENV_DISABLE_PROMPT=1
# that way, python doesn't insert its own venv indicator
function venv_name() {
  if [[ -n $VIRTUAL_ENV ]]; then
    echo -n "<$(basename "${VIRTUAL_ENV}")>"
  else
    echo -n ""
  fi
}

# This conditional block checks if true-color is supported by the current CLI environment, and if so, applies true-colors to the prompt, else 16-bit.

if command -v tput &> /dev/null; then
  if [[ "$(tput colors 2>/dev/null || echo 0)" -gt 16 ]]; then # execute truecolor scheme
    # truecolor/256bit
    PS1='$(venv=$(venv_name); branch=$(git_current_branch); path=$(git_rel_path); \
    if [ -n "${branch}" ]; then echo "%B${crim}┌─(${ash}%n${crim}◬${ash}%m${crim})${glow}${venv} ${crim}git${smldr}:${branch}${ash}%b/${path}"; \
    else echo "%B${crim}┌─(${ash}%n${crim}☠${ash}%m${crim})${glow}${venv} ${ash}%b%~"; fi)
    %{$(printf "\x1b[4D\x1b[4P")%}%B${crim}└${ash}$ ${reset}%b'
    # PS2
    PS2=' %B${ash}~%b '
    RPROMPT='${crim}☠${reset}'
  else
    PS1='$(venv=$(venv_name); branch=$(git_current_branch); path=$(git_rel_path); \
    if [ -n "${branch}" ]; then echo "${red}┌─(${reset}%n${red}◬${reset}%m${red})${grey}${venv} ${red}git%B${yellow}:${branch}%b${reset}/${path}"; \
    else echo "${red}┌─(${reset}%n${red}◬${reset}%m${red})${cyan}${venv} ${reset}%~"; fi)
    %{$(printf "\x1b[4D\x1b[4P")%}${red}└%B${yellow}$%b ${reset}'
    # PS2
    PS2=' %B~%b '
    RPROMPT='${yellow}◀${reset}'
  fi
else
  # tput not found, 16-color
  PS1='$(venv=$(venv_name); branch=$(git_current_branch); path=$(git_rel_path); \
  if [ -n "${branch}" ]; then echo "${green}┌─(${blue}%n@%m${green})${venv} ${yellow}git${blue}:${branch}${reset}/${path}${green}"; \
  else echo "${red}┌─(${yellow}%n@%m${green})${venv} ${reset}%~${green}"; fi)
  └${reset}%B$%b '
  # PS2
  PS2=' %B~%b '
  RPROMPT='${yellow}◀${reset}'
fi


# Old one
#PS1='$(venv=$(venv_name); branch=$(git_current_branch); path=$(git_rel_path); \
#if [ -n "${branch}" ]; then echo "${green}┌─(${blue}%n@%m${green})${venv} ${yellow}git${blue}:${branch}${reset}/${path}${green}"; \
#else echo "${red}┌─(${yellow}%n@%m${green})${venv} ${reset}%~${green}"; fi)
#└${reset}%B$%b '
# PS2
#PS2=' %B~%b '
