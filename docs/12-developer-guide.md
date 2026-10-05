# Developer Guide

How to get set up and contribute to RideTrack. Read the [README](../README.md) first for what the product is.

> **Current state:** the repository holds design documentation only. The `backend/` and `mobile/` folders do not exist yet; create them following the task lists. Commands below are what you will run once they do.

## 1. Where to start

| I want to… | Read |
|---|---|
| Understand what we're building | [Requirements](01-requirements.md), [Use cases](09-use-cases.md) |
| Understand the data | [ER diagram](02-er-diagram.md), [Database](06-database-mysql.md), [`schema.sql`](schema.sql) |
| Understand system flows | [DFDs](03-dfd.md), [Architecture](05-architecture.md) |
| Build the server | [Backend tasks](10-backend-tasks.md), [API](07-api.md) |
| Build the app | [Frontend tasks](11-frontend-tasks.md), [Frontend design](08-frontend-react-native.md) |
| Check a requirement is covered | [Traceability](04-traceability.md) |

## 2. Prerequisites

| Tool | Version | Notes |
|---|---|---|
| Node.js | 20 LTS or newer | Backend and Expo tooling |
| npm | bundled with Node | |
| MySQL | 8.x | Local install or Docker |
| Git | any recent | |
| Android Studio (emulator) or an Android phone with **Expo Go** | | NFR6: Android first |
| Google Maps API key | | For `react-native-maps` |
| PayHere sandbox account | | Payments in test mode only |
| Firebase project | | FCM push; download the service account JSON |

## 3. Repository layout (target)

```
RideTrack/
├── backend/        Node.js API + Socket.IO   (structure in 05-architecture.md)
├── mobile/         React Native Expo app     (structure in 08-frontend-react-native.md)
└── RideTrack-Docs/ design documentation (this folder)
```

## 4. Running the backend

```bash
cd backend
cp .env.example .env        # then fill in real values locally; never commit .env
npm install
mysql -u root -p < db/schema.sql
npm run seed                # sample routes, stops, vehicles, one user per role
npm run dev                 # http://localhost:3000/api/v1
npm test
```

Check it works: `curl http://localhost:3000/health`.

Environment variables are listed in [05-architecture](05-architecture.md#environments--configuration). Use different secrets for each of `JWT_ACCESS_SECRET`, `JWT_REFRESH_SECRET` and `QR_SIGNING_SECRET`.

## 5. Running the mobile app

```bash
cd mobile
npm install
# set EXPO_PUBLIC_API_URL to your machine's LAN IP, e.g. http://192.168.1.10:3000/api/v1
npx expo start
```

- Android emulator reaches your computer at `10.0.2.2`; a physical phone needs your LAN IP and the same Wi-Fi network.
- To work before the backend is ready, set the mock flag described in [frontend tasks, phase 0](11-frontend-tasks.md).

## 6. Testing live tracking without hardware

Use the GPS simulator script (backend Phase 3 task). It posts positions along a seeded route to `POST /vehicles/:id/location` every few seconds, so the map and ETA code can be developed and demoed without a real tracker.

## 7. Conventions

### API

- Follow [07-api](07-api.md) exactly. If an endpoint needs to change, **update the doc in the same PR**.
- Success: `{ "data": … }`. Error: `{ "error": { "code", "message" } }`. Error codes are `UPPER_SNAKE_CASE`.
- Lists paginate with `?page=&limit=`.

### Database

- Schema changes go in `schema.sql` and a numbered migration file; update [06-database-mysql](06-database-mysql.md) and [02-er-diagram](02-er-diagram.md) if the model changes.
- Parameterised queries only. No string-built SQL.
- Application code uses the limited `ridetrack` DB user, never `root`.

### Code style

- Backend: JavaScript (or TypeScript if the team agrees), ESLint + Prettier, layered routes → controllers → services → data access.
- Mobile: TypeScript strict, functional components and hooks, server data through TanStack Query, only auth/ticket cache in the client store.
- Name files by feature: `modules/tickets/tickets.service.js`, `screens/passenger/BuyTicketScreen.tsx`.

### Accessibility (NFR8)

- Body text ≥ 16 pt, touch targets ≥ 44 px, high contrast.
- Status is shown with an icon **and** text, never colour alone.

### Security (NFR3, NFR5)

- Never commit secrets, `.env`, or `firebase-service-account.json`.
- Card data never touches our servers; store only the gateway reference and status.
- Validate every input with Zod; check role on every protected route.

## 8. Git workflow

1. Branch from `main`: `feature/<area>-<short-name>` (e.g. `feature/backend-auth`), `fix/…`, `docs/…`.
2. Keep commits small with imperative messages (`Add ticket purchase endpoint`).
3. Open a pull request, link the task(s) you completed, and **tick them in the task file** in the same PR.
4. At least one teammate reviews. Tests pass before merge.
5. Don't push directly to `main`.

## 9. Definition of done

A task is done when:

- [ ] It works against the real API (or documented mock) and meets the linked requirement (FR/NFR)
- [ ] Loading, empty and error states are handled (NFR7)
- [ ] Tests added for logic that can break (auth, fares, payments, scan validation)
- [ ] Docs updated if behaviour or contract changed
- [ ] Task box ticked in [backend](10-backend-tasks.md) or [frontend](11-frontend-tasks.md) tasks

## 10. Tracking progress

- Tick boxes in the two task files; each phase ends with a requirement coverage table so you can see which FR/NFR are met.
- Quick progress count:

```bash
grep -c "\[x\]" docs/10-backend-tasks.md docs/11-frontend-tasks.md
grep -c "\[ \]" docs/10-backend-tasks.md docs/11-frontend-tasks.md
```

## 11. Suggested build order for the team

1. Backend Phase 0 and Frontend Phase 0 in parallel (the frontend uses mocks).
2. Auth end to end (Phase 1 on both sides).
3. Routes and live tracking — the core demo of the product.
4. Tickets and payments, then staff scanning.
5. Alerts, authority dashboard and reports.
6. Hardening, accessibility, usability testing.

## 12. Known open decisions

Record the decision in the relevant doc when made.

- [ ] JavaScript or TypeScript for the backend
- [ ] Where refresh tokens are stored and revoked
- [ ] How GPS devices authenticate (per-vehicle API key vs driver phone app)
- [ ] Refund rules for cancelled tickets
- [ ] Authority dashboard: inside the mobile app or a separate web app
- [ ] Sinhala / Tamil language support scope (`users.language`)
