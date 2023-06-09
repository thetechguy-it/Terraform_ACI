# Cisco ACI Provider

Requirements
------------

- [Terraform](https://www.terraform.io/downloads.html) 
  - v0.12 and higher (ACI Provider v1.0.0 or higher)
  - v0.11.x or below (ACI Provider v0.7.1 or below)

- [Go](https://golang.org/doc/install) Latest Version

## Building The Provider ##
Clone this repository to: `$GOPATH/src/github.com/CiscoDevNet/terraform-provider-cisco-aci`.

```sh
$ mkdir -p $GOPATH/src/github.com/CiscoDevNet; cd $GOPATH/src/github.com/CiscoDevNet
$ git clone https://github.com/CiscoDevNet/terraform-provider-aci.git
```

Enter the provider directory and run dep ensure to install all the dependancies. After, that run make build to build the provider binary.

```sh
$ cd $GOPATH/src/github.com/CiscoDevNet/terraform-provider-aci
$ dep ensure
$ make build

```

Using The Provider
<!-- https://www.terraform.io/docs/plugins/basics.html#installing-a-plugin -->
------------------
If you are building the provider, follow the instructions to [install it as a plugin.](https://www.terraform.io/docs/cli/plugins/index.html) After placing it into your plugins directory, run `terraform init` to initialize it.

ex.
```hcl
terraform {
  required_providers {
    aci = {
      source = "ciscodevnet/aci"
    }
  }
}

#configure provider with your cisco aci credentials.
provider "aci" {
  # cisco-aci user name
  username = "admin"
  # cisco-aci password
  password = "password"
  # cisco-aci url
  url      = "https://my-cisco-aci.com"
  insecure = true
  proxy_url = "https://proxy_server:proxy_port"
}

resource "aci_tenant" "test-tenant" {
  name        = "test-tenant"
  description = "This tenant is created by terraform"
}

resource "aci_application_profile" "test-app" {
  tenant_dn   = aci_tenant.test-tenant.id
  name        = "test-app"
  description = "This application profile is created by terraform"
}
```
Note : If you are facing the issue of `invalid character '<' looking for beginning of value` while running `terraform apply`, use signature based authentication in that case, or else use `-parallelism=1` with `terraform plan` and `terraform apply` to limit the concurrency to one thread.

```
terraform plan -parallelism=1
terraform apply -parallelism=1
```  


```hcl
  provider "aci" {
      # cisco-aci user name
      username = "admin"
      # private key path
      private_key = "path to private key"
      # Certificate Name
      cert_name = "user-cert"
      # cisco-aci url
      url      = "https://my-cisco-aci.com"
      insecure = true
  }
```

Note: The value of "cert_name" argument must match the name of the certificate object attached to the APIC user (aaaUserCert) used for signature-based authentication

Developing The Provider
-----------------------
If you want to work on the provider, you'll first need [Go](http://www.golang.org) installed on your machine. 

To compile the provider, run `make build`. This will build the provider with sanity checks present in scripts directory and put the provider binary in `$GOPATH/bin` directory.

<strong>Important: </strong>To successfully use the provider you need to follow these steps:

- Copy or Symlink the provider from the `$GOPATH/bin` to `~/.terraform.d/plugins/terraform.local/CiscoDevNet/aci/<Version>/<architecture>/` for example:
  ```bash
  ln -s ~/go/bin/terraform-provider-aci ~/.terraform.d/plugins/terraform.local/CiscoDevNet/aci/2.3.0/linux_amd64/terraform-provider-aci
  ```

- Edit the Terraform Provider Configuration to use the local provider.

  ```hcl
  terraform {
    required_providers {
      aci = {
        source = "terraform.local/CiscoDevNet/aci"
        version = "2.3.0"
      }
    }
  }
  ```

<strong>NOTE:</strong> Currently only resource properties supports the reflecting manual changes made in CISCO ACI. Manual changes to relationship is not taken care by the provider.
