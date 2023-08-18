data "aws_iam_policy_document" "assume_role_billing" {
  statement {
    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${var.idp_account_id}:root",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

data "aws_iam_policy_document" "cost_explorer_billing" {
  statement {
    actions   = ["ce:Get*",
                "ce:Describe*",
                "ce:List*",
                "account:GetAccountInformation",
                "billing:Get*",
                "payments:List*",
                "payments:Get*",
                "tax:List*",
                "tax:Get*",
                "consolidatedbilling:Get*",
                "consolidatedbilling:List*",
                "invoicing:List*",
                "invoicing:Get*",
                "cur:Get*",
                "cur:Validate*",
                "freetier:Get*"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "billing" {
  name                 = "${var.org_name}-billing"
  assume_role_policy   = data.aws_iam_policy_document.assume_role_billing.json
  inline_policy {
    name = "cost_explorer_billing"
    policy = data.aws_iam_policy_document.cost_explorer_billing.json
  }
  max_session_duration = var.role_max_session_duration
}

resource "aws_iam_role_policy_attachment" "billing" {
  role       = aws_iam_role.billing.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}
