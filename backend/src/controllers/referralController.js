import { dataStore } from '../data/mockData.js';

export const listReferrals = (_req, res) => res.json(dataStore.referrals);

export const createReferral = (req, res) => {
  const { studentId, motive, urgency, suggestedDate, description } = req.body;
  const newReferral = {
    id: `ref-${(dataStore.referrals.length + 1).toString().padStart(3, '0')}`,
    studentId,
    motive,
    urgency,
    status: 'pendiente',
    suggestedDate,
    description,
  };

  dataStore.referrals.push(newReferral);
  res.status(201).json(newReferral);
};
