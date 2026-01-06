#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:?env required: dev|staging|prod}"
CLUSTER_NAME="${2:?cluster name required}"
AWS_REGION="${3:?aws region required}"
NAMESPACE="${4:?k8s namespace required}"
ECR_REPO="${5:?ecr repo required (full URI)}"
IMAGE_TAG="${6:?image tag required (sha)}"

echo "Deploying environment=$ENVIRONMENT cluster=$CLUSTER_NAME namespace=$NAMESPACE image=$ECR_REPO:$IMAGE_TAG"

aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$AWS_REGION"

helm upgrade --install myapp apps/helm/charts/myapp \
  --namespace "$NAMESPACE" --create-namespace \
  -f "apps/helm/envs/${ENVIRONMENT}/myapp-values.yaml" \
  --set image.repository="$ECR_REPO" \
  --set image.tag="$IMAGE_TAG"
