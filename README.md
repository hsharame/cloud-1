## Description

This project deploys a WordPress site in the cloud. Infrastructure provisioning is handled with **Terraform** using the **AWS** provider. Once the server is created, the public IP address of the EC2 instance is retrieved and the automation process continues with **Ansible**.

Ansible is organized with multiple roles. The _deploy_ role is responsible for building the _docker-compose_ configuration located in the _srcs/_ directory. This configuration defines several containers (one process per container) used to run a complete WordPress environment. The stack includes a WordPress website, a MariaDB database, and phpMyAdmin for database management, all served through Nginx.

The website is accessible over HTTPS using a self-signed SSL certificate generated with OpenSSL. DNS name assignment is managed through [DuckDNS](https://www.duckdns.org/), which is configured using the Ansible _duckdns_ role.

Sensitive data required by Ansible is stored securely using **Ansible Vault**, which encrypts the secrets used during deployment.

## Usage

1. In the **_terraform.tfvars_** file, set the host IP and the name of the SSH key file.

2. Export your AWS credentials (access keys). To create an AWS access key: go to IAM → Users → select your user → Security credentials → Access keys → Create access key, then choose Local code.


   ```export AWS_ACCESS_KEY_ID="<anaccesskey>"```
   
   ```export AWS_SECRET_ACCESS_KEY="<asecretkey>"```

4. Configure the **_.env_** file in the ```srcs/``` directory.

5. From the root folder, run the following commands: ```make tf-init```, ```make tf-plan```, and ```make tf-apply```.

6. Generate the Ansible inventory with ```make inventory```.

7. Check the connection with ```make ping```. You will be asked for the Ansible Vault password, just like in the next step.

8. Run ```make bootstrap``` to start the provisioning process.

## Accessing the deployed website

You can access the deployed services using the DuckDNS domain configured during deployment.

```https://<your-domain>.duckdns.org```
Open this address in your browser to access the WordPress website.

```https://<your-domain>.duckdns.org/phpmyadmin/```
Use this address to access phpMyAdmin and manage the MariaDB database through the web interface.

## Connecting to the server via SSH

1. Make sure you have the **_*.pem_** SSH key file.

2. Restrict its permissions with chmod 400 *.pem.

3. Connect to the server using:
```ssh -i *.pem ubuntu@<public-ip>```

## Destroying the infrastructure

Run: ```make destroy```

