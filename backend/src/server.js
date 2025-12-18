import app from './app.js';
import { config } from './config/env.js';

app.listen(config.port, () => {
  console.log(`TRACE API corriendo en http://localhost:${config.port}`);
});
