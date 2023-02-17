resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block != null ? var.cidr_block : "10.0.0.0/16"
  enable_dns_hostnames = var.enable_dns_hostnames != null ? var.enable_dns_hostnames : false
  enable_dns_support   = var.enable_dns_support != null ? var.enable_dns_support : true
  instance_tenancy     = var.instance_tenancy != null ? var.instance_tenancy : "default"
  tags                 = merge(var.tags, { Name = "${var.vpc_name}" })
  # tags                               = merge(var.tags, { Name = "S4-${var.vpc_name}" })
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics != null ? var.enable_network_address_usage_metrics : false

}

resource "aws_subnet" "subnet" {
  for_each                = var.subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags                    = merge(each.value.tags, { Name = "${each.value.subnet_name}" })
}

resource "aws_vpc_dhcp_options" "dhcp_options_set" {
  count                = var.enable_dhcp_options ? 1 : 0
  domain_name          = var.domain_name != null ? var.domain_name : null
  domain_name_servers  = var.domain_name_servers != null ? var.domain_name_servers : null
  ntp_servers          = var.ntp_servers != null ? var.ntp_servers : null
  netbios_name_servers = var.netbios_name_servers != null ? var.netbios_name_servers : null
  netbios_node_type    = var.netbios_node_type != null ? var.netbios_node_type : null
  tags                 = var.tags
}

resource "aws_vpc_dhcp_options_association" "dhcp_options_attachment" {
  count           = var.enable_dhcp_options ? 1 : 0
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_options_set[count.index].id
}


resource "aws_route_table" "route_table" {
  for_each         = var.route_tables
  vpc_id           = aws_vpc.vpc.id
  propagating_vgws = each.value.propagating_vgws_list != null ? each.value.propagating_vgws_list : null
  tags             = each.value.tags #merge(each.value.tags, {Name = "S4-${var.vpc_type}-route-table"}) 
}

resource "aws_route_table_association" "rt_association" {
  for_each       = { for subnet_name, subnet in var.subnets : subnet_name => subnet }
  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.route_table[each.value.route_table_name].id
}

# TEMPORARILY REMOVE FLOW LOGS TO OFFER S3 OR CLOUDWATCH LOG GROUPS
# IF CONTROL TOWER YOU CAN CENTRALIZE INTO LOG ARCHVE ACCOUT
/*
resource "aws_flow_log" "flow_log" { #for_each loop usage
  for_each = var.flow_logs

  vpc_id         = aws_vpc.vpc.id
  traffic_type   = each.value.traffic_type
  log_group_name = each.value.log_group_name
  # log_destination      = each.value.log_destination #For S3 logging use
  # log_destination_type = "s3" #For S3 logging use
  iam_role_arn = each.value.iam_role_arn #For CloudWatch Logs log group use
  tags         = each.value.tags
}
*/

resource "aws_internet_gateway" "internet_gateway" {
  count  = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags   = merge(var.tags, { Name = "${var.vpc_name}-internet-gateway" })
  # tags   = merge(var.tags, { Name = "S4-${var.vpc_name}-internet-gateway" })
}
