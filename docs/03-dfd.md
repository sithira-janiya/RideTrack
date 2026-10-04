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

Editable source for all levels: [`dfd.drawio`](diagrams/dfd.drawio) (seven pages) · PDF: [`dfd.pdf`](diagrams/dfd.pdf)

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
| Passenger | 6.0 | Alert history request |
| Authority Officer | 6.0 | Manual alert |
| D7 | 6.0 | Alert records |
| Conductor / Inspector | 4.0 | QR scan / manual ID, passenger count |
| 4.0 | Conductor / Inspector | Validation result |
| D4 | 4.0 | Ticket status |
| 4.0 | D4 | Mark ticket used |
| 4.0 | D6 | Scan log |
| 4.0 | D3 | Passenger count |
| Authority Officer | 7.0 | Report requests, route updates |
| 7.0 | Authority Officer | Dashboard & reports |
| D3, D4, D7 | 7.0 | Live data, ticket data, delay data |
| D2 | 7.0 | Route data |
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

## Level 2 — Process 6.0 Manage Delays & Alerts

Process 6.0 is expanded into five sub-processes. This covers FR8 (notify passengers of delays, cancellations and route changes).

![DFD Level 2: Alerts](diagrams/dfd-level2-alerts.png)

Editable source: page 7 of [`dfd.drawio`](diagrams/dfd.drawio) · PDF: page 7 of [`dfd.pdf`](diagrams/dfd.pdf)

### Sub-processes

| ID | Sub-process | Description |
|---|---|---|
| 6.1 | Receive Delay / Alert Trigger | Accepts an automatic "delay detected" from process 5.0, or a manual alert (delay, cancellation, route change) from an authority officer |
| 6.2 | Create Alert Record | Builds the alert (trip, type, message, delay minutes) and stores it in D7 |
| 6.3 | Select Recipients | Uses user preferences and favourite routes in D1 to choose who should be notified |
| 6.4 | Send Notifications | Pushes the alert to the selected passengers and records delivery in D7 |
| 6.5 | View Alert History | Lets a passenger see past alerts and mark them as read |

### Data flows

| From | To | Data |
|---|---|---|
| 5.0 Update Vehicle Location | 6.1 | Delay detected |
| Transport Authority Officer | 6.1 | Manual alert (delay / cancellation / route change) |
| 6.1 | 6.2 | Alert details (trip, type, delay) |
| 6.2 | D7 | Alert record |
| 6.2 | 6.3 | New alert |
| D1 | 6.3 | User preferences & favourite routes |
| 6.3 | 6.4 | Alert & recipient list |
| 6.4 | Passenger | Delay / cancellation alerts (push) |
| 6.4 | D7 | Delivery record |
| Passenger | 6.5 | Alert history request / mark read |
| D7 | 6.5 | Alert records |
| 6.5 | Passenger | Alert history |

### Balancing with Level 1

Everything entering or leaving process 6.0 in Level 1 appears in Level 2: the delay signal from 5.0, the read of D1, the writes to and reads from D7, and the alerts sent to the passenger.

> Level 1 was updated for this: three flows were added to 6.0 — `Passenger → 6.0` (alert history request), `Authority Officer → 6.0` (manual alert) and `D7 → 6.0` (alert records). Manual alerts are how route changes reach passengers, since automatic detection only covers delays.

## Level 2 — Process 7.0 Monitor Network & Reports (authority reports)

Process 7.0 is expanded into five sub-processes. This covers FR9 (operations dashboard), FR10 (reports and statistics) and the authority's maintenance of routes and schedules.

![DFD Level 2: Authority Reports](diagrams/dfd-level2-authority-reports.png)

Editable source: page 6 of [`dfd.drawio`](diagrams/dfd.drawio) · PDF: page 6 of [`dfd.pdf`](diagrams/dfd.pdf)

### Sub-processes

| ID | Sub-process | Description |
|---|---|---|
| 7.1 | Show Live Dashboard | Combines live vehicle positions, occupancy (D3) and active delays (D7) into the dashboard shown to the officer |
| 7.2 | Process Report Request | Receives the report request (type, route, period) and validates the criteria |
| 7.3 | Collect & Aggregate Data | Reads occupancy (D3), delays (D7), tickets (D4) and route data (D2) for the chosen period and computes statistics |
| 7.4 | Generate Report | Builds the route performance, delay or occupancy report, saves it to D8 and returns it to the officer |
| 7.5 | Manage Routes & Schedules | Applies the officer's route and schedule changes to D2 |

