import bcrypt from 'bcrypt';
import { dataStore, signToken } from '../data/mockData.js';

export const login = async (req, res) => {
  const { email, password, role } = req.body;
  const user = dataStore.users.find((candidate) => candidate.email === email && candidate.role === role);

  if (!user) {
    return res.status(401).json({ message: 'Usuario o rol no encontrado' });
  }

  const isValid = await bcrypt.compare(password, user.password);
  if (!isValid) {
    return res.status(401).json({ message: 'Credenciales inválidas' });
  }

  const token = signToken(user);
  return res.json({
    token,
    profile: {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
    },
  });
};
