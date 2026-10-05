# RideTrack – To-Do & Task List

Status: **design/documentation phase** – diagrams, requirements, schema and API/architecture docs exist in `RideTrack-Docs/`; no application code yet.
Legend: `[x]` done · `[ ]` to do · **P1** must-have · **P2** should-have · **P3** nice-to-have
Requirement IDs (FR/NFR) refer to `RideTrack-Docs/docs/01-requirements.md`.

---

## 0. Repo & housekeeping

- [ ] **P1** Decide repo layout: monorepo (`backend/`, `mobile/`, `RideTrack-Docs/`) – note `RideTrack-Docs/` is itself a nested git repo
- [ ] **P1** Add root `README.md` (overview, stack, how to run, links to docs)
- [ ] **P1** Add `.gitignore` (node_modules, `.env`, firebase service account, Expo build output, `desktop.ini`)
- [ ] **P1** Make the first commit (untracked: ER/DFD diagrams, PDFs, report files) – decide which binaries belong in git
- [ ] **P2** Move root-level diagram/PDF files into `RideTrack-Docs/docs/diagrams/` and remove duplicates
- [ ] **P2** Remove the unrelated `JoinTrip Lanka Final ER Diagram V3.drawio.png` if not part of this project
- [ ] **P2** Branching strategy + PR template; set up CI (lint + tests)
- [ ] **P3** Add `CONTRIBUTING.md` and a `CHANGELOG.md`

## 1. Documentation (finish the design)

- [x] Requirements (`01-requirements.md`)
- [x] ER diagram (`02-er-diagram.md`, drawio/png/pdf)
- [x] DFD Level 0/1/2/3 diagrams
- [x] Traceability matrix (`04-traceability.md`)
- [x] Architecture, MySQL schema, API, frontend docs (`05`–`08`, `schema.sql`)
- [ ] **P1** Write `03-*.md` (file is missing from the numbering – DFD description?)
- [ ] **P2** Re-check traceability so every FR/NFR maps to a table, endpoint and screen
- [ ] **P2** Add UI wireframes/mockups from the HCI report (Figma) to docs
- [ ] **P3** Add test plan document (UAT scenarios per user story)

## 2. Database (MySQL 8) – FR1–FR12

- [ ] **P1** Review `schema.sql` against the ER diagram (keys, FKs, enums, indexes)
- [ ] **P1** Set up migrations tool (e.g. `knex`, `db-migrate` or plain SQL files)
- [ ] **P1** Create migrations for all tables (users, routes, stops, route_stops, vehicles, trips, tickets, payments, ticket_scan, location_log, delay_alert, alert_recipient…)
- [ ] **P1** Seed data: sample routes/stops, vehicles, one user per role (PASSENGER, STAFF, AUTHORITY)
- [ ] **P2** Indexes for hot paths: `location_log(vehicle_id, recorded_at)`, `tickets(user_id, status)`, `ticket_scan(trip_id)`
- [ ] **P3** Retention/archival policy for `location_log`

## 3. Backend (Node.js + Express + Socket.IO)

### 3.1 Setup
- [ ] **P1** Scaffold `backend/` (`app.js`, `server.js`, `config/`, `middleware/`, `modules/`)
- [ ] **P1** `.env.example`, config loader with validation, MySQL pool (`mysql2`)
- [ ] **P1** Middleware: `helmet`, `cors`, rate limiting, request validation (zod/joi), central error handler, `{success,data,error}` response convention
- [ ] **P1** JWT auth middleware + role guard (`PASSENGER`, `STAFF`, `AUTHORITY`)

### 3.2 Modules
- [ ] **P1** Auth: register (email/phone), login, refresh, bcrypt hashing (FR1, FR2, NFR3)
- [ ] **P1** Users: `GET/PATCH /users/me`, `PUT /users/me/push-token` (FR12)
- [ ] **P1** Routes/stops: search, details, nearby stops, arrivals with ETA (FR3)
- [ ] **P1** Vehicles: location ingest `POST /vehicles/:id/location`, latest-position cache, `GET /routes/:id/vehicles` (FR4)
- [ ] **P2** Occupancy: `POST /vehicles/:id/occupancy` (FR7)
- [ ] **P1** Tickets: create pending ticket, get ticket + signed QR token, history, cancel (FR5, FR11)
- [ ] **P1** Payments: gateway integration (PayHere sandbox) + signed webhook, activate ticket, generate QR (FR5, NFR5)
- [ ] **P1** Scans: `POST /scans` validate signature/trip/expiry/status, write `ticket_scan`, mark `USED` (FR6)
- [ ] **P2** `GET /trips/:id/scans`
- [ ] **P2** Alerts: list, mark read, manual publish by authority (FR8)
- [ ] **P2** Ops dashboard + reports endpoints (FR9, FR10)
- [ ] **P2** Authority management: routes, stops/fares, trips CRUD

