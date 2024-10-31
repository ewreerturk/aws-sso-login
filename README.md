# aws-sso-login for Key File Retrieve


The `.pem` file required for authentication is stored in the secret manager of the Development Project.  
You can retrieve it by using the secret ARN: `arn:aws:secretsmanager:<region>:<account-id>:secret:<secret-name>`.

After granting execute permissions to the `script.sh` file with `chmod +x script.sh`, you can run the script.  
Running the script will configure AWS SSO login. When prompted, if you select the third project, it will ask if you want to view the Keepass data.

In our scenario, we keep this secret information in our 3rd project, you can make it available according to your own scenario by playing on the script here.
