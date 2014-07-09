# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi=vim
#export TERM=ansi

# Point the PE installer to the cached agent installer
export q_pe_check_for_updates=n

validate_yaml() {
  ruby -ryaml -e "YAML.load_file '$1'"
}

validate_erb() {
  erb -P -x -T '-' $1 | ruby -c
}
