import { dataStore } from '../data/mockData.js';

export const listStudents = (_req, res) => res.json(dataStore.students);

export const createStudent = (req, res) => {
  const { name, curp, grade, group, tutor, emergencyPhone } = req.body;
  const newStudent = {
    id: `a-${(dataStore.students.length + 1).toString().padStart(3, '0')}`,
    name,
    curp,
    grade,
    group,
    tutor,
    emergencyPhone,
  };

  dataStore.students.push(newStudent);
  res.status(201).json(newStudent);
};

export const listTutors = (_req, res) => res.json(dataStore.tutors);

export const createTutor = (req, res) => {
  const { name, phone, email, address } = req.body;
  const newTutor = {
    id: `t-${(dataStore.tutors.length + 1).toString().padStart(3, '0')}`,
    name,
    phone,
    email,
    address,
  };

  dataStore.tutors.push(newTutor);
  res.status(201).json(newTutor);
};

export const listGroups = (_req, res) => res.json(dataStore.groups);

export const createGroup = (req, res) => {
  const { grade, code, teacher, academy } = req.body;
  const newGroup = {
    id: `g-${grade}${code.toLowerCase()}`,
    grade,
    code,
    teacher,
    academy,
  };

  dataStore.groups.push(newGroup);
  res.status(201).json(newGroup);
};
