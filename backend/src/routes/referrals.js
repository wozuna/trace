import express from 'express';
import Joi from 'joi';
import { createReferral, listReferrals } from '../controllers/referralController.js';
import { validateBody } from '../middleware/validateRequest.js';

const router = express.Router();

const referralSchema = Joi.object({
  studentId: Joi.string().required(),
  motive: Joi.string().required(),
  urgency: Joi.string().valid('alta', 'media', 'baja').required(),
  suggestedDate: Joi.string().required(),
  description: Joi.string().required(),
});

router.get('/', listReferrals);
router.post('/', validateBody(referralSchema), createReferral);

export default router;
