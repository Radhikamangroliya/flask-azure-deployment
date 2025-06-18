# Azure Deployment with Terraform & GitHub Actions

## **Deployed Application URL**

Your Flask application is successfully deployed at:

🔗 [**https://flask-web-app-radhika1.azurewebsites.net**](https://flask-web-app-radhika1.azurewebsites.net)

---
## **📌 Project Structure
```sh
hw3-Radhikamangroliya/
│── app/                     # Flask Application Code
│   ├── app.py
│   ├── requirements.txt
│── terraform/                # Terraform Files for Azure
│   ├── main.tf
│── .github/workflows/        # GitHub Actions Workflow
│   ├── azure-cd.yml
│── README.md                 # Documentation
│── .gitignore                # Ignore unnecessary files

```
## **🌟 Project Overview**

This project automates the deployment of a **Flask web application** to **Azure App Service** using **Terraform** and **GitHub Actions CI/CD pipeline**.

It includes:

- **Infrastructure as Code (IaC) with Terraform** for resource provisioning.
- **GitHub Actions workflow** to trigger deployment on new code pushes.
- **Automated deployment** of a Flask application to Azure.

---

## **🛠 Workflow: GitHub Actions CI/CD Pipeline**

The GitHub Actions workflow is stored in `.github/workflows/azure-cd.yml`.

### **👉 Workflow Steps**

1. **Repository Checkout**: Fetches the latest code.
2. **Setup Terraform**: Installs and initializes Terraform.
3. **Terraform Init & Apply**: Provisions Azure resources.
4. **Azure CLI Authentication**: Logs in using Service Principal.
5. **Flask App Deployment**: Deploys the app to Azure.

---

## ** Setup Flask Application
```sh
mkdir -p hw3-Radhikamangroliya/app
cd hw3-Radhikamangroliya/app
```
Create app.py:
Create requirements.txt:
Test Flask app locally:
```sh
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python3 app.py
```
http://127.0.0.1:5000/

## **🗂 Terraform Configuration**

The Terraform scripts are inside the `terraform/` directory.

### **👉 Resources Created**

- **Azure Resource Group**: `flask-resource-group`
- **Azure App Service Plan**: `flask-app-service-plan` (F1 Free Tier)
- **Azure Web App**: `flask-web-app-radhika1`
- 'http://10.11.1.242:5001/'

### **👉 Terraform Commands Used**
```sh
mkdir ../terraform
cd ../terraform
```
Create main.tf
Deploy Infrastructure with Terraform
```sh
az login
terraform init
terraform plan
terraform apply -auto-approve
```
Store your Azure credentials securely using GitHub Secrets to
be used by GitHub Actions and Terraform.
---

## **📂 GitHub Actions Workflow**

The `.github/workflows/azure-cd.yml` file automates deployment.

```yaml
name: Terraform Deploy to Azure

on:
  push:
    branches:
      - HW3  # Ensure you push to this branch to trigger the workflow

jobs:
  terraform:
    runs-on: ubuntu-latest

    steps:
      # Step 1: Checkout the repository
      - name: Checkout Repository
        uses: actions/checkout@v3

      # Step 2: Set up Terraform
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.5.5  # ✅ Use a stable version

      # Step 3: Change Directory to Terraform
      - name: Change Directory to Terraform
        run: cd terraform && ls -la  # ✅ Debug to check Terraform files exist

      # Step 4: Initialize Terraform
      - name: Terraform Init
        run: terraform init
        working-directory: terraform  # ✅ Ensure Terraform runs inside 'terraform' directory

      # Step 5: Terraform Plan (optional but recommended)
      - name: Terraform Plan
        run: terraform plan
        working-directory: terraform
        env:
          ARM_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
          ARM_CLIENT_SECRET: ${{ secrets.AZURE_CLIENT_SECRET }}
          ARM_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
          ARM_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      # Step 6: Apply Terraform Configuration
      - name: Terraform Apply
        run: terraform apply -auto-approve
        working-directory: terraform  # ✅ Runs inside 'terraform' directory
        env:
          ARM_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
          ARM_CLIENT_SECRET: ${{ secrets.AZURE_CLIENT_SECRET }}
          ARM_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
          ARM_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      # Step 7: Install Azure CLI
      - name: Install Azure CLI
        run: |
          curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

      # Step 8: Azure Login using Service Principal
      - name: Azure Login
        run: |
          az login --service-principal -u ${{ secrets.AZURE_CLIENT_ID }} \
            -p ${{ secrets.AZURE_CLIENT_SECRET }} --tenant ${{ secrets.AZURE_TENANT_ID }}

      # Step 9: Deploy Flask App to Azure
      - name: Deploy Flask App to Azure
        run: |
          az webapp up --name flask-web-app-radhika1 \
            --resource-group flask-resource-group \
            --runtime PYTHON:3.12 --location centralus
        working-directory: app  # ✅ Runs inside the 'app' directory
        env:
          AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
          AZURE_CLIENT_SECRET: ${{ secrets.AZURE_CLIENT_SECRET }}
          AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
          AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

```

---

## **🚧 Common Issues & Fixes**

| Issue | Solution |
|--------|----------|
| Terraform Apply Fails: No Configuration Files | Ensure you're inside the `terraform/` directory before running `terraform apply`. |
| App Service Plan Exists in Another Location | Make sure all resources are deployed in the same region (`centralus`). Update the Terraform file if needed. |
| Hostname Already Exists | Change the web app name to something unique, e.g., `flask-web-app-radhika1`. |
| GitHub Actions Fails: No Terraform Files Found | Set `working-directory: terraform` in the workflow file. |
| Web App Not Deploying | Ensure `az webapp up` is running in the correct directory (`app`). |

---

## **📄 How to Reproduce & Deploy**

1️⃣ **Clone the Repository**

```sh
git clone https://github.com/depaul-se441-winter2025/hw3-Radhikamangroliya.git
cd hw3-Radhikamangroliya
```

2️⃣ **Manually Run Terraform**

```sh
cd terraform
terraform init
terraform apply -auto-approve
```

3️⃣ **Trigger CI/CD Pipeline**

- Push any code change to `HW3` branch:

```sh
git add .
git commit -m "Updated app"
git push origin HW3
```

- This triggers **GitHub Actions** to **re-deploy**.

---

## **🌟 Conclusion**

This project successfully deploys a Flask app to **Azure App Service** using **Terraform & GitHub Actions**.

👉 **Infrastructure as Code (IaC)**\
👉 **Automated CI/CD Deployment**\
👉 **Flask App Hosted on Azure**

---

📌 **Author:** *Radhika Mangroliya*\
📌 **Course:** *SE441 - Continuous Delivery & DevOps*\
📌 **Instructor:** *Winter 2025*

