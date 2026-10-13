removed {
  from = random_id.telem

  lifecycle {
    destroy = false
  }
}

removed {
  from = azurerm_resource_group_template_deployment.telemetry

  lifecycle {
    destroy = false
  }
}
