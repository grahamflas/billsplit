import { ExpenseStatus } from "../enums/ExpenseStatus";

export interface User {
  email: string;
  firstName: string;
  id: number;
  lastName: string;
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
  createdAt: string;
  groupId: number;
  id: number;
  reference: string;
  status: ExpenseStatus,
  userId: number;
  user: User;
}

export interface UserBalance {
  balance: number;
  firstName: string;
  lastName: string;
  userId: number;
}
export interface Balances {
  totalExpenses: number;
  userBalances: UserBalance[];
}
