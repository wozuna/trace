import express from 'express';
import Joi from 'joi';
import { createGroup, createStudent, createTutor, listGroups, listStudents, listTutors } from '../controllers/adminController.js';
import { validateBody } from '../middleware/validateRequest.js';

const router = express.Router();

const studentSchema = Joi.object({
  name: Joi.string().required(),
  curp: Joi.string().required(),
  grade: Joi.number().min(1).max(6).required(),
  group: Joi.string().required(),
  tutor: Joi.string().required(),
  emergencyPhone: Joi.string().required(),
});

const tutorSchema = Joi.object({
  name: Joi.string().required(),
  phone: Joi.string().required(),
  email: Joi.string().email().required(),
  address: Joi.string().required(),
});

const groupSchema = Joi.object({
  grade: Joi.number().min(1).max(6).required(),
  code: Joi.string().required(),
  teacher: Joi.string().required(),
  academy: Joi.string().required(),
});

router.get('/students', listStudents);
router.post('/students', validateBody(studentSchema), createStudent);

router.get('/tutors', listTutors);
router.post('/tutors', validateBody(tutorSchema), createTutor);

router.get('/groups', listGroups);
router.post('/groups', validateBody(groupSchema), createGroup);

export default router;
