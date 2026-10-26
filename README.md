# Automated CI/CD & GitOps Pipeline for Node.js Application

This repository demonstrates a complete modern DevOps workflow, simulating the process from a Developer pushing code to the automatic deployment and monitoring of the application on a Kubernetes cluster.

## 🏗️ Architecture Overview
*(Insert your architecture diagram image here)*

- **Source Control (SCM):** Gitea
- **CI Engine:** Tekton (Git Clone -> Build -> Kaniko Push Image -> Auto Update GitOps Repo)
- **Image Registry:** Docker Hub
- **CD Engine:** Argo CD (GitOps, Kustomize, ApplicationSet)
- **Target Cluster:** K3s (running on WSL2)
- **Monitoring:** Prometheus & Grafana

## 🔄 Workflows

1. **Code Push:** Developer pushes code to the `my-app-source` repository on Gitea.
2. **CI Trigger:** Gitea sends a Webhook to the Tekton EventListener, triggering the CI pipeline.
3. **Build & Push:** Tekton pulls the code, builds the Node.js application, and uses Kaniko to build & push the Docker image to Docker Hub.
4. **GitOps Update:** Tekton updates the new image tag in the `my-app-gitops` repository (via `yq`), then commits and pushes the change back to Git.
5. **CD Sync:** Argo CD detects the GitOps repo change, uses Kustomize to render configurations for multiple environments (`ns-1`, `ns-2`), and syncs them to the K3s cluster.
6. **Auto-Healing:** Argo CD `selfHeal` ensures the cluster state always matches the Git repository.
7. **Monitoring:** Prometheus scrapes metrics from the cluster, and Grafana visualizes them via dashboards.

## 📁 Repository Structure

- `01-source-code/`: Node.js application source code and Dockerfile.
- `02-gitops-config/`: Kustomize configs (base/overlays) and Helm chart for Monitoring.
- `03-tekton-pipelines/`: Tekton Tasks, Pipelines, and Triggers.
- `04-argocd-config/`: Argo CD Application/ApplicationSet manifests.

## 🚀 Key Features

- **Zero-touch Deployment:** Fully automated from `git push` to production deployment.
- **Multi-Environment Management:** Easily scale to new environments (e.g., `ns-3`) using Kustomize overlays without duplicating code.
- **GitOps Best Practices:** Git is the single source of truth for both application code and infrastructure configuration.
- **Resource Optimization:** Strict resource limits and custom values configured to run smoothly on a local 16GB RAM machine.