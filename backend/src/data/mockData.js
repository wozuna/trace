import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { config } from '../config/env.js';

const hashedPassword = bcrypt.hashSync('demo1234', 10);

const users = [
  { id: 'u-admin', email: 'admin@trace.mx', role: 'administrador', name: 'Administrador TRACE', password: hashedPassword },
  { id: 'u-doc', email: 'docente@trace.mx', role: 'docente', name: 'Docente', password: hashedPassword },
  { id: 'u-dir', email: 'director@trace.mx', role: 'director', name: 'Dirección', password: hashedPassword },
  { id: 'u-orient', email: 'orientador@trace.mx', role: 'orientador', name: 'Orientador', password: hashedPassword },
];

const students = [
  {
    id: 'a-001',
    name: 'María López',
    curp: 'LOPM010101MDFRRS09',
    grade: 1,
    group: 'A',
    tutor: 'Ana López',
    emergencyPhone: '555-000-1111',
  },
  {
    id: 'a-002',
    name: 'José Ramírez',
    curp: 'RAMJ020202HDFLNS01',
    grade: 3,
    group: 'B',
    tutor: 'Carlos Ramírez',
    emergencyPhone: '555-111-2222',
  },
];

const tutors = [
  { id: 't-001', name: 'Ana López', phone: '555-000-1111', email: 'ana@example.com', address: 'CDMX' },
  { id: 't-002', name: 'Carlos Ramírez', phone: '555-111-2222', email: 'carlos@example.com', address: 'CDMX' },
];

const groups = [
  { id: 'g-1a', grade: 1, code: 'A', teacher: 'Docente 1', academy: 'Matemáticas' },
  { id: 'g-3b', grade: 3, code: 'B', teacher: 'Docente 2', academy: 'Programación' },
];

const activities = [
  {
    id: 'act-001',
    groupId: 'g-1a',
    type: 'socioemocional',
    title: 'Integración grupal',
    status: 'realizada',
    objectives: 'Trabajo en equipo y escucha activa',
    scheduledAt: '2025-02-01',
    evidence: ['foto1.jpg'],
  },
  {
    id: 'act-002',
    groupId: 'g-3b',
    type: 'trayectoria',
    title: 'Proyecto vocacional',
    status: 'planeada',
    objectives: 'Explorar intereses profesionales',
    scheduledAt: '2025-03-15',
    evidence: [],
  },
];

const referrals = [
  {
    id: 'ref-001',
    studentId: 'a-001',
    motive: 'situación psicológica',
    urgency: 'alta',
    status: 'pendiente',
    suggestedDate: '2025-02-05',
    description: 'Alumno presenta ansiedad durante las evaluaciones.',
  },
];

const reportSummary = {
  alumnos: students.length,
  actividadesSocioemocionales: {
    realizadas: activities.filter((a) => a.type === 'socioemocional' && a.status === 'realizada').length,
    pendientes: activities.filter((a) => a.type === 'socioemocional' && a.status !== 'realizada').length,
  },
  actividadesTrayectoria: {
    realizadas: activities.filter((a) => a.type === 'trayectoria' && a.status === 'realizada').length,
    pendientes: activities.filter((a) => a.type === 'trayectoria' && a.status !== 'realizada').length,
  },
  derivaciones: referrals.length,
};

export const dataStore = {
  users,
  students,
  tutors,
  groups,
  activities,
  referrals,
  reportSummary,
};

export const signToken = (user) => jwt.sign({ sub: user.id, role: user.role, name: user.name }, config.jwtSecret, { expiresIn: '12h' });
