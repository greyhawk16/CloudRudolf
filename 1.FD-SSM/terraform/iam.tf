# sonic user create
resource "aws_iam_user" "cr-fd-user-sonic" {
  name = "sonic-${var.crid}"
  tags = {
    Name = "cr-fd-user-sonic-${var.crid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}
resource "aws_iam_access_key" "cr-fd-ac-sonic" {
  user = "${aws_iam_user.cr-fd-user-sonic.name}"
}


#IAM User Policies
resource "aws_iam_policy" "cr-fd-user-sonic-list-policy" {
  name = "cr-fd-user-sonic-list-policy-${var.crid}"
  description = "cr-fd-user-sonic-list-policy-${var.crid}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "iam:GetUserPolicy",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:ListUserPolicies",
                "iam:ListAttachedUserPolicies",
                "iam:ListPolicyVersions",
                "iam:ListAttachedRolePolicies"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
resource "aws_iam_policy" "cr-fd-user-sonic-policy" {
  name = "cr-fd-user-sonic-policy-${var.crid}"
  description = "cr-fd-user-sonic-policy-${var.crid}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeSecurityGroups"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Statement2",
            "Effect": "Allow",
            "Action": [
                "ssm:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


#User Policy Attachments
resource "aws_iam_user_policy_attachment" "cr-fd-user-sonic-list-attachment" {
  user = "${aws_iam_user.cr-fd-user-sonic.name}"
  policy_arn = "${aws_iam_policy.cr-fd-user-sonic-list-policy.arn}"

}
resource "aws_iam_user_policy_attachment" "cr-fd-user-sonic-attachment" {
  user = "${aws_iam_user.cr-fd-user-sonic.name}"
  policy_arn = "${aws_iam_policy.cr-fd-user-sonic-policy.arn}"

}