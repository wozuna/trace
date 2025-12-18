import { dataStore } from '../data/mockData.js';

export const listActivities = (req, res) => {
  const { type } = req.query;
  const filtered = type ? dataStore.activities.filter((activity) => activity.type === type) : dataStore.activities;
  res.json(filtered);
};

export const createActivity = (req, res) => {
  const { groupId, type, title, objectives, scheduledAt, status, evidence } = req.body;
  const newActivity = {
    id: `act-${(dataStore.activities.length + 1).toString().padStart(3, '0')}`,
    groupId,
    type,
    title,
    objectives,
    scheduledAt,
    status,
    evidence: evidence || [],
  };

  dataStore.activities.push(newActivity);
  res.status(201).json(newActivity);
};
