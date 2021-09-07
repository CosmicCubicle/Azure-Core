variable "location" {
    type = string
    description = "The location of the public ip"
    default = "eastus"
}

variable "environment" {
    type = string
    description = "The release stage of the environment"
    default = "dev"
}
variable "rg_name" {
    type = string
    description = "The name of the resource group"
    default = "XXXXX"
}
