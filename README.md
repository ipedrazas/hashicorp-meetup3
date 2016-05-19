# hashicorp-meetup3
Materials for the 3rd Hashicorp meetup: Kubernetes &amp; Vault

# Demo


## Initialise Vault

Let's get the `vault token`:

        journalctl -u vault -r

        export VAULT_TOKEN=2596760c-1af1-6849-aeed-a68f854d037f
        export VAULT_ADDR=http://127.0.0.1:8200


Let's check we can connect to vault

        vault status

Let's define the policy [vault-policy.hcl](vault-helper/utils/vault-policy.hcl)

        vault policy-write demo vault-policy.hcl
        vault token-create -policy=demo

Now, let's write a test

        vault write secret/meetup value=Hashicorp


Let's read it back

        vault read secret/meetup


Let's read that key from my machine

        export VAULT_TOKEN=2596760c-1af1-6849-aeed-a68f854d037f
        export VAULT_ADDR=http://172.17.4.20:9000

        curl -H "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/secret/demo/meetup


Let's try now to do the same but from inside the kubernetes cluster:

        kubectl create -f test-vault.yaml
        kubectl exec -it testvault bash

        export VAULT_TOKEN=2596760c-1af1-6849-aeed-a68f854d037f
        export VAULT_ADDR=http://172.17.4.20:9000

        curl -H "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/secret/demo/meetup

Let's go back to my machine an push a json file as a secret

        ./vault-write.sh jamesbond.json demo/meetup

let's read it

        ./vault-read.sh demo/meetup

Excellent, now we just deploy our `ReplicationController` that has 1 pod and 2 containers: one that runs an app, the other that talks with vault. But to do so, we have to create the secret that contains the Vault Token:


        kubectl create -f vault-secrets.yaml
        # If the secret is in the cluster already
        kubectl replace -f vault-secrets.yaml

        kubectl create -f api/meetup-svc.yaml
        kubectl create -f api/meetup-rc.yaml

Let's test the application. First, we get the host where the pod is running:

        kubectl get pods -o wide

Now we open this address in the browser:

        http://POD_API:30009

We can test and see that we will get the meetup key. So, we have to update the Vault key to contain the password, to do so, we can use the utility

        ./vault-write.sh meetup jamesbond.json


We can expire the vault token

        vault token-revoke e1df50b9-09b4-6629-13bf-691710962ef5

And check that now we cannot access the data


Let's go now and check why Kubernetes secrets are not ideal for keeping our secrets secret:

        etcdctl -endpoints 172.17.4.51:2379 get /registry/secrets/default/vault

Which is secure as long as nobody can access ETCD... which is not that secure.

        {
            "kind": "Secret",
            "apiVersion": "v1",
            "metadata": {
                "name": "vault",
                "namespace": "default",
                "uid": "f82b2d05-1ab1-11e6-86a0-080027a75e9e",
                "creationTimestamp": "2016-05-15T15:30:35Z"
            },
            "data": {
                "token": "YzIwZTUyZWMtZTg4Yy1iNjIxLTc0NjktMDQwY2RiYjI1MGFlCg==",
                "vault": "MTcyLjE3LjQuMjA6OTAwMAo="
            },
            "type": "Opaque"
        }

Slides can be found [here](https://docs.google.com/presentation/d/1poM8Z2Ak1RkkCFX-S3N8QIVe3tmXZo_3bQuHm0L4qV8/edit?usp=sharing)
