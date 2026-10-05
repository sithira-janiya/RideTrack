# RideTrack

**A Real-Time Public Bus/Train Tracking and Digital Ticketing Application**

| | |
|---|---|
| **Institution** | Sri Lanka Institute of Information Technology (SLIIT) |
| **Module** | IT3060 – Human-Computer Interaction |
| **Group ID** | Y3.S2.WE_62 |
| **Academic year** | Year 3, Semester 2 |
| **Status** | Design documentation complete; implementation not started |

## Team

| Name | Registration No. |
|---|---|
| Silva D.S.J (Group leader) | IT23652200 |
| Rajapaksha M.P.K | IT23665620 |
| Herath H.M.S.G | IT23634626 |
| Fernando H.L.R.D | IT23635302 |

## Contents

[The problem](#the-problem) · [Who it is for](#who-it-is-for) · [Documentation](#documentation) · [Tech stack](#tech-stack) · [Diagrams](#diagrams-at-a-glance) · [Repository layout](#repository-layout) · [Status](#status) · [Contributing](#contributing)

RideTrack is a mobile app concept that shows commuters the live location and estimated arrival time of buses and trains, lets them buy and show digital QR tickets, and gives conductors, inspectors and transport authorities tools to verify fares and monitor the network in real time.

## The problem

Public transport is the main way many people in Sri Lanka travel, yet:

- Schedules are often out of date, and delays or breakdowns are not communicated to waiting passengers.
- Tickets are bought in cash from conductors or station counters, which causes queues and makes fare checking and passenger counting hard.
- Operators and regulators (such as the National Transport Commission and Sri Lanka Railways) have no live view of vehicle positions, delays or occupancy.

## Who it is for

| Group | Users | What they do in RideTrack |
|---|---|---|
| Primary | Daily commuters, students, occasional passengers, tourists | Search routes, track vehicles live, buy QR tickets, see alerts and trip history |
| Secondary | Bus conductors, drivers, train ticket inspectors, station staff | Scan and validate QR tickets, report passenger counts |
| Tertiary | Transport authority operations officers | Monitor the live network, receive delay alerts, generate reports |

## Documentation

| Document | Contents |
|---|---|
| [Requirements](docs/01-requirements.md) | Functional (FR1–FR12) and non-functional (NFR1–NFR10) requirements, user stories |
| [ER diagram](docs/02-er-diagram.md) | Entity-relationship model, relationships, data dictionary |
| [Data flow diagrams](docs/03-dfd.md) | Level 0 context diagram, Level 1 diagram, Level 2 (Purchase Ticket, Validate Ticket, Authority Reports, Alerts, User Accounts, Route Search, Vehicle Location), Level 3 (Authenticate User, Upcoming Arrivals, Calculate ETA, Scan Ticket, Check Ticket, Process Payment, Send Notifications, Aggregate Data), process / data store / flow tables |
| [Traceability](docs/04-traceability.md) | Which process and entities satisfy each requirement |
| [Architecture & tech stack](docs/05-architecture.md) | React Native + Node.js + MySQL architecture, backend structure, key flows, security |
| [Database (MySQL)](docs/06-database-mysql.md) | ER → table mapping, indexing, sample queries; runnable script [`schema.sql`](docs/schema.sql) |
| [Backend API](docs/07-api.md) | REST endpoints and WebSocket events |
| [Frontend (React Native)](docs/08-frontend-react-native.md) | Libraries, project structure, screens per role, navigation |
| [Use case diagram](docs/09-use-cases.md) | Actors, use cases, include/extend relationships, use case specifications |
| [Backend tasks](docs/10-backend-tasks.md) | Markable checklist: what is done and the phased backend to-do list |
| [Frontend tasks](docs/11-frontend-tasks.md) | Markable checklist: what is done and the phased mobile app to-do list |
| [Developer guide](docs/12-developer-guide.md) | Setup, running, conventions, Git workflow, definition of done |

## Tech stack

| Layer | Technology |
|---|---|
| Mobile app | React Native (Expo, TypeScript) |
| Backend | Node.js, Express, Socket.IO |
| Database | MySQL 8 |

### Diagrams at a glance

| Diagram | Preview | Editable source |
|---|---|---|
| Use case diagram (UML) | [`use-case-diagram.png`](docs/diagrams/use-case-diagram.png) | [`use-case-diagram.drawio`](docs/diagrams/use-case-diagram.drawio) |
| ER diagram (Chen notation) | [`er-diagram.png`](docs/diagrams/er-diagram.png) | [`er-diagram.drawio`](docs/diagrams/er-diagram.drawio) |
| DFD Level 0, Level 1, Level 2 (Purchase Ticket, Validate Ticket, Authority Reports, Alerts, User Accounts, Route Search, Vehicle Location), Level 3 (Authenticate User, Upcoming Arrivals, Calculate ETA, Scan Ticket, Check Ticket, Process Payment, Send Notifications, Aggregate Data) | [`dfd-level0.png`](docs/diagrams/dfd-level0.png), [`dfd-level1.png`](docs/diagrams/dfd-level1.png), [`dfd-level2-purchase-ticket.png`](docs/diagrams/dfd-level2-purchase-ticket.png), [`dfd-level2-validate-ticket.png`](docs/diagrams/dfd-level2-validate-ticket.png), [`dfd-level2-authority-reports.png`](docs/diagrams/dfd-level2-authority-reports.png), [`dfd-level2-alerts.png`](docs/diagrams/dfd-level2-alerts.png), [`dfd-level2-user-accounts.png`](docs/diagrams/dfd-level2-user-accounts.png), [`dfd-level2-route-search.png`](docs/diagrams/dfd-level2-route-search.png), [`dfd-level2-vehicle-location.png`](docs/diagrams/dfd-level2-vehicle-location.png), [`dfd-level3-authenticate-user.png`](docs/diagrams/dfd-level3-authenticate-user.png), [`dfd-level3-upcoming-arrivals.png`](docs/diagrams/dfd-level3-upcoming-arrivals.png), [`dfd-level3-calculate-eta.png`](docs/diagrams/dfd-level3-calculate-eta.png), [`dfd-level3-scan-ticket.png`](docs/diagrams/dfd-level3-scan-ticket.png), [`dfd-level3-check-ticket.png`](docs/diagrams/dfd-level3-check-ticket.png), [`dfd-level3-process-payment.png`](docs/diagrams/dfd-level3-process-payment.png), [`dfd-level3-send-notifications.png`](docs/diagrams/dfd-level3-send-notifications.png), [`dfd-level3-aggregate-data.png`](docs/diagrams/dfd-level3-aggregate-data.png) | [`dfd.drawio`](docs/diagrams/dfd.drawio) |

PDF versions: [`use-case-diagram.pdf`](docs/diagrams/use-case-diagram.pdf), [`er-diagram.pdf`](docs/diagrams/er-diagram.pdf), [`dfd.pdf`](docs/diagrams/dfd.pdf).

The `.drawio` files open in [diagrams.net](https://app.diagrams.net) (File → Open from → Device), the draw.io desktop app, or the VS Code *Draw.io Integration* extension.

## Repository layout

```
RideTrack-Docs/
├── README.md
└── docs/
    ├── 01-requirements.md
    ├── 02-er-diagram.md
    ├── 03-dfd.md
    ├── 04-traceability.md
    ├── 05-architecture.md
    ├── 06-database-mysql.md
    ├── 07-api.md
    ├── 08-frontend-react-native.md
    ├── 09-use-cases.md
    ├── 10-backend-tasks.md
    ├── 11-frontend-tasks.md
    ├── 12-developer-guide.md
    ├── schema.sql
    └── diagrams/
        ├── use-case-diagram.{png,pdf,drawio}
        ├── er-diagram.{png,pdf,drawio}
        ├── dfd-level0.png
        ├── dfd-level1.png
        ├── dfd-level2-purchase-ticket.png
        ├── dfd-level2-validate-ticket.png
        ├── dfd-level2-authority-reports.png
        ├── dfd-level2-alerts.png
        ├── dfd-level2-user-accounts.png
        ├── dfd-level2-route-search.png
        ├── dfd-level2-vehicle-location.png
        ├── dfd-level3-authenticate-user.png
        ├── dfd-level3-upcoming-arrivals.png
        ├── dfd-level3-calculate-eta.png
        ├── dfd-level3-scan-ticket.png
        ├── dfd-level3-check-ticket.png
        ├── dfd-level3-process-payment.png
        ├── dfd-level3-send-notifications.png
        ├── dfd-level3-aggregate-data.png
        └── dfd.{pdf,drawio}
```

## Status

This repository currently contains **design documentation only** (requirements, use case diagram, ER model, data flow diagrams, and the proposed React Native / Node.js / MySQL design). There is no source code yet. The data model and flows were derived from the project's requirements and user research, and are intended as the basis for implementation.

## Contributing

Team members: see the [developer guide](docs/12-developer-guide.md) for setup, conventions, the Git workflow and the definition of done, and tick finished work in the [backend](docs/10-backend-tasks.md) and [frontend](docs/11-frontend-tasks.md) task lists.

## Academic note

This repository is coursework produced for SLIIT. It is shared for assessment and learning; please do not copy it for submission as your own work.
