# USAGE

- Used to create a VPC with public and private subnets. 
- Also creates a vpn host with 30GB EBS volume and it's security group with the following rules:

        i. ingress rule for port 22 from 0.0.0.0/0
        ii. egress rule for all ports from 0.0.0.0/0

- This module also creates a NAT gateway and attaches it to the VPC. Capable of provisioning NAT gateway per AZ also. 

- ***.pem*** file for vpn host is saved in the root of 02-network module.

- To store the ***.tfstate*** file in provisioned cloud backend edit ***backend.tf***.

```
NOTE: The paremeter KEY in backend.tf is the path in the backend S3 bucket where the .tfstate for each module will be stored. Make sure that the path is not the same for different modules.
```
- The folder named ***vars*** contains 3 different tfvars files for different use cases:

        - vpc_minimal: For creating a VPC with only public subnets and IGW.No Jump server/vpn Host is  configured.
        - vpc_secure: For creating a VPC with both public and private subnets and IGW and NAT gateway. Jump server/vpn Host is also configured.
        - vpc_three_tier: For creating a VPC with public, application and database subnets ( where app and database subnets are private subnets)along with an IGW and NAT gateway. Jump server/vpn Host is also configured.

- To pass custom values for vpc edit one of the three files from ***.tfvars.reference*** in vars folder and change it to ***.tfvars*** and pass your values there.

- To create ***CIS compliant VPC*** set the variable ***create_cis_vpc*** to ***true*** in the .tfvars file.

- To apply  :

        cd aws/02-network
        terraform init
        terraform plan -var-file=vars/vpc_secure.tfvars -out plan.out   
        terraform apply plan.out 

- To add SSL to the Pritunl endpoint:
        
        Create a DNS record mapping to the vpn host public IP.
        Login to pritunl from the credentials in the pritunl-info.txt in the pritunl folder.
        After login,in the Initial setup window, add the record created in the 'Lets Encrypt Domain' field.
        Pritunl will automatically configure a signed SSL certificate from Lets Encrypt.

        NOTE: Port 80 to be open publicly in the vpn security group to verify and renewing the domain certificate.


- To destroy the resources:

      terraform destroy -var-file=vars/vpc_secure.tfvars


- Follows the VPC recommendations of CIS Amazon Web Services Foundations Benchmark v1.4.0 

[ 5. NETWORKING ]

server administration ports (Automated)

server administration ports (Automated)

(Automated)

