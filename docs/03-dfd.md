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

Editable source for all levels: [`dfd.drawio`](diagrams/dfd.drawio) (four pages) · PDF: [`dfd.pdf`](diagrams/dfd.pdf)

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
| D2 | 3.0 | Fare & stop data |
| D4 | 3.0 | Ticket history |
| 3.0 ⇄ Payment Gateway | | Payment request / payment confirmation |
| 3.0 | D4 | New ticket |
| 3.0 | D5 | Payment record |
| GPS Vehicle Tracker | 5.0 | GPS location data |
| 5.0 | D3 | Location & ETA |
| 5.0 | 6.0 | Delay detected |
| D1 | 6.0 | Alert recipients |
| 6.0 | D7 | Alert record |
| 6.0 | Passenger | Delay / cancellation alerts |
| Conductor / Inspector | 4.0 | QR scan / manual ID, passenger count |
| 4.0 | Conductor / Inspector | Validation result |
| D4 | 4.0 | Ticket status |
| 4.0 | D4 | Mark ticket used |
| 4.0 | D6 | Scan log |
| 4.0 | D3 | Passenger count |
| Authority Officer | 7.0 | Report requests, route updates |
| 7.0 | Authority Officer | Dashboard & reports |
| D3, D4, D7 | 7.0 | Live data, ticket data, delay data |
| 7.0 | D2 | Route / schedule updates |
| 7.0 | D8 | Generated reports |

## Level 2 — Process 3.0 Purchase Ticket

Process 3.0 is expanded into five sub-processes. This covers FR5 (buy a QR ticket) and FR11 (trip history).

![DFD Level 2: Purchase Ticket](diagrams/dfd-level2-purchase-ticket.png)

Editable source: page 3 of [`dfd.drawio`](diagrams/dfd.drawio) · PDF: page 3 of [`dfd.pdf`](diagrams/dfd.pdf)

### Sub-processes

| ID | Sub-process | Description |
|---|---|---|
| 3.1 | Check Trip & Calculate Fare | Receives the ticket request (trip, boarding and alighting stops), checks the trip, looks up fares in D2 and returns a fare quote |
| 3.2 | Create Pending Ticket | On the passenger's confirmation, stores a `PENDING` ticket in D4 |
| 3.3 | Process Payment | Sends the payment request to the gateway, receives the confirmation, records the payment in D5 |
| 3.4 | Issue QR Ticket | On successful payment, activates the ticket, generates its QR code, stores it in D4 and returns it to the passenger |
| 3.5 | View Trip History | Returns the passenger's past tickets and payment status from D4 and D5 |

### Data flows

| From | To | Data |
|---|---|---|
| Passenger | 3.1 | Ticket request (trip, stops) |
| 3.1 | Passenger | Fare quote |
| D2 | 3.1 | Route, stop & fare data |
| 3.1 | 3.2 | Validated request & fare |
| Passenger | 3.2 | Confirm purchase |
| 3.2 | D4 | Pending ticket |
| 3.2 | 3.3 | Ticket reference & amount |
| Passenger | 3.3 | Payment details |
| 3.3 ⇄ Payment Gateway | | Payment request / payment confirmation |
| 3.3 | D5 | Payment record |
| 3.3 | 3.4 | Payment result |
| 3.4 ⇄ D4 | | Activate ticket + QR code / ticket record |
| 3.4 | Passenger | QR ticket |
| Passenger | 3.5 | History request |
| D4 | 3.5 | Ticket records |
| D5 | 3.5 | Payment status |
| 3.5 | Passenger | Trip history |

### Balancing with Level 1

Everything entering or leaving process 3.0 in Level 1 appears in Level 2: the passenger's request and payment details, the QR ticket and trip history returned to them, the payment gateway exchange, reads from D2 and D4, and writes to D4 and D5. Level 2 adds only internal flows between 3.1–3.5, plus the fare quote shown to the passenger before they confirm.

> Level 1 was updated to include two reads by process 3.0 that Level 2 needs: `D2 → 3.0` (fare & stop data) and `D4 → 3.0` (ticket history).

## Level 2 — Process 4.0 Validate Ticket & Count Riders

Process 4.0 is expanded into five sub-processes. This covers FR6 (scan and validate QR tickets) and FR7 (passenger occupancy).

![DFD Level 2: Validate Ticket](diagrams/dfd-level2-validate-ticket.png)

Editable source: page 4 of [`dfd.drawio`](diagrams/dfd.drawio) · PDF: page 4 of [`dfd.pdf`](diagrams/dfd.pdf)

### Sub-processes

| ID | Sub-process | Description |
|---|---|---|
| 4.1 | Decode & Verify QR / Ticket ID | Reads the scanned QR (or manually entered ticket ID) and checks its signature and format |
| 4.2 | Check Ticket Status & Trip | Looks the ticket up in D4 and checks it exists, is `ACTIVE`, not expired, and matches the vehicle's trip |
| 4.3 | Mark Used & Log Scan | Marks a valid ticket `USED` in D4 and writes every scan (valid or invalid) to D6 |
| 4.4 | Return Validation Result | Sends **VALID** / **INVALID** (with reason) to the conductor or inspector |
| 4.5 | Update Passenger Count | Updates on-board count in D3 from valid boardings and any manual count entered by staff |

### Data flows

| From | To | Data |
|---|---|---|
| Conductor / Inspector | 4.1 | QR scan / manual ticket ID |
| 4.1 | 4.2 | Ticket reference, or invalid token |
| D4 | 4.2 | Ticket record |
| 4.2 | 4.3 | Check outcome (valid / invalid + reason) |
| 4.3 | D4 | Mark ticket USED (valid scans only) |
| 4.3 | D6 | Scan log |
| 4.3 | 4.4 | Scan outcome |
| 4.4 | Conductor / Inspector | Validation result |
| 4.3 | 4.5 | Boarding event (valid scans) |
| Conductor / Inspector | 4.5 | Manual passenger count |
| 4.5 | D3 | Passenger count |

### Balancing with Level 1

Everything entering or leaving process 4.0 in Level 1 appears in Level 2: the staff scan and passenger count, the validation result returned to staff, the read of D4, and the writes to D4, D6 and D3. Level 2 adds only the internal flows between 4.1–4.5.

> Level 1 was updated for this: the staff input is now labelled "QR scan / manual ID, passenger count" (matching Level 0), and a `4.0 → D4` flow, "Mark ticket used", was added.

An unreadable QR or unknown ticket ID is treated as an `INVALID` outcome at 4.2, so it is still logged to D6 (`ticket_id` is nullable in the [database](06-database-mysql.md) for this reason).

## Consistency with other diagrams

- The five external entities and their flows in Level 1 add up to the Level 0 flows (Level 0 → Level 1 balancing).
- Data stores D1–D8 correspond to entities in the [ER diagram](02-er-diagram.md): Users ↔ User/Staff/Authority Officer, Routes/Stops/Schedules ↔ Route/Stop/Trip, Location & Occupancy ↔ Location Log/Occupancy Log, Tickets ↔ Ticket, Payments ↔ Payment, Ticket Scans ↔ Ticket Scan, Delay Alerts ↔ Delay Alert, Reports ↔ Report.
