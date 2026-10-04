# Database Design (MySQL)

The MySQL 8 schema is the relational implementation of the [ER diagram](02-er-diagram.md). The full runnable script is [`schema.sql`](schema.sql).

## Setup

```bash
mysql -u root -p < docs/schema.sql
```

This creates the `ridetrack` database (utf8mb4) and all tables. Create a limited application user rather than using `root` from the backend:

```sql
CREATE USER 'ridetrack'@'localhost' IDENTIFIED BY 'change_me';
GRANT SELECT, INSERT, UPDATE, DELETE ON ridetrack.* TO 'ridetrack'@'localhost';
```

## ER → table mapping

| ER entity / relationship | MySQL table | Notes |
|---|---|---|
| User | `users` | `role` ENUM; email **or** phone required (FR1) |
| Staff (ISA) | `staff` | PK `user_id` is also FK → `users` |
| Authority Officer (ISA) | `authority_officers` | PK `user_id` is also FK → `users` |
| Route | `routes` | unique per (`mode`, `route_no`) |
| Stop | `stops` | indexed by latitude/longitude |
| Route `includes` Stop (M:N) | `route_stops` | junction; holds `stop_sequence`, `fare_from_origin` |
| Vehicle | `vehicles` | FK → `routes` |
| Trip | `trips` | FK → `routes`, `vehicles` |
| Ticket | `tickets` | FK → `users`, `trips`, and two `stops` |
| Payment | `payments` | `ticket_id` UNIQUE → 1:1 with ticket |
| Ticket Scan | `ticket_scans` | FK → `tickets`, `staff` |
| Location Log | `location_log` | high write volume; indexed (`vehicle_id`, `recorded_at`) |
| Occupancy Log | `occupancy_log` | indexed (`vehicle_id`, `recorded_at`) |
| Delay Alert | `delay_alerts` | FK → `trips` |
| Delay Alert `notifies` User (M:N) | `alert_recipients` | junction; holds `is_read`, `sent_at` |
| Report | `reports` | FK → `authority_officers`, `routes` |

## Differences from the ER diagram

These are deliberate implementation details:

- `tickets.status` adds `PENDING` (awaiting payment) and `CANCELLED`; `payments` adds `gateway_ref` and `PENDING`.
- `ticket_scans.ticket_id` is nullable so a scan of an unknown QR can still be logged.
- `users.language` and `users.push_token` store the app preferences (FR12) and the FCM device token (FR8).
- `routes.is_active`, `vehicles.is_active` allow retiring data without deleting history.

## Indexing and performance

- `location_log` and `occupancy_log` grow quickly (one row per vehicle every few seconds). Keep recent data hot:
  - Serve the *latest* position from an in-memory cache (or `SELECT … ORDER BY recorded_at DESC LIMIT 1` using `idx_loc_vehicle_time`).
  - Archive or partition by month and purge raw rows older than, say, 90 days; keep aggregates for reports.
- `idx_ticket_user (user_id, issued_at)` serves the trip-history screen (FR11).
- `idx_trip_route_time` serves route search and upcoming arrivals (FR3).

## Useful queries

**Latest position of every vehicle on a route (FR4)**

```sql
SELECT v.vehicle_id, v.reg_no, l.latitude, l.longitude, l.eta, l.recorded_at
FROM vehicles v
JOIN location_log l ON l.log_id = (
  SELECT log_id FROM location_log
  WHERE vehicle_id = v.vehicle_id
  ORDER BY recorded_at DESC LIMIT 1)
WHERE v.route_id = ?;
```

**Passenger trip history (FR11)**

```sql
SELECT t.ticket_id, r.route_no, r.name, tr.start_time, t.fare, t.status, p.status AS payment_status
FROM tickets t
JOIN trips tr    ON tr.trip_id  = t.trip_id
JOIN routes r    ON r.route_id  = tr.route_id
LEFT JOIN payments p ON p.ticket_id = t.ticket_id
WHERE t.user_id = ?
ORDER BY t.issued_at DESC;
```

**Average delay per route for a period (FR10)**

```sql
SELECT r.route_no, COUNT(*) AS alerts, AVG(a.delay_minutes) AS avg_delay_min
FROM delay_alerts a
JOIN trips tr ON tr.trip_id = a.trip_id
JOIN routes r ON r.route_id = tr.route_id
WHERE a.type = 'DELAY' AND a.created_at BETWEEN ? AND ?
GROUP BY r.route_id
ORDER BY avg_delay_min DESC;
```

## Backups and migrations

- Use a migration tool (e.g. `knex`, `sequelize-cli` or `db-migrate`) once development starts, instead of editing `schema.sql` in place.
- Take scheduled `mysqldump` backups; payments and tickets are the critical tables.
