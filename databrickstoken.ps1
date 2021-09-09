 $WORKSPACE_ID = (az resource show --resource-type Microsoft.Databricks/workspaces --resource-group '$(rgName)' --name '$(workspaceName)' --query id --output tsv)
          $TOKEN = (az account get-access-token --resource xxxxxx-xxxxxxx-xxxxxxxx-xxxxx | jq --raw-output '.accessToken')
          $AZ_TOKEN = (az account get-access-token --resource https://management.core.windows.net/ | jq --raw-output '.accessToken')
          $HEADERS = @{
              "Authorization" = "Bearer $TOKEN"
              "X-Databricks-Azure-SP-Management-Token" = "$AZ_TOKEN"
              "X-Databricks-Azure-Workspace-Resource-Id" = "$WORKSPACE_ID"
          }
          $BODY = @'
          { "lifetime_seconds": 1200, "comment": "Azure DevOps pipeline" }
'@
          $DB_PAT = ((Invoke-RestMethod -Method POST -Uri "https://$(region).azuredatabricks.net/api/2.0/token/create" -Headers $HEADERS -Body $BODY).token_value)
          Write-Output "##vso[task.setvariable variable=DB_PAT]$DB_PAT"