import ajax from "../utils/ajax";

class SettlementsRepository {
  static readonly baseUrl = `/api/settlements`;

  static async create({
    groupId,
    note,
    userId,
  }: {
    groupId: number;
    note: string | undefined;
    userId: number;
  }): Promise<boolean> {
    try {
      const data = {
        settlement: {
          group_id: groupId,
          note,
          user_id: userId,
        },
      };

      await ajax.post(this.baseUrl, data);

      return true;
    } catch (error) {
      return false;
    }
  }
}

export default SettlementsRepository;
