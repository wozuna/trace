# TRACE — Plan Maestro de Desarrollo
Sistema de Gestión Educativa y Seguimiento Socioemocional (CECyT)

Basado en PRD v1.0 — Noviembre 2025

---

## PROPÓSITO DEL DOCUMENTO

Este archivo define **el plan técnico oficial del proyecto TRACE** y debe ser utilizado como:
- Guía única de desarrollo
- Referencia para Codex (agente de desarrollo)
- Contrato técnico de alcance y ejecución

⚠️ **Regla fundamental**
> El desarrollo se realizará por FASES.  
> **No se implementa frontend sin que el backend correspondiente esté terminado y probado.**

---

# ARQUITECTURA GENERAL

## Stack tecnológico

### Backend
- Node.js (LTS)
- Express
- TypeScript
- SQL Server (MSSQL)
- JWT para autenticación
- bcryptjs para encriptación de contraseñas

### Frontend
- Flutter
- Provider (gestión de estado)
- Dio (HTTP)
- flutter_secure_storage

### Repositorio
Monorepo:
```
/trace
 ├── backend
 ├── frontend
 ├── docs
 │   ├── PRD.md
 │   └── TRACE_PLAN.md
 └── README.md
```

---

# FASE 1 — BACKEND (PRIORIDAD ABSOLUTA)

## Objetivo
Construir un backend **seguro, desacoplado, escalable y alineado 100% al PRD**, sin depender del frontend.

---

## 1. Inicialización del Backend

### Dependencias obligatorias

```bash
npm install express mssql dotenv cors helmet
npm install bcryptjs jsonwebtoken zod
npm install express-rate-limit uuid
npm install swagger-ui-express yamljs
npm install winston
npm install -D typescript ts-node-dev @types/node @types/express
```

---

## 2. Arquitectura Backend (Clean Architecture)

```
/backend/src
 ├── domain
 │   ├── entities
 │   ├── value-objects
 │   └── repositories (interfaces)
 │
 ├── application
 │   ├── use-cases
 │   ├── dto
 │   └── services
 │
 ├── infrastructure
 │   ├── db
 │   │   ├── mssql.pool.ts
 │   │   ├── repositories
 │   │   └── migrations
 │   ├── http
 │   │   ├── controllers
 │   │   ├── routes
 │   │   └── middlewares
 │   └── auth
 │
 ├── shared
 │   ├── errors
 │   ├── config
 │   └── logger
 │
 └── app.ts
```

---

## 3. Seguridad (OBLIGATORIA)

### Autenticación
- Login con usuario y contraseña
- Contraseñas encriptadas con bcryptjs
- JWT con expiración
- Middleware de protección de rutas
- Control de acceso por rol

### Seguridad adicional
- helmet (headers)
- express-rate-limit
- HTTPS obligatorio
- Logs de auditoría

---

## 4. Modelo de Datos (MSSQL)

Tablas obligatorias:
- Users
- Roles
- Students
- Tutors
- Teachers
- Subjects
- Groups
- Enrollments
- TeachingAssignments
- SocioEmotionalActivities
- TrajectoryActivities
- Referrals
- Appointments
- EvidenceFiles
- AuditLogs

Reglas:
- Todas con created_at y updated_at
- Llaves foráneas
- Índices en campos de búsqueda

---

## 5. Endpoints REST (MVP)

### Autenticación
- POST /auth/login
- POST /auth/refresh
- POST /auth/recover-password

### Administración
- CRUD Students
- CRUD Tutors
- CRUD Teachers
- CRUD Subjects
- CRUD Groups
- Asignaciones alumno–grupo
- Asignaciones docente–materia–grupo

### Docente
- Registrar asistencia
- Registrar actividad socioemocional
- Registrar actividad de trayectoria
- Subir evidencias
- Derivar alumno a orientación

### Orientador
- Ver citas
- Atender derivación
- Registrar seguimiento

### Director
- KPIs
- Reportes PDF
- Evidencias

---

## 6. Documentación Backend
- Swagger en /docs
- README backend
- .env.example
- Scripts de DB

---

# FASE 2 — FRONTEND (FLUTTER)

## Objetivo
Construir una app multiplataforma alineada al backend y al PRD.

---

## 1. Paquetes Flutter

```yaml
provider
dio
flutter_secure_storage
go_router
json_annotation
build_runner
image_picker
```

---

## 2. Arquitectura Flutter

```
/frontend/lib
 ├── core
 │   ├── api
 │   ├── auth
 │   ├── config
 │   └── widgets
 │
 ├── features
 │   ├── auth
 │   ├── students
 │   ├── teachers
 │   ├── groups
 │   ├── activities
 │   ├── referrals
 │   ├── reports
 │   └── dashboard
 │
 └── main.dart
```

---

## 3. Gestión de Estado
- Provider por feature
- Estados: loading / success / error
- DTOs alineados a la API

---

## 4. Pantallas (según PRD)

### Global
- Splash
- Login
- Recuperar contraseña
- Perfil
- Notificaciones

### Administrador
- Dashboard
- Alumnos
- Tutores
- Grupos
- Materias
- Asignaciones
- Usuarios y roles

### Docente
- Dashboard
- Grupos
- Asistencia
- Actividades socioemocionales
- Actividades de trayectoria
- Evidencias
- Derivaciones

### Orientador
- Dashboard
- Agenda
- Detalle de caso
- Seguimiento

### Director
- Dashboard KPIs
- Reportes
- Evidencias
- Historial

---

## 5. Integración
- JWT en secure storage
- Interceptores Dio
- Manejo de errores
- Preparado para offline

---

# FASE 3 — INTEGRACIÓN Y PRUEBAS

- Pruebas funcionales
- Validación de flujos del PRD
- Pruebas por rol
- Estabilidad

---

# FASE 4 — OPTIMIZACIÓN Y ESCALAMIENTO

- Offline
- Sincronización
- Multi-plantel
- Reportes avanzados
- Backups y DRP

---

# METODOLOGÍA DE TRABAJO CON CODEX

Cada iteración:
1. Definir entregable
2. Implementar backend
3. Probar API
4. Implementar frontend
5. Validar contra PRD
6. Commit y push

---

# CRITERIO DE ACEPTACIÓN

El sistema se considera completo cuando:
- Todas las pantallas del PRD existen
- Todos los flujos funcionan
- Seguridad cumple LFPDPPP
- KPIs y reportes operan correctamente

---

FIN DEL DOCUMENTO