### Data flows

| From | To | Data |
|---|---|---|
| Transport Authority Officer | 7.1 | Dashboard request |
| 7.1 | Transport Authority Officer | Live dashboard (vehicles, delays, occupancy) |
| D3 | 7.1 | Live vehicle & occupancy data |
| D7 | 7.1 | Delay data |
| Transport Authority Officer | 7.2 | Report request (type, route, period) |
| 7.2 | 7.3 | Validated report criteria |
| D3 | 7.3 | Occupancy data |
| D7 | 7.3 | Delay data |
| D4 | 7.3 | Ticket data |
| D2 | 7.3 | Route data |
| 7.3 | 7.4 | Aggregated statistics |
| 7.4 | D8 | Generated report |
| 7.4 | Transport Authority Officer | Route performance, delay & occupancy reports |
| Transport Authority Officer | 7.5 | Route & schedule updates |
| 7.5 | D2 | Route / schedule updates |

### Balancing with Level 1

Everything entering or leaving process 7.0 in Level 1 appears in Level 2: the officer's requests and updates, the dashboard and reports returned to them, reads from D2, D3, D4 and D7, and writes to D2 and D8.

> Level 1 was updated for this: a `D2 → 7.0` flow, "Route data", was added, since route performance reports need route information.

## Level 3 — Sub-process 4.1 Decode & Verify QR / Ticket ID (ticket scanning)

Ticket scanning is the first step of validation, so it is drawn as a **Level 3** diagram that expands sub-process 4.1 of the [Level 2 validation diagram](#level-2--process-40-validate-ticket--count-riders).

![DFD Level 3: Scan Ticket](diagrams/dfd-level3-scan-ticket.png)

Editable source: page 5 of [`dfd.drawio`](diagrams/dfd.drawio) · PDF: page 5 of [`dfd.pdf`](diagrams/dfd.pdf) (page order: Level 0, Level 1, Purchase Ticket, Validate Ticket, Scan Ticket, Authority Reports, Alerts)

### Sub-processes

| ID | Sub-process | Description |
|---|---|---|
| 4.1.1 | Read QR Code | Captures the QR from the staff device's camera; an unreadable scan is flagged |
| 4.1.2 | Decode QR Payload | Extracts the token (ticket ID, trip, signature) from the raw payload; a malformed payload is flagged |
| 4.1.3 | Verify Signature & Format | Checks the token's signature and format, so forged or altered QR codes are rejected (this can run on the staff device without a network, supporting NFR10) |
| 4.1.4 | Accept Manual Ticket ID | Fallback when a QR will not scan: takes a typed ticket ID and checks its format |
| 4.1.5 | Prepare Ticket Reference | Combines the outcome of whichever path was used into a ticket reference, or an invalid-token marker, for process 4.2 |

### Data flows

| From | To | Data |
|---|---|---|
| Conductor / Inspector | 4.1.1 | QR scan (camera image) |
| Conductor / Inspector | 4.1.4 | Manual ticket ID |
| 4.1.1 | 4.1.2 | Raw QR payload |
| 4.1.1 | 4.1.5 | Unreadable scan |
| 4.1.2 | 4.1.3 | Token (ticket ID, trip, signature) |
| 4.1.2 | 4.1.5 | Malformed payload |
| 4.1.3 | 4.1.5 | Verified ticket reference / bad signature |
| 4.1.4 | 4.1.5 | Ticket ID / bad format |
| 4.1.5 | 4.2 | Ticket reference / invalid token |

### Balancing with Level 2

The only flows crossing the boundary of 4.1 match Level 2: the staff scan or manual ID comes in, and "ticket ref / invalid token" goes out to 4.2. There are no data stores at this level, because verification uses only the scanned data and the signing key. Failed scans are not dropped: they travel on to 4.2 as an invalid token, and are logged to D6 and reported back to staff by 4.3 and 4.4.

## Consistency with other diagrams

- The five external entities and their flows in Level 1 add up to the Level 0 flows (Level 0 → Level 1 balancing).
- Data stores D1–D8 correspond to entities in the [ER diagram](02-er-diagram.md): Users ↔ User/Staff/Authority Officer, Routes/Stops/Schedules ↔ Route/Stop/Trip, Location & Occupancy ↔ Location Log/Occupancy Log, Tickets ↔ Ticket, Payments ↔ Payment, Ticket Scans ↔ Ticket Scan, Delay Alerts ↔ Delay Alert, Reports ↔ Report.
