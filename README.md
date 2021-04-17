# gke-cluster-private
private gke cluster with network + bastion host

## Steps:
- Step 1: Authenticate with your google account:
    ```
    gcloud auth application-default login
    gcloud config set project PROJECT_ID
    ```
 
- Step 2 : Clone this repo: 
```
git clone https://github.com/devseclabs/gke-cluster-private.git
```
- Step 3 : Update the terraform vars  file:
```
#rename terraform.tfvars.tpl to terraform.tfvars
mv  terraform.tfvars.tpl terraform.tfvars

# Set your values
prefix = "your-awesome-prefix"
project_id = "your-project-id"
num_nodes = 3

```

- Step 4: Deploy your private cluster:

## Deploy and Manage your deployment using terraform:
    - init your plugins                 ```terraform init```
    - plan your deployment              ```terraform plan```
    - apply the changes in your cluster ```terraform apply```

- Step 5: Set your bastion with proxy to get access to the private cluster using ssh tunnel:

```
cat notes.sh
# set your values and get your context
# configure proxy alias
alias kp='HTTPS_PROXY=localhost:8888 kubectl'

#test your connection:
kp get nodes

```

### Clean Up
- destroy your deployment: ```terraform destroy```

