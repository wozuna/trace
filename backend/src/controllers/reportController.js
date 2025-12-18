import { dataStore } from '../data/mockData.js';

export const getSummary = (_req, res) => res.json({
  ...dataStore.reportSummary,
  timestamp: new Date().toISOString(),
});

export const getKpiDashboard = (_req, res) => res.json({
  kpis: [
    { label: 'Alumnos inscritos', value: dataStore.students.length, trend: 'up' },
    { label: 'Actividades socioemocionales', value: dataStore.activities.filter((a) => a.type === 'socioemocional').length, trend: 'stable' },
    { label: 'Derivaciones a orientación', value: dataStore.referrals.length, trend: 'up' },
  ],
});
