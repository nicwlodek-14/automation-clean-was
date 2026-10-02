#  Deployment TO-DO

# Deploy Concert only
ansible-playbook -i ./inventory.json \
./deploy-concert/playbooks/install_concert_vm.yml \
--extra-vars ibm_entitlement_key="YOUR KEY HERE" \
--extra-vars '{"enable_watsonx": true}' \
--extra-vars watsonx_api_project_id="PROJECT ID" \
--extra-vars watsonx_api_url="API URL" \
--extra-vars watsonx_api_key="API KEY"

# Deploy Concert + Bob Shell (configure the Bob API key separately after install)
ansible-playbook -i ./inventory.json \
./deploy-concert/playbooks/install_bob_shell.yml \
--extra-vars ibm_entitlement_key="YOUR KEY HERE" \
--extra-vars '{"enable_watsonx": true}' \
--extra-vars watsonx_api_project_id="PROJECT ID" \
--extra-vars watsonx_api_url="API URL" \
--extra-vars watsonx_api_key="API KEY"

# Set or rotate the Bob Shell API key on an already-deployed VM
ansible-playbook -i ./inventory.json \
./deploy-concert/playbooks/configure_bob_api_key.yml \
--extra-vars bob_shell_api_key="BOB API KEY"
