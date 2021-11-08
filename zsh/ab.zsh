export PATH=$PATH:~/Library/Python/2.7/bin
alias init_bertha='source ~/BERTHA/bin/activate'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jjohnston/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jjohnston/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jjohnston/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jjohnston/google-cloud-sdk/completion.zsh.inc'; fi

#alias k-local='kubectl config use-context docker-desktop'
#alias k-qa1='kubectl config use-context gke_searchbertha-qa1_us-central1-a_basic-qa-cluster'
#alias k-hrd='kubectl config use-context gke_searchbertha-hrd_us-central1-a_ab-production-cluster-1'

alias hl
alias hi-='helm --kube-context gke_searchbertha-qa1_us-central1-a_internal-infrastructure'


[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases

#kubectl prompt
SPACESHIP_KUBECTL_SHOW=true
SPACESHIP_KUBECTL_VERSION_SHOW=false
SPACESHIP_KUBECONTEXT_SHOW=true

export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"

export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
