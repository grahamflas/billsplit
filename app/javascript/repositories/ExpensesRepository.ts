import axios from "axios";
import ajax from "../utils/ajax";

class ExpensesRepository {
  static readonly baseUrl = `/expenses`;

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
    } catch (error) {
      return false;
    }
  };
}

export default ExpensesRepository;
