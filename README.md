# Argo-workflows CI/CD

## Installation and setup (MacOS)

```bash
brew install multipass --cask
git clone https://github.com/adnanselimovic-abh/argo-workflows.git 
cd argo-workflows
multipass launch -n k3s --mem 2G --disk 10G --cpus 2 --cloud-init cloud-config.yaml
```

## Installation and setup (Linux)
```bash
brew install multipass --cask
git clone https://github.com/adnanselimovic-abh/argo-workflows.git 
cd argo-workflows
multipass launch -n k3s --mem 2G --disk 10G --cpus 2 --cloud-init cloud-config.yaml
```