import express from 'express';
import Joi from 'joi';
import { createActivity, listActivities } from '../controllers/activityController.js';
import { validateBody } from '../middleware/validateRequest.js';

const router = express.Router();

const activitySchema = Joi.object({
  groupId: Joi.string().required(),
  type: Joi.string().valid('socioemocional', 'trayectoria').required(),
  title: Joi.string().required(),
  objectives: Joi.string().required(),
  scheduledAt: Joi.string().required(),
  status: Joi.string().valid('planeada', 'realizada', 'pospuesta').required(),
  evidence: Joi.array().items(Joi.string()),
});

router.get('/', listActivities);
router.post('/', validateBody(activitySchema), createActivity);

export default router;
