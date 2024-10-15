resource "aws_iam_role" "nops_integration_role" {
  name = "NopsIntegrationRole-${local.client_id}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.nops_principal}:root"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = local.external_id
          }
        }
      }
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

  tags = {
    version   = "1.1.0"
    createdat = formatdate("YYYYMMDD", timestamp())
  }
  depends_on = [null_resource.force_new_role]
  lifecycle {
    create_before_destroy = true
    replace_triggered_by  = [null_resource.reconfigure_trigger.id]
  }
}

resource "aws_iam_role_policy" "nops_integration_policy" {
  name = "NopsIntegrationPolicy"
  role = aws_iam_role.nops_integration_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cur:DescribeReportDefinitions",
          "cur:DeleteReportDefinition",
          "cur:PutReportDefinition",
          "ce:ListCostAllocationTags",
          "ce:UpdateCostAllocationTagsStatus",
          "organizations:InviteAccountToOrganization",
          "s3:ListBucket",
          "support:DescribeTrustedAdvisorCheckRefreshStatuses",
          "support:DescribeTrustedAdvisorCheckResult",
          "support:DescribeTrustedAdvisorChecks",
          "wellarchitected:*",
          "ce:*"
        ]
        Resource = "*"
      },
      {
        Effect = "Deny"
        Action = [
          "acm-pca:Describe*",
          "acm-pca:Get*",
          "acm-pca:List*",
          "acm:Describe*",
          "acm:Get*",
          "acm:List*",
          "apigateway:GET",
          "appconfig:GetConfiguration*",
          "appflow:DescribeConnector*",
          "appflow:ListConnector*",
          "appstream:DescribeDirectoryConfigs",
          "appstream:DescribeUsers",
          "appstream:DescribeSessions",
          "appsync:Get*",
          "appsync:List*",
          "athena:Get*",
          "athena:List*",
          "backup:GetBackupVaultAccessPolicy",
          "cassandra:Select",
          "chime:Describe*",
          "chime:Get*",
          "chime:List*",
          "cloud9:Describe*",
          "cloud9:Get*",
          "cloud9:List*",
          "clouddirectory:Get*",
          "clouddirectory:List*",
          "cloudfront:GetCloudFrontOriginAccessIdentity",
          "cloudfront:GetFieldLevelEncryption*",
          "cloudfront:GetKeyGroupConfig",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStream",
          "cloudwatch:ListMetricStreams",
          "codeartifact:GetAuthorizationToken",
          "codeartifact:ReadFromRepository",
          "codebuild:BatchGet*",
          "codebuild:ListSourceCredentials",
          "codecommit:BatchGet*",
          "codecommit:Get*",
          "codecommit:GitPull",
          "codedeploy:BatchGet*",
          "codedeploy:Get*",
          "codestar:DescribeUserProfile",
          "codestar:ListUserProfiles",
          "cognito-identity:*",
          "cognito-idp:*",
          "cognito-sync:*",
          "comprehend:Describe*",
          "comprehend:List*",
          "config:BatchGetAggregateResourceConfig",
          "config:BatchGetResourceConfig",
          "config:SelectAggregateResourceConfig",
          "config:SelectResourceConfig",
          "connect:Describe*",
          "connect:Get*",
          "connect:List*",
          "datapipeline:DescribeObjects",
          "datapipeline:EvaluateExpression",
          "datapipeline:QueryObjects",
          "dax:BatchGetItem",
          "dax:GetItem",
          "dax:Query",
          "deepcomposer:Get*",
          "deepcomposer:List*",
          "devicefarm:GetRemoteAccessSession",
          "devicefarm:ListRemoteAccessSessions",
          "directconnect:Describe*",
          "directconnect:List*",
          "discovery:Describe*",
          "discovery:Get*",
          "discovery:List*",
          "dms:Describe*",
          "dms:List*",
          "ds:Get*",
          "dynamodb:GetItem",
          "dynamodb:BatchGetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "ec2:GetConsoleScreenshot",
          "ecr:BatchGetImage",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr-public:GetAuthorizationToken",
          "eks:DescribeIdentityProviderConfig",
          "elasticbeanstalk:DescribeConfigurationOptions",
          "elasticbeanstalk:DescribeConfigurationSettings",
          "es:ESHttpGet*",
          "fis:GetExperimentTemplate",
          "fms:GetAdminAccount",
          "frauddetector:BatchGetVariable",
          "frauddetector:Get*",
          "gamelift:GetGameSessionLogUrl",
          "gamelift:GetInstanceAccess",
          "geo:ListDevicePositions",
          "glue:GetSecurityConfiguration*",
          "glue:SearchTables",
          "glue:GetTable*",
          "guardduty:GetIPSet",
          "guardduty:GetMasterAccount",
          "guardduty:GetMembers",
          "guardduty:ListMembers",
          "guardduty:ListOrganizationAdminAccounts",
          "inspector2:GetConfiguration",
          "imagebuilder:GetImage",
          "iotroborunner:Get*",
          "iotsitewise:ListAccessPolicies",
          "ivs:GetPlaybackKeyPair",
          "ivs:GetStreamSession",
          "kafka:GetBootstrapBrokers",
          "kendra:Query*",
          "kinesis:Get*",
          "kms:DescribeKey",
          "kms:GetPublicKey",
          "lex:Get*",
          "lambda:GetFunctionConfiguration",
          "license-manager:GetGrant",
          "license-manager:GetLicense",
          "license-manager:ListTokens",
          "lightsail:GetBucketAccessKeys",
          "lightsail:GetCertificates",
          "lightsail:GetContainerImages",
          "lightsail:GetKeyPair",
          "lightsail:GetRelationalDatabaseLogStreams",
          "logs:GetLogEvents",
          "logs:StartQuery",
          "machinelearning:GetMLModel",
          "macie2:GetAdministratorAccount",
          "macie2:GetMember",
          "macie2:GetMacieSession",
          "macie2:SearchResources",
          "macie2:GetSensitiveDataOccurrences",
          "nimble:GetStreamingSession",
          "polly:SynthesizeSpeech",
          "proton:GetEnvironmentTemplate",
          "proton:GetServiceTemplate",
          "proton:ListServiceTemplates",
          "proton:ListEnvironmentTemplates",
          "qldb:GetBlock",
          "qldb:GetDigest",
          "rds:Download*",
          "rekognition:CompareFaces",
          "rekognition:Detect*",
          "rekognition:Search*",
          "resiliencehub:DescribeAppVersionTemplate",
          "resiliencehub:ListRecommendationTemplates",
          "robomaker:GetWorldTemplateBody",
          "s3-object-lambda:GetObject",
          "sagemaker:Search",
          "schemas:GetDiscoveredSchema",
          "sdb:Get*",
          "sdb:Select*",
          "secretsmanager:*",
          "securityhub:GetFindings",
          "securityhub:GetMembers",
          "securityhub:ListMembers",
          "ses:GetTemplate",
          "ses:GetEmailTemplate",
          "ses:GetContact",
          "ses:GetContactList",
          "ses:ListTemplates",
          "ses:ListEmailTemplates",
          "ses:ListVerifiedEmailAddresses",
          "signer:GetSigningProfile",
          "signer:ListProfilePermissions",
          "signer:ListSigningProfiles",
          "sms-voice:DescribeKeywords",
          "sms-voice:DescribeOptedOutNumbers",
          "sms-voice:DescribePhoneNumbers",
          "sms-voice:DescribePools",
          "snowball:Describe*",
          "sqs:Receive*",
          "ssm-contacts:*",
          "ssm:DescribeParameters*",
          "ssm:GetParameter*",
          "sso:Describe*",
          "sso:Get*",
          "sso:List*",
          "storagegateway:DescribeChapCredentials",
          "support:DescribeCommunications",
          "timestream:ListDatabases",
          "timestream:ListTables",
          "transcribe:Get*",
          "transcribe:List*",
          "transfer:Describe*",
          "transfer:List*",
          "waf-regional:GetChangeToken",
          "workmail:DescribeUser",
          "workmail:GetMailUserDetails",
          "workmail:ListUsers"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "nops_eventbridge_integration_policy" {
  name = "NopsEventBridgeIntegrationPolicy"
  role = aws_iam_role.nops_integration_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["events:CreateEventBus"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "nops_system_bucket_policy" {
  count = local.is_master_account && var.system_bucket_name != "na" ? 1 : 0
  name  = "NopsSystemBucketPolicy"
  role  = aws_iam_role.nops_integration_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:*"]
        Resource = [
          "arn:aws:s3:::${local.bucket_name}",
          "arn:aws:s3:::${local.bucket_name}/*"
        ]
      }
    ]
  })
}
