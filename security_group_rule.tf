resource "aws_security_group_rule" "egress" {
  security_group_id   = "${aws_security_group.security_group.id}"
  type                = "egress"
  from_port           = 0
  to_port             = 0
  protocol            = "-1"
  cidr_blocks         = ["0.0.0.0/0"]

  count = "${var.egress_enable ? 1 : 0}"
}

resource "aws_security_group_rule" "ingress_from_security_group" {
  security_group_id         = "${aws_security_group.security_group.id}"
  type                      = "ingress"
  protocol                  = "${lookup(var.ingress_from_security_group[count.index], "protocol")}"
  from_port                 = "${lookup(var.ingress_from_security_group[count.index], "from_port")}"
  to_port                   = "${lookup(var.ingress_from_security_group[count.index], "to_port")}"
  source_security_group_id  = "${lookup(var.ingress_from_security_group[count.index], "source_security_group_id")}"

  count = "${var.ingress_from_security_group_count}"
}

resource "aws_security_group_rule" "ingress_from_cidr_blocks" {
  security_group_id         = "${aws_security_group.security_group.id}"
  type                      = "ingress"
  protocol                  = "${lookup(var.ingress_from_cidr_blocks[count.index], "protocol")}"
  from_port                 = "${lookup(var.ingress_from_cidr_blocks[count.index], "from_port")}"
  to_port                   = "${lookup(var.ingress_from_cidr_blocks[count.index], "to_port")}"
  cidr_blocks               = ["${split(",", lookup(var.ingress_from_cidr_blocks[count.index], "cidr_blocks"))}"]

  count = "${var.ingress_from_cidr_blocks_count}"
}

resource "aws_security_group_rule" "ingress_from_self" {
  security_group_id = "${aws_security_group.security_group.id}"
  type              = "ingress"
  protocol          = "${lookup(var.ingress_from_self[count.index], "protocol")}"
  from_port         = "${lookup(var.ingress_from_self[count.index], "from_port")}"
  to_port           = "${lookup(var.ingress_from_self[count.index], "to_port")}"
  self              = true

  count = "${var.ingress_from_self_count}"
}
