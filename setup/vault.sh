
# https://mycloudjourney.medium.com/vault-installation-to-minikube-via-helm-with-integrated-storage-15c9d1a907e6

kubectl create ns vault

helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm search repo hashicorp/vault

cat > helm-vault-raft-values.yml <<EOF
server:
  affinity: ""
  ha:
    enabled: true
    raft: 
      enabled: true
EOF

helm install vault hashicorp/vault --values helm-vault-raft-values.yml -n vault


helm status vault -n vault
helm get manifest vault -n vault


kubectl exec vault-0 -n vault -- vault operator init \
    -key-shares=1 \
    -key-threshold=1 \
    -format=json > cluster-keys.json
cat cluster-keys.json


VAULT_UNSEAL_KEY=$(jq -r ".unseal_keys_b64[]" cluster-keys.json)
kubectl exec vault-0 -n vault -- vault operator unseal $VAULT_UNSEAL_KEY


# Join the vault-1 and vault-2pods to the Raft cluster
kubectl exec -ti vault-1 -n vault -- vault operator raft join http://vault-0.vault-internal:8200
kubectl exec -ti vault-2 -n vault -- vault operator raft join http://vault-0.vault-internal:8200

kubectl exec -ti vault-1 -n vault -- vault operator unseal $VAULT_UNSEAL_KEY
kubectl exec -ti vault-2 -n vault -- vault operator unseal $VAULT_UNSEAL_KEY

kubectl get po -n vault

kubectl port-forward service/vault -n vault 8200:8200
http://localhost:8200               # enter root token



# vault secrets enable -path=secret/ kv
VAULT_ROOT_TKN=$(jq -r  ".root_token" cluster-keys.json)
kubectl create secret generic vault-token --from-literal=token="$VAULT_ROOT_TKN"
