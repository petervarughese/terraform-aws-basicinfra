#Conditions

variable "enable_internet_gateway" {
  type        = bool
  default     = false
  description = "Whether to enable the internet gateway in the VPC"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = false
  description = "Whether to enable dns hostname resolution via the DHCP options set"
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Whether to enable dns resolution in the DHCP options set"
}

variable "enable_dhcp_options" {
  type        = bool
  default     = false
  description = "Whether to enable or disable the creation, and attachment, of a DHCP option set"
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

#VPC Variables

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "vpc_name" {
  type    = string
  default = ""
}

variable "subnet_name" {
  type    = string
  default = ""
}

variable "enable_network_address_usage_metrics" {
  type    = bool
  default = false
}

variable "subnets" {
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
    route_table_name        = string
    subnet_name             = string
    tags                    = map(string)
  }))
  default = {
    "subnet-1" = {
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = true
      route_table_name        = "route_table_1"
      subnet_name             = "subnet_name"
      tags                    = {}
    },
    "subnet-2" = {
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "us-east-1b"
      map_public_ip_on_launch = false
      route_table_name        = "route_table_2"
      subnet_name             = "subnet_name"
      tags                    = {}
    }
  }
}

variable "route_tables" {
  type = map(object({
    propagating_vgws_list = list(string),
    tags                  = map(string)
  }))
  default = {
    "route_table_1" = {
      propagating_vgws_list = null
      tags                  = {}
    },
    "route_table_2" = {
      propagating_vgws_list = null
      tags                  = {}
    }
  }
}

variable "domain_name" {
  description = "(Optional) the suffix domain name to use by default when resolving non Fully Qualified Domain Names. "
  type        = string
  default     = null
}

variable "domain_name_servers" {
  description = "A list of domain name servers to use for the DHCP options set"
  type        = list(string)
  default     = null
}

variable "ntp_servers" {
  description = "A list of NTP servers to use for the DHCP options set"
  type        = list(string)
  default     = null
}

variable "netbios_name_servers" {
  description = "A list of NetBIOS name servers to use for the DHCP options set"
  type        = list(string)
  default     = null
}

variable "netbios_node_type" {
  description = "The NetBIOS node type to use for the DHCP options set"
  type        = number
  default     = null
}

# TEMPORARILY REMOVE FLOW LOGS TO OFFER S3 OR CLOUDWATCH LOG GROUPS
# IF CONTROL TOWER YOU CAN CENTRALIZE INTO LOG ARCHVE ACCOUT
/*
#Flow Log Variables
variable "flow_logs" {
  type = map(object({
    traffic_type   = string
    log_group_name = string
    iam_role_arn   = string
    tags           = map(string)
  }))
  default = {
    "flow_log_one" = {
      traffic_type   = "ALL"
      iam_role_arn   = "arn:aws:iam::12345678912:role/AmazonWamMarketplace_Default_Role"
      log_group_name = "dev-vpc"
      tags           = {}
    },
    "flow_log_two" = {
      traffic_type   = "REJECT"
      iam_role_arn   = "arn:aws:iam::12345678912:role/AmazonWamMarketplace_Default_Role"
      log_group_name = "dev-vpc"
      tags = {
        Environment = "example-2"
      }
    }
  }
}
*/