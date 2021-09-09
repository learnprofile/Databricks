$RESULT = (az group exists --name $(rgName))
          if ($RESULT -eq 'false') {
            Write-Output "[INFO] Resource group does not exist, creating.."
            az group create --name $(rgName) --location $(region)
          } else {
            Write-Output "[ERROR] Resource group already exists"
            exit 1
          }