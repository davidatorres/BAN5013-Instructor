# Variables
csv_file="users.csv"  # Path to the CSV file
tenant_id="296ca264-a31d-4ced-a5bb-cf30157d52bd"  # Azure AD tenant ID
group_name="Students"  # Name of the Azure AD group to which the users will be added

# Read the CSV file and create users
while IFS=',' read -r first_name last_name user_name password group x; do
    # Create the users
    display_name="$first_name $last_name"
    user_principal_name="$user_name@dat.ms"
    user_id=$(az ad user create \
        --display-name "$display_name" \
        --user-principal-name $user_principal_name \
        --password $password \
        --force-change-password-next-sign-in false \
        --query "id" \
        --output tsv)

    # Add the user to the group
    az ad group member add \
        --group $group \
        --member-id $user_id

    echo ">>> $user_principal_name, $display_name, $password, $tenant_id, $group, $user_id"
done < "$csv_file"
