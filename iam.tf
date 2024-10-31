resource "aws_iam_role" "nops_integration_role" {
  name = "NopsIntegrationRole-${local.client_id}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.nops_principal}:root"
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

  tags = {
    version = "1.1.0"
  }
}

resource "aws_iam_role_policy" "nops_wafr_policy" {
  count = var.wafr ? 1 : 0
  name  = "NopsWAFRPolicy"
  role  = aws_iam_role.nops_integration_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "access-analyzer:GetAccessPreview",
          "access-analyzer:GetAnalyzedResource",
          "access-analyzer:GetAnalyzer",
          "access-analyzer:GetArchiveRule",
          "access-analyzer:GetFinding",
          "access-analyzer:GetGeneratedPolicy",
          "access-analyzer:ListAccessPreviewFindings",
          "access-analyzer:ListAccessPreviews",
          "access-analyzer:ListAnalyzedResources",
          "access-analyzer:ListAnalyzers",
          "access-analyzer:ListArchiveRules",
          "access-analyzer:ListFindings",
          "access-analyzer:ListPolicyGenerations",
          "access-analyzer:ListTagsForResource",
          "access-analyzer:ValidatePolicy",
          "cloudtrail:DescribeTrails",
          "cloudtrail:LookupEvents",
          "cloudwatch:GetMetricStatistics",
          "config:DescribeConfigurationRecorders",
          "dynamodb:DescribeTable",
          "iam:ListUsers",
          "iam:GetRole",
          "iam:GetAccountSummary",
          "iam:GetAccountPasswordPolicy",
          "iam:ListAttachedUserPolicies",
          "inspector:ListAssessmentRuns",
          "ec2:DescribeFlowLogs",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "trustedadvisor:GetOrganizationRecommendation",
          "trustedadvisor:GetRecommendation",
          "trustedadvisor:ListChecks",
          "trustedadvisor:ListOrganizationRecommendationAccounts",
          "trustedadvisor:ListOrganizationRecommendationResources",
          "trustedadvisor:ListOrganizationRecommendations",
          "trustedadvisor:ListRecommendationResources",
          "trustedadvisor:ListRecommendations",
          "wellarchitected:*",
          "workspaces:DescribeWorkspaceDirectories"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "nops_essentials_policy" {
  count = var.essentials ? 1 : 0
  name  = "NopsEssentialsPolicy"
  role  = aws_iam_role.nops_integration_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:ListMetrics",
          "events:CreateEventBus",
          "scheduler:GetSchedule",
          "scheduler:GetScheduleGroup",
          "scheduler:ListScheduleGroups",
          "scheduler:ListSchedules",
          "scheduler:ListTagsForResource",
        ],
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy" "nops_compute_copilot_policy" {
  count = var.compute_copilot ? 1 : 0
  name  = "NopsComputeCopilotPolicy"
  role  = aws_iam_role.nops_integration_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:DescribeLaunchConfigurations",
          "ec2:DescribeImages",
          "lambda:InvokeFunction",
          "cloudformation:ListStacks",
          "cloudformation:DescribeStacks",
        ]
        Resource = "*"
      }
    ]
  })
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
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling-plans:DescribeScalingPlans",
          "autoscaling-plans:GetScalingPlanResourceForecastData",
          "autoscaling-plans:DescribeScalingPlanResources",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribePolicies",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeLoadBalancers",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAccountLimits",
          "apigateway:GET",
          "ce:DescribeCostCategoryDefinition",
          "ce:DescribeNotificationSubscription",
          "ce:DescribeReport",
          "ce:GetAnomalies",
          "ce:GetAnomalyMonitors",
          "ce:GetAnomalySubscriptions",
          "ce:GetApproximateUsageRecords",
          "ce:GetCostAndUsage",
          "ce:GetCostAndUsageWithResources",
          "ce:GetCostCategories",
          "ce:GetCostForecast",
          "ce:GetDimensionValues",
          "ce:GetPreferences",
          "ce:GetReservationCoverage",
          "ce:GetReservationPurchaseRecommendation",
          "ce:GetReservationUtilization",
          "ce:GetRightsizingRecommendation",
          "ce:GetSavingsPlanPurchaseRecommendationDetails",
          "ce:GetSavingsPlansCoverage",
          "ce:GetSavingsPlansPurchaseRecommendation",
          "ce:GetSavingsPlansUtilization",
          "ce:GetSavingsPlansUtilizationDetails",
          "ce:GetTags",
          "ce:GetUsageForecast",
          "ce:ListCostAllocationTagBackfillHistory",
          "ce:ListCostAllocationTags",
          "ce:ListCostCategoryDefinitions",
          "ce:ListSavingsPlansPurchaseRecommendationGeneration",
          "ce:ListTagsForResource",
          "ce:StartSavingsPlansPurchaseRecommendationGeneration",
          "compute-optimizer:DescribeRecommendationExportJobs",
          "compute-optimizer:GetAutoScalingGroupRecommendations",
          "compute-optimizer:GetEBSVolumeRecommendations",
          "compute-optimizer:GetEC2InstanceRecommendations",
          "compute-optimizer:GetEC2RecommendationProjectedMetrics",
          "compute-optimizer:GetECSServiceRecommendationProjectedMetrics",
          "compute-optimizer:GetECSServiceRecommendations",
          "compute-optimizer:GetEffectiveRecommendationPreferences",
          "compute-optimizer:GetEnrollmentStatus",
          "compute-optimizer:GetEnrollmentStatusesForOrganization",
          "compute-optimizer:GetLambdaFunctionRecommendations",
          "compute-optimizer:GetLicenseRecommendations",
          "compute-optimizer:GetRDSDatabaseRecommendationProjectedMetrics",
          "compute-optimizer:GetRDSDatabaseRecommendations",
          "compute-optimizer:GetRecommendationPreferences",
          "compute-optimizer:GetRecommendationSummaries",
          "config:DescribeConfigurationRecorders",
          "consolidatedbilling:GetAccountBillingRole",
          "cost-optimization-hub:GetPreferences",
          "cost-optimization-hub:GetRecommendation",
          "cost-optimization-hub:ListEnrollmentStatuses",
          "cost-optimization-hub:ListRecommendations",
          "cost-optimization-hub:ListRecommendationSummaries",
          "consolidatedbilling:ListLinkedAccounts",
          "cur:GetClassicReport",
          "cur:GetClassicReportPreferences",
          "cur:GetUsageReport",
          "cur:DescribeReportDefinitions",
          "cur:PutReportDefinition",
          "dynamodb:ListTables",
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeNatGateways",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeRegions",
          "ec2:DescribeReservedInstances",
          "ec2:DescribeVolumes",
          "ec2:DescribeVpcs",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeSnapshots",
          "ecs:ListClusters",
          "eks:ListTagsForResource",
          "eks:ListClusters",
          "eks:ListNodegroups",
          "eks:DescribeCluster",
          "eks:DescribeNodegroup",
          "elasticache:DescribeCacheClusters",
          "elasticache:DescribeCacheSubnetGroups",
          "elasticfilesystem:DescribeFileSystems",
          "elasticloadbalancing:DescribeLoadBalancers",
          "es:DescribeElasticsearchDomains",
          "es:ListDomainNames",
          "events:ListRules",
          "guardduty:ListDetectors",
          "iam:ListRoles",
          "iam:ListAccountAliases",
          "kms:Decrypt",
          "lambda:GetFunction",
          "lambda:GetPolicy",
          "lambda:ListFunctions",
          "organizations:InviteAccountToOrganization",
          "rds:DescribeDBClusters",
          "rds:DescribeDBInstances",
          "rds:DescribeDBSnapshots",
          "rds:DescribeDBClusterSnapshotAttributes",
          "rds:DescribeDBClusterSnapshots",
          "rds:DescribeDBRecommendations",
          "rds:DescribeDBSecurityGroups",
          "rds:ListTagsForResource",
          "redshift:DescribeClusters",
          "s3:ListAllMyBuckets",
          "s3:GetBucketVersioning",
          "savingsplans:DescribeSavingsPlanRates",
          "savingsplans:DescribeSavingsPlans",
          "savingsplans:DescribeSavingsPlansOfferingRates",
          "savingsplans:DescribeSavingsPlansOfferings",
          "savingsplans:ListTagsForResource",
          "support:DescribeCases",
          "support:DescribeTrustedAdvisorCheckRefreshStatuses",
          "support:DescribeTrustedAdvisorCheckResult",
          "support:DescribeTrustedAdvisorChecks",
          "tag:GetResources",
          "tag:GetTagValues",
          "tag:DescribeReportCreation",
          "tag:GetTagKeys",
          "tag:GetComplianceSummary",
          "organizations:ListAccounts",
          "organizations:DescribeOrganization",
          "organizations:ListRoots",
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "nops_system_bucket_policy" {
  count = local.is_master_account && local.system_bucket_name != "na" ? 1 : 0
  name  = "NopsSystemBucketPolicy"
  role  = aws_iam_role.nops_integration_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketPolicy",
          "s3:GetEncryptionConfiguration",
          "s3:GetBucketVersioning",
          "s3:GetBucketPolicyStatus",
          "s3:GetBucketLocation",
          "s3:GetBucketAcl",
          "s3:GetBucketLogging",
          "s3:GetObject",
          "s3:PutBucketPolicy",
          "s3:PutObject",
          "s3:HeadBucket"
        ]
        Resource = [
          "arn:aws:s3:::${local.system_bucket_name}",
          "arn:aws:s3:::${local.system_bucket_name}/*"
        ]
      }
    ]
  })
}
