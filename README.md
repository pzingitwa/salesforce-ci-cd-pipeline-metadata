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
## 🔐 Secure Authentication

Authentication is handled using a secure SFDX_AUTH_URL stored as a GitHub Secret, avoiding hardcoding any credentials in the workflow.

---
## 🧪 Apex Test Coverage

The pipeline runs Apex tests and validates them using the RunLocalTests flag during deployment. Logs and results are available in GitHub Actions.

---
## 📸 Screenshots

Add these after running the pipeline:

---
GitHub Actions tab showing the running workflow
<img width="1119" height="623" alt="GitHubActions" src="https://github.com/user-attachments/assets/ba90f30a-64e3-400d-9e0f-73e78ebcd770" />

<img width="1207" height="824" alt="GitHub Actions Logs" src="https://github.com/user-attachments/assets/8b94c5a3-3a74-4059-b755-7988848c08d1" />

Logs of successful deployment
<img width="1107" height="240" alt="Classes deploying messages" src="https://github.com/user-attachments/assets/bba102b5-45f5-49f3-ad05-7374c7f1724b" />


Apex test coverage or CLI output
<img width="1004" height="543" alt="Apex Code Coverage" src="https://github.com/user-attachments/assets/b7b510a0-5bcd-4865-8e19-750aeffa171d" />

---
## 📈 Benefits of this Setup
 
⏱️ Faster deployments and shorter release cycles

🚫 Reduced manual errors

📦 Easy rollback and version tracking via GitHub

🔐 Secure, repeatable deployments across environments

👨‍💻 Better collaboration in teams

✨ Future Improvements
Add PMD static code analysis

Add Slack notifications or deployment badges

Multi-org support (Dev → QA → Prod)

## ⚙️ GitHub Actions Workflow

name: Deploy to Salesforce Sandbox

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout source
      uses: actions/checkout@v3

    - name: Install Salesforce CLI (sf)
      run: npm install @salesforce/cli --global

    - name: Authenticate with SFDX URL
      run: |
        echo "${{ secrets.SFDX_AUTH_URL }}" > auth.txt
        sf org login sfdx-url --sfdx-url-file auth.txt --alias sfdev --set-default

    - name: Confirm SFDX Project Directory
      run: |
        cd ci-cd-project
        ls
        cat sfdx-project.json

    - name: Deploy Metadata to Salesforce Sandbox
      run: |
        cd ci-cd-project
        sf project deploy start --source-dir force-app --target-org sfdev --test-level RunLocalTests --verbose

----


