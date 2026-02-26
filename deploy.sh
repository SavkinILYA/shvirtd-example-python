#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/SavkinILYA/shvirtd-example-python.git"
INSTALL_DIR="/opt/shvirtd-example-python"

echo "=== Установка/обновление docker ==="
if ! command -v docker &> /dev/null; then
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
    newgrp docker
fi

echo "=== Клонирование / обновление репозитория ==="
if [ -d "$INSTALL_DIR" ]; then
    cd "$INSTALL_DIR"
    git pull --ff-only
else
    sudo mkdir -p "$INSTALL_DIR"
    sudo chown $USER:$USER "$INSTALL_DIR"
    git clone "$REPO_URL" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

echo "=== Запуск проекта ==="
docker compose down || true
docker compose pull || true
docker compose up -d --build --remove-orphans

echo "=== Готово! ==="
echo "Проверьте сервис: http://$(curl -s ifconfig.me):8090"