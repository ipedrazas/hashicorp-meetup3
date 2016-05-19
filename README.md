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

Let's define the policy

        vault policy-write demo [vault-policy.json](vault-helper/utils/vault-policy.json)
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