### 3.3 Real-time & jobs
- [ ] **P1** Socket.IO: JWT handshake, `route:subscribe/unsubscribe`, broadcast `vehicle:location` (NFR2 ≤ 5 s)
- [ ] **P2** `vehicle:occupancy`, `alert:new`, `ops:update` events
- [ ] **P2** Cron jobs: delay detection → `delay_alert` + `alert_recipient` + FCM push (FR8)
- [ ] **P2** Cron job: expire unused tickets
- [ ] **P2** GPS simulator script to feed fake vehicle locations for demos/testing

### 3.4 Quality & security
- [ ] **P1** Parameterised SQL only; rate-limit auth and scan endpoints (NFR3)
- [ ] **P1** Unit + integration tests (`jest` + `supertest`) for auth, tickets, scans
- [ ] **P2** OpenAPI/Swagger spec generated from `07-api.md`
- [ ] **P3** Structured logging, health-check endpoint

## 4. Mobile app (React Native + Expo + TypeScript)

### 4.1 Setup
- [ ] **P1** Scaffold `mobile/` with Expo + TypeScript; add React Navigation, TanStack Query, Zustand, axios, socket.io-client
- [ ] **P1** API client with token-refresh interceptor; tokens in `expo-secure-store`
- [ ] **P1** Theme: accessible colours/fonts/spacing (NFR1, NFR8)
- [ ] **P1** Role-based navigation: `AuthStack`, `PassengerTabs`, `StaffStack`, `AuthorityStack`

### 4.2 Passenger
- [ ] **P1** Register / Login screens (FR1, FR2)
- [ ] **P1** Home, route search & route detail with arrivals (FR3)
- [ ] **P1** Live map with vehicles, ETA, occupancy via WebSocket (FR4, FR7)
- [ ] **P1** Buy ticket flow (trip → stops → fare → gateway payment) (FR5)
- [ ] **P1** My tickets + Ticket QR, cached offline (FR5, NFR10)
- [ ] **P2** Trip/transaction history (FR11)
- [ ] **P2** Alerts screen + push notifications via `expo-notifications` (FR8)
- [ ] **P2** Profile & preferences (FR12)

### 4.3 Staff (conductor / inspector)
- [ ] **P1** QR scanner screen (`expo-camera`) (FR6)
- [ ] **P1** Scan result screen – big green VALID / red INVALID with reason (FR6, NFR7)
- [ ] **P2** Manual ticket-ID entry
- [ ] **P2** Passenger count update (FR7)

### 4.4 Authority
- [ ] **P2** Dashboard: live vehicles, active delays, occupancy summary (FR9)
- [ ] **P2** Live fleet map
- [ ] **P2** Reports with date/route filters (FR10)
- [ ] **P3** Publish/review alerts; consider web version of the dashboard

## 5. Integrations

- [ ] **P1** Google Maps API key + `react-native-maps` config (Android)
- [ ] **P1** PayHere (or other) sandbox account, webhook URL, signature verification
- [ ] **P2** Firebase project, FCM service account, device token registration
- [ ] **P3** GPS hardware / driver-phone tracking app feeding `/vehicles/:id/location`

## 6. Testing & validation

- [ ] **P1** Manual test pass of the 5 user stories end to end
- [ ] **P2** Verify NFR2: location → passenger screen latency ≤ 5 s
- [ ] **P2** Verify NFR10: ticket still scannable offline
- [ ] **P2** Test on recent Android versions/devices (NFR6)
- [ ] **P2** Usability test with commuters/staff (NFR1, NFR8) – reuse the HCI survey participants
- [ ] **P3** Load test the location ingest endpoint

## 7. Deployment

- [ ] **P2** Host backend + MySQL (Railway/Render/VPS) with HTTPS (NFR3)
- [ ] **P2** Environment secrets management; never commit `.env`
- [ ] **P2** Build Android APK/AAB with EAS Build
- [ ] **P3** Backups and uptime monitoring (NFR4)

---

## Suggested milestones

| # | Milestone | Scope |
|---|---|---|
| M1 | Foundation | Repo cleanup, DB migrations + seed, backend scaffold, auth |
| M2 | Core passenger | Routes, live tracking + map, ticket purchase + QR |
| M3 | Staff | Scanner, validation, occupancy |
| M4 | Authority & alerts | Dashboard, reports, delay alerts, push |
| M5 | Polish | Offline cache, accessibility, testing, deployment |
