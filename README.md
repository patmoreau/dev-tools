# dev-tools

Instructions to setup a local dev environment with minikube.

## Installing Kubernetes
```bash
brew install hyperkit
brew install minikube
minikube start
```

## Getting Docker to run
```bash
brew install docker
brew install docker-compose
eval $(minikube docker-env)
```
Add the line to ```.zshrc``` to have it load up when ever using iterm.

## Enable the Ingress controller with DNS
```bash
minikube addons enable ingress
minikube addons enable ingress-dns
```

### Add the minikube ip as a dns server
```bash
minikube-config/minikube-dns-config.sh
```

#### mDNS reloading on mac osx
```bash
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
```

## For development and deployment
```bash
brew install skaffold
brew install kustomize
```

## Inspirations
https://arnon.me/2021/09/replace-docker-with-minikube/
https://itnext.io/goodbye-docker-desktop-hello-minikube-3649f2a1c469
https://minikube.sigs.k8s.io/docs/handbook/addons/ingress-dns/
https://www.imore.com/how-turn-system-integrity-protection-macos
https://itnext.io/setting-up-self-signed-https-access-to-local-dev-k8s-cluster-in-minikube-539bc62ad62f

client_id: cb0c4647-6e99-4b0d-a2c3-0031456394b3
client_secret: JdB7Q~JLu9TiAr3_~yzZhC0VPc5NA1~4sNQAo