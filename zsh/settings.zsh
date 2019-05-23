alias pip="pip3"
alias python="python3"

alias graylog-connect="ssh -f -N -L 9000:graylog-primary.infra.circleci.com:80 jumphost-base.prod.circleci.com"

export GO111MODULE=on
export GOPATH=$HOME/go
export PATH=$PATH:$HOME/go/bin

. /Users/$(whoami)/bin/z.sh

bindkey -v
