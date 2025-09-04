export interface User {
  email: string;
  id: number;
}

export interface Group {
  expenses: Expense[];
  id: number;
  name: string;
  readableCreatedAt: string;
  users: User[];
}

export interface Expense {
  amount: number;
  groupId: number;
  id: number;
  reference: string;
  userId: number;
}
