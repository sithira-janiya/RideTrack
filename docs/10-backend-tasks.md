# Backend Tasks (Node.js + Express + Socket.IO + MySQL)

Markable checklist. Tick a box by changing `[ ]` to `[x]` in your PR. Design references: [architecture](05-architecture.md) · [API](07-api.md) · [database](06-database-mysql.md) · [developer guide](12-developer-guide.md).

Status as of 2026-10-05: **design finished, no backend code yet.**

## Done

- [x] Requirements FR1–FR12 / NFR1–NFR10 written ([01](01-requirements.md))
- [x] ER diagram and data dictionary ([02](02-er-diagram.md))
- [x] DFD Level 0–3 ([03](03-dfd.md)) and requirement traceability ([04](04-traceability.md))
- [x] Architecture, tech stack, backend folder structure, security approach ([05](05-architecture.md))
- [x] MySQL schema script, 16 tables ([schema.sql](schema.sql), [06](06-database-mysql.md))
- [x] REST + WebSocket API contract ([07](07-api.md))
- [x] Use cases ([09](09-use-cases.md))

## To do

Phases are in build order; each depends on the one before it. Suggested split for a team is marked **(parallel OK)**.

### Phase 0 — Project setup

- [ ] Create `backend/` with `npm init`, install `express mysql2 jsonwebtoken bcrypt zod socket.io node-cron helmet cors express-rate-limit firebase-admin dotenv`; dev: `jest supertest nodemon eslint prettier`
- [ ] Create the folder structure from [05-architecture](05-architecture.md#backend-structure-nodejs)
- [ ] `src/config/`: env loader (fail fast on missing vars), MySQL pool, constants
- [ ] `.env.example` and `.gitignore` (`.env`, `node_modules`, `firebase-service-account.json`)
- [ ] `app.js`: helmet, cors, JSON body parser, request logging, `/api/v1` router, `GET /health`
- [ ] `server.js`: HTTP server + Socket.IO bootstrap, graceful shutdown
- [ ] Central error handler returning `{ error: { code, message } }` and a typed `AppError`
- [ ] Zod validation middleware (body / query / params)
- [ ] ESLint + Prettier + `npm test` / `npm run dev` scripts
- [ ] Copy `schema.sql` to `backend/db/` and add a seed script (sample routes, stops, vehicles, one user per role)
- [ ] Create the limited `ridetrack` MySQL user (see [06](06-database-mysql.md#setup))

### Phase 1 — Authentication and users (FR1, FR2, FR12, NFR3)

- [ ] `POST /auth/register` — email **or** phone + password, bcrypt hash, unique checks
- [ ] `POST /auth/login` — returns access (short-lived) + refresh token
- [ ] `POST /auth/refresh` — rotate refresh token; decide where refresh tokens are stored/revoked
- [ ] JWT auth middleware and `requireRole('PASSENGER' | 'STAFF' | 'AUTHORITY')` guard
- [ ] Rate limit `/auth/*`
- [ ] `GET /users/me`, `PATCH /users/me` (name, language, notification preference)
- [ ] `PUT /users/me/push-token`
- [ ] Tests: register duplicate, wrong password, expired token, wrong role → 403

### Phase 2 — Routes, stops, schedules (FR3) **(parallel OK with Phase 3)**

- [ ] `GET /routes?mode=&q=` with pagination
- [ ] `GET /routes/:id` with ordered stops
- [ ] `GET /stops/nearby?lat=&lng=&radius=` (bounding box + haversine on `idx` lat/lng)
- [ ] `GET /routes/:id/arrivals?stopId=` — upcoming arrivals from `trips` (`idx_trip_route_time`)
- [ ] Authority CRUD: `POST/PATCH /routes`, `POST /routes/:id/stops` (fares), `POST/PATCH /trips`
- [ ] Tests for search and arrivals ordering

### Phase 3 — Live tracking (FR4, FR7, NFR2)

- [ ] Device API-key auth for `POST /vehicles/:id/location`
- [ ] Location ingest: validate, write `location_log`, update in-memory latest-position cache
- [ ] ETA calculation (DFD 5.3): distance to next stop / recent speed; unit tests
- [ ] Socket.IO: token auth on connect, `route:subscribe` / `route:unsubscribe` rooms
- [ ] Broadcast `vehicle:location` to `route:<id>` (target ≤ 5 s end to end)
- [ ] `GET /routes/:id/vehicles` (position, ETA, occupancy)
- [ ] `POST /vehicles/:id/occupancy` (staff) → `occupancy_log` + `vehicle:occupancy` event
- [ ] GPS simulator script that replays a route, so the frontend can be built without hardware
- [ ] Log retention job: purge or partition `location_log` older than 90 days

### Phase 4 — Tickets and payments (FR5, FR11, NFR5, NFR10)

- [ ] `POST /tickets` — create `PENDING` ticket, calculate fare from `route_stops`, create payment session
- [ ] Payment gateway client (PayHere sandbox) behind an interface so it can be mocked
- [ ] `POST /payments/webhook` — verify signature, idempotent, mark `PAID`, activate ticket
- [ ] Generate signed QR token (HMAC/JWT bound to ticket + trip, uses `QR_SIGNING_SECRET`)
- [ ] `GET /tickets/:id` and `GET /tickets?status=&page=` (history, `idx_ticket_user`)
- [ ] `POST /tickets/:id/cancel` and refund rules
- [ ] Job: expire unused tickets and abandoned `PENDING` payments
- [ ] Tests: duplicate webhook, bad signature, paying twice, cancelling a used ticket

### Phase 5 — Ticket validation (FR6)

- [ ] `POST /scans` accepting `{qrToken}` or `{ticketId}`
- [ ] Checks: signature, trip match, expiry, status; mark `USED` atomically (transaction / `UPDATE … WHERE status='ACTIVE'`)
- [ ] Always write a `ticket_scans` row, including unknown QR (nullable `ticket_id`)
- [ ] Reasons returned in the error code (`TICKET_ALREADY_USED`, `TICKET_EXPIRED`, …)
- [ ] `GET /trips/:id/scans`
- [ ] Rate limit scans; test double-scan race condition

### Phase 6 — Alerts and notifications (FR8)

- [ ] Delay-detection cron job: compare trip ETA with schedule, insert `delay_alerts`
- [ ] Fan out `alert_recipients` rows to affected passengers
- [ ] FCM push via `firebase-admin`; handle invalid tokens
- [ ] `GET /alerts?unread=true`, `PATCH /alerts/:id/read`, `POST /alerts` (authority)
- [ ] Emit `alert:new` over Socket.IO

### Phase 7 — Authority operations and reports (FR9, FR10)

- [ ] `GET /ops/dashboard` — live vehicles, active delays, occupancy summary
- [ ] Emit `ops:update` deltas to authority clients
- [ ] `GET /reports?type=&routeId=&from=&to=` — route performance, delays, occupancy (DFD 7.3)
- [ ] Persist generated reports in `reports`

### Phase 8 — Hardening and release (NFR3, NFR4, NFR9)

- [ ] Review every query is parameterised; no secrets in logs
- [ ] Request logging with request IDs; structured error logs
- [ ] Integration test suite against a throwaway MySQL (docker-compose)
- [ ] OpenAPI/Swagger file generated from [07-api](07-api.md) (optional)
- [ ] Dockerfile + `docker-compose.yml` (api + mysql)
- [ ] HTTPS deployment, DB backups, production env checklist
- [ ] Load test the location ingest + broadcast path

## Requirement coverage

| Requirement | Phase |
|---|---|
| FR1, FR2, FR12 | 1 |
| FR3 | 2 |
| FR4, FR7 | 3 |
| FR5, FR11 | 4 |
| FR6 | 5 |
| FR8 | 6 |
| FR9, FR10 | 7 |
| NFR2 | 3 |
| NFR3, NFR5 | 1, 4, 8 |
