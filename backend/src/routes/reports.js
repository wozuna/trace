import express from 'express';
import { getKpiDashboard, getSummary } from '../controllers/reportController.js';

const router = express.Router();

router.get('/summary', getSummary);
router.get('/kpis', getKpiDashboard);

export default router;
