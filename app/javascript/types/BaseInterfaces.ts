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
  group: Group;
  id: number;
  reference: string;
  status: ExpenseStatus;
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

export interface Settlement {
  balances: Balances;
  createdAt: string;
  expenses: Expense[];
  group: Group;
  id: number;
  note: number;
  user: User;
}

export interface Invitation {
  creator: User;
  group: Group;
  invitee: User | undefined;
  inviteeEmail: string;
}

export type NotificationCategory =
  | "expense_added"
  | "expense_updated"
  | "settlement_created"
  | "invitation_created";

export interface Notification {
  category: NotificationCategory;
  createdAt: string;
  id: number;
  link: string;
  source_type: "Expense" | "Settlement" | "Invitation";
  source: Expense | Settlement | Invitation;
  user: User;
}
