resource "aws_iam_role" "nodes_general" {
  name               = var.worker_eks_role
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# resource "aws_iam_policy" "aws_secret" {
#   name = "raj-eks-read-secret"
#   policy = jsondecode(
#    {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "secretsmanager:GetSecretValue",
#                 "secretsmanager:DescribeSecret"
#             ],
#             "Resource": "arn:aws:secretsmanager:us-east-2:718455846845:secret:qa/legacy/imp-Kw2Gcn"
#         }
#     ]
# }
# )
# }


resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_general" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon-eks_cni_Policy_general" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes_general.name
}


resource "aws_eks_node_group" "nodes_general" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.nodes_general.arn
  subnet_ids      = data.aws_subnets.main.ids

  scaling_config {
    desired_size = var.desire_size
    max_size     = var.max_size
    min_size     = var.min_size
  }
  ami_type             = var.ami_type
  capacity_type        = var.capacity_type
  disk_size            = var.disk_size
  force_update_version = var.force_update_version
  instance_types       = [var.instance_type]

  labels = {
    role = "nodes-general"
  }

  version = var.eks_version
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.amazon-eks_cni_Policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
    aws_iam_role.eks_cluster
  ]
}