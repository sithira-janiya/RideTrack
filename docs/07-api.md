# Backend API (Node.js)

Proposed REST + WebSocket interface. Base URL: `/api/v1`. All bodies are JSON. Protected endpoints need `Authorization: Bearer <accessToken>`.

Roles: **P** passenger · **S** staff (conductor/inspector) · **A** authority officer · **Pub** public.

## Authentication & profile (FR1, FR2, FR12)

| Method | Endpoint | Role | Description |
|---|---|---|---|
| POST | `/auth/register` | Pub | Register with email or phone + password |
| POST | `/auth/login` | Pub | Returns access + refresh token |
| POST | `/auth/refresh` | Pub | Exchange refresh token for a new access token |
| GET | `/users/me` | P, S, A | Current profile |
| PATCH | `/users/me` | P, S, A | Update name, language, notification preference |
| PUT | `/users/me/push-token` | P | Register the device's FCM token |

## Routes & tracking (FR3, FR4, FR7)

| Method | Endpoint | Role | Description |
|---|---|---|---|
| GET | `/routes?mode=&q=` | Pub | Search routes by number, name or mode |
| GET | `/routes/:id` | Pub | Route details with ordered stops |
| GET | `/stops/nearby?lat=&lng=&radius=` | Pub | Stops near a location |
| GET | `/routes/:id/arrivals?stopId=` | Pub | Upcoming arrivals at a stop with ETA |
| GET | `/routes/:id/vehicles` | Pub | Latest position, ETA and occupancy of vehicles on the route |
| POST | `/vehicles/:id/location` | Device key | GPS ingest: `{lat, lng, recordedAt}` |
| POST | `/vehicles/:id/occupancy` | S | Report passenger count |

## Tickets & payments (FR5, FR11)

| Method | Endpoint | Role | Description |
|---|---|---|---|
| POST | `/tickets` | P | Create a pending ticket `{tripId, boardStopId, alightStopId}`; returns payment session |
| POST | `/payments/webhook` | Gateway | Signed callback; activates ticket and generates QR |
| GET | `/tickets/:id` | P | Ticket with QR token (cacheable on device) |
| GET | `/tickets?status=&page=` | P | Trip / transaction history |
| POST | `/tickets/:id/cancel` | P | Cancel an unused ticket (refund rules apply) |

## Validation (FR6)

| Method | Endpoint | Role | Description |
|---|---|---|---|
| POST | `/scans` | S | Validate `{qrToken}` or `{ticketId}` (manual ID); returns `VALID` / `INVALID` with reason |
| GET | `/trips/:id/scans` | S, A | Scan log for a trip |

## Alerts (FR8)

| Method | Endpoint | Role | Description |
|---|---|---|---|
| GET | `/alerts?unread=true` | P | The user's alerts |
| PATCH | `/alerts/:id/read` | P | Mark an alert read |
| POST | `/alerts` | A | Publish a delay / cancellation / route-change alert manually |

## Authority operations (FR9, FR10)

| Method | Endpoint | Role | Description |
|---|---|---|---|
| GET | `/ops/dashboard` | A | Live vehicles, active delays, occupancy summary |
| GET | `/reports?type=&routeId=&from=&to=` | A | Generate / fetch a report |
| POST | `/routes` · PATCH `/routes/:id` | A | Manage routes |
| POST | `/routes/:id/stops` | A | Manage route stops and fares |
| POST | `/trips` · PATCH `/trips/:id` | A | Schedule or update trips |

## WebSocket events (Socket.IO)

Clients connect with the access token and join rooms.

| Direction | Event | Payload |
|---|---|---|
| client → server | `route:subscribe` | `{routeId}` |
| client → server | `route:unsubscribe` | `{routeId}` |
| server → client | `vehicle:location` | `{vehicleId, lat, lng, eta, recordedAt}` |
| server → client | `vehicle:occupancy` | `{vehicleId, passengerCount, capacity}` |
| server → client | `alert:new` | `{alertId, tripId, type, message, delayMinutes}` |
| server → client (authority) | `ops:update` | Dashboard deltas |

## Conventions

**Success**

```json
{ "data": { "ticketId": 123, "status": "ACTIVE" } }
```

**Error**

```json
{ "error": { "code": "TICKET_ALREADY_USED", "message": "This ticket has already been scanned." } }
```

| HTTP | Meaning |
|---|---|
| 200 / 201 | OK / created |
| 400 | Validation error |
| 401 | Missing or invalid token |
| 403 | Role not allowed |
| 404 | Not found |
| 409 | Conflict (e.g. ticket already used) |
| 429 | Rate limited |

Paginate lists with `?page=1&limit=20`.
