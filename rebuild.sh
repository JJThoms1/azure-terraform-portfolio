#!/bin/bash
echo "Rebuilding Azure infrastructure..."
terraform init
terraform apply -auto-approve
echo "Done. Infrastructure is live."
