# resource "aws_iam_openid_connect_provider" "cluster" {
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = []
#   url             = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
# }

# resource "aws_eks_identity_provider_config" "example" {
#   cluster_name = aws_eks_cluster.eks.name

#   oidc {
#     client_id                     = "kubernetes"
#     identity_provider_config_name = "raj-eks-oidc"
#     issuer_url                    =   aws_eks_cluster.eks.aws_eks_identity_provider_config  # var.oidc_of_eks_cluster.identity.issuer_url
#   }
# }