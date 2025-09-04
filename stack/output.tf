output "frontend_sg_id" {
  value = module.frontend_sg.sg_id
}

output "backend_sg_id" {
  value = module.backend_sg.sg_id
}

output "redis_sg_id" {
  value = module.redis_sg.sg_id
}

output "postgres_sg_id" {
  value = module.postgres_sg.sg_id
}

output "nginx_sg_id" {
  value = module.nginx_sg.sg_id
}
