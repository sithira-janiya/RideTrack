# Frontend (React Native)

One React Native app serves all three user types; the visible screens depend on the logged-in user's `role`. (The authority dashboard can alternatively be a web app later.)

## Recommended setup

| Concern | Choice |
|---|---|
| Framework | React Native with **Expo** (managed workflow), TypeScript |
| Navigation | React Navigation (stack + bottom tabs) |
| Server state | TanStack Query (React Query) for REST data |
| Client state | Zustand or Redux Toolkit (auth session, cached tickets) |
| Real-time | `socket.io-client` |
| Maps | `react-native-maps` |
| QR display / scan | `react-native-qrcode-svg`, `expo-camera` (barcode scanning) |
| Secure storage | `expo-secure-store` (tokens) |
| Offline ticket cache | `@react-native-async-storage/async-storage` or `expo-sqlite` |
| Push | `expo-notifications` + FCM |
| Forms / validation | React Hook Form + Zod |

## Project structure

```
mobile/
├── app.json
├── src/
│   ├── api/               # axios client, interceptors (token refresh), endpoint modules
│   ├── socket/            # socket.io client + hooks
│   ├── navigation/        # AuthStack, PassengerTabs, StaffStack, AuthorityStack
│   ├── screens/
│   │   ├── auth/          # Login, Register
│   │   ├── passenger/     # Home, RouteSearch, RouteDetail, LiveMap, BuyTicket, MyTickets, TicketQR, Alerts, Profile
│   │   ├── staff/         # ScanTicket, ScanResult, ManualEntry, PassengerCount
│   │   └── authority/     # Dashboard, LiveFleet, Reports, Alerts
│   ├── components/        # shared UI: Button, Card, StatusBadge, OccupancyBar, ETAChip...
│   ├── store/             # auth store, ticket cache
│   ├── hooks/             # useLiveVehicles, useTickets, useAuth...
│   ├── theme/             # colours, typography, spacing (accessibility, NFR8)
│   ├── utils/
│   └── types/
└── package.json
```

## Screens by role

### Passenger (FR1–FR5, FR7, FR8, FR11, FR12)

| Screen | Purpose |
|---|---|
| Register / Login | Email or phone + password |
| Home | Search bar, nearby stops, favourite routes |
| Route search & detail | Routes, stops, upcoming arrivals |
| Live map | Vehicles on a map with ETA and occupancy indicator; updates over WebSocket |
| Buy ticket | Pick trip, boarding and alighting stops, confirm fare, pay via gateway |
| My tickets / Ticket QR | Active tickets with QR (cached offline, NFR10) and trip history |
| Alerts | Delay, cancellation and route-change notifications |
| Profile & preferences | Name, language, notification settings |

### Staff — conductor / inspector (FR6, FR7)

| Screen | Purpose |
|---|---|
| Scan ticket | Camera QR scanner |
| Scan result | Large green **VALID** / red **INVALID** with reason |
| Manual entry | Enter ticket ID when a QR won't scan |
| Passenger count | Update on-board count |

### Authority (FR9, FR10)

| Screen | Purpose |
|---|---|
| Dashboard | Live vehicles, active delays, occupancy summary |
| Live fleet map | All vehicles by route |
| Reports | Route performance, delays and occupancy with date filters |
| Alerts | Publish and review alerts |

## Navigation

```
Root
├── AuthStack ........ Login · Register
└── (by role after login)
    ├── PassengerTabs . Home · Map · Tickets · Alerts · Profile
    ├── StaffStack ..... Scan · Result · ManualEntry · Count
    └── AuthorityStack . Dashboard · Fleet · Reports · Alerts
```

## Key implementation notes

- **Tokens**: keep access/refresh tokens in `expo-secure-store`; an axios interceptor refreshes on `401`.
- **Live map**: on screen focus emit `route:subscribe`, update marker positions from `vehicle:location`, and `route:unsubscribe` on blur to save battery and data.
- **Offline tickets (NFR10)**: after purchase, persist the ticket and QR token locally; show it from cache first, then refresh from the server when online. Staff devices verify the QR signature so a ticket scans even without signal at the passenger's end.
- **Error handling (NFR7)**: show clear messages; never discard a pending payment. Re-check ticket status from the server on app resume.
- **Accessibility (NFR8)**: minimum 16 pt body text, high-contrast colours, touch targets ≥ 44 px, status shown by icon **and** text, not colour alone.
- **Android first (NFR6)**: test on recent Android versions; iOS support is a by-product of React Native.

## Getting started (once the app exists)

```bash
npx create-expo-app mobile --template blank-typescript
cd mobile
npx expo install react-native-maps expo-camera expo-secure-store expo-notifications
npm install @react-navigation/native @react-navigation/native-stack @react-navigation/bottom-tabs \
  @tanstack/react-query axios socket.io-client zustand react-native-qrcode-svg
npx expo start
```
