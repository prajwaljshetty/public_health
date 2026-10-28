# public_health

`SERVER` / Backend infrastructure

# Where the workflow becomes a system.

The backend for `public_health`.

A Python-based service connecting household operations, pickup workflows, persistent state, and real-time communication — built around a simple idea: every interaction should have a defined path, and every update should reach the right place.

---

### System layers

**01  /  REQUEST**

FastAPI provides the interface between the mobile application and backend operations, with dedicated routes for household registration, authentication, and data access.

**02  /  IDENTITY**

Access and refresh tokens support authenticated sessions and controlled access to protected resources.

**03  /  PERSISTENCE**

Firebase stores application data and pickup-related state, providing the foundation for ongoing operations.

**04  /  REAL-TIME**

WebSocket connections provide a channel for communicating pickup status changes to connected clients.

---

### The toolchain

`Python`　`FastAPI`　`Firebase`　`JWT`　`WebSockets`

---

### Engineering, beneath the interface.

The interesting problems live between the endpoints.

How does a client recover an authenticated session? How does a state change propagate to a connected user? How should API boundaries, persistent data, and asynchronous communication work together?

This project is where those questions become implementation.

---

<text color="secondary" size="sm">BACKEND SYSTEMS  /  MOBILE INFRASTRUCTURE  /  REAL-TIME DATA</text>

*Built to connect the moving parts.*

