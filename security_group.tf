resource "aws_security_group" "security_group" {
  lifecycle {
    create_before_destroy = true
  }

  name_prefix = "${var.name}-"
  description = "${var.description}"
  vpc_id      = "${var.vpc}"

  tags = "${merge(
    map("Name", var.name),
    var.tags
  )}"
}

output "security_group" {
  value = {
    id          = "${aws_security_group.security_group.id}"
    name        = "${aws_security_group.security_group.name}"
    description = "${aws_security_group.security_group.description}"
  }
}
