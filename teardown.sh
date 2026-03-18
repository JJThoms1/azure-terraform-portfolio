#!/bin/bash
echo "Destroying all Azure infrastructure..."
terraform destroy -auto-approve
echo "Done. No resources running in Azure."
