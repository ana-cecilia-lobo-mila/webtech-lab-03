# Wheelhouse API

The Wheelhouse API is available under `/api/v1` and uses JSON for all responses.

## Routes

| Method | Path | Token required | Success | Possible errors |
|---|---|---|---|---|
| GET | `/api/v1/services` | No | 200 | — |
| GET | `/api/v1/services/:id` | No | 200 | 404 |
| POST | `/api/v1/services` | Yes | 201 | 400, 401, 422 |
| GET | `/api/v1/repairs` | Yes | 200 | 400, 401 |
| GET | `/api/v1/repairs/:id` | Yes | 200 | 401, 404 |

Protected routes use an HTTP Bearer token in the `Authorization` header.

## Service

A service is represented with its id, name, price, and the number of repairs in which the service has been charged.

Example:

```json
{
  "id": 1,
  "name": "Foreign exchange regulations",
  "price": "10000.0",
  "repairs_count": 5
}
```

## Repair

A repair includes its state and dates, information about its bike and customer, the charged service lines, total price, overdue status, and the customer's answer when applicable.

Example:

```json
{
  "id": 14,
  "state": "approved",
  "started_on": "2026-09-01",
  "promised_on": "2026-09-05",
  "handed_back_at": null,
  "bike": {
    "brand": "Trek",
    "model": "Marlin",
    "serial_number": "ABC123"
  },
  "customer": {
    "name": "Example Customer"
  },
  "lines": [
    {
      "service_name": "Brake adjustment",
      "charged_price": "10000.0"
    }
  ],
  "total": "10000.0",
  "overdue": false,
  "customer_answer": "approved"
}
```

## Repair collection

`GET /api/v1/repairs` returns a JSON array of repair documents.

It can optionally be filtered using the `state` query parameter:

```text
GET /api/v1/repairs?state=approved
```

Example response:

```json
[
  {
    "id": 14,
    "state": "approved",
    "started_on": "2026-09-01",
    "promised_on": "2026-09-05",
    "handed_back_at": null,
    "bike": {
      "brand": "Trek",
      "model": "Marlin",
      "serial_number": "ABC123"
    },
    "customer": {
      "name": "Example Customer"
    },
    "lines": [
      {
        "service_name": "Brake adjustment",
        "charged_price": "10000.0"
      }
    ],
    "total": "10000.0",
    "overdue": false,
    "customer_answer": "approved"
  }
]
```

Valid states are:

- `received`
- `diagnosing`
- `waiting_for_approval`
- `approved`
- `rejected`
- `in_repair`
- `ready`
- `picked_up`

## Errors

All API errors use a JSON object with exactly one `errors` key containing a list of messages.

Example:

```json
{
  "errors": [
    "Couldn't find Service with 'id'=\"999999\""
  ]
}
```

The API uses the following error status codes:

- `400 Bad Request`: malformed JSON, missing required request data, or an invalid repair state filter.
- `401 Unauthorized`: missing or incorrect token on a protected endpoint.
- `404 Not Found`: the requested record does not exist.
- `422 Unprocessable Content`: validation errors while creating a service.

## Price representation

Prices are represented as JSON strings. This representation is used consistently for `price`, `charged_price`, and repair `total`.

Using strings preserves the decimal representation produced by Rails without converting monetary values to floating-point JSON numbers.

## Omitted repair fields

The repair API intentionally does not expose every database column.

Database foreign keys such as `bike_id` and `mechanic_id` are omitted because the useful bike and customer information is represented directly in nested objects.

The customer's phone number is also omitted because it is not required by the API consumer and avoids exposing unnecessary personal information.

Other internal information that is not part of the public repair representation is also omitted so that the API exposes only the information required by its clients.