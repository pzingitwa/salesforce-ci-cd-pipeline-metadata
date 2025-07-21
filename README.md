# Salesforce CI/CD Pipeline using GitHub Actions

This project demonstrates a complete Continuous Integration and Continuous Deployment (CI/CD) pipeline for Salesforce Metadata using GitHub Actions and Salesforce DX. It enables automated deployments to a Salesforce sandbox when changes are pushed to the `main` branch.

---

## 🔧 Technologies Used

- **Salesforce DX (SFDX)**
- **GitHub Actions**
- **VS Code**
- **Git**
- **Sandbox Org (Test Environment)**

---

## 🎯 Project Goals

- Automate metadata deployment to Salesforce sandbox
- Run Apex test classes with each deployment
- Maintain source control of Salesforce metadata via GitHub
- Improve deployment reliability and developer velocity

---

## 🧱 Folder Structure
ci-cd-project
│
├── .github/
│ └── workflows/
│ └── deploy.yml # GitHub Actions pipeline config
├── force-app/
│ └── main/
│ └── default/ # Salesforce metadata (classes, triggers, etc.)
├── README.md # Project documentation
└── sfdx-project.json # Salesforce DX project config


---

## 🚀 CI/CD Pipeline Flow

1. Developer pushes code to the `main` branch
2. GitHub Actions is triggered
3. Salesforce CLI is installed
4. Org is authenticated using a secure SFDX Auth URL
5. Source is deployed to the sandbox
6. Apex tests are run and validated

---

## ⚙️ GitHub Actions Workflow

```yaml
name: Deploy to Salesforce Sandbox

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout source
      uses: actions/checkout@v2

    - name: Install Salesforce CLI
      run: npm install sfdx-cli --global

    - name: Authenticate to Salesforce
      run: |
        echo "${{ secrets.SFDX_AUTH_URL }}" > auth-url.txt
        sfdx auth:sfdxurl:store -f auth-url.txt -a MySandbox

    - name: Deploy to Sandbox
      run: |
        sfdx force:source:deploy -p force-app -u MySandbox --testlevel RunLocalTests
'''
---

##🔐 Secure Authentication
Authentication is handled using a secure SFDX_AUTH_URL stored as a GitHub Secret, avoiding hardcoding any credentials in the workflow.

---

##🧪 Apex Test Coverage
The pipeline runs Apex tests and validates them using the RunLocalTests flag during deployment. Logs and results are available in GitHub Actions.

---

##📸 Screenshots
Add these after running the pipeline:

---

GitHub Actions tab showing the running workflow

Logs of successful deployment

Apex test coverage or CLI output

---

📈 Benefits of this Setup
⏱️ Faster deployments and shorter release cycles

🚫 Reduced manual errors

📦 Easy rollback and version tracking via GitHub

🔐 Secure, repeatable deployments across environments

👨‍💻 Better collaboration in teams

✨ Future Improvements
Add PMD static code analysis

Add Slack notifications or deployment badges

Multi-org support (Dev → QA → Prod)
