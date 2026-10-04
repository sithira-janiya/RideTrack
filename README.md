# RideTrack

**A Real-Time Public Bus/Train Tracking and Digital Ticketing Application**

> HCI project, Sri Lanka Institute of Information Technology (SLIIT), Year 3 Semester 2 — Group ID `Y3.S2.WE_62`

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
| [Data flow diagrams](docs/03-dfd.md) | Level 0 context diagram, Level 1 diagram, Level 2 (Purchase Ticket), process / data store / flow tables |
| [Traceability](docs/04-traceability.md) | Which process and entities satisfy each requirement |
| [Architecture & tech stack](docs/05-architecture.md) | React Native + Node.js + MySQL architecture, backend structure, key flows, security |
| [Database (MySQL)](docs/06-database-mysql.md) | ER → table mapping, indexing, sample queries; runnable script [`schema.sql`](docs/schema.sql) |
| [Backend API](docs/07-api.md) | REST endpoints and WebSocket events |
| [Frontend (React Native)](docs/08-frontend-react-native.md) | Libraries, project structure, screens per role, navigation |

## Tech stack

| Layer | Technology |
|---|---|
| Mobile app | React Native (Expo, TypeScript) |
| Backend | Node.js, Express, Socket.IO |
| Database | MySQL 8 |

### Diagrams at a glance

| Diagram | Preview | Editable source |
|---|---|---|
| ER diagram (Chen notation) | [`er-diagram.png`](docs/diagrams/er-diagram.png) | [`er-diagram.drawio`](docs/diagrams/er-diagram.drawio) |
| DFD Level 0, Level 1 and Level 2 (Purchase Ticket) | [`dfd-level0.png`](docs/diagrams/dfd-level0.png), [`dfd-level1.png`](docs/diagrams/dfd-level1.png), [`dfd-level2-purchase-ticket.png`](docs/diagrams/dfd-level2-purchase-ticket.png) | [`dfd.drawio`](docs/diagrams/dfd.drawio) |

PDF versions: [`er-diagram.pdf`](docs/diagrams/er-diagram.pdf), [`dfd.pdf`](docs/diagrams/dfd.pdf).

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
    ├── schema.sql
    └── diagrams/
        ├── er-diagram.{png,pdf,drawio}
        ├── dfd-level0.png
        ├── dfd-level1.png
        ├── dfd-level2-purchase-ticket.png
        └── dfd.{pdf,drawio}
```

## Status

This repository currently contains **design documentation only** (requirements, ER model, data flow diagrams, and the proposed React Native / Node.js / MySQL design). There is no source code yet. The data model and flows were derived from the project's requirements and user research, and are intended as the basis for implementation.
