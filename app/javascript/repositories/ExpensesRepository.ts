import { AxiosError } from "axios";

import { toast } from "react-toastify";

import ajax from "../utils/ajax";

class ExpensesRepository {
  static readonly baseUrl = `/api/expenses`;

  static async create({
    amount,
    groupId,
    reference,
    userId,
  }: {
    amount: number | undefined;
    groupId: number | undefined;
    reference: string | undefined;
    userId: number | undefined;
  }): Promise<boolean> {
    try {
      const data = {
        expense: {
          reference,
          amount,
          user_id: userId,
          group_id: groupId
        }
      }

      await ajax.post(this.baseUrl,data)

      return true;
    } catch (error: unknown) {
        if (error instanceof AxiosError){
          error
            .response
            ?.data
            .errors
            .forEach(error => toast(`Error: ${error}`))
        }
      return false;
    }
  };

  static async update({
    amount,
    id,
    reference,
    userId,
  }: {
    amount: number;
    id: number;
    reference: string;
    userId: number;
  }): Promise<boolean> {
    try {
      const data = {
        expense: {
          amount,
          reference,
          user_id: userId,
        }
      }

      await ajax.put(`${this.baseUrl}/${id}`, data)

      return true;
    } catch (error: unknown) {
        if (error instanceof AxiosError){
          error
            .response
            ?.data
            .errors
            .forEach(error => toast(`Error: ${error}`))
        }
      return false;
    }
  };

  static async delete(expenseId: number): Promise<boolean> {
    try {
      await ajax.delete(`${this.baseUrl}/${expenseId}`);

      return true;
    } catch (error) {
      if (error instanceof AxiosError){
        error
          .response
          ?.data
          .errors
          .forEach(toast)
      }

      return false;
    }
  };
}

export default ExpensesRepository;
