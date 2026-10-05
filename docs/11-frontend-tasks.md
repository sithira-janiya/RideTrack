# Frontend Tasks (React Native + Expo)

Markable checklist. Tick a box by changing `[ ]` to `[x]` in your PR. Design references: [frontend design](08-frontend-react-native.md) · [API](07-api.md) · [developer guide](12-developer-guide.md).

Status as of 2026-10-05: **design finished, no app code yet.** The HCI report (PDF in the repository root) holds the user research and interface design to follow.

## Done

- [x] User research, personas and requirements ([01](01-requirements.md))
- [x] Use cases and actors per role ([09](09-use-cases.md))
- [x] Library choices, project structure, screen list per role, navigation map ([08](08-frontend-react-native.md))
- [x] API contract the app will call ([07](07-api.md))

## To do

> Until the backend exists, build against mock data (see Phase 0). Each screen task means: UI, loading/empty/error states, and wiring to the API.

### Phase 0 — Project setup

- [ ] `npx create-expo-app mobile --template blank-typescript` (commands in [08](08-frontend-react-native.md#getting-started-once-the-app-exists))
- [ ] Install navigation, TanStack Query, axios, socket.io-client, zustand, maps, camera, secure-store, notifications, qrcode-svg, react-hook-form, zod
- [ ] Create the folder structure from [08](08-frontend-react-native.md#project-structure)
- [ ] Theme: colours, typography (≥ 16 pt body), spacing, 44 px touch targets (NFR8)
- [ ] Shared components: `Button`, `Card`, `TextField`, `StatusBadge`, `OccupancyBar`, `ETAChip`, `EmptyState`, `ErrorMessage`, `Loading`
- [ ] Environment config for API base URL (`app.config.ts` / `EXPO_PUBLIC_API_URL`)
- [ ] Mock API layer (MSW or a simple fake client) toggled by an env flag
- [ ] ESLint + Prettier + TypeScript strict; shared `types/` matching [07-api](07-api.md)

### Phase 1 — Auth and session (FR1, FR2, FR12)

- [ ] API client with axios; interceptor refreshes the token on `401` and retries once
- [ ] Auth store (Zustand); tokens in `expo-secure-store`
- [ ] Login screen (email or phone + password)
- [ ] Register screen with Zod validation and clear messages (NFR7)
- [ ] Root navigator: `AuthStack` vs role-based stack after login; restore session on app start
- [ ] Logout and token-expiry handling

### Phase 2 — Passenger: find routes (FR3)

- [ ] Home: search bar, nearby stops (location permission flow), favourite routes
- [ ] Route search results (mode filter, debounce)
- [ ] Route detail: ordered stops and fares
- [ ] Upcoming arrivals at a stop with ETA

### Phase 3 — Passenger: live map (FR4, FR7, NFR2)

- [ ] `LiveMap` with `react-native-maps` showing route polyline, stops and vehicle markers
- [ ] Socket client with auth; `useLiveVehicles(routeId)` hook (subscribe on focus, unsubscribe on blur)
- [ ] Marker updates from `vehicle:location`; smooth animation between points
- [ ] ETA chip and occupancy indicator (icon **and** text) from `vehicle:occupancy`
- [ ] Reconnect handling and a "last updated" label when data is stale

### Phase 4 — Passenger: tickets (FR5, FR11, NFR7, NFR10)

- [ ] Buy ticket: pick trip, boarding and alighting stops, fare summary
- [ ] Open the payment gateway (WebView / browser) and handle the return
- [ ] Never lose a pending payment: persist pending state; re-check status on app resume
- [ ] My tickets list (active / used / cancelled) with pagination
- [ ] Ticket QR screen with `react-native-qrcode-svg`, brightness boost
- [ ] Offline cache: store ticket + QR token locally, show cache first then refresh when online
- [ ] Cancel unused ticket flow
- [ ] Trip / transaction history

### Phase 5 — Staff scanner (FR6, FR7)

- [ ] Camera permission flow and QR scanning with `expo-camera`
- [ ] Scan result screen: large **VALID** (green) / **INVALID** (red) with reason, icon + text
- [ ] Manual ticket-ID entry fallback
- [ ] Passenger count screen → `POST /vehicles/:id/occupancy`
- [ ] Choose current vehicle/trip for the shift
- [ ] Feedback: haptic or sound on scan; fast reset for the next scan

### Phase 6 — Alerts and profile (FR8, FR12)

- [ ] Register for push: `expo-notifications` permission, send token to `PUT /users/me/push-token`
- [ ] Alerts list with unread state, mark as read
- [ ] In-app banner on `alert:new`
- [ ] Profile: edit name, language, notification preferences

### Phase 7 — Authority screens (FR9, FR10)

- [ ] Dashboard: live vehicles, active delays, occupancy summary (`ops:update`)
- [ ] Live fleet map (all vehicles, filter by route)
- [ ] Reports screen: type and date filters, charts/tables
- [ ] Publish and review alerts

### Phase 8 — Quality and release (NFR1, NFR6, NFR8)

- [ ] Accessibility pass: font scaling, contrast, screen reader labels, not colour alone
- [ ] Test on recent Android versions and at least one low-end device
- [ ] Offline and weak-network testing (airplane mode ticket display)
- [ ] Component tests (Jest + React Native Testing Library) for auth, buy ticket and scan result
- [ ] Usability test with commuters and staff against the HCI report's tasks
- [ ] App icon, splash, EAS Build for an Android APK/AAB

## Requirement coverage

| Requirement | Phase |
|---|---|
| FR1, FR2 | 1 |
| FR3 | 2 |
| FR4, FR7 | 3, 5 |
| FR5, FR11 | 4 |
| FR6 | 5 |
| FR8, FR12 | 6 |
| FR9, FR10 | 7 |
| NFR1, NFR6, NFR8 | 0, 8 |
| NFR7, NFR10 | 4 |
