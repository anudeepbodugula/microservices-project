# 🧩 Microservices DevOps Project

This project showcases a complete microservices architecture using Docker, Kubernetes, Helm charts, and GitOps-ready patterns. Each service is independently deployable and follows cloud-native, secure, and scalable practices.

---

## 📦 Services and Technologies

| Service              | Description                                        | Language         | Containerization | K8s Deployment | Helm Chart |
|----------------------|----------------------------------------------------|------------------|------------------|----------------|------------|
| `auth-service`       | Auth & token issuing service                      | Python (Flask)   | ✅ Multi-stage    | ✅              | ✅          |
| `review-service`     | Peer review and feedback system                   | Java Maven       | ✅                | ✅              | ✅          |
| `publication-service`| Handles content publishing and article mgmt       | Go               | ✅                | ✅              | ✅          |
| `frontend`           | UI to interact with services                      | Html             | ✅                | ✅              | (Planned)   |
| `mysql`              | Persistent relational database                    | MySQL            | ✅                | ✅              | (via YAML)  |

---

## 🐳 Dockerization

Each service uses **multi-stage builds** for small, efficient images. Example from a 'python-service':

```dockerfile
# Stage 1: Build Python dependencies
FROM python:3.10-slim as builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user -r requirements.txt

# Stage 2: Final image
FROM python:3.10-slim
WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY . .
ENV PATH=/root/.local/bin:$PATH
CMD ["python", "app.py"]

	•	Uses slim images for minimal surface area
	•	Dependencies are separated to reduce layer cache invalidation
	•	Secure and fast to build

⸻

☸️ Kubernetes Manifests

Services are deployed using Kubernetes manifests with the following best practices:
	•	Deployment.yaml with:
	•	Liveness and readiness probes
	•	Rolling update strategy
	•	Resource requests and limits
	•	Service.yaml (ClusterIP)
	•	Secret.yaml using envFrom
	•	Namespace: All under dev

File structure example:

kubernetes/
  └── auth-service/
      ├── deployment.yaml
      ├── service.yaml
      ├── secret.yaml


⸻

📦 Helm Charts

Each service has been converted into a Helm chart for:
	•	Reusability across environments (dev/stage/prod)
	•	Versioning and rollback support
	•	Template-driven configuration (values.yaml)
	•	Reusable helper templates (_helpers.tpl)

Example structure:

auth-service/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── secret.yaml
│   ├── NOTES.txt
│   └── _helpers.tpl


⸻

🔁 Helm Workflow

🧪 Lint and Dry-Run

helm lint .
helm template auth-service . --namespace dev

🚀 Install

helm install auth-service . --namespace dev --create-namespace

🔄 Upgrade

helm upgrade auth-service . --namespace dev

🧾 History & Rollback

helm history auth-service -n dev
helm rollback auth-service <REVISION> -n dev


📂 Repository Structure

.
├── auth-service/
│   ├── Dockerfile
│   └── helm chart/
├── publication-service/
├── review-service/
├── frontend/
├── kubernetes/
│   ├── mysql/
│   └── shared/
├── README.md
└── helm-charts/


⸻

🧪 Local Testing

kubectl port-forward svc/auth-service 8080:5001 -n dev
curl http://localhost:8080/health


⸻

✅ What You’ll Learn from This Project
	•	Microservices orchestration with Kubernetes
	•	Secure, efficient Docker builds
	•	Helm chart design from scratch
	•	Secret management and environment overrides
	•	Real-world rollout strategies with Helm
	•	GitOps-compatible architecture

⸻

👨‍💻 Maintainer

Anudeep Murali
DevOps Engineer | SRE | Kubernetes Architect
📍 Toronto, ON
🔗 GitHub