# Data Flow Diagrams

Notation (Yourdon / DeMarco): rectangles are **external entities**, circles are **processes**, open-ended rectangles are **data stores**, arrows are **data flows**.

## Level 0 — Context diagram

The whole system is one process interacting with five external entities.

![DFD Level 0](diagrams/dfd-level0.png)

| External entity | Sends to RideTrack | Receives from RideTrack |
|---|---|---|
| Passenger | Registration/login details, route search, ticket request, profile updates | Live location & ETA, QR ticket, delay alerts, trip history |
| Conductor / Inspector | QR scan or manual ticket ID, passenger count | Validation result (valid / invalid) |
| Transport Authority Officer | Report requests, route & schedule updates | Live dashboard, performance & delay reports |
| GPS Vehicle Tracker | Vehicle GPS location data | — |
| Payment Gateway | Payment confirmation | Payment request |

## Level 1

![DFD Level 1](diagrams/dfd-level1.png)

Editable source for both levels: [`dfd.drawio`](diagrams/dfd.drawio) (two pages) · PDF: [`dfd.pdf`](diagrams/dfd.pdf)

### Processes

| ID | Process | Description |
|---|---|---|
| 1.0 | Manage Accounts | Registers users, authenticates logins, maintains profiles and preferences |
| 2.0 | Search Routes & Track Vehicles | Finds routes and shows live vehicle location and ETA |
| 3.0 | Purchase Ticket | Takes a ticket request, processes payment, issues a QR ticket, returns trip history |
| 4.0 | Validate Ticket & Count Riders | Validates scanned QR tickets, logs scans, records passenger counts |
| 5.0 | Update Vehicle Location | Receives GPS data, updates location and ETA, detects delays |
| 6.0 | Manage Delays & Alerts | Records delay/cancellation alerts and sends them to passengers |
| 7.0 | Monitor Network & Reports | Operations dashboard and report generation for authority users |

### Data stores

| ID | Data store | Main contents |
|---|---|---|
| D1 | Users | Accounts, roles, preferences |
| D2 | Routes / Stops / Schedules | Route, stop and timetable data |
| D3 | Location & Occupancy | Vehicle positions, ETAs, passenger counts |
| D4 | Tickets | Issued QR tickets and their status |
| D5 | Payments | Payment records |
| D6 | Ticket Scans | Validation log |
| D7 | Delay Alerts | Delay, cancellation and route-change alerts |
| D8 | Reports | Generated reports |

### Data flows

| From | To | Data |
|---|---|---|
| Passenger | 1.0 | Registration / login details |
| 1.0 | Passenger | Authentication result, profile |
| 1.0 ⇄ D1 | | Save user / user record |
| Passenger | 2.0 | Route search |
| 2.0 | Passenger | Routes, live location & ETA |
| D2 | 2.0 | Route data |
| D3 | 2.0 | Vehicle location |
| Passenger | 3.0 | Ticket request & payment details |
| 3.0 | Passenger | QR ticket, trip history |
| 3.0 ⇄ Payment Gateway | | Payment request / payment confirmation |
| 3.0 | D4 | New ticket |
| 3.0 | D5 | Payment record |
| GPS Vehicle Tracker | 5.0 | GPS location data |
| 5.0 | D3 | Location & ETA |
| 5.0 | 6.0 | Delay detected |
| D1 | 6.0 | Alert recipients |
| 6.0 | D7 | Alert record |
| 6.0 | Passenger | Delay / cancellation alerts |
| Conductor / Inspector | 4.0 | QR scan / manual ID |
| 4.0 | Conductor / Inspector | Validation result |
| D4 | 4.0 | Ticket status |
| 4.0 | D6 | Scan log |
| 4.0 | D3 | Passenger count |
| Authority Officer | 7.0 | Report requests, route updates |
| 7.0 | Authority Officer | Dashboard & reports |
| D3, D4, D7 | 7.0 | Live data, ticket data, delay data |
| 7.0 | D2 | Route / schedule updates |
| 7.0 | D8 | Generated reports |

## Consistency with other diagrams

- The five external entities and their flows in Level 1 add up to the Level 0 flows (Level 0 → Level 1 balancing).
- Data stores D1–D8 correspond to entities in the [ER diagram](02-er-diagram.md): Users ↔ User/Staff/Authority Officer, Routes/Stops/Schedules ↔ Route/Stop/Trip, Location & Occupancy ↔ Location Log/Occupancy Log, Tickets ↔ Ticket, Payments ↔ Payment, Ticket Scans ↔ Ticket Scan, Delay Alerts ↔ Delay Alert, Reports ↔ Report.
