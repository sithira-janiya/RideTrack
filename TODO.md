# RideTrack – To-Do & Task List

Master to-do list. The detailed, phase-by-phase checklists live in the task docs below, so tick items **there** and keep this file as the high-level view.

Status as of 2026-10-05: **design documentation complete; implementation not started.**
Legend: `[x]` done · `[ ]` to do. Requirement IDs (FR/NFR) refer to [docs/01-requirements.md](docs/01-requirements.md).

## Detailed checklists

| Area | File | Open / done |
|---|---|---|
| Backend (Node.js, Express, Socket.IO, MySQL) | [docs/10-backend-tasks.md](docs/10-backend-tasks.md) | 64 / 7 |
| Frontend (React Native + Expo) | [docs/11-frontend-tasks.md](docs/11-frontend-tasks.md) | 51 / 4 |
| Setup, conventions, Git workflow | [docs/12-developer-guide.md](docs/12-developer-guide.md) | – |

## Design documentation (done)

- [x] Requirements FR1–FR12 / NFR1–NFR10 ([01](docs/01-requirements.md))
- [x] ER diagram and data dictionary ([02](docs/02-er-diagram.md))
- [x] DFD Level 0–3 ([03](docs/03-dfd.md))
- [x] Requirement traceability ([04](docs/04-traceability.md))
- [x] Architecture and tech stack ([05](docs/05-architecture.md))
- [x] MySQL design and `schema.sql` – 16 tables ([06](docs/06-database-mysql.md))
- [x] REST + WebSocket API contract ([07](docs/07-api.md))
- [x] Frontend design ([08](docs/08-frontend-react-native.md))
- [x] Use cases and use case diagram ([09](docs/09-use-cases.md))
- [x] Backend/frontend task checklists and developer guide ([10](docs/10-backend-tasks.md), [11](docs/11-frontend-tasks.md), [12](docs/12-developer-guide.md))
- [x] README, LICENSE, `.gitignore`

## Repo housekeeping

- [ ] Commit or delete the untracked root-level files. The diagrams (`RideTrack_ER_Diagram.*`, `RideTrack_DFD*`) duplicate `docs/diagrams/`; the HCI report and `Y3.S2.WE_62 report complete.pdf` are referenced by the frontend tasks and README, so decide whether to track them
- [ ] Remove `JoinTrip Lanka Final ER Diagram V3.drawio.png` – it looks like it belongs to a different project
- [ ] Remove the nested `RideTrack-Docs/` folder (a second git repo; its contents are already in `docs/`) or add it to `.gitignore`
- [ ] Decide the code layout: add `backend/` and `mobile/` beside `docs/` (matches [05](docs/05-architecture.md) and [08](docs/08-frontend-react-native.md))
- [ ] Set up CI (lint + tests) once the first code lands
- [ ] Add PR template and branch protection for `main`

## Cross-cutting tasks (not covered by the task docs)

- [ ] Create the Google Maps API key and enable it for Android
- [ ] Create a PayHere sandbox account and register the webhook URL
- [ ] Create the Firebase project and FCM service account
- [ ] Add UI wireframes/mockups from the HCI report to `docs/`
- [ ] Write a UAT test plan, one scenario per user story
- [ ] Verify NFR2 (location → screen ≤ 5 s) and NFR10 (ticket scannable offline) end to end
- [ ] Decide whether the authority dashboard stays in the mobile app or becomes a web app

## Milestones

| # | Milestone | Backend phases | Frontend phases |
|---|---|---|---|
| M1 | Foundation and auth | 0, 1 | 0, 1 |
| M2 | Core passenger flow | 2, 3, 4 | 2, 3, 4 |
| M3 | Staff validation | 5 | 5 |
| M4 | Alerts, authority, reports | 6, 7 | 6, 7 |
| M5 | Hardening and release | 8 | 8 |
