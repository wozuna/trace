import express from 'express';
import Joi from 'joi';
import { login } from '../controllers/authController.js';
import { validateBody } from '../middleware/validateRequest.js';

const router = express.Router();

const loginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(6).required(),
  role: Joi.string().valid('administrador', 'docente', 'director', 'orientador').required(),
});

router.post('/login', validateBody(loginSchema), login);

export default router;
