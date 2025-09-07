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
    groupId: number;
    reference: string;
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

      console.log("Creating expense", data)

      await ajax.post(this.baseUrl,data)

      return true;
    } catch (error) {
      return false;
    }
  };
}

export default ExpensesRepository;
