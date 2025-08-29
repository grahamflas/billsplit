export interface User {
  id: number;
  email: string;
}

export interface Group {
  id: number;
  name: string;
  users: User[];
}
