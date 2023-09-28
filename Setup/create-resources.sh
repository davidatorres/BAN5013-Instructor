# Author: Prof. Torres
# Date:   2023-09-24
# Description: Create resources for in-person class of BAN5013

clear

#!/bin/zsh

# Calculate the date one day from now
tomorrow=$(strftime "%Y-%m-%dT%H:%M:%SZ" $((EPOCHSECONDS + 86400)))

az sql server create \
    --location westus3 \
    --subscription vse-fte \
    --resource-group ban5013rg \
    --name ban$1 \
    --minimal-tls-version 1.2 \
    --enable-public-network true \
    --admin-user ban5013 \
    --admin-password ban@$1 

az sql server firewall-rule create \
    --subscription vse-fte \
    --resource-group ban5013rg \
    --server ban$1 \
    --name AllowAllIps \
    --start-ip-address 0.0.0.0 \
    --end-ip-address 255.255.255.255 

az sql db create \
    --subscription vse-fte \
    --resource-group ban5013rg \
    --server ban$1 \
    --name AdventureWorks \
    --edition GeneralPurpose \
    --capacity 2 \
    --compute-model Serverless \
    --family Gen5 \
    --auto-pause-delay 150 \
    --zone-redundant false 

az sql db create \
    --subscription vse-fte \
    --resource-group ban5013rg \
    --server ban$1 \
    --name AdventureWorksLT \
    --edition GeneralPurpose \
    --capacity 2 \
    --compute-model Serverless \
    --family Gen5 \
    --auto-pause-delay 150 \
    --zone-redundant false 

SAS=$(az storage container generate-sas \
    --account-name ban5013st \
    --account-key "2ZOR64xakvsM97HOT/gWQ+mrJ0D8wNGD3zzR038ccLNFu8dDWfRhXPO4M0ASTeOl0NPsoATW//pi+AStcog0pg==" \
    --name backup \
    --permissions rl \
    --expiry $tomorrow) 

SAS=$(echo $SAS | sed 's/\"//g')
    
echo $SAS

# az sql db import \
#     --subscription vse-fte \
#     --resource-group ban5013rg \
#     --server ban$1 \
#     --name AdventureWorks \
#     --admin-user ban5013 \
#     --admin-password ban@$1 \
#     --storage-uri https://ban5013st.blob.core.windows.net/backup/AdventureWorks.bacpac \
#     --storage-key-type SharedAccessKey \
#     --storage-key "?$SAS"

az sql db import \
    --subscription vse-fte \
    --resource-group ban5013rg \
    --server ban$1 \
    --name AdventureWorksLT \
    --admin-user ban5013 \
    --admin-password ban@$1 \
    --storage-uri https://ban5013st.blob.core.windows.net/backup/AdventureWorksLT.bacpac \
    --storage-key-type SharedAccessKey \
    --storage-key "?$SAS"

# az sql db export \
#     --subscription vse-fte \
#     --resource-group ban5013rg \
#     --server ban5013sql \
#     --name AdventureWorks \
#     --admin-user ban5013 \
#     --admin-password waterloo5013@ \
#     --storage-key-type StorageAccessKey \
#     --storage-key "?sv=2022-11-02&ss=bfqt&srt=c&sp=rwdlacupiytfx&se=2023-09-25T04:28:41Z&st=2023-09-24T20:28:41Z&spr=https&sig=3x31mYcQ4MG8Wq0DvNngL%2BdqMsDK8Jcoiq1ABz2nPKo%3D" \
#     --storage-uri https://ban5013st.blob.core.windows.net/backup/AdventureWorks.bacpac