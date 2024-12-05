#!/usr/bin/bash
echo "✅ Kubectl and Helm installed successfully"

sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
brew install derailed/k9s/k9s

echo "✅ kubectx, kubens, fzf, and k9s installed successfully"
sudo apt-get install fzf -y

alias k="kubectl"
alias kga="kubectl get all"
alias kgn="kubectl get all --all-namespaces"
alias kdel="kubectl delete"
alias kd="kubectl describe"
alias kg="kubectl get"

echo 'alias k="kubectl"' >> /home/$USER/.bashrc
echo 'alias kga="kubectl get all"' >> /home/$USER/.bashrc
echo 'alias kgn="kubectl get all --all-namespaces"' >> /home/$USER/.bashrc
echo 'alias kdel="kubectl delete"' >> /home/$USER/.bashrc
echo 'alias kd="kubectl describe"' >> /home/$USER/.bashrc
echo 'alias kg="kubectl get"' >> /home/$USER/.bashrc

echo "✅ The following aliases were added:"
echo "alias k=kubectl"
echo "alias kga=kubectl get all"
echo "alias kgn=kubectl get all --all-namespaces"
echo "alias kdel=kubectl delete"
echo "alias kd=kubectl describe"
echo "alias kg=kubectl get"

source ~/.bashrc 

# Install ArgoCD CLI
sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo chmod +x /usr/local/bin/argocd

# Install ngrok
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok

# Install vCluster
curl -L -o vcluster "https://github.com/loft-sh/vcluster/releases/download/v0.19.5/vcluster-linux-amd64" && sudo install -c -m 0755 vcluster /usr/local/bin && rm -f vcluster

# Install yq
if ! command -v yq &> /dev/null; then
    echo "Installing yq..."
    sudo wget https://github.com/mikefarah/yq/releases/download/v4.35.1/yq_linux_amd64 -O /usr/local/bin/yq && sudo chmod +x /usr/local/bin/yq
fi