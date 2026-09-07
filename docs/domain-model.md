## Image
[![Domain model](domain-model.png)](domain-model.png)

## New code
```dbml
Table customers {
  id bigint [pk, increment]
  name varchar [not null]
  phone varchar
  created_at datetime [not null]
  updated_at datetime [not null]
}

Table mechanics {
  id bigint [pk, increment]
  name varchar [not null]
  created_at datetime [not null]
  updated_at datetime [not null]
}

Table services {
  id bigint [pk, increment]
  name varchar [not null, unique]
  price decimal(8,2) [not null]
  created_at datetime [not null]
  updated_at datetime [not null]
}

Table bikes {
  id bigint [pk, increment]
  customer_id bigint [not null]
  brand varchar
  model varchar
  color varchar
  serial_number varchar [unique]
  created_at datetime [not null]
  updated_at datetime [not null]
}

Table repairs {
  id bigint [pk, increment]
  bike_id bigint [not null]
  mechanic_id bigint [null]
  started_on date
  promised_on date [not null]
  handed_back_at datetime
  state varchar [not null, default: 'received']
  created_at datetime [not null]
  updated_at datetime [not null]
}

Table repair_services {
  id bigint [pk, increment]
  repair_id bigint [not null]
  service_id bigint [not null]
  charged_price decimal(8,2) [not null]
  created_at datetime [not null]
  updated_at datetime [not null]
}
```

## Changes since Lab 3
* Removed `Photo` and `Note` tables: The lab rules state these arrive in Lab 9.
* Renamed Primary Keys to `id`: Adopted Rails conventions.
* Renamed Foreign Keys: Added `_id` suffix (e.g., `bike_id`, `mechanic_id`) following Rails conventions.
* Removed `Customer_bike` table: Added `customer_id` directly to `bikes` to enforce that a bike cannot exist without an owner.
* Removed `Service_price` table: Moved `price` directly to the `services` table to enforce that a service must have a price.
* Renamed `status` to `state` in `repairs` and added a default value of "received".
* Renamed date columns: Changed `start_date` to `started_on` and `promised_date` to `promised_on` following Rails conventions for dates.
* Allowed NULL for `mechanic_id` in `repairs`: A mechanic is not known when the repair first arrives.

## Lifecycle
- States:
  - received
  - diagnosing
  - waiting_for_approval
  - approved
  - rejected
  - in_repair
  - ready
  - picked_up

- Allowed transitions
  - received → diagnosing
  - diagnosing → waiting_for_approval
  - waiting_for_approval → approved
  - waiting_for_approval → rejected
  - approved → in_repair
  - in_repair → ready
  - ready → picked_up
  - rejected → picked_up

- Not allowed transitions
  - rejected → in_repair
  - any transition that repeats the same state

## Table
| Entity | User story that requires it |
| Customer | 3 |
| Mechanic | 12 |
| Bike | 4 |
| Customer_bike | 8 |
| Repair | 1, 5, 6, 11, 13, 16 |
| Note | 10 |
| Photo | 9 |
| Service | 2 |
| Service_price |14, 15 |
| Repair_service | 1, 7 |


## The thing and the copy of the thing
Each bicycle is represented as a separate entity with its own id_bike and serial_number, even when two bicycles have the same brand, model, and color. 
The Customer_bike table records which customer owns each bicycle and the period of ownership, while repairs are associated directly with the bicycle through id_bike. 
This prevents the mix-up described by the owner because two similar bicycles can still be uniquely identified and their repair histories remain attached to the correct bicycle. 
A single table with a quantity column would only tell us that there are, for example, two blue Trek Marlins, but it could not tell us which specific bicycle has a particular serial number, who owns it, or which repair history belongs to each bicycle.

## Derived, or stored? 
The total cost of a repair is deliberately not stored as a separate column because it can be derived by adding the final_price values of the services associated with that repair through Repair_service. In contrast, final_price is stored even though it may appear derivable from the service price, because the shop sometimes charges less than the standard price. If final_price were not stored, changing the standard price in the future would make it impossible to know how much the customer was actually charged for an old repair.
