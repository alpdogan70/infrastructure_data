

resource "null_resource" "ansible_infrastructure" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = <<-EOT
      sleep 60s;
      #base
      #${var.ANSIBLE_ENV_VARS} ${var.ANSIBLE_COMMAND} ${var.default_user} ${var.ANSIBLE_OPTIONS} -e users_default_account=${var.default_user} ../../ansible/infrastructure_base.yml;
      
      #minio
      #${var.ANSIBLE_ENV_VARS} ${var.ANSIBLE_COMMAND} ${var.default_user} ${var.ANSIBLE_OPTIONS} ../../ansible/infrastructure_minio.yml;
      
      #iot stack
      ${var.ANSIBLE_ENV_VARS} ${var.ANSIBLE_COMMAND} ${var.default_user} ${var.ANSIBLE_OPTIONS} ../../ansible/infrastructure_iot_stack.yml;

      #consul server/agent
      #${var.ANSIBLE_ENV_VARS} ${var.ANSIBLE_COMMAND} ${var.default_user} ${var.ANSIBLE_OPTIONS}  ../../ansible/infrastructure_consul.yml;
      
      #consul services
      #${var.ANSIBLE_ENV_VARS} ${var.ANSIBLE_COMMAND} ${var.default_user} ${var.ANSIBLE_OPTIONS}  ../../ansible/infrastructure_consul_services.yml;
      
      #monitoring
      #${var.ANSIBLE_ENV_VARS} ${var.ANSIBLE_COMMAND} ${var.default_user} ${var.ANSIBLE_OPTIONS}  ../../ansible/infrastructure_monitoring.yml;

      #loki
      #${var.ANSIBLE_ENV_VARS} ${var.ANSIBLE_COMMAND} ${var.default_user} ${var.ANSIBLE_OPTIONS}  ../../ansible/infrastructure_loki.yml;

      #BMC simulator (NOUVEAU)
      #${var.ANSIBLE_ENV_VARS} ${var.ANSIBLE_COMMAND} ${var.default_user} ${var.ANSIBLE_OPTIONS}  ../../ansible/infrastructure_bmc.yml;
      
      #Energy AI Intelligence (🆕 NOUVEAU)
      ${var.ANSIBLE_ENV_VARS} ${var.ANSIBLE_COMMAND} ${var.default_user} ${var.ANSIBLE_OPTIONS}  ../../ansible/infrastructure_energy_ai.yml;

      #proxy
      #${var.ANSIBLE_ENV_VARS} ${var.ANSIBLE_COMMAND} ${var.default_user} ${var.ANSIBLE_OPTIONS}  ../../ansible/infrastructure_proxy.yml;

      #kubernetes
      #${var.ANSIBLE_ENV_VARS} ${var.ANSIBLE_COMMAND} ${var.default_user} ${var.ANSIBLE_OPTIONS}  ../../ansible/infrastructure_kubernetes.yml;

      #kubernetes
      #${var.ANSIBLE_ENV_VARS} ${var.ANSIBLE_COMMAND} ${var.default_user} ${var.ANSIBLE_OPTIONS}  ../../ansible/infrastructure_kubernetes_routes.yml;
 
      #kubernetes
      ${var.ANSIBLE_ENV_VARS} ${var.ANSIBLE_COMMAND} ${var.default_user} ${var.ANSIBLE_OPTIONS}  ../../ansible/infrastructure_kubernetes_tooling.yml;

      
    EOT
  }
    depends_on = [module.consul,module.traefik,module.k8sm,module.k8sw,module.minio,module.mqtt,module.influxdb,module.telegraf,module.iot-simulator,module.bmc-simulator,module.energy-ai]
}


resource "null_resource" "destroy_routes" {

  triggers = {
    ansible_env_vars  = var.ANSIBLE_ENV_VARS
    ansible_command   = var.ANSIBLE_COMMAND
    default_user      = var.default_user
    ansible_options   = var.ANSIBLE_OPTIONS
  }

  provisioner "local-exec" {
    command = <<-EOT
      ${self.triggers.ansible_env_vars} ${self.triggers.ansible_command} ${self.triggers.default_user} ${self.triggers.ansible_options} ../../ansible/infrastructure_kubernetes_remove_routes.yml;
    EOT
    when = destroy
  }
}
