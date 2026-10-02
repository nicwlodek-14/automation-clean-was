#  Deployment TO-DO

# Deploy Concert only
ansible-playbook -i ./inventory.json \
./deploy-concert/playbooks/install_concert_vm.yml \
--extra-vars ibm_entitlement_key="YOUR KEY HERE" \
--extra-vars '{"enable_watsonx": true}' \
--extra-vars watsonx_api_project_id="PROJECT ID" \
--extra-vars watsonx_api_url="API URL" \
--extra-vars watsonx_api_key="API KEY"
