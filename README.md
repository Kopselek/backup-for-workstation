# Backup for Workstation (Terraform)

This project contains two scripts: one written in Terraform and the other in PowerShell. The Terraform script should be run on a host or the GCP administrator's PC. The PowerShell scripts are intended to be run on the workstation that you would like to back up.

## Terraform

### Installation

- Install Terraform from [Terraform downloads page](https://www.terraform.io/downloads.html)

### Configuration

- Create a `terraform.tfvars` file from `terraform.tfvars.example`
- Provide values for the variables, including the project ID, region, and user emails.
- Run the following commands in the directory containing your Terraform files.

     ```sh
     terraform init
     terraform apply
     ```

## PowerShell

### Installation

- Install Google Cloud SDK from [Google Cloud SDK downloads page](https://cloud.google.com/sdk/docs/install)

- If PowerShell is not already installed, follow the [PowerShell installation instructions](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell).

### Configuration

- Log in to your Google account
    ```
    gcloud auth login
    ```
- Set the project ID the same as the one used to create the buckets in Terraform (GCP)
    ```
    gcloud config set project [PROJECT_ID]
    ```
- Configurate config.json:
    - user variable is domain from email. For example.example@gmail.com it will be example.example
    - localFolderPath is path for destination path you want to Backup
    - hour and minute variables are for schedule script
- Run `upload_folder.ps1` if you want make Backup
- Run (as admin) `upload_folder_schedule.ps1` if you want to set Windows Scheduler with hour and minute from config.json to run `upload_folder.ps1`
