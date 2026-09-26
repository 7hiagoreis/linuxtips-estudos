#!/usr/bin/env bash
#
# bootstrap.sh / Monta a VM Ubuntu para estudos DevOps
# Roda DENTRO da VM, executado pelo Vagrant como root.
#
set -euo pipefail

echo ">>> [bootstrap] Iniciando a instalação..."

# ------------------------------------------------------------------
# 1. Sistema Base / Ubuntu
# ------------------------------------------------------------------
echo ">>> Atualizando os Pacotes..."
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y

echo ">>> Instalando os Pacotes Essenciais..."
apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  git \
  vim \
  htop \
  tree \
  jq \
  unzip \
  zip \
  net-tools \
  dnsutils \
  iputils-ping \
  traceroute \
  make \
  build-essential \
  software-properties-common \
  apt-transport-https

# ------------------------------------------------------------------
# 2. Docker + Docker Compose (Repositorio Oficial)
# ------------------------------------------------------------------
echo ">>> Instalando o Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update -y
apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

systemctl enable docker
systemctl start docker

# ------------------------------------------------------------------
# 3. Criando o Usuário "devops"
# ------------------------------------------------------------------
echo ">>> Criando o usuário 'devops'..."
if ! id -u devops >/dev/null 2>&1; then
  useradd -m -s /bin/bash devops
  usermod -aG sudo,docker devops
  echo "devops:devops" | chpasswd
  echo "devops ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/devops
  chmod 0440 /etc/sudoers.d/devops
fi

# ------------------------------------------------------------------
# 4. SSH: Chave do Vagrant + Configuração
# ------------------------------------------------------------------
echo ">>> Configurando o SSH..."
if [ -f /home/vagrant/.ssh/authorized_keys ]; then
  mkdir -p /home/devops/.ssh
  cp /home/vagrant/.ssh/authorized_keys /home/devops/.ssh/authorized_keys
  chown -R devops:devops /home/devops/.ssh
  chmod 700 /home/devops/.ssh
  chmod 600 /home/devops/.ssh/authorized_keys
fi

# Aplica o sshd_config customizado, se existir
if [ -f /vagrant/configs/sshd_config ]; then
  cp /vagrant/configs/sshd_config /etc/ssh/sshd_config
  systemctl restart ssh || systemctl restart sshd || true
fi


# ------------------------------------------------------------------
# 5. Finalizando...
# ------------------------------------------------------------------
echo ">>> Limpando o cache do apt..."
apt-get autoremove -y
apt-get clean

echo ""
echo "=============================================="
echo "  VM Instalada com Sucesso!"
echo "=============================================="
echo "  Hostname : $(hostname)"
echo "  IP       : 192.168.56.13"
echo "  Usuário  : devops (senha: devops, sudo sem senha)"
echo ""
echo "  Docker   : $(docker --version)"
echo "  Compose  : $(docker compose version --short 2>/dev/null || echo 'ok')"
echo ""
echo "  Acesse com: vagrant ssh"
echo "=============================================="
