# public_health

`SERVER` / Backend Systems

## Where the workflow becomes a system.

The backend powering `public_health`.

A Python-based service connecting household operations, pickup workflows, persistent data, and real-time updates. Built to turn mobile interactions into structured operations — from authentication to pickup status changes.

### System architecture

**01 / REQUESTS**

FastAPI powers the backend API, handling household registration, authentication, and pickup-related operations.

**02 / IDENTITY**

JWT-based authentication supports secure access to protected resources and authenticated sessions.

**03 / PERSISTENCE**

Firebase provides persistent storage for application data and pickup-related state.

**04 / REAL-TIME**

WebSockets enable live communication of pickup status changes between the backend and connected clients.

### The stack

`Python` · `FastAPI` · `Firebase` · `JWT` · `WebSockets`

### Beyond the endpoints.

The real engineering happens between the moving parts.

How does a session stay authenticated? How does a state change reach the right client? How do persistence, API boundaries, and asynchronous communication fit together?

This project is my space to explore those questions through implementation, debugging, and system design.

---

`BACKEND ENGINEERING` / `MOBILE INFRASTRUCTURE` / `REAL-TIME SYSTEMS`

*Built to connect the moving parts.*
