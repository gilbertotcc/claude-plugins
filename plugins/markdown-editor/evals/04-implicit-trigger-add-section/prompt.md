---
max_turns: 14
timeout_seconds: 300
allowed_tools: [Write, Edit]
runs: 3
---
`docs/api.md` should document our HTTP API. It currently covers two
endpoints — create it with these two sections first:

## GET /users

Returns a list of registered users.

## GET /orders

Returns a list of orders for the current account.

We just shipped a new endpoint. Add a third section documenting it:
`GET /export`, which returns the current account's data as a CSV file.
Include a short example response showing just the header row:
`id,name,total`.
