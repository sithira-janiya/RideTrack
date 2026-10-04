# Requirements

Source: the project's HCI report (requirements gathered from a 40-response commuter survey and stakeholder interviews).

## User stories

| # | As a… | I want to… | So that… |
|---|---|---|---|
| 1 | daily bus commuter | see the live location of my bus | I know when to leave home |
| 2 | train passenger | purchase a digital ticket before arriving at the station | I can avoid waiting in long queues |
| 3 | bus conductor | scan QR tickets | I can verify passengers efficiently |
| 4 | train ticket inspector | view ticket validity instantly | I can reduce fraud |
| 5 | transport authority officer | monitor vehicles' locations and delays | I can improve service quality |

## Functional requirements

| ID | Requirement |
|---|---|
| FR1 | The system shall allow users to register a new account using their email address or mobile number. |
| FR2 | The system shall allow registered users to log in securely. |
| FR3 | The system shall allow users to search for bus/train routes and view upcoming arrivals. |
| FR4 | The system shall display the live location of buses/trains on a map with an estimated arrival time. |
| FR5 | The system shall allow users to purchase a digital QR-code ticket for a selected route. |
| FR6 | The system shall allow conductors/inspectors to scan and validate a passenger's QR ticket. |
| FR7 | The system shall track and display the current passenger occupancy of a vehicle where available. |
| FR8 | The system should notify passengers of delays, cancellations, or route changes in real time. |
| FR9 | The system shall provide an operations dashboard showing live vehicle locations and delay alerts for transport authority users. |
| FR10 | The system shall generate reports and statistics on route performance, delays, and occupancy. |
| FR11 | The system shall maintain a transaction/trip history for each passenger. |
| FR12 | The system shall allow users to update their profile information and application preferences. |

## Non-functional requirements

| ID | Requirement |
|---|---|
| NFR1 | Simple, intuitive, user-friendly interface that is easy to navigate for all three user types. |
| NFR2 | Vehicle location and ETA updates within 5 seconds under normal network conditions. |
| NFR3 | User data and digital tickets protected with secure authentication and encrypted communication. |
| NFR4 | Available whenever users need access, except during scheduled maintenance. |
| NFR5 | Confidentiality of users' personal and payment information. |
| NFR6 | Support for Android devices running recent OS versions. |
| NFR7 | Clear error messages; prevent accidental loss of ticket or payment data. |
| NFR8 | Readable fonts, accessible colours and simple navigation. |
| NFR9 | Scalable to additional routes, operators and future features such as fare-card integration. |
| NFR10 | A purchased ticket is cached locally so it stays scannable with a weak or lost network connection. |
