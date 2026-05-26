# RUN_LOCAL.md — team-gate (Access Gate Service)

Hướng dẫn chạy lại Access Gate service trong 5 bước.

---

## Yêu cầu

- Docker Desktop (hoặc Docker Engine)
- Node.js 20.x LTS + npm
- Git

---

## Bước 1 — Clone repo và cài dependencies

```bash
git clone https://github.com/Connectivity-services-ad-PT/lab-04-PNS1441.git
cd lab-04-PNS1441
npm install
```

---

## Bước 2 — Build Docker image

```bash
docker build -t fit4110/access-gate:lab04 .
```

---

## Bước 3 — Chạy container

```bash
docker run -d --rm \
  --name fit4110-gate-lab04 \
  -p 8000:8000 \
  --env-file .env.example \
  fit4110/access-gate:lab04
```

Kiểm tra health:

```bash
curl http://localhost:8000/health
# Expected: {"status":"ok","service":"access-gate","version":"0.4.0"}
```

---

## Bước 4 — Chạy Newman test suite

```bash
npm run test:local
```

Report được sinh tại:

- `reports/newman-lab04-local.xml` (JUnit)
- `reports/newman-lab04-local.html` (HTML)

---

## Bước 5 — Dừng container

```bash
docker stop fit4110-gate-lab04
```

---

## Lệnh nhanh bằng Makefile

```bash
make build        # Build image
make run          # Run container
make test-local   # Chạy Newman
make stop         # Dừng container
make test-docker  # Build + run + test + stop tự động
```

---

## Thông tin service

| Endpoint | Method | Auth | Mô tả |
|---|---|---|---|
| `/health` | GET | Không | Kiểm tra service |
| `/access-events` | POST | Bearer | Ghi nhận quẹt thẻ |
| `/access-events` | GET | Bearer | Lấy danh sách events |
| `/cards/{id}` | GET | Bearer | Lấy thông tin thẻ |
| `/cards` | POST | Bearer | Tạo thẻ mới |

**Auth token mặc định:** `local-dev-token`  
**Thẻ test có sẵn:** `CARD-2026-001` (active), `CARD-EXPIRED-001` (expired)

---

## Image tag

```bash
docker tag fit4110/access-gate:lab04 ghcr.io/<owner>/team-gate:v0.1.0-team-gate
```
