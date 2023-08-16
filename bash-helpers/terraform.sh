# terraform.sh
logger "" "[${BASH_SOURCE[0]}]"

# ------------------------------------------------
#  config
# ------------------------------------------------
logger "[$(basename "${BASH_SOURCE[0]}")]: Loading config..."

complete -C /usr/local/bin/terraform terraform

# ------------------------------------------------
#  aliases
# ------------------------------------------------
logger "[$(basename "${BASH_SOURCE[0]}")]: Loading alises..."

alias tf="terraform"
alias tfV="terraform version"
alias tfa="terraform apply"
alias tfc="terraform console"
alias tfd="terraform destroy"
alias tfdb="terraform debug"
alias tfe="terraform env"
alias tff="terraform fmt"
alias tffr="..r && terraform fmt -recursive && cd -"
alias tfg="terraform get"
alias tfgr="terraform graph"
alias tfi="terraform init"
alias tfim="terraform import"
alias tfo="terraform output"
alias tfp="terraform plan"
alias tfpu="terraform push"
alias tfpv="terraform providers"
alias tfr="terraform refresh"
alias tfs="terraform show"
alias tft="terraform taint"
alias tfu="terraform untaint"
alias tfug="terraform 0.12upgrade"
alias tful="terraform force-unlock"
alias tfv="terraform validate"
alias tfw="terraform workspace"

# Project naviation
# alias cdp="cd \$(pwd | sed -e \"s|\(.*/projects\)/[^/]*/\(.*\)$|\1/production/\2/|\")"
# alias cds="cd \$(pwd | sed -e \"s|\(.*/projects\)/[^/]*/\(.*\)$|\1/staging/\2/|\")"
# alias cdd="cd \$(pwd | sed -e \"s|\(.*/projects\)/[^/]*/\(.*\)$|\1/demo/\2/|\")"
# alias cdt="cd \$HOME/dev/${ORG_ROOT)/src/ops/packages/terraform/projects/"
# alias cdv="cd \$HOME/dev/${ORG_ROOT)/src/ops/vendors/"

alias tfia=init_all_modules
alias tfva=validate_all_modules

# ------------------------------------------------
#  helpers
# ------------------------------------------------
logger "[$(basename "${BASH_SOURCE[0]}")]: Loading helpers..."

function get_terraform_workspace () {
    [[ -d .terraform ]] && printf "%s" " $(terraform workspace show 2>/dev/null)"
}

function init_all_modules() {
    ALL_MODULES=find_all_terraform_modules

    for module in ${ALL_MODULES};
        do
            printf "%s\n" "${module}"
            (cd "${module}" && terraform init)
        done
}

function validate_all_modules() {
    ALL_MODULES=find_all_terraform_modules

    for module in ${ALL_MODULES};
        do
            printf_callout "%s\n" "${module}"
            (cd "${module}" && terraform validate)
        done
}
