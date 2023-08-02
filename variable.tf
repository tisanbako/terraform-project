variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "pub1_subnet_cidr" {
    type = list
    default = ["10.0.1.0/24", "10.0.2.0/24",]
}
variable "pub2_subnet_cidr" {
    type = list
    default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "private1_subnet_cidr" {
    type = list
    default = ["10.0.5.0/24", "10.0.6.0/24", ]
}

variable "private2_subnet_cidr" {
    type = list
    default = ["10.0.7.0/24", "10.0.8.0/24"]
}

variable "az_list" {
    type = list
    default = ["us-east-1", "us-east-1"]
}