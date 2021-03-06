variable "shared_credentials_file" {
  description = "Terraform user aws credentials_file"
  type        = string
  default     = "/home/ran/.aws/credentials"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Kubernetes project name"
  type        = string
  default     = "devops-it-all"
}

variable "haproxy_instance_type" {
  description = "haproxy type & size"
  type        = string
  default     = "t2.micro"
}

variable "haproxy_scale_size" {
  description = "haproxy scale size"
  type        = number
  default     = 1
}

variable "management_apps" {
  default = [
    { name = "consul"},
    { name = "vault"},
    { name = "jenkins"},
    { name = "prometheus"},
    { name = "grafana"},
    { name = "elasticsearch"},
    { name = "logstash"},
    { name = "kibana"},
    { name = "stats"},
  ]
}

variable "domain_name" {
  description = "kubernetes wildcard domain name"
  type        = string
}

variable "haproxy_frontend_port" {
  default = 80
}

variable "haproxy_frontend_mode" {
  default = "http"
}

variable "haproxy_socket" {
  default = "/var/lib/haproxy/stats"
}

variable "haproxy_connection_num" {
  default = 10000
}

variable "haproxy_chroot" {
  default = "/var/lib/haproxy"
}

variable "haproxy_user" {
  default = "haproxy"
}

variable "haproxy_group" {
  default = "haproxy"
}

variable "eks_worker_role_arn" {
  description = "Current eks worker role arn"
  type        = string
}
variable "haproxy_role_arn" {
  description = "Current haproxy role arn"
  type        = string
}
