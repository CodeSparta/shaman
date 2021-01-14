resource "aws_iam_instance_profile" "master" {
  name = "${var.cluster_name}-master-profile"

  role = aws_iam_role.master_role.name
}

resource "aws_iam_role" "master_role" {
  name = "${var.cluster_name}-master-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.cluster_name}-master-role"
    )
  )
}

resource "aws_iam_role_policy" "master_policy" {
  name = "${var.cluster_name}-master-policy"
  role = aws_iam_role.master_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "ec2:*",
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": "iam:PassRole",
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action" : [
        "s3:GetObject"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": "elasticloadbalancing:*",
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF

}