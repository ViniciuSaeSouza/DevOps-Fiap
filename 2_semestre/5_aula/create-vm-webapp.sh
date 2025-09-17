#!/bin/bash

#
# Execute este script no Azure Cloud Shell
#

# Variáveis
RG_NAME="rg-deploys"
LOCATION="eastus"
VM_NAME="Win11DevVM"
ADMIN_USER="rm9999"
ADMIN_PASSWORD="Fiap@2tdsvms"
VM_SIZE="Standard_B2ms" # 2 vCPUs, 8GB RAM
IMAGE="MicrosoftWindowsDesktop:windows-11:win11-23h2-pro:22631.5768.250808"
OS_DISK_SIZE=128
NSG_NAME="${VM_NAME}-nsg"

# Criação do Grupo de Recursos
echo "Criando o Grupo de Recursos..."
az group create --name $RG_NAME --location $LOCATION

# Criação da VM
echo "Criando VM Windows 11..."
az vm create \
  --resource-group $RG_NAME \
  --name $VM_NAME \
  --image $IMAGE \
  --size $VM_SIZE \
  --admin-username $ADMIN_USER \
  --admin-password "$ADMIN_PASSWORD" \
  --storage-sku StandardSSD_LRS \
  --os-disk-size-gb $OS_DISK_SIZE \
  --nsg $NSG_NAME \
  --public-ip-sku Standard

# Agendar desligamento automático
echo "Agendando desligamento automático para 23:30h (Brasília / GMT -3)"
az vm auto-shutdown \
  --resource-group $RG_NAME \
  --name $VM_NAME \
  --time 0230

# Instalar Ferramentas necessárias
echo "Instalando: Java 21, Eclipse, Maven, VSC e Git"
az vm run-command invoke \
  --resource-group $RG_NAME \
  --name $VM_NAME \
  --command-id RunPowerShellScript \
  --scripts "
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
    choco install microsoft-openjdk-21 -y;
    \$Java = Get-ChildItem 'C:\Program Files' -Filter '*jdk*' -Directory | Select-Object -First 1;
    if (\$Java) {
      [Environment]::SetEnvironmentVariable('JAVA_HOME', \$Java.FullName, 'Machine');
      \$CurrentPath = [Environment]::GetEnvironmentVariable('Path', 'Machine');
      [Environment]::SetEnvironmentVariable('Path', \"\$CurrentPath;\$($Java.FullName)\\bin\", 'Machine');
      Write-Host \"JAVA_HOME: \$($Java.FullName)\" -ForegroundColor Green;
    }
    choco install vscode -y;
    choco install eclipse -y;
    choco install git -y;
    choco install maven --version=3.9.11 -y;
    [Environment]::SetEnvironmentVariable('M2_HOME', 'C:\ProgramData\chocolatey\lib\maven\apache-maven-3.9.11', 'Machine');
    \$CurrentPath = [Environment]::GetEnvironmentVariable('Path', 'Machine');
    if (-not (\$CurrentPath -like '*C:\ProgramData\chocolatey\lib\maven\apache-maven-3.9.11\bin*')) {
      [Environment]::SetEnvironmentVariable('Path', \"\$CurrentPath;C:\ProgramData\chocolatey\lib\maven\apache-maven-3.9.11\\bin\", 'Machine');
    }
  "


#
# Conteúdo extra
#

#
# Instalar Gradle
#
# Abra um terminal do Power Shell e execute como Administrador
#
#choco install gradle --version=9.0.0 -y

# Definir a variável de ambiente GRADLE_HOME para o diretório do Gradle instalado via Chocolatey
#[System.Environment]::SetEnvironmentVariable("GRADLE_HOME", "C:\ProgramData\chocolatey\lib\gradle\tools\gradle-9.0.0", [System.EnvironmentVariableTarget]::Machine)

# Adicionar GRADLE_HOME\bin ao PATH do sistema
#$oldPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
#$newPath = "$oldPath;${env:GRADLE_HOME}\bin"
#[System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
#
# REINCIE O TERMINAL PARA QUE AS VARIÁVEIS ENTREM EM VIGOR NA SESSÃO
#
#$env:GRADLE_HOME
#$Env:PATH

#
# Instalar Azure CLI
#
# choco install azure-cli -y

#
# Instalar CURL
#
# choco install curl -y
