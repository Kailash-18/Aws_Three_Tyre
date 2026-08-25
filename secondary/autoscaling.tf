resource "aws_autoscaling_group" "frontend" {
  name_prefix         = "${var.project_name}-secondary-frontend-asg-"
  min_size            = var.frontend_min_size
  desired_capacity    = var.frontend_desired_size
  max_size            = var.frontend_max_size
  vpc_zone_identifier = aws_subnet.frontend[*].id

  health_check_type         = "ELB"
  health_check_grace_period = 300
  default_instance_warmup   = 180
  target_group_arns         = [aws_lb_target_group.frontend.arn]

  launch_template {
    id      = aws_launch_template.frontend.id
    version = aws_launch_template.frontend.latest_version
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
      instance_warmup        = 180
    }

    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-secondary-frontend"
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "Kailash Ambadipudi"
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = "Terraform"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "frontend_cpu" {
  name                   = "${var.project_name}-secondary-frontend-cpu"
  autoscaling_group_name = aws_autoscaling_group.frontend.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.autoscaling_target_cpu
  }
}

resource "aws_autoscaling_group" "backend" {
  name_prefix         = "${var.project_name}-secondary-backend-asg-"
  min_size            = var.backend_min_size
  desired_capacity    = var.backend_desired_size
  max_size            = var.backend_max_size
  vpc_zone_identifier = aws_subnet.backend[*].id

  health_check_type         = "ELB"
  health_check_grace_period = 300
  default_instance_warmup   = 180
  target_group_arns         = [aws_lb_target_group.backend.arn]

  launch_template {
    id      = aws_launch_template.backend.id
    version = aws_launch_template.backend.latest_version
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
      instance_warmup        = 180
    }

    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-secondary-backend"
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "Kailash Ambadipudi"
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = "Terraform"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "backend_cpu" {
  name                   = "${var.project_name}-secondary-backend-cpu"
  autoscaling_group_name = aws_autoscaling_group.backend.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.autoscaling_target_cpu
  }
}
