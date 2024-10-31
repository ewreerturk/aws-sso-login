#!/bin/bash

# AWS CLI should be installed 
configure_aws() {
    aws configure set default.output json
    aws configure set sso_start_url "your_start_url"
    aws configure set sso_region "your_project_region" 
    aws configure set sso_role_name "your_project_role_name"
}

choose_account() {
    echo "Choose the account you want to login to:
1: your_project.xxxxxlogging (your_account_id_1)
2: your_project.xxxxxmonitoring (your_account_id_2)
3: your_project-xxxxxdevelopment (your_account_id_3)
4: your_project-xxxxxmanagement (your_account_id_3)"

    read -p "Enter your choice (1-4): " selection

# Choose the SSO_ACCOUNT value
    case "$selection" in
        1)
            SSO_ACCOUNT="your_account_id_1"
            ;;
        2)
            SSO_ACCOUNT="your_account_id_2"
            ;;
        3)
            SSO_ACCOUNT="your_account_id_3"
            ;;
        4)
            SSO_ACCOUNT="your_account_id_4"
            ;;
        *)
            echo "Invalid selection."
            exit 1
            ;;
    esac
}

login_aws() {
    aws configure set sso_account_id "$SSO_ACCOUNT"
    aws sso login
    if [ $? -ne 0 ]; then
        echo "Failed to start SSO session."
        exit 1
    fi
    echo "SSO session successfully started."
}

handle_secret_key() {
    OUTPUT_FILE="secret.key"
     
     
     # If the user has selected option 3 (your_project-xxxxxdevelopment) and wants to view the secret key directly, press 'y'
    if [ "$selection" == "3" ]; then
        read -p "Do you want to view the secret key? (y/n) " view_secret  # If the user does not want to display it, they can press 'n' and continue using the terminal with the AWS CLI connection established.

        if [ "$view_secret" == "y" ]; then
            # if you do not want to use the script you can just use this command [61st line to 65th line ]
            aws secretsmanager get-secret-value \
                --region eu-central-1 \ #change region
                --secret-id keepass-secret-key \ #change secret-id
                --query SecretString \
                --output text > "$OUTPUT_FILE"
            if [ $? -eq 0 ]; then
                echo "Secret was successfully saved to $OUTPUT_FILE."
            else
                echo "Secret key unreachable."
            fi
        else
            echo "Continuing without viewing the secret key."
        fi
    fi
}

main() {
    configure_aws
    choose_account
    login_aws
    handle_secret_key
}


main

