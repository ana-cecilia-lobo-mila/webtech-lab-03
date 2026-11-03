# Permissions

This document describes the authorization rules implemented with Pundit.

The policies use the current authenticated account and its role.

## Customers

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | Yes | Yes | No |
| show | Yes | Yes | No |
| new | Yes | Yes | No |
| create | Yes | Yes | No |
| edit | Yes | Yes | No |
| update | Yes | Yes | No |
| destroy | Yes | No | No |

## Bikes

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | Yes | Yes | No |
| show | Yes | Yes | No |
| new | Yes | Yes | No |
| create | Yes | Yes | No |
| edit | Yes | Yes | No |
| update | Yes | Yes | No |
| destroy | Yes | No | No |

## Services

The services index and show pages are public, including for visitors without an authenticated account.

| Action | Owner | Counter | Mechanic | Visitor |
|---|---|---|---|---|
| index | Yes | Yes | Yes | Yes |
| show | Yes | Yes | Yes | Yes |
| new | Yes | No | No | No |
| create | Yes | No | No | No |
| edit | Yes | No | No | No |
| update | Yes | No | No | No |
| destroy | Yes | No | No | No |

## Mechanics

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | Yes | Yes | Yes |
| show | Yes | Yes | Yes |
| new | Yes | No | No |
| create | Yes | No | No |
| edit | Yes | No | No |
| update | Yes | No | No |
| destroy | Yes | No | No |

## Repairs

A mechanic can access the repairs index, but can only read repairs assigned to the staff member associated with their account. If the account has no associated mechanic, the index will contain no repairs.

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | Yes | Yes | Own assigned repairs only |
| show | Yes | Yes | Own assigned repairs only |
| new | Yes | Yes | No |
| create | Yes | Yes | No |
| edit | Yes | Yes, unless `picked_up` | Own assigned repairs, unless `picked_up` |
| update | Yes | Yes, unless `picked_up` | Own assigned repairs, unless `picked_up` |
| destroy | Yes | No | No |
| destroy_intake_photo | Yes | Yes, unless `picked_up` | No |

## Repair form attributes

The following table describes which repair form attributes each role can modify. Mechanic permissions apply only to repairs assigned to their associated staff member and that have not been picked up.

| Form attribute | Owner | Counter | Mechanic (own assigned, not picked up) |
|---|---|---|---|
| `bike_id` | Yes | Yes | No |
| `mechanic_id` | Yes | Yes | No |
| `promised_on` | Yes | Yes | No |
| `started_on` | Yes | Yes | No |
| `state` | Yes | Yes | Yes |
| `diagnosis` | Yes | Yes | Yes |
| `intake_photos` | Yes | Yes | Yes |
| `repair_services_attributes[id]` | Yes | Yes | No |
| `repair_services_attributes[service_id]` | Yes | Yes | No |
| `repair_services_attributes[charged_price]` | Yes | Yes | No |
| `repair_services_attributes[_destroy]` | Yes | Yes | No |

`taken_in_by` is assigned from the current authenticated account and is never accepted from form parameters.

## Default account role

New accounts receive the `mechanic` role by default. A mechanic account without an associated staff member has no access to assigned repairs.

## Policy scopes

- Customers and bikes: owner and counter can access all records.
- Mechanics: owner, counter, and mechanic can access the staff list.
- Services: all records are publicly accessible.
- Repairs: owner and counter can access all records; mechanics can access only repairs assigned to their associated staff member.