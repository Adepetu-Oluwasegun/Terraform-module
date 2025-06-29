# configure aws provider
provider "aws" {
  region  = var.region
  profile = "terraform-user"
}

# create vpc
module "vpc" {
  source                       = "../modules/Vpc"
  region                       = var.region
  project_name                 = var.project_name
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
}

# create nat gateway
module "gateway" {
  source                     = "../modules/Nat gateway"
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  internet_gateway           = module.vpc.internet_gateway
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  vpc_id                     = module.vpc.vpc_id
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az2_id = module.vpc.private_app_subnet_az2_id
}

# create security groups
module "security_group" {
  source = "../modules/Security groups"
  vpc_id = module.vpc.vpc_id
}

# create ecs task execution role
module "ecs_task_execution_role" {
  source       = "../modules/ecs-task-execution-role"
  project_name = module.vpc.project_name
}

# create ssl cerificate
module "acm" {
  source           = "../modules/acm"
  domain_name      = var.domain_name
  alternative_name = var.alternative_name
}

# create App load balancer 
module "Alb" {
  source                = "../modules/Alb"
  project_name          = module.vpc.project_name
  public_subnet_az1_id  = module.vpc.public_subnet_az1_id
  public_subnet_az2_id  = module.vpc.public_subnet_az2_id
  certificate_arn       = module.acm.certificate_arn
  alb_security_group_id = module.security_group.alb_security_group_id
  vpc_id                = module.vpc.vpc_id
}