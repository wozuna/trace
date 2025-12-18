import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import morgan from 'morgan';
import { config } from './config/env.js';
import authRoutes from './routes/auth.js';
import adminRoutes from './routes/admin.js';
import activitiesRoutes from './routes/activities.js';
import referralsRoutes from './routes/referrals.js';
import reportsRoutes from './routes/reports.js';

const app = express();

app.use(helmet());
app.use(cors({ origin: config.corsOrigins }));
app.use(express.json({ limit: '1mb' }));
app.use(morgan('dev'));

app.get('/health', (_req, res) => res.json({ status: 'ok', timestamp: new Date().toISOString() }));

app.use('/api/auth', authRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/activities', activitiesRoutes);
app.use('/api/referrals', referralsRoutes);
app.use('/api/reports', reportsRoutes);

app.use((_req, res) => res.status(404).json({ message: 'Recurso no encontrado' }));

export default app;
