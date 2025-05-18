# Ava.API Dockerized

This project contains a Docker Compose configuration to serve the `Ava.API` WebAPI securely using [Caddy](https://caddyserver.com/) as a reverse proxy with automatic HTTPS via Let's Encrypt.

---

## 🧱 Project Structure

```text
.
├── docker-compose.yml       # Defines API + Caddy services
├── Dockerfile.API           # Dockerfile to build Ava.API (built externally)
├── Caddyfile                # Caddy reverse proxy and TLS config
└── caddy-volume.sh          # Script to backup/restore Caddy data volume
```

## 🚀 Getting Started

### 1. Build the API Image (outside this repo)

> You must build and tag the image separately before using `docker-compose`.

```bash
docker build -f Dockerfile.API -t ava-api:20250518 .
```

> Or pull it from your container registry if you're using CI/CD.

### 2. Run the Stack

```bash
docker compose up -d
```

> Caddy will automatically fetch and manage HTTPS certificates for your domain.

## 🌐 Access

- `https://your.domain.com/swagger` → Ava.API Swagger UI
- `http://localhost:80` and `https://localhost:443` → Caddy entrypoints

Make sure your DNS for `your.domain.com` points to the host running Docker.

## 🔐 Caddy SSL Persistence

Caddy stores certificates and config state in Docker volumes:

- `caddy_data` → TLS certs, ACME state
- `caddy_config` → runtime configuration (can be removed if unused)

To back up or restore:

```bash
# Backup caddy_data volume to ./caddy_data.tar.gz
./caddy-volume.sh backup

# Restore from ./caddy_data.tar.gz
./caddy-volume.sh restore
```

## 🧰 Useful Commands

```bash
docker compose logs -f caddy        # View Caddy logs
docker compose exec ava-api sh      # Shell into API container
docker volume ls                    # List volumes
```

## 📁 Caddyfile Example

```caddyfile
your.domain.com {
    reverse_proxy ava-api:5165
    encode gzip
}
```

## 📌 Notes

- `ava-api` container only exposes port 5165 **internally** to Caddy
- No external access to API unless routed through Caddy
- Environment variables are passed to the API container via `docker-compose.yml`

## 🛑 Stopping and Cleaning Up

```bash
docker compose down         # Stop containers
docker compose down -v      # Stop and delete volumes (⚠️ removes certs)
```

## 🔧 Troubleshooting

- Ensure ports 80 and 443 are open on your host
- If certs aren't being issued, check:
  - DNS is correctly configured
  - Firewall or ISP isn't blocking outbound port 443
- Force HTTPS with Caddy by adding:

```caddyfile
your.domain.com {
    redir https://{host}{uri}
    reverse_proxy ava-api:5165
}
```

## 📃 License

This project is licensed under the [MIT License](LICENSE).
