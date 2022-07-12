# Argo-workflows CI/CD

## Installation and setup (MacOS)

```bash
brew install multipass --cask
git clone https://github.com/adnanselimovic-abh/argo-workflows.git 
cd argo-workflows
multipass launch -n k3s --mem 4G --disk 10G --cpus 4 --cloud-init cloud-config.yaml
```

## Installation and setup (Linux)
```bash
snap install multipass
git clone https://github.com/adnanselimovic-abh/argo-workflows.git 
cd argo-workflows
multipass launch -n k3s --mem 4G --disk 10G --cpus 4 --cloud-init cloud-config.yaml
```

## How to configure laboratory
You will need to create dockerhub registry account to allow ci-cd flow pushing container images on remote repository.

```bash
export DOCKER_USERNAME=[USERNAME]
export DOCKER_TOKEN=[PERSONAL_ACCESS_TOKEN]
kubectl create secret generic docker-config --from-literal="config.json={\"auths\": {\"https://index.docker.io/v1/\": {\"auth\": \"$(echo -n $DOCKER_USERNAME:$DOCKER_TOKEN|base64)\"}}}" --namespace argo-events
```

After multipass launches k3s VM - shell can be spawned. One more step is needed before laboratory is configured.
Fetch the IP of the VM created.

```bash
multipass list k3s
Name                    State             IPv4             Image
k3s                     Running           192.168.64.2     Ubuntu 20.04 LTS
                                          10.42.0.0
                                          10.42.0.1
                                          172.17.0.1
```
In this case It is 192.168.64.2. Now hosts file need to be edited.

###Linux
```bash
sudo echo "\n192.168.64.2 local.k3s" >> /etc/hosts
```
###MacOS
```bash
sudo echo "\n192.168.64.2 local.k3s" >> /private/etc/hosts
```

Replace 192.168.64.2 with the IP address you get from multipas output!

## Spawn shell
```bash
multipass shell k3s
ubuntu@k3s:~$ k get pods -n kube-system
NAME                                      READY   STATUS      RESTARTS   AGE
coredns-d76bd69b-rxzfg                    1/1     Running     0          6h7m
local-path-provisioner-6c79684f77-k8mh2   1/1     Running     0          6h7m
helm-install-traefik-crd-mjzw6            0/1     Completed   0          6h7m
metrics-server-7cd5fcb6b7-4krsv           1/1     Running     0          6h7m
svclb-traefik-6a62f4c4-86rvd              2/2     Running     0          6h5m
helm-install-traefik-s6b7t                0/1     Completed   2          6h7m
traefik-df4ff85d6-mjzkt                   1/1     Running     0          6h5m
```
Output should look like this. If everything is configured correctly:
- k3s is installed
- traefik is available and local.k3s is serving ingress endpoints
- argo-workflows and argo-events are installed and pre-configured.

### Test if everything is configured
From the host machine terminal, execute
```bash
curl local.k3s
404 page not found
```

Traefik returned 404 page not found so everything works!

*Note:* It can take up to 5 minutes for the virtual machine to be provisioned and everything to be deployed.
It can take longer if you tweak CPU and Memory in the multipass launch command.
# How to use argo workflows?
Hit the url in the browser of your preference:
```http
http://local.k3s/argo
```
To login to UI follow the instructions below.
```bash
SECRET=$(kubectl get sa atlantbh-argo-workflows-server -o=jsonpath='{.secrets[0].name}' --namespace argo)
ARGO_TOKEN="Bearer $(kubectl get secret $SECRET -o=jsonpath='{.data.token}' --namespace argo | base64 -d)"
echo "$ARGO_TOKEN"
```
