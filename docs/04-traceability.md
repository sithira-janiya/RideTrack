# Requirements Traceability

Maps each functional requirement to the DFD process that delivers it and the ER entities that store its data. See [requirements](01-requirements.md), [ER diagram](02-er-diagram.md) and [DFD](03-dfd.md).

| Requirement | DFD process | Data stores | ER entities |
|---|---|---|---|
| FR1 Register account | 1.0 Manage Accounts | D1 | User |
| FR2 Secure login | 1.0 Manage Accounts | D1 | User |
| FR3 Search routes, upcoming arrivals | 2.0 Search Routes & Track Vehicles | D2, D3 | Route, Stop, Trip |
| FR4 Live location and ETA | 2.0, 5.0 Update Vehicle Location | D3 | Vehicle, Location Log |
| FR5 Buy QR ticket | 3.0 Purchase Ticket | D4, D5 | Ticket, Payment |
| FR6 Scan / validate QR ticket | 4.0 Validate Ticket & Count Riders | D4, D6 | Ticket, Ticket Scan, Staff |
| FR7 Passenger occupancy | 4.0 | D3 | Occupancy Log, Vehicle |
| FR8 Delay / cancellation alerts | 5.0, 6.0 Manage Delays & Alerts | D7, D1 | Delay Alert, User (`notifies`) |
| FR9 Operations dashboard | 7.0 Monitor Network & Reports | D3, D7 | Location Log, Delay Alert |
| FR10 Reports and statistics | 7.0 | D3, D4, D7, D8 | Report, Trip, Ticket |
| FR11 Trip / transaction history | 3.0 | D4, D5 | Ticket, Payment |
| FR12 Update profile and preferences | 1.0 | D1 | User |

## Non-functional requirements and the design

| Requirement | How the design supports it |
|---|---|
| NFR2 (updates within 5 s) | Flow 5.0 → D3 is a dedicated, frequent write path for location and ETA |
| NFR3, NFR5 (security, confidentiality) | Passwords stored hashed; payment handled by an external Payment Gateway, so card data never enters D5 |
| NFR9 (scalability) | Vehicle, Route and Staff entities carry operator/organisation data; new operators need no schema change |
| NFR10 (offline ticket) | `qrCode` is self-contained on the Ticket and can be cached on the device |

NFR1, NFR4, NFR6, NFR7 and NFR8 concern the user interface and platform and are covered by the UI design, not the data model.
