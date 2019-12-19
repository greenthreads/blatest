/*
* main.tf
*/
provider "aws" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"
  # Assign IPv6 address on private subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
  private_subnet_assign_ipv6_address_on_creation = false
  # Assign IPv6 address on intra subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
  intra_subnet_assign_ipv6_address_on_creation = false
  # Assign IPv6 address on redshift subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
  redshift_subnet_assign_ipv6_address_on_creation = false
  # Should be true to enable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic.
  enable_classiclink = false
  # Assign IPv6 address on public subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
  public_subnet_assign_ipv6_address_on_creation = false
  # Assign IPv6 address on database subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
  database_subnet_assign_ipv6_address_on_creation = false
  # Should be true to enable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic.
  enable_classiclink_dns_support = false
  # Assign IPv6 address on elasticache subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch
  elasticache_subnet_assign_ipv6_address_on_creation = false
}

module "sqs" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "2.0.0"
  # A unique name beginning with the specified prefix.
  name_prefix = ""
  # This is the human-readable name of the queue. If omitted, Terraform will assign a random name.
  name = ""
  # The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK
  kms_master_key_id = ""
}

module "nomad" {
  source  = "hashicorp/nomad/aws"
  version = "0.5.0"
  # The ID of the AMI to run in the cluster. This should be an AMI built from the Packer template under examples/nomad-consul-ami/nomad-consul.json. If no AMI is specified, the template will 'just work' by using the example public AMIs. WARNING! Do not use the example AMIs in a production setting!
  ami_id = ""
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.5.0"
  # The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier
  identifier = ""
  # The database engine to use
  engine = ""
  # The name of your final DB snapshot when this DB instance is deleted.
  final_snapshot_identifier = ""
  # The instance type of the RDS instance
  instance_class = ""
  # Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file
  password = ""
  # The allocated storage in gigabytes
  allocated_storage = ""
  # Username for the master DB user
  username = ""
  # The engine version to use
  engine_version = ""
  # The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'
  maintenance_window = ""
  # The port on which the DB accepts connections
  port = ""
  # The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window
  backup_window = ""
}

module "couchbase" {
  source  = "gruntwork-io/couchbase/aws"
  version = "0.2.2"
  # The ID of the AMI to run in the cluster. This should be an AMI built from the Packer template under examples/couchbase-ami/couchbase.json. Set to null to use one of the example AMIs we have published publicly.
  ami_id = ""
  # The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to null to not associate a Key Pair.
  ssh_key_name = ""
}

module "consul" {
  source  = "hashicorp/consul/aws"
  version = "0.7.3"
  # The maximum hourly price to pay for EC2 Spot Instances.
  spot_price = 1
  # The ID of the VPC in which the nodes will be deployed.  Uses default VPC if not supplied.
  vpc_id = ""
  # The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair.
  ssh_key_name = ""
  # The ID of the AMI to run in the cluster. This should be an AMI built from the Packer template under examples/consul-ami/consul.json. To keep this example simple, we run the same AMI on both server and client nodes, but in real-world usage, your client nodes would also run your apps. If the default value is used, Terraform will look up the latest AMI build automatically.
  ami_id = ""
}

module "vpn-gateway" {
  source  = "terraform-aws-modules/vpn-gateway/aws"
  version = "2.2.0"
  # The id of the VPC where the VPN Gateway lives.
  vpc_id = ""
  # The id of the VPN Gateway.
  vpn_gateway_id = ""
  # The id of the Customer Gateway.
  customer_gateway_id = ""
}

module "vault" {
  source  = "hashicorp/vault/aws"
  version = "0.13.3"
  # The domain name of the Route 53 Hosted Zone in which to add a DNS entry for Vault (e.g. example.com). Only used if var.create_dns_entry is true.
  hosted_zone_domain_name = ""
  # The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair.
  ssh_key_name = ""
  # The ID of the AMI to run in the cluster. This should be an AMI built from the Packer template under examples/vault-consul-ami/vault-consul.json. If no AMI is specified, the template will 'just work' by using the example public AMIs. WARNING! Do not use the example AMIs in a production setting!
  ami_id = ""
  # The domain name to use in the DNS A record for the Vault ELB (e.g. vault.example.com). Make sure that a) this is a domain within the var.hosted_zone_domain_name hosted zone and b) this is the same domain name you used in the TLS certificates for Vault. Only used if var.create_dns_entry is true.
  vault_domain_name = ""
}

module "elb" {
  source  = "terraform-aws-modules/elb/aws"
  version = "2.3.0"
  # The name of the ELB
  name = ""
  # A list of security group IDs to assign to the ELB
  security_groups = []
  # A health check block
  health_check = {}
  # A list of listener blocks
  listener = []
  # A list of subnet IDs to attach to the ELB
  subnets = []
  # The prefix name of the ELB
  name_prefix = ""
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "3.4.0"
  # Creates a unique name beginning with the specified prefix
  name = ""
  # The number of Amazon EC2 instances that should be running in the group
  desired_capacity = ""
  # A list of subnet IDs to launch resources in
  vpc_zone_identifier = []
  # Controls how health checking is done. Values are - EC2 and ELB
  health_check_type = ""
  # The minimum size of the auto scale group
  min_size = ""
  # The maximum size of the auto scale group
  max_size = ""
  # Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over min_elb_capacity behavior.
  wait_for_elb_capacity = 1
}

module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.2.0"
  # Name of security group
  name = ""
  # ID of the VPC where to create security group
  vpc_id = ""
}

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.12.0"
  # A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet.
  ipv6_address_count = 1
  # Can be used instead of user_data to pass base64-encoded binary data directly. Use this instead of user_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption.
  user_data_base64 = ""
  # The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead.
  user_data = ""
  # Name to be used on all resources as prefix
  name = ""
  # If true, the EC2 instance will have associated public IP address
  associate_public_ip_address = false
  # A list of security group IDs to associate with
  vpc_security_group_ids = []
  # Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface
  ipv6_addresses = []
  # The type of instance to start
  instance_type = ""
  # ID of AMI to use for the instance
  ami = ""
  # Private IP address to associate with the instance in a VPC
  private_ip = ""
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.0.0"
  # A list of subnets to associate with the load balancer. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f']
  subnets = []
  # The resource name prefix and Name tag of the load balancer.
  name_prefix = ""
  # The resource name and Name tag of the load balancer.
  name = ""
  # VPC id where the load balancer and other resources will be deployed.
  vpc_id = ""
}

module "notify-slack" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "2.4.0"
  # The name of the channel in Slack for notifications
  slack_channel = ""
  # The URL of Slack webhook
  slack_webhook_url = ""
  # The name of the SNS topic to create
  sns_topic_name = ""
  # The username that will appear on Slack messages
  slack_username = ""
  # The ARN of the KMS Key to use when encrypting log data for Lambda
  cloudwatch_log_group_kms_key_id = ""
}

module "influx" {
  source  = "gruntwork-io/influx/aws"
  version = "0.1.1"
  # The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair.
  ssh_key_name = ""
  # The ID of the AMI to run in the cluster. This should be an AMI built from the Packer template under examples/influxdb-ami/influxdb.json.
  ami_id = ""
  # A long pass phrase that will be used to sign tokens for intra-cluster communication on data nodes. This should not be set in plain-text and can be passed in as an env var or from a secrets management tool.
  shared_secret = ""
  # The key of your InfluxDB Enterprise license. This should not be set in plain-text and can be passed in as an env var or from a secrets management tool.
  license_key = ""
}

module "kubernetes" {
  source  = "coreos/kubernetes/aws"
  version = "1.8.9-tectonic.1"
  /*
    (internal) The e-mail address used to:
1. login as the admin user to the Tectonic Console.
2. generate DNS zones for some providers.

Note: This field MUST be in all lower-case e-mail address format and set manually prior to creating the cluster.

    */
  tectonic_admin_email = ""
  # Name of an SSH key located within the AWS region. Example: coreos-user.
  tectonic_aws_ssh_key = ""
  /*
    The name of the cluster.
If used in a cloud-environment, this will be prepended to `tectonic_base_domain` resulting in the URL to the Tectonic console.

Note: This field MUST be set manually prior to creating the cluster.
Warning: Special characters in the name like '.' may cause errors on OpenStack platforms due to resource name constraints.

    */
  tectonic_cluster_name = ""
  /*
    (internal) The admin user password to login to the Tectonic Console.

Note: This field MUST be set manually prior to creating the cluster. Backslashes and double quotes must
also be escaped.

    */
  tectonic_admin_password = ""
  /*
    The base DNS domain of the cluster. It must NOT contain a trailing period. Some
DNS providers will automatically add this if necessary.

Example: `openstack.dev.coreos.systems`.

Note: This field MUST be set manually prior to creating the cluster.
This applies only to cloud platforms.

[Azure-specific NOTE]
To use Azure-provided DNS, `tectonic_base_domain` should be set to `""`
If using DNS records, ensure that `tectonic_base_domain` is set to a properly configured external DNS zone.
Instructions for configuring delegated domains for Azure DNS can be found here: https://docs.microsoft.com/en-us/azure/dns/dns-delegate-domain-azure-dns

    */
  tectonic_base_domain = ""
}
